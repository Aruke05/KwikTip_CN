# KwikTip_CN — Custom Rich-Text Mythic+ Tips

`KwikTip_CN` is an independent Simplified Chinese edition based on
[postblink/KwikTip](https://github.com/postblink/KwikTip). Version
`3.4.0-cn.8` keeps the dungeon detection engine but removes all bundled
strategy prose. HUD bodies are written and maintained by the player.

## Rich-text editor

Open settings with `/kwikcn` or `/kwik`, then select **Tip Editor**.

- Select any of the eight dungeons in the current Mythic+ rotation.
- Edit a dungeon overview, boss entry, or detected non-boss area.
- Insert colors, tank/healer/DPS/interrupt icons, bullets, and line breaks from
  the toolbar, or type WoW rich-text markup directly.
- Check formatting in the live preview and save the entry.
- Unsaved text is preserved when switching entries or closing settings.

Text is stored in `KwikTipCNDB.customTips` under stable dungeon, encounter, and
area keys. Empty entries never fall back to bundled English or translated
strategy text.

The pencil button at the lower-left of the HUD opens a compact editor for the
currently displayed overview, boss, or area. It uses the same saved entry and
rich-text toolbar as settings; press `Ctrl+Enter` or click Save to apply it.

## Detection retained

The structural catalog still contains instance IDs, UI map IDs, encounter IDs,
NPC IDs, boss names, area IDs, and verified locale aliases. These fields drive
automatic HUD selection but contain no boss, trash, area, affix, raid, delve,
or Timewalking strategy prose.

Current Mythic+ editor catalog:

- Altar of Fangs
- Murder Row
- Den of Nalorakk
- The Blinding Vale
- Voidscar Arena
- Kings' Rest
- Temple of Sethraliss
- Ruby Life Pools

## Installation

1. Copy the repository directory to:

   ```text
   World of Warcraft\_retail_\Interface\AddOns\KwikTip_CN
   ```

2. Disable or remove the original `KwikTip` addon to avoid loading both.
3. Restart the game and enable **KwikTip 中文版** on the character screen.
4. Run `/kwikcn` and open **文本编辑 / Tip Editor**.

Configuration is saved independently in:

```text
WTF\Account\<account>\SavedVariables\KwikTip_CN.lua
```

## Commands

| Command | Action |
|---|---|
| `/kwikcn`, `/kwik` | Open settings |
| `/kwik move` | Move or lock the HUD |
| `/kwik preview` | Show a neutral HUD preview |
| `/kwik debug` | Print current dungeon detection state |
| `/kwik debuglog` | Toggle detection logging |
| `/kwik clearlog` | Clear saved debug logs |

## Verification

```powershell
python -m unittest tests.test_zhcn_static
lua5.1 tests/test_localization.lua
```

The tests verify that the current eight Mythic+ dungeons appear in the editor,
that bundled prose fields are absent, and that saved rich text reaches the
production HUD rendering path.

## License

GPL-3.0-or-later. See `LICENSE`.
