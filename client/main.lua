local config = require 'data.config'
if not config then return end

-- Emote-System ermitteln (ohne ox_lib)
local scully, rpemotes, export

CreateThread(function()
    while true do
        if GetResourceState('rpemotes') == 'started' then
            rpemotes = true
            export   = exports['rpemotes']
            break
        elseif GetResourceState('scully_emotemenu') == 'started' then
            scully = true
            export = exports['scully_emotemenu']
            break
        end
        Wait(1000)
    end
    print("^2[Funkanimation]^7 Emote-System gefunden: " .. (rpemotes and "rpemotes" or "scully_emotemenu"))
end)

local function notify(data)
    if lib and lib.notify then
        lib.notify(data)
    end
end

-- State
local state = {
    selectedEmote = config.defaultEmote,
    isRadioActive = false,
    menuOpen      = false,
}

-- Hilfsfunktionen

local function isBlacklistedPed()
    local ped   = PlayerPedId()
    local model = GetEntityModel(ped)
    for _, v in ipairs(config.blacklistedPeds) do
        if model == v then return true end
    end
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        local cls = GetVehicleClass(veh)
        for _, c in ipairs(config.blacklistedClasses) do
            if cls == c then return true end
        end
    end
    return false
end

local function getActiveEmote()
    return state.selectedEmote
end

-- Emote Handler

local function playEmote(emote)
    if not export or not emote then return end
    if scully then
        export:playEmoteByCommand(emote)
    else
        export:EmoteCommandStart(emote)
    end
end

local function stopEmote()
    if not export then return end
    if scully then
        export:cancelEmote()
    else
        export:EmoteCancel()
    end
end

local function handleRadioAnim(enable)
    if isBlacklistedPed() then return end
    if enable then
        local emote = getActiveEmote()
        playEmote(emote)
        state.isRadioActive = true
        if config.debug then print("[Funkanimation] Radio AN → Emote: " .. tostring(emote)) end
    else
        stopEmote()
        state.isRadioActive = false
        if config.debug then print("[Funkanimation] Radio AUS") end
    end

    if state.menuOpen then
        SendNUIMessage({
            action       = 'updateStatus',
            radioActive  = state.isRadioActive,
            selectedEmote = state.selectedEmote,
        })
    end
end

-- NUI

local function closeMenu()
    state.menuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

local function openAnimationMenu()
    state.menuOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action        = 'open',
        animations    = config.radioMenu,
        selectedEmote = state.selectedEmote,
        radioActive   = state.isRadioActive,
    })
end

RegisterNUICallback('close', function(_, cb)
    closeMenu()
    cb('ok')
end)

RegisterNUICallback('selectAnimation', function(data, cb)
    if not data or not data.emote then
        cb('ok')
        return
    end

    state.selectedEmote = data.emote
    notify({
        title       = "Funkanimation",
        description = string.format("'%s' ausgewählt", data.title or data.emote),
        type        = "success",
        duration    = 2500,
        icon        = "fa-solid fa-microphone"
    })

    if state.isRadioActive then
        playEmote(state.selectedEmote)
    end

    cb('ok')
end)

-- Events

if config.useEvent then
    AddEventHandler("pma-voice:radioActive", function(radioTalking)
        handleRadioAnim(radioTalking)
    end)
end

-- Commands & Keybinds

RegisterCommand(config.menuCommand or "funkani", function()
    if state.menuOpen then
        closeMenu()
    else
        openAnimationMenu()
    end
end, false)

TriggerEvent('chat:addSuggestion', '/funkani', 'Öffnet das Funk Animation Menü')

RegisterKeyMapping(
    config.menuCommand or "funkani",
    "Funkanimation Menü öffnen",
    "keyboard",
    config.keybind or "F9"
)

-- Initialisierung

CreateThread(function()
    while not NetworkIsSessionStarted() do Wait(500) end
    print("^2[Funkanimation]^7 Gestartet | Emote: " .. state.selectedEmote)
end)

--[[
    Automatische Kleidungs-Erkennung (vorerst deaktiviert)
    Wird in einer zukünftigen Version wieder aktiviert.

    local function getEmoteByClothing()
        local ped = PlayerPedId()
        for _, mapping in ipairs(config.clothingAnimations) do
            -- Drawable/Texture Matching ...
        end
        return config.defaultEmote
    end
]]
