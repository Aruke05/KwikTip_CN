<p align="center">
  <img src="assets/ktlogo.png" alt="KwikTip" />
</p>

<p align="center">
  World of Warcraft: Midnight (12.1.0)
</p>

A World of Warcraft: Midnight addon that displays contextual tips for dungeons, raids, delves, and Timewalking. As your group moves through an instance, KwikTip surfaces relevant boss and trash tips in a small, unobtrusive HUD — no interaction required mid-pull.

Inspired by **QE Dungeon Tips** by QEdev (no longer maintained).

**[Download on CurseForge](https://www.curseforge.com/wow/addons/kwiktip)** &nbsp;|&nbsp; **[Download on Wago](https://addons.wago.io/addons/kwiktip)** &nbsp;|&nbsp; **[Download on WoWInterface](https://www.wowinterface.com/downloads/info27074-KwikTip.html)**

![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)

---

## Screenshots

<p align="center">
  <img src="assets/example.png" alt="KwikTip in action" />
</p>

<p align="center">
  <img src="assets/tipwindow.png" alt="Tip HUD" />
  &nbsp;&nbsp;
  <img src="assets/settings.png" alt="Settings window" />
</p>

---

## Features

- **Boss tips** — concise, actionable guidance for every boss across dungeons, raids, delves, and Timewalking
- **Sub-zone aware HUD** — the HUD updates automatically as your group moves through each area; boss room tips surface on entry before the encounter starts, and trash sections in supported dungeons get their own contextual tips
- **Role-specific notes** — tips are categorized by role (tank, healer, DPS, general) and interrupt priority, each with a distinct color and icon so you can find what's relevant at a glance
- **M+ affix display** — active keystone affix names and tips are shown in the HUD while waiting between encounters
- **Raid support** — difficulty-aware tips for Season 1 raids (The Voidspire, March on Quel'Danas, The Dreamrift) and a prepared skeleton for the Season 2 raid (Venomous Abyss — opens Aug 18). Enabled by default; tips show automatically inside raid instances
- **Delve support** — boss tips for all 10 Season 1 delves (opt-in via the **Enable in Delves** setting), plus 3 Season 2 delve stubs (Ring of Glory, Gnarldor Isle, Venomfall Deeps)
- **Timewalking support** — all 35 Timewalking dungeons are registered by expansion pool (Burning Crusade through Legion); boss tips are being filled in pool by pool
- **Custom notes** — save your own per-subzone notes that appear alongside tips in the HUD
- **Persistent Tip Window** — optionally keep the HUD visible throughout a run
- **Send to Chat** — print the current tip to Say, Instance, Party, or Raid so your group can read it
- **Resizable, draggable HUD** — drag to reposition, drag corners to resize; locks in place when done. Auto-expand height is available so long tips aren't cut off
- **LibSharedMedia-3.0 support** — font picker lists all fonts registered by your other addons if LSM is present; falls back to three built-in WoW fonts otherwise
- **German (deDE) localization** — the settings UI, slash help, and HUD labels are fully translated for German clients (tip content stays English)

---

## Dungeon Coverage

Boss tips are present for every dungeon, raid wing, delve, and (where filled) Timewalking entry below. Full area-tip coverage — boss rooms and trash sections — is live for the Midnight and legacy M+ dungeons.

### Season 2 Mythic+ Rotation (8 dungeons, Patch 12.1)

| Dungeon | Type |
|---|---|
| Altar of Fangs | New — Midnight (3 bosses) |
| Murder Row | Promoted — Midnight |
| Den of Nalorakk | Promoted — Midnight |
| The Blinding Vale | Promoted — Midnight |
| Voidscar Arena | Promoted — Midnight (method.gg guide pending) |
| Kings' Rest | Legacy — BfA (method.gg guide pending) |
| Temple of Sethraliss | Legacy — BfA |
| Ruby Life Pools | Legacy — Dragonflight |

All 8 dungeons have boss tips + role notes. Trash tips are complete for 7/8 (Voidscar Arena pending). Of the 8, 4 dungeons still have `instanceID = 0` / `uiMapID = 0` (Kings' Rest, Temple of Sethraliss, Ruby Life Pools, Altar of Fangs) — IDs will auto-fill from the in-game log once run with `/kwik debuglog` and `tools/sync_ids.py --apply`. Altar of Fangs and Ruby Life Pools tips were rewritten from the live S2 method.gg guides; Blinding Vale cross-verified with corrections; Murder Row, Den of Nalorakk, and Temple of Sethraliss confirmed clean. Voidscar Arena and Kings' Rest tips stand on Tactyks' YouTube S2 guides until method.gg publishes.

### Season 1 Mythic+ Rotation (still supported)

| Dungeon | Type |
|---|---|
| Windrunner Spire | New — Midnight |
| Maisara Caverns | New — Midnight |
| Magisters' Terrace | New — Midnight (reworked) |
| Nexus-Point Xenas | New — Midnight |
| Algeth'ar Academy | Legacy |
| Pit of Saron | Legacy |
| Seat of the Triumvirate | Legacy |
| Skyreach | Legacy |

Full boss + trash tips, all IDs confirmed in-game.

### Raids

| Raid Wing | Notes |
|---|---|
| The Voidspire (S1) | 6 bosses — tips + role notes |
| March on Quel'Danas (S1) | uiMapID pending in-game verification |
| The Dreamrift (S1) | tips + role notes |
| **Venomous Abyss (S2)** | **Opens Aug 18, 2026 — 8-boss skeleton present, tips TODO.** |

### Delves (13)

10 Season 1 delves (Collegiate Calamity, The Shadow Enclave, Parhelion Plaza, Twilight Crypts, Atal'Aman, The Darkway, The Grudge Pit, Gulf of Memory, Sunkiller Sanctum, Shadowguard Point) — boss tips for all; **opt-in** via the **Enable in Delves** setting. 3 Season 2 delve stubs added (The Ring of Glory, Gnarldor Isle, Venomfall Deeps — Nemesis) — boss tips TODO, IDs 0.

### Timewalking (35 dungeons)

Registered across six pools: Burning Crusade, Wrath of the Lich King, Cataclysm, Mists of Pandaria, Warlords of Draenor, and Legion. `uiMapID`s are set to `0` and boss tips are still being added — verify a dungeon's `uiMapID` in-game with `/run print(C_Map.GetBestMapForUnit("player"))` and contribute tips from Wowhead (primary) + warcraft.wiki.gg (secondary).

---

## Installation

1. Download or clone this repository
2. Copy the `KwikTip` folder into your addons directory:
   ```
   World of Warcraft/_retail_/Interface/AddOns/KwikTip
   ```
3. Enable the addon in the WoW character select screen

---

## Usage

| Command | Action |
|---|---|
| `/kwiktip` or `/kwik` | Open/close settings |
| `/kwik move` | Toggle move mode (drag and resize the HUD) |
| `/kwik debug` | Print current instance detection state to chat |
| `/kwik debuglog` | Toggle map/mob ID logging to SavedVariables |
| `/kwik preview` | Toggle role notes preview in the HUD |
| `/kwik clearlog` | Clear all debug logs from SavedVariables |
| `/kwik feedback` | Print the feedback/issue link to chat |
| `/kwik help` | Print all available commands to chat |

The HUD is hidden outside of instances. Use `/kwik move` to show and reposition it at any time.

### Settings

Open the settings window (minimap button or `/kwik`) to configure:

- **Persistent Tip Window** — keep the HUD visible between subzone changes during a run
- **Enable Custom Notes** — show the per-subzone note button so you can save personal notes
- **Enable in Delves** — opt in to tips inside Delve (scenario) instances
- **Hide HUD** — quickly hide the addon without disabling it; toggle again to show
- **Auto-expand Height** — let the HUD grow for long tips instead of clipping
- **Send to Chat** — choose None / Say / Instance / Party / Raid to print the current tip
- **Font** — pick from LibSharedMedia-3.0 fonts (falls back to built-in WoW fonts)
- **Preview** — see how role notes render without entering an instance

A minimap button (when enabled) provides quick access: left-click opens settings, right-click toggles move mode, drag to reposition.

---

## Translations

The settings UI, slash help, and HUD labels are fully localizable. **German (deDE)** is bundled and maintained with each release. Tip content intentionally stays in English — mechanical accuracy is critical and mistranslations could cost your group a key.

To contribute a translation for your language:

1. Log in to CurseForge
2. Go to the [KwikTip localization page](https://legacy.curseforge.com/wow/addons/kwiktip/localization)
3. Select your language and fill in the strings

Translations are pulled automatically into each release via the CurseForge packager.

---

## Feedback & Tips

Tips feel off or missing? File an issue: https://github.com/postblink/KwikTip/issues

There are templates for bug reports and tip suggestions — the tip-suggestion template is the fastest way to get a correction or addition into the next release.
