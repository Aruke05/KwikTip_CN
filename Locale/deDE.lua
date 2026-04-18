-- KwikTip: German (deDE) client strings — UI, chat, debug, preview demo.
local _, KwikTip = ...
if GetLocale() ~= "deDE" then return end

local L = KwikTip.L

-- Init
L["loaded. Type /kwik for settings."] = "geladen. Tippe /kwik für die Einstellungen."

-- Frames / HUD
L["Print tip to instance chat"] = "Tipp in Instanzchat ausgeben"
L["Add Note"] = "Notiz hinzufügen"
L["Save"] = "Speichern"
L["Clear"] = "Leeren"
L["Note"] = "Notiz"
L["Add a personal note for this area"] = "Persönliche Notiz für diesen Bereich hinzufügen"

-- Core — Warte-/Demo-Texte
L["Waiting for relevant encounter..."] = "Warte auf passende Begegnung …"
L["Demo Dungeon"] = "Beispiel-Dungeon"
L["Example Boss"] = "Beispiel-Boss"

-- Slash-Hilfe
L["commands:"] = "Befehle:"
L["  /kwik           — open settings"] = "  /kwik           — Einstellungen öffnen"
L["  /kwik move      — toggle move/lock mode"] = "  /kwik move      — Verschieben/Sperren umschalten"
L["  /kwik preview   — toggle role notes preview in the HUD"] = "  /kwik preview   — Rollen-Vorschau im HUD umschalten"
L["  /kwik debug     — print current detection state to chat"] = "  /kwik debug     — Erkennungsstatus in den Chat ausgeben"
L["  /kwik debuglog  — toggle map/mob ID logging to SavedVariables"] = "  /kwik debuglog  — Karten-/Mob-ID-Protokollierung (SavedVariables) umschalten"
L["  /kwik clearlog  — clear all debug logs from SavedVariables"] = "  /kwik clearlog  — alle Debug-Protokolle in SavedVariables löschen"
L["  /kwik feedback  — print the feedback/issue link"] = "  /kwik feedback  — Feedback-/Issue-Link ausgeben"
L["  /kwik help      — show this command list"] = "  /kwik help      — diese Befehlsliste anzeigen"
L["unknown command. Type /kwik help for a list of commands."] = "Unbekannter Befehl. Tippe /kwik help für die Befehlsliste."

-- Affix detail heading (format: +Level …)
L["+%d Active Affixes"] = "+%d Aktive Affixe"

-- Preview (role demo)
L["Avoid the red zones; use a personal defensive on the big hit."] = "Rote Zonen meiden; beim großen Treffer persönliche Defensive nutzen."
L["Tank swap at 3 stacks of the debuff."] = "Tankwechsel bei 3 Stapeln des Debuffs."
L["Major healing CDs after every Cataclysm cast."] = "Starke Heil-CDs nach jedem Cataclysm-Wirken."
L["Kill adds before switching back to the boss."] = "Adds zuerst töten, dann wieder auf den Boss."
L["Shadowbolt — interrupt every cast, no exceptions."] = "Schattenblitz — jeden Zauber unterbrechen, ohne Ausnahme."

-- Debug output (/kwik debug, debuglog, clearlog, feedback)
L["debug:"] = "Debug:"
L["  inInstance=%s  type=%s  boss=%s  area=%s  dungeon=%s"] = "  inInstance=%s  Typ=%s  Boss=%s  Bereich=%s  Dungeon=%s"
L["  instanceID=%s  mapID=%s  dungeon=%s"] = "  Instanz-ID=%s  Karten-ID=%s  Dungeon=%s"
L["  subzone=%q  role=%s"] = "  Unterzone=%q  Rolle=%s"
L["  keystone=+%d  affixes=%d"] = "  Schlüsselstein=+%d  Affixe=%d"
L["  mapIDLog=%d  encounterLog=%d  keystoneLog=%d  spellLog=%d  snapshots=%d"] = "  mapIDLog=%d  encounterLog=%d  keystoneLog=%d  spellLog=%d  Snapshots=%d"
L["debug logging %s."] = "Debug-Protokollierung %s."
L["enabled"] = "aktiviert"
L["disabled"] = "deaktiviert"
L["mapIDLog, encounterLog, keystoneLog, spellLog, and debugSnapshots cleared."] = "mapIDLog, encounterLog, keystoneLog, spellLog und debugSnapshots geleert."
L["Tips feel off? Open an issue at: https://github.com/postblink/KwikTip/issues"] = "Tipps passen nicht? Issue auf https://github.com/postblink/KwikTip/issues eröffnen"

-- UI_Config
L["Left-click: Settings"] = "Linksklick: Einstellungen"
L["Right-click: Move HUD"] = "Rechtsklick: HUD verschieben"
L["Drag: Reposition"] = "Ziehen: Position ändern"
L["KwikTip Settings"] = "KwikTip-Einstellungen"
L["General"] = "Allgemein"
L["Layout"] = "Layout"
L["Appearance"] = "Darstellung"
L["Preview"] = "Vorschau"
L["DISPLAY"] = "ANZEIGE"
L["Disable Tips"] = "Tipps deaktivieren"
L["Show Minimap Button"] = "Minikarten-Button anzeigen"
L["Persistent Tip Window"] = "Dauerhaftes Tipp-Fenster"
L["Quickly hides the addon without disabling it. Toggle again to show it."] = "Blendet das Addon schnell aus, ohne es zu deaktivieren. Erneut umschalten, um es wieder anzuzeigen."
L["Keeps the tip window visible between subzone changes during a run."] = "Hält das Tipp-Fenster beim Unterzonenwechsel im Lauf sichtbar."
L["Enable Custom Notes"] = "Eigene Notizen aktivieren"
L["Allows you to save a custom note for each subzone."] = "Erlaubt eine eigene Notiz pro Unterzone."
L["Enable in Delves"] = "In Tiefen aktivieren"
L["Shows tips inside Delve instances."] = "Zeigt Tipps in Tiefen-Instanzen an."
L["SEND TO CHAT"] = "IN CHAT SENDEN"
L["None"] = "Keine"
L["Say"] = "Sagen"
L["Instance"] = "Instanz"
L["Party"] = "Gruppe"
L["Raid"] = "Schlachtzug"
L["POSITION"] = "POSITION"
L["Move Window"] = "Fenster verschieben"
L["Lock Window"] = "Fenster sperren"
L["SIZING"] = "GRÖSSE"
L["W:"] = "B:"
L["H:"] = "H:"
L["Auto-expand Height"] = "Höhe automatisch anpassen"
L["WINDOW"] = "FENSTER"
L["Opacity"] = "Deckkraft"
L["Opacity: %d%%"] = "Deckkraft: %d%%"
L["Show Border"] = "Rahmen anzeigen"
L["Border Color:"] = "Rahmenfarbe:"
L["TEXT"] = "TEXT"
L["Size: %d"] = "Größe: %d"
L["Text Shadow"] = "Textschatten"
L["Outline:"] = "Kontur:"
L["Outline"] = "Kontur"
L["Thick Outline"] = "Dicke Kontur"
