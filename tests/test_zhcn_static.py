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

    def test_priority_strategy_content_is_translated(self) -> None:
        source = (ROOT / "Locale" / "tips_zhCN.lua").read_text(encoding="utf-8")
        encounter_ids = set(re.findall(r"boss\[(\d+)\]", source))
        self.assertGreaterEqual(len(encounter_ids), 30)
        self.assertIn("读条前将首领拉到房间角落", source)
        self.assertIn("当前第 2 赛季", (ROOT / "README_zhCN.md").read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
