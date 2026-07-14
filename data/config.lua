local config = {}

-- ═══════════════════════════════════════════════════════════════
--  Allgemein
-- ═══════════════════════════════════════════════════════════════

config.debug        = false
config.defaultEmote = "wt4"
config.useEvent     = true

-- ═══════════════════════════════════════════════════════════════
--  Menü
-- ═══════════════════════════════════════════════════════════════

config.menuCommand = "funkani"
config.keybind     = "F9"

-- ═══════════════════════════════════════════════════════════════
--  Animations-Auswahl (Custom UI)
-- ═══════════════════════════════════════════════════════════════

config.radioMenu = {
    { title = "Standard",  description = "Standard-Funkanimation",          icon = "fa-solid fa-wave-square",   emote = "wt4"        },
    { title = "Brust",     description = "Funkanimation über die Brust",    icon = "fa-solid fa-user",            emote = "radiochest" },
    { title = "Schulter",  description = "Funkanimation über die Schulter", icon = "fa-solid fa-walkie-talkie", emote = "radio"      },
    { title = "Ohr",       description = "Funkanimation über das Ohrstück", icon = "fa-solid fa-headset",         emote = "phonecall"  },
}

-- ═══════════════════════════════════════════════════════════════
--  Blacklists
-- ═══════════════════════════════════════════════════════════════

config.blacklistedPeds    = { `a_c_seagull`, `a_c_shepard`, `a_c_poodle`, `a_c_mtlion`, `a_c_chimp`, `a_c_pig` }
config.blacklistedClasses = { 8, 13, 15, 16 }

--[[
    Automatische Kleidungs-Erkennung (vorerst deaktiviert)

    config.clothingAnimations = {
        {
            label     = "Polizei Uniform",
            component = 11,
            drawable  = 55,
            texture   = "0",
            emote     = "radiochest",
        },
    }
]]

return config
