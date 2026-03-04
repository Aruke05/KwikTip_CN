-- KwikTip: HUD frame and layout API
local ADDON_NAME, KwikTip = ...

-- ============================================================
-- HUD Frame
-- ============================================================
local hud = CreateFrame("Frame", "KwikTipHUD", UIParent, "BackdropTemplate")
KwikTip.HUD = hud

hud:SetFrameStrata("MEDIUM")
hud:SetClampedToScreen(true)
hud:SetMovable(true)
hud:EnableMouse(false)  -- mouse passthrough by default; enabled only in move mode
hud:Hide()

hud:SetBackdrop({
    bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
    insets   = { left = 1, right = 1, top = 1, bottom = 1 },
})
hud:SetBackdropColor(0, 0, 0, 0.75)
hud:SetBackdropBorderColor(0, 0, 0, 1)

-- Content text label
local contentText = hud:CreateFontString(nil, "OVERLAY", "GameFontNormal")
contentText:SetPoint("TOPLEFT",     hud, "TOPLEFT",     6, -6)
contentText:SetPoint("BOTTOMRIGHT", hud, "BOTTOMRIGHT", -6,  6)
contentText:SetJustifyH("LEFT")
contentText:SetJustifyV("TOP")
contentText:SetWordWrap(true)
contentText:SetText("")
KwikTip.HUDText = contentText

-- ============================================================
-- Drag support
-- ============================================================
hud:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
        self:StartMoving()
    end
end)

hud:SetScript("OnMouseUp", function(self)
    self:StopMovingOrSizing()
    KwikTipDB.x = math.floor(self:GetLeft() + self:GetWidth() / 2 - UIParent:GetWidth() / 2 + 0.5)
    KwikTipDB.y = math.floor(self:GetBottom() + self:GetHeight() / 2 - UIParent:GetHeight() / 2 + 0.5)
end)

-- ============================================================
-- Public API
-- ============================================================

-- Apply saved settings to the HUD (size, opacity, position).
function KwikTip:ApplySettings()
    local db = KwikTipDB
    hud:SetSize(db.width, db.height)
    hud:SetBackdropColor(0, 0, 0, db.alpha)
    hud:ClearAllPoints()
    hud:SetPoint("CENTER", UIParent, "CENTER", db.x or 0, db.y or 0)
end

-- Show the HUD when any active state warrants it, or when move mode is active.
--   bossActive  : ENCOUNTER_START is in progress
--   trashActive : player is targeting a known trash mob
--   areaActive  : player is inside a named area bounding box
-- Respects the persistentHide flag set from the config window.
function KwikTip:UpdateVisibility()
    if KwikTipDB.persistentHide and not self.moveMode then
        hud:Hide()
        return
    end

    if self.moveMode or self.bossActive or self.trashActive or self.areaActive then
        hud:Show()
    else
        hud:Hide()
    end
end

-- Toggle between move mode (draggable, gold border) and locked mode.
-- Config.lua defines _UpdateConfigMoveBtn; it will be a no-op until that file loads.
function KwikTip:ToggleMoveMode()
    self.moveMode = not self.moveMode

    if self.moveMode then
        hud:EnableMouse(true)
        hud:Show()
        hud:SetBackdropBorderColor(1, 0.82, 0, 1)  -- gold outline = move mode active
    else
        hud:EnableMouse(false)
        hud:SetBackdropBorderColor(0, 0, 0, 1)
        -- Persist final position before potentially hiding
        KwikTipDB.x = math.floor(hud:GetLeft() + hud:GetWidth() / 2 - UIParent:GetWidth() / 2 + 0.5)
        KwikTipDB.y = math.floor(hud:GetBottom() + hud:GetHeight() / 2 - UIParent:GetHeight() / 2 + 0.5)
        self:UpdateVisibility()
    end

    -- Sync the button label in the config window if it is open
    if self._UpdateConfigMoveBtn then
        self:_UpdateConfigMoveBtn()
    end
end

-- Set the text displayed inside the HUD box.
-- Guards against redundant SetText calls when content hasn't changed.
function KwikTip:SetContent(str)
    str = str or ""
    if self._lastContent == str then return end
    self._lastContent = str
    contentText:SetText(str)
end
