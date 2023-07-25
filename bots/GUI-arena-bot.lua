local Unlocker, awful, project = ...

local gui, settings, cmd = awful.UI:New("arenabot", {
	cmd = {"arena"},
	title = "ARENA BOT",
	show = false, -- show on load by default
	width = 500,
	height = 500,
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
    icon:SetTexture('Interface\\Icons\\Achievement_arena_2v2_2')
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    icon:SetPoint('TOPLEFT', 7, -5)
    self.icon = icon

    self:SetScript('OnClick', self.OnClick)

    self:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -25, -50)
    self:SetMovable(true)
    self:EnableMouse(true)
    self:RegisterForDrag("LeftButton")
    self:SetScript("OnDragStart", self.StartMoving)
    self:SetScript("OnDragStop", self.StopMovingOrSizing)

    self:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("Arena Bot")
        GameTooltip:Show()
        end)
end

function MinimapButton:OnClick(button)
    if button == 'LeftButton' then
        awful.call("RunMacroText", "/arena")
    elseif button == 'RightButton' then
        awful.call("RunMacroText", "/arena")
    end
end

MinimapButton:Load()

local info = gui:Tab("INFO")
info:Text({
  text = "To get menu back type /arena",
  header = true
})
info:Checkbox({
  text = "Show button menu (ArenaBOT)",
  var = "arenaBTN",
  default = true,
})
info:Checkbox({
  text = "Auto leave Arena (Toggle OFF if you have disconnect issues)",
  var = "autoLeave",
  default = false,
})
info:Checkbox({
  text = "Ignore Enemy Healer",
  var = "dontAttackHealer",
  default = false,
})
info:Checkbox({
  text = "Auto CC Trinket",
  var = "autoCCTrinket",
  default = false,
})
info:Checkbox({
    text = "Anti AFK                                                                               ",
    var = "antiAfk",
    default = true,
})
info:Checkbox({
    text = "Auto jump                                                                            ",
    var = "autoJump",
    default = false,
})
info:Checkbox({
    text = "Auto Mount, uses favorite mount                                                    ",
    var = "autoMount",
    default = true,
})
info:Checkbox({
  text = "Auto Burst                                     ",
  var = "autoBurst",
  default = true,
})
info:Checkbox({
  text = "Auto Open PVP Boxes                                            ",
  var = "autoBox",
  default = false,
})
info:Checkbox({
  text = "Auto Repair, need to be in Valdrakken                                     ",
  var = "autoRepair",
  default = true,
})

-- making the settings available to the rest of our project
project.settingsArenaBot = settings

local sf = gui:StatusFrame({
    colors = {
        background = {0, 0, 0, 0},
        enabled = {30, 240, 255, 1},
    },
    maxWidth = 500,
    padding = 10,
})
sf:Button({
    spellId = 382896,
    var = "queueSoloShuffle",
    text = "Q Shuffle",
    default = false,
    size = 25
})
sf:Button({
    spellId = 117489,
    var = "queue3Arena",
    text = "Q 3v3",
    default = false,
    size = 25
})
sf:Button({
    spellId = 382895,
    var = "queue2Arena",
    text = "Q 2v2",
    default = false,
    size = 25
})
sf:Button({
    spellId = 247928,
    var = "queueSkirmish",
    text = "Q Skirm",
    default = false,
    size = 25
})
sf:Button({
    spellId = 198877,
    var = "arenaBot",
    text = "Start",
    default = false,
    size = 25
})

local dps = gui:Tab("DPS")
dps:Text({
  text = "|cFFFF0000WARNING:|r This tab is for DPS (and FW) only!",
  paddingBottom = 15,
  header = true
})
dps:Checkbox({
    text = "Don't follow friend, Should be ON when playing with other ArenaBot users.",
    var = "dontFollowFriend",
    default = false,
  })
local healer = gui:Tab("HEALER")
healer:Text({
  text = "|cFFFF0000WARNING:|r This tab is for HEALERS only!",
  paddingBottom = 15,
  header = true
})
healer:Slider({
	text = "Healer Range Slider",
	var = "healerRange",
	min = 1,
	max = 30,
    step = 1,
	default = 20,
	valueType = "yards",
	tooltip = "yards from friend"
})

awful.addUpdateCallback(function()
    if settings.arenaBTN == true then
        sf:Show()
    end
    if settings.arenaBTN == false then
        sf:Hide()
    end
end)
