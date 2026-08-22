-- KwikTip_CN: zhCN detection names and sub-zone aliases (no bundled strategy prose)
local ADDON_NAME, KwikTip = ...
if GetLocale() ~= "zhCN" then return end

KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID = {
    [3525] = {
        name = "阿兹塔雷克",
    },
}
KwikTip.AREA_OVERRIDE_BY_ID = {}
KwikTip.SUBZONE_LOCALE_BY_AREA_ID = {}
