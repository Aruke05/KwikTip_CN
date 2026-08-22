-- KwikTip_CN: deDE detection names and sub-zone aliases (no bundled strategy prose)
local ADDON_NAME, KwikTip = ...
if GetLocale() ~= "deDE" then return end

KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID = {}
KwikTip.DUNGEON_LOCALE_BY_INSTANCEID = {}
KwikTip.AREA_OVERRIDE_BY_ID = {}
KwikTip.SUBZONE_LOCALE_BY_AREA_ID = {
    ["2805:1"] = {
        "Die Promenade",
    },
    ["2805:4"] = {
        "Königin Sylvanas' Gemächer",
    },
    ["2805:5"] = {
        "Windrunner-Gruft",
    },
    ["2805:6"] = {
        "Der Gipfel",
    },
    ["2811:1"] = {
        "Arkane Bibliothek",
    },
    ["2811:2"] = {
        "Beobachtungsgelände",
    },
    ["2811:3"] = {
        "Großmagistrix' Asyl",
    },
    ["2811:4"] = {
        "Turm der Theorie",
    },
    ["2811:5"] = {
        "Konstellarium",
    },
    ["2811:6"] = {
        "Himmelsorrery",
    },
    ["2813:1"] = {
        "Silbermond-Tierhandlung",
    },
    ["2813:2"] = {
        "Der Illegale Regen",
    },
    ["2813:3"] = {
        "Terrasse der Auguren",
    },
    ["2813:4"] = {
        "Lithiels Anlegestelle",
    },
    ["2825:1"] = {
        "Anhaltender Winter",
    },
    ["2825:2"] = {
        "Die Nahrungssuche",
    },
    ["2825:3"] = {
        "Traumwandler-Passage",
    },
    ["2825:4"] = {
        "Das Herz der Wut",
    },
    ["2915:1"] = {
        "Der Basar",
    },
    ["2915:2"] = {
        "Corespark-Triebwerk",
    },
    ["2915:3"] = {
        "Kernverteidigung Nullfeld",
    },
    ["2915:4"] = {
        "Der Nexus-Kern",
    },
}
