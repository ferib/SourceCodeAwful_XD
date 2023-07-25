local Unlocker, awful, project = ...

local gui, settings, cmd = awful.UI:New("FishingBot", {
	cmd = {"fishing"},
	title = "Fishing BOT",
	show = false, -- show on load by default
	width = 400,
	height = 200,
	scale = 1,
	colors = {
		-- color of our ui title in the top left
		title = yellow,
		-- primary is the primary text color
		primary = white,
		-- accent controls colors of elements and some element text in the UI. it should contrast nicely with the background.
		accent = yellow,
		background = dark,
	}
})

local MinimapButton = CreateFrame('Button', "MainMenuBarToggler", Minimap)

function MinimapButton:Load()
    self:SetFrameStrata('HIGH')
    self:SetWidth(31)
    self:SetHeight(31)
    self:SetFrameLevel(8)
    self:RegisterForClicks('anyUp')
    self:SetHighlightTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight')

    local overlay = self:CreateTexture(nil, 'OVERLAY')
    overlay:SetWidth(53)
    overlay:SetHeight(53)
    overlay:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder')
    overlay:SetPoint('TOPLEFT')

    local icon = self:CreateTexture(nil, 'BACKGROUND')
    icon:SetWidth(20)
    icon:SetHeight(20)
    icon:SetTexture('Interface\\Icons\\Trade_fishing')
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    icon:SetPoint('TOPLEFT', 7, -5)
    self.icon = icon

    self:SetScript('OnClick', self.OnClick)

    self:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -26, -76)
    self:SetMovable(true)
    self:EnableMouse(true)
    self:RegisterForDrag("LeftButton")
    self:SetScript("OnDragStart", self.StartMoving)
    self:SetScript("OnDragStop", self.StopMovingOrSizing)

    self:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("XD FishingBOT")
        GameTooltip:Show()
        end)
end

function MinimapButton:OnClick(button)
    if button == 'LeftButton' then
        awful.call("RunMacroText", "/fishing")
    elseif button == 'RightButton' then
        awful.call("RunMacroText", "/fishing")
    end
end

MinimapButton:Load()

-- making the settings available to the rest of our project
project.settingsFishingBot = settings

local info = gui:Tab("INFO")
info:Text({
  text = "To get menu back type /fishing",
  header = true
})
info:Checkbox({
  text = "Show button menu (FishingBOT)",
  var = "fishingBTN",
  default = true,
})

local sf = gui:StatusFrame({
    colors = {
        background = {0, 0, 0, 0},
        enabled = {30, 240, 255, 1},
    },
    maxWidth = 500,
    padding = 10,
})
sf:Button({
    spellId = 393734,
    var = "autoFishInQueue",
    text = "Fish Between Games",
    default = false,
    size = 25
})
sf:Button({
    spellId = 271677,
    var = "autoFish",
    text = "Start",
    default = false,
    size = 25
})

awful.addUpdateCallback(function()
    if settings.fishingBTN == true then
        sf:Show()
    end
    if settings.fishingBTN == false then
        sf:Hide()
    end
end)
