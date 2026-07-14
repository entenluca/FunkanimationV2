const app = document.getElementById('app');
const animationList = document.getElementById('animation-list');
const radioStatus = document.getElementById('radio-status');
const activeEmote = document.getElementById('active-emote');
const btnClose = document.getElementById('btn-close');

const iconMap = {
    'fa-solid fa-wave-square': '📡',
    'fa-solid fa-user': '👤',
    'fa-solid fa-walkie-talkie': '📻',
    'fa-solid fa-headset': '🎧',
    'fa-solid fa-radio': '📻',
    'fa-solid fa-microphone': '🎤',
};

let state = {
    selectedEmote: null,
    radioActive: false,
};

function getIcon(iconClass) {
    return iconMap[iconClass] || '📻';
}

function postNui(event, data = {}) {
    fetch(`https://${GetParentResourceName()}/${event}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
    });
}

function closeUI() {
    app.classList.add('hidden');
    postNui('close');
}

function renderAnimations(animations) {
    animationList.innerHTML = '';

    animations.forEach((entry) => {
        const card = document.createElement('div');
        card.className = 'animation-card' + (entry.emote === state.selectedEmote ? ' selected' : '');
        card.innerHTML = `
            <div class="card-icon">${getIcon(entry.icon)}</div>
            <div class="card-content">
                <div class="card-title">${entry.title || entry.emote}</div>
                <div class="card-desc">${entry.description || ''}</div>
            </div>
            <div class="card-check"></div>
        `;

        card.addEventListener('click', () => {
            state.selectedEmote = entry.emote;
            postNui('selectAnimation', { emote: entry.emote, title: entry.title });
            renderAnimations(animations);
            updateStatus();
        });

        animationList.appendChild(card);
    });
}

function updateStatus() {
    radioStatus.textContent = state.radioActive ? 'Aktiv' : 'Inaktiv';
    radioStatus.classList.toggle('active', state.radioActive);
    activeEmote.textContent = state.selectedEmote || '—';
}

function openUI(data) {
    state.selectedEmote = data.selectedEmote;
    state.radioActive = data.radioActive;
    renderAnimations(data.animations || []);
    updateStatus();
    app.classList.remove('hidden');
}

window.addEventListener('message', (event) => {
    const data = event.data;
    if (!data || !data.action) return;

    if (data.action === 'open') {
        openUI(data);
    } else if (data.action === 'close') {
        app.classList.add('hidden');
    } else if (data.action === 'updateStatus') {
        state.radioActive = data.radioActive;
        state.selectedEmote = data.selectedEmote;
        updateStatus();
    }
});

btnClose.addEventListener('click', closeUI);

document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && !app.classList.contains('hidden')) {
        closeUI();
    }
});
