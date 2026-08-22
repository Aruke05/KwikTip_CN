-- KwikTip_CN: zhCN detection names and sub-zone aliases (no bundled strategy prose)
local ADDON_NAME, KwikTip = ...
if GetLocale() ~= "zhCN" then return end

KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID = {
    [3525] = {
        name = "阿兹塔雷克",
    },
}
-- Runtime APIs provide all current-season names. These verified fallbacks keep
-- the editor Chinese during the brief period before Challenge Mode data loads.
KwikTip.DUNGEON_LOCALE_BY_INSTANCEID = {
    [1877] = "塞塔里斯神庙",
    [2825] = "纳洛拉克的洞穴",
    [2993] = "毒牙祭坛",
}
KwikTip.AREA_OVERRIDE_BY_ID = {}
KwikTip.SUBZONE_LOCALE_BY_AREA_ID = {}
