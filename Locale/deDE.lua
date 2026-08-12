-- KwikTip: German (deDE) locale
-- Semantic keys matching enUS.lua. Overrides only the keys that differ.
-- Untranslated keys fall back through enUS.lua → metatable (self-string).
-- Strategy prose translations belong in Locale/tips_deDE.lua, not here.
local ADDON_NAME, KwikTip = ...
local L = KwikTip.L

-- ============================================================
-- Set UI translations: override L table values for deDE locale
-- ============================================================
local t = {
    SETTINGS_TITLE    = "KwikTip Einstellungen",
    LOADED_MSG        = "geladen. /kwik für Einstellungen.",
    COMMANDS          = "Befehle:",
    CMD_OPEN          = "  /kwik           — Einstellungen öffnen",
    CMD_MOVE          = "  /kwik move      — Bewegungsmodus umschalten",
    CMD_PREVIEW       = "  /kwik preview   — Rollennotizen-Vorschau umschalten",
    CMD_DEBUG         = "  /kwik debug     — aktuellen Erkennungsstatus anzeigen",
    CMD_DEBUGLOG      = "  /kwik debuglog  — Karten-/NPC-ID-Logging umschalten",
    CMD_CLEARLOG      = "  /kwik clearlog  — alle Debug-Logs löschen",
    CMD_FEEDBACK      = "  /kwik feedback  — Feedback-Link anzeigen",
    CMD_HELP          = "  /kwik help      — Befehlsliste anzeigen",
    CMD_UNKNOWN       = "Unbekannter Befehl. /kwik help für eine Befehlsliste.",
    WAITING_ENCOUNTER = "Warte auf relevante Begegnung...",
    DEMO_DUNGEON      = "Demo-Dungeon",
    DEMO_BOSS         = "Beispiel-Boss",
    TAB_GENERAL       = "Allgemein",
    TAB_LAYOUT        = "Layout",
    TAB_APPEARANCE    = "Erscheinungsbild",
    PREVIEW_BTN       = "Vorschau",
    SECTION_DISPLAY   = "ANZEIGE",
    CHECK_DISABLE     = "Tipps deaktivieren",
    CHECK_MINIMAP     = "Minimap-Button anzeigen",
    CHECK_PERSISTENT  = "Beständiges Tip-Fenster",
    TOOLTIP_HIDE      = "Blendet das Addon aus, ohne es zu deaktivieren. Erneutes Umschalten zeigt es wieder.",
    TOOLTIP_PERSISTENT = "Hält das Tip-Fenster zwischen Zonenwechseln sichtbar.",
    CHECK_NOTES       = "Benutzerdefinierte Notizen aktivieren",
    TOOLTIP_NOTES     = "Ermöglicht das Speichern persönlicher Notizen für jede Subzone.",
    CHECK_DELVES      = "In Delven aktivieren",
    TOOLTIP_DELVES    = "Zeigt Tipps in Delve-Instanzen.",
    SECTION_CHAT      = "IN CHAT SENDEN",
    LABEL_NONE        = "Keiner",
    CHAT_SAY          = "Sagen",
    CHAT_INSTANCE     = "Instanz",
    CHAT_PARTY        = "Gruppe",
    CHAT_RAID         = "Schlachtzug",
    SECTION_POSITION  = "POSITION",
    BTN_MOVE          = "Fenster verschieben",
    BTN_LOCK          = "Fenster sperren",
    SECTION_SIZING    = "GRÖSSE",
    LABEL_WIDTH       = "B:",
    LABEL_HEIGHT      = "H:",
    CHECK_AUTOEXPAND  = "Automatische Höhe",
    SECTION_WINDOW    = "FENSTER",
    SLIDER_OPACITY    = "Deckkraft",
    FMT_OPACITY       = "Deckkraft: %d%%",
    CHECK_BORDER      = "Rahmen anzeigen",
    LABEL_BORDER_COLOR = "Rahmenfarbe:",
    SECTION_TEXT      = "TEXT",
    FMT_SIZE          = "Größe: %d",
    CHECK_SHADOW      = "Textschatten",
    LABEL_OUTLINE     = "Umrandung:",
    OUTLINE_OUTLINE   = "Umrandung",
    OUTLINE_THICK     = "Dicke Umrandung",
    TOOLTIP_MINIMAP_LEFT = "Linksklick: Einstellungen",
    TOOLTIP_MINIMAP_RIGHT = "Rechtsklick: HUD verschieben",
    TOOLTIP_MINIMAP_DRAG  = "Ziehen: positionieren",
    BTN_NOTE_ADD      = "Notiz hinzufügen",
    LABEL_NOTE        = "Notiz",
    BTN_NOTE_SAVE     = "Speichern",
    BTN_NOTE_CLEAR    = "Löschen",
    TOOLTIP_PRINT     = "Tipp in den Instanzchat senden",
    TOOLTIP_NOTE      = "Persönliche Notiz für diesen Bereich hinzufügen",
}

-- Apply translations directly to the L table
for k, v in pairs(t) do
    L[k] = v
end