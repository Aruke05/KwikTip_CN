<p align="center">
  <img src="assets/ktlogo.png" alt="KwikTip" />
</p>

<p align="center">
  World of Warcraft: Midnight (12.0.1)
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
- **Raid support** — difficulty-aware tips for the Midnight Season 1 raids (The Voidspire, March on Quel'Danas, The Dreamrift). Enabled by default; tips show automatically inside raid instances
- **Delve support** — boss tips for all 10 Midnight delves (opt-in via the **Enable in Delves** setting)
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

### Season 1 Mythic+ Rotation (8 dungeons)

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

### Additional Midnight Dungeons (not in M+)

These are in the current season's content but are not part of the keystone rotation. They have full boss tips; trash/area tips vary.

| Dungeon | Type |
|---|---|
| Murder Row | Level-up (81–88) |
| Den of Nalorakk | Level-up (81–88) |
| The Blinding Vale | Max level |
| Voidscar Arena | Max level |

### Raids

| Raid Wing | Notes |
|---|---|
| The Voidspire | 6 bosses — tips + role notes |
| March on Quel'Danas | uiMapID pending in-game verification |
| The Dreamrift | tips + role notes |

### Delves (10)

Collegiate Calamity, The Shadow Enclave, Parhelion Plaza, Twilight Crypts, Atal'Aman, The Darkway, The Grudge Pit, Gulf of Memory, Sunkiller Sanctum, Shadowguard Point. Boss tips for all; **opt-in** via the **Enable in Delves** setting.

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
