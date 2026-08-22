"""Static checks for the bundled Simplified Chinese locale.

Run from the repository root with:
    python -m unittest tests.test_zhcn_static
"""

from pathlib import Path
import re
import unittest


ROOT = Path(__file__).resolve().parents[1]
ASSIGNMENT = re.compile(r"^\s*(?:L\.)?([A-Z][A-Z0-9_]*)\s*=\s*\"(.*)\"\s*,?\s*$")
PLACEHOLDER = re.compile(r"%(?:\d+\$)?[-+ #0]*(?:\d+|\*)?(?:\.\d+)?[cdeEfgGiouqsxX%]")


def locale_strings(path: Path) -> dict[str, str]:
    result: dict[str, str] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        match = ASSIGNMENT.match(line)
        if match:
            result[match.group(1)] = match.group(2)
    return result


class ZhCNLocaleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.english = locale_strings(ROOT / "Locale" / "enUS.lua")
        cls.chinese = locale_strings(ROOT / "Locale" / "zhCN.lua")

    def test_every_english_key_is_translated(self) -> None:
        self.assertEqual(set(self.english), set(self.chinese))

    def test_format_placeholders_are_preserved(self) -> None:
        for key, english in self.english.items():
            with self.subTest(key=key):
                self.assertEqual(
                    PLACEHOLDER.findall(english),
                    PLACEHOLDER.findall(self.chinese[key]),
                )

    def test_locale_guard_is_zhcn_only(self) -> None:
        source = (ROOT / "Locale" / "zhCN.lua").read_text(encoding="utf-8")
        self.assertIn('if GetLocale() ~= "zhCN" then return end', source)

    def test_toc_loads_zhcn_after_base_locale(self) -> None:
        toc = (ROOT / "KwikTip_CN.toc").read_text(encoding="utf-8")
        self.assertIn("## Title-zhCN:", toc)
        self.assertIn("## Notes-zhCN:", toc)
        self.assertLess(toc.index("Locale\\enUS.lua"), toc.index("Locale\\zhCN.lua"))
        self.assertIn("Locale\\tips_zhCN.lua", toc)
        self.assertLess(toc.index("Locale\\tips_zhCN.lua"), toc.index("CustomTips.lua"))
        self.assertLess(toc.index("CustomTips.lua"), toc.index("Core.lua"))

    def test_standalone_addon_identity(self) -> None:
        toc_path = ROOT / "KwikTip_CN.toc"
        self.assertTrue(toc_path.exists())
        self.assertFalse((ROOT / "KwikTip.toc").exists())
        toc = toc_path.read_text(encoding="utf-8")
        self.assertIn("## SavedVariables: KwikTipCNDB", toc)
        self.assertNotIn("X-Curse-Project-ID", toc)
        self.assertNotIn("X-Wago-ID", toc)
        self.assertNotIn("X-WoWI-ID", toc)
        self.assertIn("package-as: KwikTip_CN", (ROOT / ".pkgmeta").read_text(encoding="utf-8"))
        ui = (ROOT / "UI_Config.lua").read_text(encoding="utf-8")
        self.assertIn(r"Interface\\AddOns\\KwikTip_CN\\assets", ui)

    def test_bundled_strategy_prose_is_removed(self) -> None:
        sources = [
            ROOT / "DungeonData.lua",
            ROOT / "DungeonData_Timewalking.lua",
            ROOT / "Locale" / "tips_deDE.lua",
            ROOT / "Locale" / "tips_zhCN.lua",
        ]
        combined = "\n".join(path.read_text(encoding="utf-8") for path in sources)
        self.assertNotRegex(combined, r"\btip\s*=")
        self.assertNotRegex(combined, r"\bnotes\s*=")
        self.assertIn("当前第 2 赛季", (ROOT / "README_zhCN.md").read_text(encoding="utf-8"))

    def test_custom_rich_text_mode_is_wired(self) -> None:
        custom = (ROOT / "CustomTips.lua").read_text(encoding="utf-8")
        ui = (ROOT / "UI_Config.lua").read_text(encoding="utf-8")
        frames = (ROOT / "Frames.lua").read_text(encoding="utf-8")
        init = (ROOT / "Init.lua").read_text(encoding="utf-8")
        self.assertIn("KwikTip.CUSTOM_TIPS_ONLY = true", custom)
        self.assertIn("GetEditableMythicPlusDungeons", custom)
        self.assertIn("customTips", init)
        self.assertIn("L.TAB_TIP_EDITOR", ui)
        self.assertIn("EDITOR_PREVIEW", ui)
        self.assertIn("SetCustomTip", ui)
        self.assertIn("GetCurrentTipEditTarget", frames)
        self.assertIn("SetMaxLetters(8000)", frames)
        self.assertIn("UpdateNotePreview", frames)


if __name__ == "__main__":
    unittest.main()
