// ==UserScript==
// @name         Script pony-town
// @namespace    http://tampermonkey.net/
// @version      8.0
// @description  Script pony-town
// @author       cl1maxEz
// @match        https://pony.town/*
// @icon         https://i.ibb.co/9mLnTZTv/image.png
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    console.log('🦄 Script pony-town загружен!');

    // ================== ПЕРЕВОДЫ ==================
    const translations = {
        ru: {
            spamBtn: '🍕 Набор',
            spamStart: '▶ Начать',
            spamStop: '⏸ Стоп',
            spamStatusStopped: 'Статус: Остановлен',
            spamStatusActive: 'Статус: 🔄 Активен',
            spamStatusStoppedText: 'Статус: ⏹ Остановлен',
            spamSent: '📨 Отправлено',
            modeLabel: 'Режим:',
            modeClassic: '🔄 Набор',
            modeSlow: '🐢 Медл.',
            modeSpam: '⚡ Спам',
            placeholder: 'Введите текст...',
            afkBtn: '💤 Анти-AFK',
            afkActive: '⏸ AFK вкл',
            afkMenuTitle: '⚡ Анти-AFK',
            afkInterval: 'Интервал (сек):',
            afkStart: '▶ Запустить',
            afkStop: '⏹ Остановить',
            afkStatus: 'Статус: ',
            afkStatusOn: '🟢 Работает',
            afkStatusOff: '🔴 Выключен',
            searchBtn: '🔍 Поиск',
            searchPlaceholder: 'Слово1, слово2...',
            searchHint: '✨ Найденное подсветится.',
            searchClear: 'Очистить',
            highlightOn: '💡 Подсветка: Вкл',
            highlightOff: '💡 Подсветка: Выкл',
            settingsBtn: '⚙ Настр.',
            settingsTitle: '⚙ Настройки',
            settingsLanguage: '🌐 Язык:',
            settingsLangRu: '🇷🇺 Русский',
            settingsLangEn: '🇬🇧 English',
            settingsTheme: '🎨 Тема:',
            settingsSave: '💾 Сохранить',
            settingsSaved: '✅ Сохранено!',
            hideTitle: 'Скрыть/показать',
            welcomeTitle: '🦄 Pony Town Script',
            welcomeVersion: 'v8.0',
            welcomeFeature1: '🍕 Набор — авто-отправка (3 режима)',
            welcomeFeature2: '💤 Анти-AFK — защита от кика',
            welcomeFeature3: '🔍 Поиск — фильтр чата',
            welcomeFeature4: '⚙ Настройки — язык и тема',
            welcomeFeature5: '👁 Скрыть кнопки',
            welcomeBtn: 'Погнали! 🚀',
            welcomeLangLabel: 'Язык / Language:',
            changelogTitle: '📋 Новое в v8.0:',
            changelog1: '• ИСПРАВЛЕН ВЫБОР ТЕМЫ',
            changelog2: '• Все цвета работают корректно',
            changelog3: '• Стабильная работа',
            changelog4: '• Улучшена производительность',
            changelog5: '• Без багов!'
        },
        en: {
            spamBtn: '🍕 Spam',
            spamStart: '▶ Start',
            spamStop: '⏸ Stop',
            spamStatusStopped: 'Status: Stopped',
            spamStatusActive: 'Status: 🔄 Active',
            spamStatusStoppedText: 'Status: ⏹ Stopped',
            spamSent: '📨 Sent',
            modeLabel: 'Mode:',
            modeClassic: '🔄 Clsc',
            modeSlow: '🐢 Slow',
            modeSpam: '⚡ Spam',
            placeholder: 'Enter text...',
            afkBtn: '💤 AFK',
            afkActive: '⏸ AFK ON',
            afkMenuTitle: '⚡ Anti-AFK',
            afkInterval: 'Interval (sec):',
            afkStart: '▶ Start',
            afkStop: '⏹ Stop',
            afkStatus: 'Status: ',
            afkStatusOn: '🟢 Running',
            afkStatusOff: '🔴 Stopped',
            searchBtn: '🔍 Find',
            searchPlaceholder: 'Word1, word2...',
            searchHint: '✨ Matches highlighted.',
            searchClear: 'Clear',
            highlightOn: '💡 HL: ON',
            highlightOff: '💡 HL: OFF',
            settingsBtn: '⚙ Sett.',
            settingsTitle: '⚙ Settings',
            settingsLanguage: '🌐 Language:',
            settingsLangRu: '🇷🇺 Russian',
            settingsLangEn: '🇬🇧 English',
            settingsTheme: '🎨 Theme:',
            settingsSave: '💾 Save',
            settingsSaved: '✅ Saved!',
            hideTitle: 'Hide/show',
            welcomeTitle: '🦄 Pony Town Script',
            welcomeVersion: 'v8.0',
            welcomeFeature1: '🍕 Spam — auto-send (3 modes)',
            welcomeFeature2: '💤 Anti-AFK — kick protection',
            welcomeFeature3: '🔍 Search — chat filter',
            welcomeFeature4: '⚙ Settings — language & theme',
            welcomeFeature5: '👁 Hide buttons',
            welcomeBtn: 'Let\'s go! 🚀',
            welcomeLangLabel: 'Language / Язык:',
            changelogTitle: '📋 New in v8.0:',
            changelog1: '• FIXED THEME SELECTION',
            changelog2: '• All colors work correctly',
            changelog3: '• Stable performance',
            changelog4: '• Improved performance',
            changelog5: '• Zero bugs!'
        }
    };

    let currentLang = 'ru';
    let t = translations[currentLang];

    function loadLanguage() {
        try {
            const saved = localStorage.getItem('tg_pony_lang_v13');
            if (saved && translations[saved]) { currentLang = saved; t = translations[currentLang]; }
        } catch (e) {}
    }

    function setLanguage(lang) {
        if (translations[lang]) {
            currentLang = lang;
            t = translations[lang];
            localStorage.setItem('tg_pony_lang_v13', lang);
            updateAllTexts();
        }
    }

    // ================== ТЕМА ==================
    let currentTheme = 'default';
    let rainbowInterval = null;

    const themeColors = {
        default: { main: '#8B5CF6', hover: '#7C3AED', light: '#A78BFA', afk: '#0EA5E9', afkHover: '#0284C7', search: '#F59E0B', searchHover: '#D97706', settings: '#6366F1', settingsHover: '#4F46E5', isRainbow: false },
        rainbow: { main: '#8B5CF6', hover: '#7C3AED', light: '#A78BFA', afk: '#8B5CF6', afkHover: '#7C3AED', search: '#8B5CF6', searchHover: '#7C3AED', settings: '#8B5CF6', settingsHover: '#7C3AED', isRainbow: true },
        purple:  { main: '#8B5CF6', hover: '#7C3AED', light: '#A78BFA', afk: '#8B5CF6', afkHover: '#7C3AED', search: '#8B5CF6', searchHover: '#7C3AED', settings: '#8B5CF6', settingsHover: '#7C3AED', isRainbow: false },
        blue:    { main: '#3B82F6', hover: '#2563EB', light: '#60A5FA', afk: '#3B82F6', afkHover: '#2563EB', search: '#3B82F6', searchHover: '#2563EB', settings: '#3B82F6', settingsHover: '#2563EB', isRainbow: false },
        green:   { main: '#10B981', hover: '#059669', light: '#34D399', afk: '#10B981', afkHover: '#059669', search: '#10B981', searchHover: '#059669', settings: '#10B981', settingsHover: '#059669', isRainbow: false },
        red:     { main: '#EF4444', hover: '#DC2626', light: '#F87171', afk: '#EF4444', afkHover: '#DC2626', search: '#EF4444', searchHover: '#DC2626', settings: '#EF4444', settingsHover: '#DC2626', isRainbow: false },
        orange:  { main: '#F59E0B', hover: '#D97706', light: '#FBBF24', afk: '#F59E0B', afkHover: '#D97706', search: '#F59E0B', searchHover: '#D97706', settings: '#F59E0B', settingsHover: '#D97706', isRainbow: false },
        pink:    { main: '#EC4899', hover: '#DB2777', light: '#F472B6', afk: '#EC4899', afkHover: '#DB2777', search: '#EC4899', searchHover: '#DB2777', settings: '#EC4899', settingsHover: '#DB2777', isRainbow: false },
        cyan:    { main: '#06B6D4', hover: '#0891B2', light: '#22D3EE', afk: '#06B6D4', afkHover: '#0891B2', search: '#06B6D4', searchHover: '#0891B2', settings: '#06B6D4', settingsHover: '#0891B2', isRainbow: false },
        yellow:  { main: '#EAB308', hover: '#CA8A04', light: '#FACC15', afk: '#EAB308', afkHover: '#CA8A04', search: '#EAB308', searchHover: '#CA8A04', settings: '#EAB308', settingsHover: '#CA8A04', isRainbow: false },
        indigo:  { main: '#6366F1', hover: '#4F46E5', light: '#818CF8', afk: '#6366F1', afkHover: '#4F46E5', search: '#6366F1', searchHover: '#4F46E5', settings: '#6366F1', settingsHover: '#4F46E5', isRainbow: false },
        teal:    { main: '#14B8A6', hover: '#0D9488', light: '#2DD4BF', afk: '#14B8A6', afkHover: '#0D9488', search: '#14B8A6', searchHover: '#0D9488', settings: '#14B8A6', settingsHover: '#0D9488', isRainbow: false },
        lime:    { main: '#84CC16', hover: '#65A30D', light: '#A3E635', afk: '#84CC16', afkHover: '#65A30D', search: '#84CC16', searchHover: '#65A30D', settings: '#84CC16', settingsHover: '#65A30D', isRainbow: false },
        neon:    { main: '#7C3AED', hover: '#6D28D9', light: '#A78BFA', afk: '#7C3AED', afkHover: '#6D28D9', search: '#7C3AED', searchHover: '#6D28D9', settings: '#7C3AED', settingsHover: '#6D28D9', isRainbow: false, glow: true }
    };

    const themeNames = {
        default: '🌈 Стандарт',
        rainbow: '🌈 Радуга',
        purple: '🟣 Фиолетовый',
        blue: '🔵 Синий',
        green: '🟢 Зелёный',
        red: '🔴 Красный',
        orange: '🟠 Оранжевый',
        pink: '🩷 Розовый',
        cyan: '🩵 Голубой',
        yellow: '🟡 Жёлтый',
        indigo: '💙 Индиго',
        teal: '🩶 Бирюзовый',
        lime: '💚 Лайм',
        neon: '💜 Неон'
    };

    const themeOrder = ['default', 'rainbow', 'purple', 'blue', 'green', 'red', 'orange', 'pink', 'cyan', 'yellow', 'indigo', 'teal', 'lime', 'neon'];

    function loadTheme() {
        try {
            const saved = localStorage.getItem('tg_pony_theme_v11');
            if (saved && themeColors[saved]) currentTheme = saved;
        } catch (e) {}
    }

    function setTheme(theme) {
        if (themeColors[theme]) {
            stopRainbow();
            currentTheme = theme;
            localStorage.setItem('tg_pony_theme_v11', theme);
            applyTheme();
            // Обновляем выпадающий список если он открыт
            const themeSelect = document.getElementById('tgSettingTheme');
            if (themeSelect) {
                themeSelect.value = theme;
            }
        }
    }

    function applyTheme() {
        const c = themeColors[currentTheme];
        if (!c) return;

        document.documentElement.style.setProperty('--tg-main', c.main);
        document.documentElement.style.setProperty('--tg-main-hover', c.hover);
        document.documentElement.style.setProperty('--tg-main-light', c.light);
        document.documentElement.style.setProperty('--tg-afk', c.afk);
        document.documentElement.style.setProperty('--tg-afk-hover', c.afkHover);
        document.documentElement.style.setProperty('--tg-search', c.search);
        document.documentElement.style.setProperty('--tg-search-hover', c.searchHover);
        document.documentElement.style.setProperty('--tg-settings', c.settings);
        document.documentElement.style.setProperty('--tg-settings-hover', c.settingsHover);

        if (c.glow) {
            document.documentElement.style.setProperty('--tg-glow', `0 0 10px ${c.main}, 0 0 20px ${c.light}`);
            document.documentElement.style.setProperty('--tg-glow-strong', `0 0 15px ${c.main}, 0 0 30px ${c.light}, 0 0 45px ${c.light}`);
        } else {
            document.documentElement.style.setProperty('--tg-glow', 'none');
            document.documentElement.style.setProperty('--tg-glow-strong', 'none');
        }

        // Если текущая тема - радуга, запускаем анимацию
        if (currentTheme === 'rainbow') {
            startRainbow();
        } else {
            stopRainbow();
        }
    }

    function startRainbow() {
        stopRainbow();
        let hue = 0;
        function updateRainbow() {
            hue = (hue + 1) % 360;
            document.documentElement.style.setProperty('--tg-main', `hsl(${hue}, 70%, 60%)`);
            document.documentElement.style.setProperty('--tg-main-hover', `hsl(${hue}, 65%, 52%)`);
            document.documentElement.style.setProperty('--tg-main-light', `hsl(${hue}, 70%, 60%)`);
            document.documentElement.style.setProperty('--tg-afk', `hsl(${(hue + 30) % 360}, 70%, 60%)`);
            document.documentElement.style.setProperty('--tg-afk-hover', `hsl(${(hue + 30) % 360}, 65%, 52%)`);
            document.documentElement.style.setProperty('--tg-search', `hsl(${(hue + 60) % 360}, 70%, 60%)`);
            document.documentElement.style.setProperty('--tg-search-hover', `hsl(${(hue + 60) % 360}, 65%, 52%)`);
            document.documentElement.style.setProperty('--tg-settings', `hsl(${(hue + 90) % 360}, 70%, 60%)`);
            document.documentElement.style.setProperty('--tg-settings-hover', `hsl(${(hue + 90) % 360}, 65%, 52%)`);
        }
        updateRainbow();
        rainbowInterval = setInterval(updateRainbow, 30);
    }

    function stopRainbow() {
        if (rainbowInterval) { clearInterval(rainbowInterval); rainbowInterval = null; }
    }

    // ================== ПРИВЕТСТВИЯ ==================
    let isActive = false;
    let greetingMessage = 'Привет всем! 🎉';
    let messageCount = 0;
    let intervalId = null;
    let isSendingMessage = false;
    let isChatOpen = false;
    const MODES = { CLASSIC: 'classic', SLOW: 'slow', SPAM: 'spam' };
    let currentMode = MODES.CLASSIC;
    const MODE_INTERVALS = {
        [MODES.CLASSIC]: () => 4000 + Math.random() * 2000,
        [MODES.SLOW]: 10000,
        [MODES.SPAM]: 1000
    };

    // ================== АНТИ-AFK ==================
    let isAntiafkActive = false;
    let antiafkIntervalId = null;
    let ANTIAFK_INTERVAL_MS = 15000;
    let isAfkMenuOpen = false;

    function clickCenterScreen() {
        const event = new MouseEvent('click', { bubbles: true, cancelable: true, view: window });
        const element = document.elementFromPoint(window.innerWidth / 2, window.innerHeight / 2);
        if (element) element.dispatchEvent(event);
    }
    function startAntiafk() {
        if (antiafkIntervalId) clearInterval(antiafkIntervalId);
        antiafkIntervalId = setInterval(clickCenterScreen, ANTIAFK_INTERVAL_MS);
    }
    function stopAntiafk() {
        if (antiafkIntervalId) { clearInterval(antiafkIntervalId); antiafkIntervalId = null; }
    }
    function createAfkMenu() {
        const menu = document.createElement('div');
        menu.className = 'tg-pony-afk-menu';
        menu.id = 'tgAfkMenu';
        menu.innerHTML = `
            <div class="tg-pony-afk-menu-title">${t.afkMenuTitle}</div>
            <div class="tg-pony-afk-menu-group">
                <label class="tg-pony-afk-menu-label"><span>${t.afkInterval}</span>
                    <input type="number" class="tg-pony-afk-menu-input" id="tgAfkIntervalInput" value="${ANTIAFK_INTERVAL_MS / 1000}" min="1" max="60" step="1">
                </label>
            </div>
            <button class="tg-pony-afk-menu-btn" id="tgAfkToggleBtn">${isAntiafkActive ? t.afkStop : t.afkStart}</button>
            <div class="tg-pony-afk-menu-status">${t.afkStatus}${isAntiafkActive ? t.afkStatusOn : t.afkStatusOff}</div>
        `;
        document.body.appendChild(menu);
        document.getElementById('tgAfkToggleBtn').addEventListener('click', () => {
            isAntiafkActive = !isAntiafkActive;
            const seconds = parseInt(document.getElementById('tgAfkIntervalInput').value) || 15;
            ANTIAFK_INTERVAL_MS = seconds * 1000;
            localStorage.setItem('tg_pony_afk_interval', seconds);
            if (isAntiafkActive) { startAntiafk(); }
            else { stopAntiafk(); }
            menu.querySelector('.tg-pony-afk-menu-status').innerHTML = `${t.afkStatus}${isAntiafkActive ? t.afkStatusOn : t.afkStatusOff}`;
            document.getElementById('tgAfkToggleBtn').textContent = isAntiafkActive ? t.afkStop : t.afkStart;
            updateAllTexts();
        });
        return menu;
    }
    function toggleAfkMenu() {
        let menu = document.getElementById('tgAfkMenu');
        if (!menu) menu = createAfkMenu();
        if (menu.style.display === 'flex') { menu.style.display = 'none'; isAfkMenuOpen = false; }
        else { menu.style.display = 'flex'; isAfkMenuOpen = true; }
    }

    // ================== ПОИСК ==================
    let chatSearchTerms = [];
    let chatObserver = null;
    let highlightEnabled = true;
    let highlightColor = '#F59E0B';

    function hexToRgba(hex, alpha) {
        const clean = hex.replace('#', '');
        return `rgba(${parseInt(clean.substring(0, 2), 16)}, ${parseInt(clean.substring(2, 4), 16)}, ${parseInt(clean.substring(4, 6), 16)}, ${alpha})`;
    }
    function updateHighlightColorVar() {
        document.documentElement.style.setProperty('--tg-chat-highlight-bg', hexToRgba(highlightColor, 0.3));
    }
    function lineMatchesSearch(lineText) {
        if (chatSearchTerms.length === 0) return null;
        const lower = lineText.toLowerCase();
        return chatSearchTerms.some(term => lower.includes(term));
    }
    function applyFilterToLine(lineEl) {
        const text = lineEl.textContent || '';
        const result = lineMatchesSearch(text);
        if (result === null) { lineEl.classList.remove('tg-chat-hidden', 'tg-chat-highlight'); return; }
        if (result) {
            lineEl.classList.remove('tg-chat-hidden');
            if (highlightEnabled) lineEl.classList.add('tg-chat-highlight');
            else lineEl.classList.remove('tg-chat-highlight');
        } else {
            lineEl.classList.remove('tg-chat-highlight');
            lineEl.classList.add('tg-chat-hidden');
        }
    }
    function applyFilterToAllLines() {
        document.querySelectorAll('.chat-line').forEach(applyFilterToLine);
    }
    function startChatSearchObserver() {
        const scrollInner = document.querySelector('.chat-log-scroll-inner');
        if (!scrollInner) { setTimeout(startChatSearchObserver, 1000); return; }
        applyFilterToAllLines();
        if (chatObserver) chatObserver.disconnect();
        chatObserver = new MutationObserver((mutations) => {
            mutations.forEach(mutation => {
                mutation.addedNodes.forEach(node => {
                    if (node.nodeType === 1 && node.classList && node.classList.contains('chat-line')) {
                        applyFilterToLine(node);
                    }
                });
            });
        });
        chatObserver.observe(scrollInner, { childList: true });
    }
    function setChatSearch(rawInput) {
        chatSearchTerms = rawInput.split(',').map(s => s.trim().toLowerCase()).filter(s => s.length > 0);
        applyFilterToAllLines();
    }

    // ================== СКРЫТИЕ UI ==================
    let isScriptUIHidden = false;
    function hideScriptUI() {
        document.querySelectorAll('.tg-pony-btn, .tg-pony-afk-btn, .tg-pony-search-btn, .tg-pony-settings-btn, .tg-pony-greeting-input, .tg-pony-search-input, .tg-pony-settings-panel, .tg-pony-afk-menu').forEach(el => el.classList.add('tg-script-ui-hidden'));
        isScriptUIHidden = true;
        const hideBtn = document.getElementById('tgHideScriptUIBtn');
        if (hideBtn) { hideBtn.textContent = '👁'; hideBtn.style.opacity = '0.25'; }
    }
    function showScriptUI() {
        document.querySelectorAll('.tg-script-ui-hidden').forEach(el => el.classList.remove('tg-script-ui-hidden'));
        isScriptUIHidden = false;
        const hideBtn = document.getElementById('tgHideScriptUIBtn');
        if (hideBtn) { hideBtn.textContent = '👁‍🗨'; hideBtn.style.opacity = '0.7'; }
    }
    function toggleScriptUI() { isScriptUIHidden ? showScriptUI() : hideScriptUI(); }

    // ================== НАСТРОЙКИ ==================
    let isSettingsPanelOpen = false;

    function createSettingsPanel() {
        const oldPanel = document.getElementById('tgSettingsPanel');
        if (oldPanel) oldPanel.remove();

        // Строим ОПЦИИ с ПРАВИЛЬНЫМ selected
        let themeOptionsHTML = '';
        for (let i = 0; i < themeOrder.length; i++) {
            const key = themeOrder[i];
            const name = themeNames[key] || key;
            if (key === currentTheme) {
                themeOptionsHTML += `<option value="${key}" selected>${name}</option>`;
            } else {
                themeOptionsHTML += `<option value="${key}">${name}</option>`;
            }
        }

        const panel = document.createElement('div');
        panel.className = 'tg-pony-settings-panel';
        panel.id = 'tgSettingsPanel';
        panel.innerHTML = `
            <div class="tg-pony-settings-title">${t.settingsTitle}</div>
            <div class="tg-pony-settings-group">
                <label class="tg-pony-settings-label">
                    <span>${t.settingsLanguage}</span>
                    <select class="tg-pony-settings-select" id="tgSettingLanguage">
                        <option value="ru" ${currentLang === 'ru' ? 'selected' : ''}>${t.settingsLangRu}</option>
                        <option value="en" ${currentLang === 'en' ? 'selected' : ''}>${t.settingsLangEn}</option>
                    </select>
                </label>
            </div>
            <div class="tg-pony-settings-group">
                <label class="tg-pony-settings-label">
                    <span>${t.settingsTheme}</span>
                    <select class="tg-pony-settings-select" id="tgSettingTheme">${themeOptionsHTML}</select>
                </label>
            </div>
            <div class="tg-pony-settings-actions">
                <button class="tg-pony-settings-save-btn" id="tgSettingsSaveBtn">${t.settingsSave}</button>
            </div>
        `;
        document.body.appendChild(panel);

        document.getElementById('tgSettingsSaveBtn').addEventListener('click', () => {
            const lang = document.getElementById('tgSettingLanguage').value;
            const theme = document.getElementById('tgSettingTheme').value;
            setLanguage(lang);
            setTheme(theme);
            showSettingsNotification(t.settingsSaved);
        });

        return panel;
    }

    function showSettingsNotification(message) {
        const existingNotif = document.querySelector('.tg-pony-settings-notification');
        if (existingNotif) existingNotif.remove();
        const notif = document.createElement('div');
        notif.className = 'tg-pony-settings-notification';
        notif.textContent = message;
        document.body.appendChild(notif);
        setTimeout(() => { notif.style.opacity = '0'; setTimeout(() => notif.remove(), 300); }, 2000);
    }

    function toggleSettingsPanel() {
        const panel = document.getElementById('tgSettingsPanel');
        if (panel && panel.style.display === 'flex') {
            panel.style.display = 'none';
            isSettingsPanelOpen = false;
            panel.remove();
        } else {
            createSettingsPanel();
            const newPanel = document.getElementById('tgSettingsPanel');
            if (newPanel) newPanel.style.display = 'flex';
            isSettingsPanelOpen = true;
        }
    }

    // ================== ОБНОВЛЕНИЕ ТЕКСТОВ ==================
    function updateAllTexts() {
        const spamBtn = document.getElementById('tgGreetingBtn');
        if (spamBtn) spamBtn.textContent = t.spamBtn;
        const afkBtn = document.getElementById('tgAfkBtn');
        if (afkBtn) afkBtn.textContent = isAntiafkActive ? t.afkActive : t.afkBtn;
        const searchBtn = document.getElementById('tgSearchBtn');
        if (searchBtn) searchBtn.textContent = t.searchBtn;
        const settingsBtn = document.getElementById('tgSettingsBtn');
        if (settingsBtn) settingsBtn.textContent = t.settingsBtn;
        const startBtn = document.getElementById('tgStartBtn');
        if (startBtn) startBtn.textContent = isActive ? t.spamStop : t.spamStart;
        const statusText = document.getElementById('tgStatusText');
        if (statusText) statusText.textContent = isActive ? `${t.spamStatusActive} (${currentMode})` : t.spamStatusStoppedText;
        const textarea = document.getElementById('tgTextArea');
        if (textarea) textarea.placeholder = t.placeholder;
        const modeBtns = document.querySelectorAll('.tg-mode-btn');
        const modeNames = [t.modeClassic, t.modeSlow, t.modeSpam];
        modeBtns.forEach((btn, i) => { if (modeNames[i]) btn.textContent = modeNames[i]; });
        const searchInput = document.getElementById('tgSearchInput');
        if (searchInput) searchInput.placeholder = t.searchPlaceholder;
        const highlightToggle = document.querySelector('.tg-pony-highlight-toggle');
        if (highlightToggle) highlightToggle.textContent = highlightEnabled ? t.highlightOn : t.highlightOff;
        const hideBtn = document.getElementById('tgHideScriptUIBtn');
        if (hideBtn) hideBtn.title = t.hideTitle;
        const settingsPanel = document.getElementById('tgSettingsPanel');
        if (settingsPanel && settingsPanel.style.display === 'flex') {
            settingsPanel.remove();
            createSettingsPanel();
            const newPanel = document.getElementById('tgSettingsPanel');
            if (newPanel) newPanel.style.display = 'flex';
        }
        const afkMenu = document.getElementById('tgAfkMenu');
        if (afkMenu) {
            afkMenu.remove();
            createAfkMenu();
            if (isAfkMenuOpen) document.getElementById('tgAfkMenu').style.display = 'flex';
        }
    }

    // ================== СТИЛИ ==================
    function createStyles() {
        if (document.getElementById('tg-pony-styles')) return;
        const style = document.createElement('style');
        style.id = 'tg-pony-styles';
        style.textContent = `
            :root { --tg-main: #8B5CF6; --tg-main-hover: #7C3AED; --tg-main-light: #A78BFA; --tg-afk: #0EA5E9; --tg-afk-hover: #0284C7; --tg-search: #F59E0B; --tg-search-hover: #D97706; --tg-settings: #6366F1; --tg-settings-hover: #4F46E5; --tg-glow: none; --tg-glow-strong: none; }
            .tg-pony-btn { position: fixed; top: 10px; left: 10px; background: var(--tg-main); color: white; border: none; border-radius: 20px; padding: 8px 12px; font-size: 12px; cursor: pointer; z-index: 9999; font-family: Arial, sans-serif; box-shadow: 0 2px 8px rgba(0,0,0,0.3), var(--tg-glow); user-select: none; width: 80px; text-align: center; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; transition: all 0.3s; }
            .tg-pony-btn:hover { background: var(--tg-main-hover); box-shadow: 0 2px 8px rgba(0,0,0,0.3), var(--tg-glow-strong); }
            .tg-pony-btn.active { background: #EF4444; box-shadow: 0 2px 8px rgba(0,0,0,0.3); }
            .tg-pony-afk-btn { position: fixed; top: 10px; left: 100px; background: var(--tg-afk); color: white; border: none; border-radius: 20px; padding: 8px 12px; font-size: 12px; cursor: pointer; z-index: 9999; font-family: Arial, sans-serif; box-shadow: 0 2px 8px rgba(0,0,0,0.3), var(--tg-glow); user-select: none; width: 80px; text-align: center; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; transition: all 0.3s; }
            .tg-pony-afk-btn:hover { background: var(--tg-afk-hover); box-shadow: 0 2px 8px rgba(0,0,0,0.3), var(--tg-glow-strong); }
            .tg-pony-afk-btn.active { background: #EF4444; box-shadow: 0 2px 8px rgba(0,0,0,0.3); }
            .tg-pony-search-btn { position: fixed; top: 10px; left: 190px; background: var(--tg-search); color: white; border: none; border-radius: 20px; padding: 8px 12px; font-size: 12px; cursor: pointer; z-index: 9999; font-family: Arial, sans-serif; box-shadow: 0 2px 8px rgba(0,0,0,0.3), var(--tg-glow); user-select: none; width: 80px; text-align: center; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; transition: all 0.3s; }
            .tg-pony-search-btn:hover { background: var(--tg-search-hover); box-shadow: 0 2px 8px rgba(0,0,0,0.3), var(--tg-glow-strong); }
            .tg-pony-search-btn.active { background: #EF4444; box-shadow: 0 2px 8px rgba(0,0,0,0.3); }
            .tg-pony-settings-btn { position: fixed; top: 10px; left: 280px; background: var(--tg-settings); color: white; border: none; border-radius: 20px; padding: 8px 12px; font-size: 12px; cursor: pointer; z-index: 9999; font-family: Arial, sans-serif; box-shadow: 0 2px 8px rgba(0,0,0,0.3), var(--tg-glow); user-select: none; width: 80px; text-align: center; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; transition: all 0.3s; }
            .tg-pony-settings-btn:hover { background: var(--tg-settings-hover); box-shadow: 0 2px 8px rgba(0,0,0,0.3), var(--tg-glow-strong); }
            .tg-pony-settings-btn.active { background: #EF4444; box-shadow: 0 2px 8px rgba(0,0,0,0.3); }
            .tg-pony-hide-script-ui-btn { position: fixed; top: 12px; left: 370px; background: rgba(75, 85, 99, 0.8); color: white; border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 50%; width: 32px; height: 32px; font-size: 16px; cursor: pointer; z-index: 10000; font-family: Arial, sans-serif; box-shadow: 0 2px 8px rgba(0,0,0,0.3); user-select: none; display: flex; align-items: center; justify-content: center; padding: 0; opacity: 0.7; transition: all 0.3s; line-height: 1; }
            .tg-pony-hide-script-ui-btn:hover { opacity: 1 !important; background: rgba(75, 85, 99, 1); }
            .tg-script-ui-hidden { display: none !important; }
            .tg-pony-afk-menu { position: fixed; top: 55px; left: 100px; background: #1F2937; border: 1px solid var(--tg-afk); border-radius: 10px; padding: 16px; z-index: 9999; width: 200px; font-family: Arial, sans-serif; display: none; flex-direction: column; gap: 10px; box-shadow: 0 8px 32px rgba(0,0,0,0.5); color: #F9FAFB; }
            .tg-pony-afk-menu-title { font-size: 15px; font-weight: bold; color: var(--tg-afk); text-align: center; }
            .tg-pony-afk-menu-btn { background: var(--tg-afk); color: white; border: none; border-radius: 6px; padding: 10px; font-size: 13px; cursor: pointer; font-family: Arial, sans-serif; font-weight: bold; width: 100%; }
            .tg-pony-afk-menu-btn:hover { background: var(--tg-afk-hover); }
            .tg-pony-settings-panel { position: fixed; top: 55px; left: 280px; background: #1F2937; border: 1px solid var(--tg-settings); border-radius: 10px; padding: 16px; z-index: 9999; width: 240px; font-family: Arial, sans-serif; display: none; flex-direction: column; gap: 12px; box-shadow: 0 8px 32px rgba(0,0,0,0.5); color: #F9FAFB; }
            .tg-pony-settings-title { font-size: 16px; font-weight: bold; color: var(--tg-settings); text-align: center; margin-bottom: 4px; }
            .tg-pony-settings-select { background: #374151; border: 1px solid #4B5563; border-radius: 6px; padding: 8px 10px; color: #F9FAFB; font-size: 13px; font-family: Arial, sans-serif; cursor: pointer; }
            .tg-pony-settings-select:focus { outline: none; border-color: var(--tg-settings); }
            .tg-pony-settings-save-btn { flex: 1; background: var(--tg-settings); color: white; border: none; border-radius: 6px; padding: 10px; font-size: 13px; cursor: pointer; font-family: Arial, sans-serif; font-weight: bold; }
            .tg-pony-settings-save-btn:hover { background: var(--tg-settings-hover); }
            .tg-pony-search-input { position: fixed; top: 55px; left: 190px; background: #1F2937; border: 1px solid var(--tg-search); border-radius: 10px; padding: 12px; z-index: 9999; width: 200px; font-family: Arial, sans-serif; display: none; flex-direction: column; gap: 6px; box-shadow: 0 8px 32px rgba(0,0,0,0.5); }
            .tg-pony-search-input input { background: transparent; color: #F9FAFB; border: 1px solid #374151; border-radius: 6px; padding: 6px 8px; font-size: 12px; font-family: Arial, sans-serif; width: 100%; box-sizing: border-box; }
            .tg-pony-search-input input:focus { outline: none; border-color: var(--tg-search); }
            .tg-pony-greeting-input { position: fixed; top: 55px; left: 10px; background: #1F2937; border: 1px solid var(--tg-main); border-radius: 10px; padding: 12px; z-index: 9999; width: 200px; font-family: Arial, sans-serif; display: none; flex-direction: column; gap: 8px; box-shadow: 0 8px 32px rgba(0,0,0,0.5); }
            .tg-pony-greeting-input textarea { background: transparent; color: #F9FAFB; border: 1px solid #374151; border-radius: 6px; padding: 6px 8px; font-size: 12px; font-family: Arial, sans-serif; resize: vertical; min-height: 40px; width: 100%; box-sizing: border-box; }
            .tg-pony-greeting-input textarea:focus { outline: none; border-color: var(--tg-main); }
            .tg-pony-start-btn { background: #10B981; color: white; border: none; border-radius: 6px; padding: 8px; font-size: 14px; cursor: pointer; font-family: Arial, sans-serif; width: 100%; text-align: center; white-space: nowrap; }
            .tg-pony-start-btn:hover { background: #059669; }
            .tg-pony-start-btn.active { background: #EF4444; }
            .tg-mode-btn { background: #374151; color: #9CA3AF; border: 1px solid #4B5563; border-radius: 6px; padding: 6px 4px; font-size: 10px; cursor: pointer; font-family: Arial, sans-serif; width: 100%; text-align: center; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
            .tg-mode-btn:hover { background: #4B5563; color: #F9FAFB; }
            .tg-mode-btn.active { background: var(--tg-main); color: white; border-color: var(--tg-main); }
            .tg-pony-welcome-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.6); backdrop-filter: blur(4px); z-index: 20000; display: flex; align-items: center; justify-content: center; opacity: 0; pointer-events: none; transition: opacity 0.4s; }
            .tg-pony-welcome-overlay.visible { opacity: 1; pointer-events: auto; }
            .tg-pony-welcome-modal { background: #1F2937; border: 2px solid var(--tg-main); border-radius: 16px; padding: 24px 28px; width: 400px; max-width: 90vw; max-height: 85vh; overflow-y: auto; font-family: Arial, sans-serif; text-align: center; box-shadow: 0 20px 60px rgba(0,0,0,0.5); transform: translateY(-10px); transition: transform 0.4s; }
            .tg-pony-welcome-overlay.visible .tg-pony-welcome-modal { transform: translateY(0); }
            .tg-pony-welcome-title { font-size: 22px; font-weight: bold; margin-bottom: 4px; animation: purpleShimmer 3s ease-in-out infinite; background: linear-gradient(90deg, #8B5CF6, #A78BFA, #7C3AED, #A78BFA, #8B5CF6); background-size: 200% auto; -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
            @keyframes purpleShimmer { 0% { background-position: 0% center; } 50% { background-position: 100% center; } 100% { background-position: 0% center; } }
            .tg-pony-welcome-btn { background: var(--tg-main); color: white; border: none; border-radius: 8px; padding: 12px 24px; font-size: 15px; font-weight: bold; cursor: pointer; font-family: Arial, sans-serif; width: 100%; transition: all 0.3s; }
            .tg-pony-welcome-btn:hover { background: var(--tg-main-hover); transform: scale(1.02); }
            .tg-pony-welcome-lang-row { display: flex; align-items: center; justify-content: center; gap: 12px; margin-bottom: 16px; }
            .tg-pony-welcome-lang-label { font-size: 13px; animation: purpleShimmer 3s ease-in-out infinite; background: linear-gradient(90deg, #8B5CF6, #A78BFA, #7C3AED, #A78BFA, #8B5CF6); background-size: 200% auto; -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
            .tg-pony-welcome-lang-btn { background: #374151; color: #9CA3AF; border: 2px solid #4B5563; border-radius: 8px; padding: 8px 16px; font-size: 15px; cursor: pointer; font-family: Arial, sans-serif; transition: all 0.3s ease; }
            .tg-pony-welcome-lang-btn:hover { background: #4B5563; color: #F9FAFB; border-color: #6366F1; box-shadow: 0 0 8px rgba(139, 92, 246, 0.4); transform: scale(1.05); }
            .tg-pony-welcome-lang-btn.active { background: var(--tg-main); color: white; border-color: var(--tg-main); box-shadow: 0 0 12px var(--tg-main-light), 0 0 24px var(--tg-main); }
            .tg-pony-welcome-tg-link { font-size: 13px; color: var(--tg-main-light); text-decoration: none; margin-bottom: 16px; display: inline-block; transition: all 0.3s; }
            .tg-pony-welcome-tg-link:hover { text-decoration: underline; }
            .tg-pony-status-text { font-size: 11px; color: #6B7280; text-align: center; margin-top: 2px; }
            .tg-pony-counter-text { font-size: 10px; color: #10B981; text-align: center; margin-top: 2px; display: none; }
            .tg-pony-counter-text.active { display: block; }
            .tg-mode-label { color: #6B7280; font-size: 10px; text-align: center; margin-bottom: 2px; }
            .tg-mode-container { display: flex; gap: 4px; margin-top: 2px; }
            .tg-mode-container .tg-mode-item { flex: 1; }
            .tg-pony-settings-group { display: flex; flex-direction: column; gap: 4px; }
            .tg-pony-settings-label { display: flex; flex-direction: column; gap: 4px; font-size: 12px; color: #D1D5DB; }
            .tg-pony-settings-actions { display: flex; gap: 8px; margin-top: 4px; }
            .tg-pony-settings-notification { position: fixed; bottom: 20px; left: 50%; transform: translateX(-50%); background: #10B981; color: white; padding: 12px 24px; border-radius: 8px; font-family: Arial, sans-serif; font-size: 14px; z-index: 10001; box-shadow: 0 4px 16px rgba(0,0,0,0.3); transition: opacity 0.3s; }
            .tg-pony-search-hint { font-size: 10px; color: #6B7280; }
            .tg-pony-search-clear { background: #4B5563; color: white; border: none; border-radius: 6px; padding: 5px; font-size: 11px; cursor: pointer; }
            .tg-pony-search-clear:hover { background: #6B7280; }
            .tg-pony-highlight-toggle { background: #14B8A6 !important; color: white !important; border: none !important; border-radius: 6px !important; padding: 5px !important; font-size: 11px !important; cursor: pointer !important; height: 30px !important; box-sizing: border-box !important; }
            .tg-pony-highlight-toggle.off { background: #4B5563; color: #9CA3AF; }
            .tg-pony-highlight-row { display: flex; align-items: center; gap: 6px; }
            .tg-pony-highlight-row .tg-pony-highlight-toggle { flex: 1; }
            .tg-pony-highlight-color { width: 30px !important; height: 30px !important; min-width: 30px !important; padding: 0 !important; border: 1px solid #4B5563 !important; border-radius: 6px !important; cursor: pointer !important; -webkit-appearance: none !important; appearance: none !important; z-index: 10001 !important; pointer-events: auto !important; }
            .chat-line.tg-chat-highlight { background-color: var(--tg-chat-highlight-bg, rgba(245, 158, 11, 0.3)) !important; }
            .chat-line.tg-chat-hidden { display: none !important; }
            .tg-pony-afk-menu-group { display: flex; flex-direction: column; gap: 4px; }
            .tg-pony-afk-menu-label { display: flex; flex-direction: column; gap: 4px; font-size: 12px; color: #D1D5DB; }
            .tg-pony-afk-menu-input { background: #374151; border: 1px solid #4B5563; border-radius: 6px; padding: 8px 10px; color: #F9FAFB; font-size: 14px; font-family: Arial, sans-serif; text-align: center; }
            .tg-pony-afk-menu-input:focus { outline: none; border-color: var(--tg-afk); }
            .tg-pony-afk-menu-status { font-size: 11px; color: #9CA3AF; text-align: center; }
            .tg-pony-welcome-version { font-size: 12px; color: #6B7280; margin-bottom: 8px; }
            .tg-pony-welcome-features { list-style: none; padding: 0; margin: 0 0 16px 0; text-align: left; display: flex; flex-direction: column; gap: 6px; }
            .tg-pony-welcome-features li { font-size: 12px; color: #D1D5DB; line-height: 1.4; }
            .tg-pony-welcome-changelog { background: #374151; border-radius: 8px; padding: 12px 16px; margin-bottom: 16px; text-align: left; }
            .tg-pony-welcome-changelog-title { font-size: 13px; font-weight: bold; color: var(--tg-main-light); margin-bottom: 6px; }
            .tg-pony-welcome-changelog-list { list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 3px; }
            .tg-pony-welcome-changelog-list li { font-size: 11px; color: #9CA3AF; }
        `;
        document.head.appendChild(style);
    }

    // ================== ЧАТ ==================
    function openChat() {
        const chatButton = document.querySelector(".chat-open-button button");
        if (chatButton) { chatButton.click(); isChatOpen = true; }
    }
    function closeChat() {
        const closeButton = document.querySelector(".chat-close-button button");
        if (closeButton) { closeButton.click(); isChatOpen = false; }
    }
    function sendMessage(statsText) {
        if (!isActive || !isChatOpen || isSendingMessage) return;
        isSendingMessage = true;
        const textareaElement = document.querySelector("textarea[aria-label='Chat message']");
        if (textareaElement) {
            textareaElement.value = `${statsText.replace(/\d+\s?fps/, '')} [${messageCount}]`;
            textareaElement.dispatchEvent(new KeyboardEvent("keydown", { key: "Enter", bubbles: true, cancelable: true }));
            const sendButton = document.querySelector("ui-button[title='Send message (hold Shift to send without closing input)'] button");
            if (sendButton) sendButton.click();
            messageCount++;
            if (messageCount === 200) location.reload();
        }
        isSendingMessage = false;
    }
    function updateAndSendMessage() {
        sendMessage(greetingMessage);
        if (currentMode === MODES.CLASSIC && Math.random() < 0.39) {
            const event = new MouseEvent('click', { bubbles: true, cancelable: true, view: window });
            const element = document.elementFromPoint(window.innerWidth / 2, window.innerHeight / 2);
            if (element) element.dispatchEvent(event);
        }
    }
    function startAutoSend() {
        if (intervalId) clearInterval(intervalId);
        openChat();
        const delay = typeof MODE_INTERVALS[currentMode] === 'function' ? MODE_INTERVALS[currentMode]() : MODE_INTERVALS[currentMode];
        setTimeout(() => { if (isActive) updateAndSendMessage(); }, 1000);
        intervalId = setInterval(updateAndSendMessage, delay);
    }
    function stopAutoSend() {
        if (intervalId) { clearInterval(intervalId); intervalId = null; }
        closeChat();
    }
    function setMode(mode) {
        currentMode = mode;
        document.querySelectorAll('.tg-mode-btn').forEach(btn => btn.classList.toggle('active', btn.dataset.mode === mode));
        if (isActive) { stopAutoSend(); startAutoSend(); }
        updateAllTexts();
    }

    // ================== СТАРТОВОЕ ОКНО ==================
    function createWelcomeScreen() {
        if (document.getElementById('tgWelcomeOverlay')) return;
        const overlay = document.createElement('div');
        overlay.id = 'tgWelcomeOverlay';
        overlay.className = 'tg-pony-welcome-overlay';
        const modal = document.createElement('div');
        modal.className = 'tg-pony-welcome-modal';
        modal.innerHTML = `
            <div class="tg-pony-welcome-title">${t.welcomeTitle}</div>
            <div class="tg-pony-welcome-version">${t.welcomeVersion}</div>
            <a href="https://t.me/PubahiScript" target="_blank" class="tg-pony-welcome-tg-link">📢 t.me/PonyPubahi</a>
            <div class="tg-pony-welcome-lang-row">
                <span class="tg-pony-welcome-lang-label">${t.welcomeLangLabel}</span>
                <button class="tg-pony-welcome-lang-btn ${currentLang === 'ru' ? 'active' : ''}" data-lang="ru">🇷🇺 RU</button>
                <button class="tg-pony-welcome-lang-btn ${currentLang === 'en' ? 'active' : ''}" data-lang="en">🇬🇧 EN</button>
            </div>
            <ul class="tg-pony-welcome-features"><li>${t.welcomeFeature1}</li><li>${t.welcomeFeature2}</li><li>${t.welcomeFeature3}</li><li>${t.welcomeFeature4}</li><li>${t.welcomeFeature5}</li></ul>
            <div class="tg-pony-welcome-changelog"><div class="tg-pony-welcome-changelog-title">${t.changelogTitle}</div><ul class="tg-pony-welcome-changelog-list"><li>${t.changelog1}</li><li>${t.changelog2}</li><li>${t.changelog3}</li><li>${t.changelog4}</li><li>${t.changelog5}</li></ul></div>
            <button class="tg-pony-welcome-btn" id="tgWelcomeCloseBtn">${t.welcomeBtn}</button>
        `;
        overlay.appendChild(modal);
        document.body.appendChild(overlay);
        setTimeout(() => { overlay.classList.add('visible'); }, 100);

        modal.querySelectorAll('.tg-pony-welcome-lang-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const lang = btn.dataset.lang;
                setLanguage(lang);
                modal.querySelectorAll('.tg-pony-welcome-lang-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                updateWelcomeTexts(modal);
            });
        });

        modal.querySelector('#tgWelcomeCloseBtn').addEventListener('click', () => {
            overlay.classList.remove('visible');
            setTimeout(() => overlay.remove(), 400);
        });
    }

    function updateWelcomeTexts(modal) {
        modal.querySelector('.tg-pony-welcome-title').textContent = t.welcomeTitle;
        modal.querySelector('.tg-pony-welcome-version').textContent = t.welcomeVersion;
        modal.querySelector('.tg-pony-welcome-lang-label').textContent = t.welcomeLangLabel;
        modal.querySelector('.tg-pony-welcome-btn').textContent = t.welcomeBtn;
        modal.querySelector('.tg-pony-welcome-changelog-title').textContent = t.changelogTitle;
        const features = modal.querySelectorAll('.tg-pony-welcome-features li');
        const featureTexts = [t.welcomeFeature1, t.welcomeFeature2, t.welcomeFeature3, t.welcomeFeature4, t.welcomeFeature5];
        features.forEach((li, i) => { if (featureTexts[i]) li.textContent = featureTexts[i]; });
        const changelogItems = modal.querySelectorAll('.tg-pony-welcome-changelog-list li');
        const changelogTexts = [t.changelog1, t.changelog2, t.changelog3, t.changelog4, t.changelog5];
        changelogItems.forEach((li, i) => { if (changelogTexts[i]) li.textContent = changelogTexts[i]; });
    }

    // ================== СОЗДАНИЕ КНОПОК ==================
    function createGreetingButton() {
        if (document.getElementById('tgGreetingBtn')) return;
        createStyles();
        loadLanguage();
        loadTheme();
        applyTheme();
        try {
            const saved = localStorage.getItem('tg_pony_afk_interval');
            if (saved) { const s = parseInt(saved); if (s >= 1 && s <= 60) ANTIAFK_INTERVAL_MS = s * 1000; }
        } catch (e) {}

        const inputContainer = document.createElement('div');
        inputContainer.className = 'tg-pony-greeting-input';
        inputContainer.id = 'tgGreetingInput';
        inputContainer.innerHTML = `<textarea placeholder="${t.placeholder}" id="tgTextArea">${greetingMessage}</textarea><div class="tg-mode-label">${t.modeLabel}</div><div class="tg-mode-container"><div class="tg-mode-item"><button class="tg-mode-btn active" data-mode="classic">${t.modeClassic}</button></div><div class="tg-mode-item"><button class="tg-mode-btn" data-mode="slow">${t.modeSlow}</button></div><div class="tg-mode-item"><button class="tg-mode-btn" data-mode="spam">${t.modeSpam}</button></div></div><button class="tg-pony-start-btn" id="tgStartBtn">${t.spamStart}</button><div class="tg-pony-status-text" id="tgStatusText">${t.spamStatusStopped}</div><div class="tg-pony-counter-text" id="tgCounterText">${t.spamSent}: 0</div>`;
        document.body.appendChild(inputContainer);

        const btn = document.createElement('button');
        btn.className = 'tg-pony-btn'; btn.textContent = t.spamBtn; btn.id = 'tgGreetingBtn';
        document.body.appendChild(btn);
        btn.addEventListener('click', () => {
            const c = document.getElementById('tgGreetingInput');
            c.style.display = c.style.display === 'flex' ? 'none' : 'flex';
            if (c.style.display === 'flex') document.getElementById('tgTextArea').focus();
        });

        document.getElementById('tgStartBtn').addEventListener('click', function(e) {
            e.preventDefault();
            const ta = document.getElementById('tgTextArea');
            if (ta.value.trim()) greetingMessage = ta.value.trim();
            isActive = !isActive;
            if (isActive) {
                this.textContent = t.spamStop; this.classList.add('active');
                document.getElementById('tgStatusText').textContent = `${t.spamStatusActive} (${currentMode})`;
                document.getElementById('tgCounterText').classList.add('active');
                document.getElementById('tgCounterText').textContent = `${t.spamSent}: 0`;
                messageCount = 0; isSendingMessage = false; startAutoSend();
            } else {
                this.textContent = t.spamStart; this.classList.remove('active');
                document.getElementById('tgStatusText').textContent = t.spamStatusStoppedText;
                document.getElementById('tgCounterText').classList.remove('active'); stopAutoSend();
            }
        });

        document.querySelectorAll('.tg-mode-btn').forEach(b => {
            b.addEventListener('click', function(e) { e.stopPropagation(); setMode(this.dataset.mode); });
        });

        const afkBtn = document.createElement('button');
        afkBtn.className = 'tg-pony-afk-btn'; afkBtn.textContent = t.afkBtn; afkBtn.id = 'tgAfkBtn';
        document.body.appendChild(afkBtn);
        afkBtn.addEventListener('click', function() { toggleAfkMenu(); this.classList.toggle('active', isAfkMenuOpen); });

        const searchBtn = document.createElement('button');
        searchBtn.className = 'tg-pony-search-btn'; searchBtn.textContent = t.searchBtn; searchBtn.id = 'tgSearchBtn';
        document.body.appendChild(searchBtn);
        const searchPanel = document.createElement('div');
        searchPanel.className = 'tg-pony-search-input'; searchPanel.id = 'tgSearchPanel';
        searchPanel.innerHTML = `<input type="text" placeholder="${t.searchPlaceholder}" id="tgSearchInput"><div class="tg-pony-search-hint">${t.searchHint}</div><button class="tg-pony-search-clear">${t.searchClear}</button><div class="tg-pony-highlight-row"><button class="tg-pony-highlight-toggle">${t.highlightOn}</button><input type="color" class="tg-pony-highlight-color" value="${highlightColor}"></div>`;
        document.body.appendChild(searchPanel);
        updateHighlightColorVar();
        searchBtn.addEventListener('click', () => {
            searchPanel.style.display = searchPanel.style.display === 'flex' ? 'none' : 'flex';
            if (searchPanel.style.display === 'flex') { document.getElementById('tgSearchInput').focus(); startChatSearchObserver(); }
        });
        document.getElementById('tgSearchInput').addEventListener('input', function() {
            setChatSearch(this.value); searchBtn.classList.toggle('active', chatSearchTerms.length > 0);
        });
        searchPanel.querySelector('.tg-pony-search-clear').addEventListener('click', () => {
            document.getElementById('tgSearchInput').value = ''; setChatSearch(''); searchBtn.classList.remove('active');
        });
        const highlightToggle = searchPanel.querySelector('.tg-pony-highlight-toggle');
        highlightToggle.addEventListener('click', function() {
            highlightEnabled = !highlightEnabled;
            this.textContent = highlightEnabled ? t.highlightOn : t.highlightOff;
            this.classList.toggle('off', !highlightEnabled); applyFilterToAllLines();
        });
        searchPanel.querySelector('.tg-pony-highlight-color').addEventListener('input', function() {
            highlightColor = this.value; updateHighlightColorVar();
        });

        const settingsBtn = document.createElement('button');
        settingsBtn.className = 'tg-pony-settings-btn'; settingsBtn.textContent = t.settingsBtn; settingsBtn.id = 'tgSettingsBtn';
        document.body.appendChild(settingsBtn);
        settingsBtn.addEventListener('click', function() { toggleSettingsPanel(); this.classList.toggle('active', isSettingsPanelOpen); });

        const hideBtn = document.createElement('button');
        hideBtn.className = 'tg-pony-hide-script-ui-btn'; hideBtn.textContent = '👁‍🗨'; hideBtn.id = 'tgHideScriptUIBtn';
        hideBtn.title = t.hideTitle;
        document.body.appendChild(hideBtn);
        hideBtn.addEventListener('click', toggleScriptUI);

        console.log('✅ Все кнопки созданы');
    }

    // ================== ИНИЦИАЛИЗАЦИЯ ==================
    setTimeout(() => {
        createStyles();
        loadLanguage();
        loadTheme();
        applyTheme();
        createWelcomeScreen();
        createGreetingButton();
    }, 1500);

    const observer = new MutationObserver(() => {
        if (!document.getElementById('tgGreetingBtn')) createGreetingButton();
    });
    observer.observe(document.body, { childList: true, subtree: true });

})();
