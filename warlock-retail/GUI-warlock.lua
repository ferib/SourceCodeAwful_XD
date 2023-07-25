local Unlocker, awful, project = ...
awful.DevMode = true
if awful.player.class2 ~= "WARLOCK" then return end
local Draw = awful.Draw
local player, target, focus, healer, enemyHealer = awful.player, awful.target, awful.focus, awful.healer, awful.enemyHealer
local AwfulFont = awful.createFont(12, "OUTLINE")
local demonicGateway = awful.Spell(111771, { radius = 2 })
local soulBurn = awful.Spell(385899, { beneficial = true, targeted = false, ignoreFacing = true })
local soulBurnBuff = awful.Spell(387626, { beneficial = true, targeted = false, ignoreFacing = true })
local demonicCircle = awful.Spell(48018, { beneficial = true, ignoreMoving = false, ignoreFacing = true })
local demonicCircleTeleport = awful.Spell(48020, { beneficial = true, ignoreMoving = false, ignoreFacing = true })
local FieldMedicsHazardPayout = GetItemInfo(203724)
local VictoriousContendersStrongbox = GetItemInfo(201250)
local ShadowflameResidueSack = GetItemInfo(205423)
local LargeShadowflameResidueSack = GetItemInfo(205682)
local WhelplingsShadowflameCrestFragment = GetItemInfo(204075)
local WhelplingsShadowflameCrestFragmentItem = awful.Item(204075)

local Mines = {
    [123848] = true, -- ooze-covered-thorium-vein
    [1610] = true, -- incendicite-mineral-vein
    [165658] = true, -- dark-iron-deposit
    [1731] = true, -- copper-vein
    [1732] = true, -- tin-vein
    [1733] = true, -- silver-vein
    [1734] = true, -- gold-vein
    [1735] = true, -- iron-deposit
    [175404] = true, -- rich-thorium-vein
    [177388] = true, -- ooze-covered-rich-thorium-vein
    [181068] = true, -- small-obsidian-chunk
    [181069] = true, -- large-obsidian-chunk
    [181108] = true, -- truesilver-deposit
    [181248] = true, -- copper-vein
    [181249] = true, -- tin-vein
    [181555] = true, -- fel-iron-deposit
    [181556] = true, -- adamantite-deposit
    [181557] = true, -- khorium-vein
    [181569] = true, -- rich-adamantite-deposit
    [181570] = true, -- rich-adamantite-deposit
    [185557] = true, -- ancient-gem-vein
    [185877] = true, -- nethercite-deposit
    [189978] = true, -- cobalt-deposit
    [189979] = true, -- rich-cobalt-deposit
    [189980] = true, -- saronite-deposit
    [189981] = true, -- rich-saronite-deposit
    [191133] = true, -- titanium-vein
    [195036] = true, -- pure-saronite-deposit
    [202736] = true, -- obsidium-deposit
    [202737] = true, -- pyrite-deposit
    [202738] = true, -- elementium-vein
    [202739] = true, -- rich-obsidium-deposit
    [202740] = true, -- rich-pyrite-deposit
    [202741] = true, -- rich-elementium-vein
    [2040] = true, -- mithril-deposit
    [2047] = true, -- truesilver-deposit
    [209311] = true, -- ghost-iron-deposit
    [209312] = true, -- kyparite-deposit
    [209313] = true, -- trillium-vein
    [209328] = true, -- rich-ghost-iron-deposit
    [209329] = true, -- rich-kyparite-deposit
    [209330] = true, -- rich-trillium-vein
    [221540] = true, -- rich-trillium-vein
    [221541] = true, -- trillium-vein
    [228493] = true, -- true-iron-deposit
    [230428] = true, -- smoldering-true-iron-deposit
    [232542] = true, -- blackrock-deposit
    [232543] = true, -- rich-blackrock-deposit
    [232544] = true, -- true-iron-deposit
    [236169] = true, -- harvestable-precious-crystal
    [241726] = true, -- leystone-deposit
    [241743] = true, -- felslate-deposit
    [243313] = true, -- blackrock-deposit
    [245325] = true, -- rich-felslate-deposit
    [247370] = true, -- brimstone-destroyer-core
    [247698] = true, -- shattered-felslate-seam
    [247911] = true, -- charged-leystone-deposit
    [247923] = true, -- darkened-felslate-deposit
    [247956] = true, -- brimstone-destroyer-core
    [247957] = true, -- brimstone-destroyer-core
    [247958] = true, -- brimstone-destroyer-core
    [247959] = true, -- brimstone-destroyer-core
    [247960] = true, -- brimstone-destroyer-core
    [247962] = true, -- brimstone-destroyer-core
    [247967] = true, -- brimstone-destroyer-core
    [247968] = true, -- brimstone-destroyer-core
    [247969] = true, -- brimstone-destroyer-core
    [251181] = true, -- azure-ore
    [253280] = true, -- leystone-seam
    [255344] = true, -- felslate-seam
    [268901] = true, -- felslate-spike
    [272780] = true, -- empyrium-seam
    [276616] = true, -- monelite-deposit
    [276617] = true, -- storm-silver-deposit
    [276618] = true, -- platinum-deposit
    [276619] = true, -- monelite-seam
    [390137] = true, --Metamorphic Serevite Deposit
    [276620] = true, -- storm-silver-seam
    [276621] = true, -- rich-monelite-deposit
    [276622] = true, -- rich-storm-silver-deposit
    [276623] = true, -- rich-platinum-deposit
    [324] = true, -- small-thorium-vein
    [325874] = true, -- osmenite-seam
    [325875] = true, -- osmenite-deposit
    [349898] = true, -- laestrite-deposit
    [349899] = true, -- rich-laestrite-deposit
    [349900] = true, -- elethium-deposit
    [349980] = true, -- solenium-deposit
    [349981] = true, -- oxxein-deposit
    [349982] = true, -- phaedrum-deposit
    [349983] = true, -- sinvyr-deposit
    [350082] = true, -- rich-elethium-deposit
    [350084] = true, -- rich-sinvyr-deposit
    [350085] = true, -- rich-oxxein-deposit
    [350086] = true, -- rich-solenium-deposit
    [350087] = true, -- rich-phaedrum-deposit
    [355507] = true, -- rich-phaedrum-deposit
    [356400] = true, -- ligneous-phaedrum-deposit
    [356402] = true, -- menacing-sinvyr-deposit
    [370399] = true, -- rich-progenium-deposit
    [370400] = true, -- progenium-deposit

    [389459] = true,
    [389460] = true,
    [384693] = true,
    [389413] = true,
    [388213] = true,
    [378819] = true,
    [381102] = true, 
    [381517] = true, 
    [381103] = true, 
    [381105] = true, 
    [381518] = true, 
    [381519] = true, 
    [381515] = true, 
    [381516] = true, 
    [381104] = true,
    [379248] = true, 
    [379252] = true, 
    [379267] = true, 
    [375238] = true, 
    [379263] = true, 
    [375240] = true, 
    [375234] = true, 
    [375235] = true, 
    [375239] = true
}
local Herbs = {
    [398758] = true, --Saxufrage
    [398761] = true, --Titantouched hochenblume
    [398765] = true, --infurious
    [398757] = true, -- hochenblume
    [390139] = true, -- hochenblume lambent
    [398756] = true, -- wirthebark
    [398752] = true, 
    [398753] = true, -- lush hochenblume
    [390140] = true, -- lambent saxifrage
    [398767] = true, -- infurious saxifrage
    [142140] = true, -- purple-lotus
    [142141] = true, -- arthas-tears
    [142142] = true, -- sungrass
    [142143] = true, -- blindweed
    [142144] = true, -- ghost-mushroom
    [142145] = true, -- gromsblood
    [141853] = true, -- violet-tragan
    [1617] = true, -- silverleaf
    [1618] = true, -- peacebloom
    [1619] = true, -- earthroot
    [1620] = true, -- mageroyal
    [1621] = true, -- briarthorn
    [1622] = true, -- bruiseweed
    [1623] = true, -- wild-steelbloom
    [1624] = true, -- kingsblood
    [1628] = true, -- grave-moss
    [176583] = true, -- golden-sansam
    [176584] = true, -- dreamfoil
    [176586] = true, -- mountain-silversage
    [176587] = true, -- sorrowmoss
    [176588] = true, -- icecap
    [176589] = true, -- black-lotus
    [181270] = true, -- felweed
    [181271] = true, -- dreaming-glory
    [181275] = true, -- ragveil
    [181276] = true, -- flame-cap
    [181277] = true, -- terocone
    [181278] = true, -- ancient-lichen
    [181279] = true, -- netherbloom
    [181280] = true, -- nightmare-vine
    [181281] = true, -- mana-thistle
    [185881] = true, -- netherdust-bush
    [186662] = true, -- reagent-pouch
    [189973] = true, -- goldclover
    [190169] = true, -- tiger-lily
    [190170] = true, -- talandras-rose
    [190171] = true, -- lichbloom
    [190172] = true, -- icethorn
    [190176] = true, -- frost-lotus
    [191019] = true, -- adders-tongue
    [191303] = true, -- firethorn
    [192827] = true, -- wild-mustard
    [192828] = true, -- crystalsong-carrot
    [194213] = true, -- winter-hyacinth
    [201562] = true, -- seaweed-frond
    [202747] = true, -- cinderbloom
    [202748] = true, -- stormvine
    [202749] = true, -- azsharas-veil
    [202750] = true, -- heartblossom
    [202751] = true, -- twilight-jasmine
    [202752] = true, -- whiptail
    [2041] = true, -- liferoot
    [2042] = true, -- fadeleaf
    [2043] = true, -- khadgars-whisker
    [2044] = true, -- dragons-teeth
    [2045] = true, -- stranglekelp
    [2046] = true, -- goldthorn
    [206085] = true, -- frozen-herb
    [208828] = true, -- corpse-worm-mound
    [209059] = true, -- blood-nettle
    [209349] = true, -- green-tea-leaf
    [209350] = true, -- silkweed
    [209351] = true, -- snow-lily
    [209354] = true, -- golden-lotus
    [209355] = true, -- fools-cap
    [210537] = true, -- eternal-blossom
    [210538] = true, -- eternal-blossom
    [210539] = true, -- eternal-blossom
    [212902] = true, -- solidified-amber
    [228573] = true, -- gorgrond-flytrap
    [228574] = true, -- starflower
    [241641] = true, -- foxflower
    [244774] = true, -- aethril
    [244778] = true, -- starlight-rose
    [247865] = true, -- aqueous-aethril
    [248000] = true, -- felwort
    [248003] = true, -- felwort
    [248010] = true, -- felwort
    [252404] = true, -- felwort
    [253069] = true, -- blacker-lotus
    [269278] = true, -- fel-encrusted-herb
    [269887] = true, -- fel-encrusted-herb-cluster
    [272782] = true, -- astral-glory
    [276234] = true, -- riverbud
    [276239] = true, -- sirens-sting
    [276242] = true, -- anchor-weed
    [2866] = true, -- firebloom
    [288646] = true, -- prickly-pear
    [294125] = true, -- anchor-weed
    [336433] = true, -- widowbloom
    [336688] = true, -- vigils-torch
    [336689] = true, -- marrowroot
    [336690] = true, -- rising-glory
    [336691] = true, -- nightshade
    [341808] = true, -- gersahl-shrub
    [356540] = true, -- engorged-marrowroot
    [356597] = true, -- lacy-bell-morel
    [356607] = true, -- violet-frill
    [370398] = true, -- first-flower
    [373461] = true, -- chromatic-rosid
    [244776] = true, --Dreamleaf
    [244777] = true, --Fjarnskaggl
    [381212] = true,
    [128304] = true,
    [377002] = true,
    [376930] = true,
    [376082] = true,
    [376081] = true,
    [381214] = true,
    [381209] = true,
    [381211] = true,
    [381960] = true,
    [384291] = true,
    [381210] = true,
    [381213] = true,
    [381957] = true, 
    [375241] = true, 
    [384299] = true, 
    [375242] = true, 
    [375245] = true, 
    [375243] = true, 
    [383616] = true, 
    [384294] = true, 
    [375244] = true, 
    [375246] = true,
    [381203] = true, 
    [381959] = true, 
    [381205] = true, 
    [381207] = true, 
    [381204] = true, 
    [381202] = true, 
    [381201] = true, 
    [384295] = true,
    [381958] = true, 
    [381196] = true, 
    [381197] = true, 
    [381199] = true, 
    [381154] = true, 
    [381200] = true, 
    [381198] = true, 
    [384293] = true,
}
local Randoms = {
    [383735] = true, -- disturbed-dirt
    [376587] = true, -- expedition-scouts-pack
}

local gui, settings, cmd = awful.UI:New("XD", {
	cmd = {"xd", "XD", "XD?"},
	title = "|cFF6eff86Warlock                                    ",
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

awful.addUpdateCallback(function()
    --autoBox
    if project.settings.autoBox and select(2,IsInInstance()) == "none" and not player.casting then 
        UseItemByName(FieldMedicsHazardPayout)
        UseItemByName(VictoriousContendersStrongbox)
        if select(2,GetItemCooldown(205423)) <= 0 or select(2,GetItemCooldown(205682)) <= 0 or select(2,GetItemCooldown(204075)) <= 0 then
            UseItemByName(ShadowflameResidueSack)
            UseItemByName(LargeShadowflameResidueSack)
            if WhelplingsShadowflameCrestFragmentItem.count >= 15 and not player.moving then
                UseItemByName(WhelplingsShadowflameCrestFragment)
            end
        end
        --Loot
        if LootFrame and LootFrame:IsVisible() then
            for i = 1, GetNumLootItems() do
                if LootSlotHasItem(i) then
                    LootSlot(i)
                    ConfirmLootSlot(i)
                    CloseLoot()
                end
            end
        end
    end
end)

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
    icon:SetTexture('Interface\\Icons\\Classicon_warlock')
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    icon:SetPoint('TOPLEFT', 7, -5)
    self.icon = icon

    self:SetScript('OnClick', self.OnClick)

    self:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -2, 2)
    self:SetMovable(true)
    self:EnableMouse(true)
    self:RegisterForDrag("LeftButton")
    self:SetScript("OnDragStart", self.StartMoving)
    self:SetScript("OnDragStop", self.StopMovingOrSizing)

    self:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("XD Warlock")
        GameTooltip:Show()
        end)
end

function MinimapButton:OnClick(button)
    if button == 'LeftButton' then
        awful.call("RunMacroText", "/xd")
    elseif button == 'RightButton' then
        awful.call("RunMacroText", "/xd")
    end
end

MinimapButton:Load()


local function eventTrace(self,event,...)
    if event == "ACTIVE_PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
        if project.settings.autoReloadOnTalentChange then
            awful.call("ReloadUI")
        end
    end
end

Events = CreateFrame("Frame")
local function RegisterEvents(self, ...)
	for i=1,select('#', ...) do
		self:RegisterEvent(select(i, ...))
	end
end
Events.RegisterEvents = RegisterEvents
Events:RegisterEvents("ACTIVE_PLAYER_SPECIALIZATION_CHANGED")
Events:RegisterEvents("TRAIT_CONFIG_UPDATED")
Events:SetScript("OnEvent", eventTrace)

-- making the settings available to the rest of our project
project.settings = settings

--Draw healer
Draw(function(draw)
    if settings.drawLineToFriendlyHealerToggle then
        if select(2,IsInInstance()) == "arena" then
            if healer.exists and not healer.dead then
                local px, py, pz = player.position()
                local distance = healer.distanceliteral
                local x,y,z = healer.position()
                local los = healer.los
                if x and y and z and px and py and pz then
                    -- Out of Range
                    if distance > 40 then
                        draw:SetColor(255, 0, 0, 175)
                        draw:SetWidth(3)
                        draw:Line(px,py,pz,x,y,z, 10)
                        draw:Outline(x,y,z, 0.75)
                    end
                    -- Not Line of Sight
                    if not los then
                        draw:SetColor(243, 134, 48, 175)
                        draw:SetWidth(3)
                        draw:Line(px,py,pz,x,y,z, 10)
                        draw:Outline(x,y,z, 0.75)
                    end
                    -- Line of Sight
                    if los and distance <= 40 then
                        draw:SetColor(0, 255, 0, 175)
                        draw:SetWidth(2)
                        draw:Line(px,py,pz,x,y,z, 10)
                        draw:Outline(x,y,z, 0.75)
                    end
                end
            end
        end
    end
end)

--Draw target
Draw(function(draw)
    if settings.drawLineToTargetToggle then
        if target.exists and not target.dead then
            local px, py, pz = player.position()
            local distance = target.distanceliteral
            local x,y,z = target.position()
            local los = target.los
            if x and y and z and px and py and pz then
                -- Out of Range
                if distance > 40 then
                    draw:SetColor(255, 0, 0, 175)
                    draw:SetWidth(3)
                    draw:Line(px,py,pz,x,y,z, 10)
                    draw:Outline(x,y,z, 0.75)
                end
                -- Not Line of Sight
                if not los then
                    draw:SetColor(243, 134, 48, 175)
                    draw:SetWidth(3)
                    draw:Line(px,py,pz,x,y,z, 10)
                    draw:Outline(x,y,z, 0.75)
                end
                -- Line of Sight
                if los and distance <= 40 then
                    draw:SetColor(255, 255, 255, 255)
                    draw:SetWidth(2)
                    draw:Line(px,py,pz,x,y,z, 10)
                    draw:Outline(x,y,z, 0.75)
                end
            end
        end
    end
end)

--Draw EarthenWall
Draw(function(draw)
    if settings.totemDrawings then
        local EarthenWall = awful.friendlyTotems.within(40).find(function(obj) return obj.id == 100943 end)
        if EarthenWall then
            local x,y,z = EarthenWall.position()
            if x and y and z then
                draw:SetColor(0, 255, 0, 175)
                draw:Text("STAND HERE", AwfulFont, x, y, z)
                draw:Outline(x,y,z, 10)
            end
        end
    end
end)

--Draw teleport circle
Draw(function(draw)
    if settings.teleportCircleDrawing then
        awful.objects.within(40).loop(function(object)
            if object.creator.exists and object.creator.guid == player.guid and object.id == 191083 then
                local px, py, pz = player.position()
                local distance = object.distanceliteral
                local x,y,z = object.position()
                if x and y and z and px and py and pz then
                    --OutOfRange
                    if distance > 40 then
                        draw:SetColor(255, 0, 0, 250)
                        draw:SetWidth(3)
                        draw:Line(px,py,pz,x,y,z, 10)
                        draw:Outline(x,y,z, 0.75)
                    end
                    --TooClose
                    if distance >= 0 and distance <= settings.defensivesDemonicCircleTeleportSliderRange then
                        draw:SetColor(255, 0, 0, 255)
                        draw:SetWidth(3)
                        draw:Line(px,py,pz,x,y,z, 10)
                        draw:Outline(x,y,z, 0.75)
                    end
                    --InRange
                    if distance <= 40 and distance >= 10 then
                        draw:SetColor(102, 51, 153, 255)
                        draw:SetWidth(2)
                        draw:Line(px,py,pz,x,y,z, 10)
                        draw:Outline(x,y,z, 0.75)
                    end
                end
            end
        end)
    end
end)

--auto gate
Draw(function(draw)
    if settings.autoGateAndTP and select(2,IsInInstance()) == "arena" then
        zoneName = GetZoneText()
        local x, y, z = player.position()
        draw:SetColor(102, 51, 153, 255)
        draw:SetWidth(1)

        if zoneName == "Enigma Crucible" then
            --Side 1
            draw:Line(302,251,89,272,278,89,5)
            draw:Outline(302,251,89,1)
            draw:Outline(272,278,89,1)
            
            if x > 301 and x < 303 and y > 250 and y < 252 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(272,278,89)
                    end
                end
            end

            --Side 2
            draw:Line(231,274,90,264,252,89,5)
            draw:Outline(231,274,90,1)
            draw:Outline(263,252,89,1)
            
            if x > 230 and x < 232 and y > 273 and y < 275 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(263,252,89)
                    end
                end
            end
        end
        if zoneName == "Nokhudon Proving Grounds" then
            --Side 1
            draw:Line(-502,4157,384,-524,4190,381,5)
            draw:Outline(-502,4157,384,1)
            draw:Outline(-524,4190,381,1)
            
            if x < -501 and x > -503 and y > 4156 and y < 4158 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(-524,4190,381)
                    end
                end
            end

            --Side 2
            draw:Line(-562,4194,384,-556,4155,380,5)
            draw:Outline(-562,4194,384,1)
            draw:Outline(-556,4155,380,1)
            
            if x < -561 and x > -563 and y > 4193 and y < 4195 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(-556,4155,380)
                    end
                end
            end
        end
        if zoneName == "Nagrand Arena" then
            --Side 1
            draw:Line(-2040,6619,12,-2028,6657,11,5)
            draw:Outline(-2040,6619,12,1)
            draw:Outline(-2028,6657,11,1)
            
            if x < -2039 and x > -2041 and y > 6618 and y < 6620 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(-2028,6657,11)
                    end
                end
            end

            --Side 2
            draw:Line(-2046,6691,12,-2053,6652,12,5)
            draw:Outline(-2046,6691,12,1)
            draw:Outline(-2053,6652,12,1)
            
            if x < -2045 and x > -2047 and y > 6690 and y < 6692 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(-2053,6652,12)
                    end
                end
            end
        end
        if zoneName == "Ashamane's Fall" then 
            --Side 1
            draw:Line(3523,5511,325,3551,5539,324,5)
            draw:Outline(3523,5511,325,1)
            draw:Outline(3551,5539,324,1)
            
            if x > 3522 and x < 3524 and y > 5510 and y < 5512 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(3551,5539,324,1)
                    end
                end
            end

            --Side 2
            draw:Line(3522,5562,324,3551,5541,324,5)
            draw:Outline(3522,5562,324,1)
            draw:Outline(3551,5541,324,1)
            
            if x > 3521 and x < 3523 and y > 5561 and y < 5563 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(3551,5541,324,1)
                    end
                end
            end
        end
        if zoneName == "Maldraxxus Coliseum" then
            --Side 1
            draw:Line(2813,2219,3260,2850,2231,3259,5)
            draw:Outline(2813,2219,3260,1)
            draw:Outline(2850,2231,3259,1)
            
            if x > 2812 and x < 2814 and y > 2218 and y < 2220 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(2850,2231,3259)
                    end
                end
            end

            --Side 2
            draw:Line(2807,2290,3260,2844,2282,3260,5)
            draw:Outline(2807,2290,3260,1)
            draw:Outline(2844,2282,3260,1)
            
            if x > 2806 and x < 2808 and y > 2289 and y < 2291 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(2844,2282,3260)
                    end
                end
            end
        end
        if zoneName == "The Tiger's Peak" then
            --Side 1
            draw:Line(598,637,381,561,648,380,5)
            draw:Outline(598,637,381,1)
            draw:Outline(561,648,380,1)
            
            if x > 597 and x < 599 and y > 636 and y < 638 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(561,648,380)
                    end
                end
            end

            --Side 2
            draw:Line(533,637,380,570,649,380,5)
            draw:Outline(533,637,380,1)
            draw:Outline(570,649,380,1)
            
            if x > 532 and x < 534 and y > 636 and y < 638 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(570,649,380)
                    end
                end
            end
        end
        if zoneName == "Empyrean Domain" then
            --Side 1
            draw:Line(-1282,735,7249,-1242,735,7249,5)
            draw:Outline(-1282,735,7249,1)
            draw:Outline(-1242,735,7249,1)
            
            if x < -1281 and x > -1283 and y > 734 and y < 736 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(-1242,735,7249)
                    end
                end
            end

            --Side 2
            draw:Line(-1244,696,7249,-1238,735,7249,5)
            draw:Outline(-1244,696,7249,1)
            draw:Outline(-1238,735,7249,1)
            
            if x < -1243 and x > -1245 and y > 695 and y < 697 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(-1238,735,7249)
                    end
                end
            end
        end
        if zoneName == "Dalaran Arena" then
            --Side 1
            draw:Line(1271,768,7,1285,802,7,5)
            draw:Outline(1271,768,7,1)
            draw:Outline(1285,802,7,1)

            if x > 1270 and x < 1272 and y > 767 and y < 769 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(1285,802,7)
                    end
                end
            end

            --Side 2
            draw:Line(1315,816,6,1295,782,7,5)
            draw:Outline(1315,816,6,1)
            draw:Outline(1295,782,7,1)

            if x > 1314 and x < 1316 and y > 815 and y < 817 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(1295,782,7)
                    end
                end
            end
        end
        if zoneName == "Blade's Edge Arena" then
            --Side 1
            draw:Line(2765,5971,3,2803,5978,-4,5)
            draw:Outline(2765,5971,3,1)
            draw:Outline(2803,5978,-4,1)

            if x > 2764 and x < 2766 and y > 5970 and y < 5972 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(2803,5978,-4)
                    end
                end
            end

            --Side 2
            draw:Line(2811,6035,3,2772,6035,-4,5)
            draw:Outline(2811,6035,3,1)
            draw:Outline(2772,6035,-4,1)

            if x > 2810 and x < 2812 and y > 6034 and y < 6036 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(2772,6035,-4)
                    end
                end
            end
        end
        if zoneName == "Black Rook Hold Arena" then
            --Side 1
            draw:Line(1378,1238,32,1408,1211,33,5)
            draw:Outline(1378,1238,32,1)
            draw:Outline(1408,1211,33,1)

            if x > 1377 and x < 1379 and y > 1237 and y < 1239 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(1408,1211,33)
                    end
                end
            end

            --Side 2
            draw:Line(1460,1275,32,1420,1279,33,5)
            draw:Outline(1460,1275,32,1)
            draw:Outline(1420,1279,33,1)

            if x > 1459 and x < 1461 and y > 1274 and y < 1276 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(1420,1279,33)
                    end
                end
            end
        end
        if zoneName == "Tol'viron Arena" then
            --Side 1
            draw:Line(-10677,453,24,-10692,416,24,5)
            draw:Outline(-10677,453,24,1)
            draw:Outline(-10692,416,24,1)

            if x < -10676 and x > -10678 and y > 452 and y < 454 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(-10692,416,24)
                    end
                end
            end
            --Side 2
            draw:Line(-10754,450,24,-10725,423,24,5)
            draw:Outline(-10754,450,24,1)
            draw:Outline(-10725,423,24,1)

            if x < -10753 and x > -10755 and y > 449 and y < 451 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(-10725,423,24)
                    end
                end
            end
        end
        if zoneName == "Ruins of Lordaeron" then
            --Side 1
            draw:Line(1290,1619,34,1296,1655,34,5)
            draw:Outline(1290,1619,34,1)
            draw:Outline(1296,1655,34,1)

            if x > 1289 and x < 1291 and y > 1618 and y < 1620 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(1296,1655,34)
                    end
                end
            end

            --Side 2
            draw:Line(1283,1712,34,1282,1680,34,5)
            draw:Outline(1283,1712,34,1)
            draw:Outline(1282,1680,34,1)

            if x > 1282 and x < 1284 and y > 1711 and y < 1713 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(1282,1680,34)
                    end
                end
            end
        end
        if zoneName == "Mugambala" then
            --Side 1
            draw:Line(-1922,1307,44,-1941,1300,34,5)
            draw:Outline(-1922,1307,44,1)
            draw:Outline(-1941,1300,34,1)

            if x < -1921 and x > -1923 and y > 1306 and y < 1308 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(-1941,1300,34)
                    end
                end
            end

            --Side 2
            draw:Line(-1920,1290,44,-1955,1290,34,5)
            draw:Outline(-1920,1290,44,1)
            draw:Outline(-1955,1290,34,1)

            if x < -1919 and x > -1921 and y > 1289 and y < 1291 then
                if demonicCircleTeleport.cd > 0 then return end
                demonicCircle:Cast()
                if demonicGateway.cd == 0 then
                    if not player.buff(soulBurnBuff.id) then
                        soulBurn:Cast()
                    end
                    if player.buff(soulBurnBuff.id) then
                        demonicGateway:AoECast(-1955,1290,34)
                    end
                end
            end
        end
    end
end)

--draw around traps flare etc
Draw(function(draw)
    if select(2,IsInInstance()) == "arena" then
        if project.settings.trapEtcIndicator then
            awful.triggers.loop(function(trigger)
                if not trigger.creator.friend then
                    local x,y,z = trigger.position()
                    draw:Circle(x,y,z,2.5)    
                end
            end)
        end
    end
end)

--melee range indicator
Draw(function(draw)
    if project.settings.meleeRangeCheck then
        if target.enemy then
            local tx, ty, tz = target.position()
            local hitbox = math.max(5, player.combatReach + target.combatReach + 1.3) + 1
            if tx and ty and tz then
                draw:SetWidth(0.5)
                if target.distanceLiteral <= hitbox then
                    draw:SetColorRaw(255, 0, 0, 0.3)
                else
                    draw:SetColorRaw(255, 255, 255, 0.3)
                end
                draw:Outline(tx, ty, tz, hitbox)
            end
        end
    end
end)

--gather ESP
awful.Draw(function(draw)
    local px, py, pz = awful.player.position()
    awful.objects.loop(function(object)
        --mines
        if Mines[object.id] and settings.mineEspToggle then
            local x, y, z = object.position()
            local name = object.name
            if x and y and z then
                draw:SetColor(192, 192, 192, 175)
                draw:SetWidth(1.5)
                draw:Line(px,py,pz,x,y,z, 20)
                draw:Outline(x, y, z, 1.5)
                draw:SetColor(192, 192, 192, 200)
                draw:Text("[Mine] "..name, AwfulFont, x, y, z+2)
            end
        end
        --herbs
        if Herbs[object.id] and settings.herbEspToggle then
            local x, y, z = object.position()
            local name = object.name
            if x and y and z then
                draw:SetColor(0, 255, 0, 175)
                draw:SetWidth(1.5)
                draw:Line(px,py,pz,x,y,z, 20)
                draw:Outline(x, y, z, 1.5)
                draw:SetColor(0, 255, 0, 200)
                draw:Text("[Herb] "..name, AwfulFont, x, y, z+2)
            end
        end
        --random
        if Randoms[object.id] and settings.randomEspToggle then
            local x, y, z = object.position()
            local name = object.name
            if x and y and z then
                draw:SetColor(255, 0, 0, 175)
                draw:SetWidth(1.5)
                draw:Line(px,py,pz,x,y,z, 20)
                draw:Outline(x, y, z, 1.5)
                draw:SetColor(255, 0, 0, 175)
                draw:Text("[Random] "..name, AwfulFont, x, y, z+2)
            end
        end
    end)
end)

awful.SpellQueueWindow_Update = 6969696969696969
project.SQW = tonumber(GetCVar("SpellQueueWindow"))
local TargetSQW = 0
if project.SQW ~= TargetSQW then
    SetCVar("SpellQueueWindow", TargetSQW)
end

--! STATUS FRAME !--
local sf = gui:StatusFrame({
    colors = {
        background = {0, 0, 0, 0},
        enabled = {30, 240, 255, 1},
    },
    maxWidth = 500,
    padding = 10,
})
if awful.player.spec == "Destruction" or awful.player.spec == "Affliction" then
    sf:Button({
        spellId = 691,
        var = "summonFelhunter",
        default = true,
        size = 25
    })
    sf:Button({
        spellId = 688,
        var = "summonImp",
        default = false,
        size = 25
    })
    sf:Button({
        spellId = 697,
        var = "summonVoidwalker",
        default = false,
        size = 25
    })
end

-- and this is the tab I'll be adding elements to
local info = gui:Tab("INFO")
info:Text({
  text = "Join our discord and give feedback <3",
  header = true
})
info:Text({
  text = "To get menu back type /xd",
  header = true
})
info:Text({
  text = "Toggle rotation /xd toggle",
  header = true
})
info:Checkbox({
  text = "Show button menu (Rotation)",
  var = "rotationBTN",
  default = true,
})


local togglePVP = gui:Tab("GENERAL")
togglePVP:Checkbox({
  text = "Alert on Queue Pop             ",
  var = "alertQueue",
  default = true,
})
togglePVP:Checkbox({
  text = "Auto Accept Queue              ",
  var = "acceptQueue",
  default = false,
})
togglePVP:Checkbox({
  text = "Anti AFK                          ",
  var = "antiAfk",
  default = true,
})
togglePVP:Checkbox({
  text = "Auto Target Swap Logic        ",
  var = "autoTargetToggle",
  default = true,
})
togglePVP:Checkbox({
  text = "Stop Attack on BREAKABLE CC",
  var = "autoStopAttackOnCCTarget",
  default = true,
})
togglePVP:Checkbox({
  text = "Auto Focus                                          ",
  var = "autoFocusToggle",
  default = true,
})
togglePVP:Checkbox({
  text = "Auto Reload on Talent Change           ",
  var = "autoReloadOnTalentChange",
  default = true,
})
togglePVP:Checkbox({
  text = "ONLY target enemy PLAYERS           ",
  var = "onlyTargetEnemyPlayers",
  default = true,
})
togglePVP:Checkbox({
  text = "Auto Gate/TP               ",
  var = "autoGateAndTP",
  default = true,
})
togglePVP:Checkbox({
  text = "Spam PetAttack on Current Target         ",
  var = "petAttackSpam",
  default = true,
})
togglePVP:Checkbox({
  text = "Spam PetAttack on Focus (it will autofocus enemyhealer when you target dps)",
  var = "petAttackSpamFocus",
  default = false,
})
togglePVP:Checkbox({
  text = "Auto Open PVP Boxes                                            ",
  var = "autoBox",
  default = true,
})


local toggleSettings = gui:Tab("SUMMONS")
toggleSettings:Checkbox({
  text = "Auto Summon Pet",
  var = "autoPet",
  default = true,
})
toggleSettings:Checkbox({
  text = "Auto Soulwell & Healthstone          ",
  var = "autoSoulWell",
  default = true,
})
toggleSettings:Checkbox({
  text = "Summon Infernal (Destruction)",
  var = "autoSummonInfernal",
  default = true,
})
toggleSettings:Checkbox({
  text = "Summon Obelisk (Demonology)",
  var = "autoSummonObelisk",
  default = true,
})
toggleSettings:Checkbox({
  text = "Summon Tyrant (Demonology)",
  var = "autoSummonTyrant",
  default = true,
})
toggleSettings:Checkbox({
  text = "Summon Fel Lord (Demonology)",
  var = "autoFelLord",
  default = true,
})

local toggleDpsCds = gui:Tab("DAMAGE COOLDOWNS")
toggleDpsCds:Checkbox({
  text = "Auto Dimensional Rift (Destruction)",
  var = "autoDimensionalRift",
  default = true,
})
toggleDpsCds:Checkbox({
  text = "Auto Grimoire FelGuard (Demonology)",
  var = "autoGrimoireFelGuard",
  default = true,
})
toggleDpsCds:Checkbox({
  text = "Auto Guillotine (Demonology)                ",
  var = "autoGuillotine",
  default = true,
})
toggleDpsCds:Checkbox({
  text = "Auto Call Observer                             ",
  var = "autoCallObserver",
  default = true,
})
toggleDpsCds:Checkbox({
  text = "Auto Havoc (Destruction)                ",
  var = "autoHavoc",
  default = true,
})
toggleDpsCds:Checkbox({
  text = "Use Demonic Circle before using Tyrant (Demonology)                ",
  var = "tpTyrant",
  default = false,
})
toggleDpsCds:Checkbox({
  text = "Auto SoulRip                ",
  var = "autoSoulRip",
  default = true,
})

local toggleBuffs = gui:Tab("BUFFS")
toggleBuffs:Checkbox({
  text = "Auto Grimoire Of Sacrifice",
  var = "autoGrimoireOfSacrifice",
  default = true,
})

local toggleESP = gui:Tab("ESP")
toggleESP:Checkbox({
  text = "Player ESP, needs /reload      ",
  var = "playerEspToggle",
  default = true,
})
toggleESP:Checkbox({
  text = "Herb ESP                      ",
  var = "herbEspToggle",
  default = true,
})
toggleESP:Checkbox({
  text = "Mine ESP                      ",
  var = "mineEspToggle",
  default = true,
})
toggleESP:Checkbox({
  text = "Random ESP                      ",
  var = "randomEspToggle",
  default = true,
})

local textAndDrawingsToggle = gui:Tab("TEXT/DRAWINGS/ALERTS")
textAndDrawingsToggle:Checkbox({
  text = "Draw Line to Target",
  var = "drawLineToTargetToggle",
  default = true,
})
textAndDrawingsToggle:Checkbox({
  text = "Draw Line to FriendlyHealer",
  var = "drawLineToFriendlyHealerToggle",
  default = true,
})
textAndDrawingsToggle:Checkbox({
  text = "All text that pops up        ",
  var = "allText",
  default = true,
})
textAndDrawingsToggle:Checkbox({
  text = "Totem Drawings           ",
  var = "totemDrawings",
  default = true,
})
textAndDrawingsToggle:Checkbox({
  text = "Teleport Circle Drawing           ",
  var = "teleportCircleDrawing",
  default = true,
})
textAndDrawingsToggle:Checkbox({
  text = "Melee Range Indicator           ",
  var = "meleeRangeCheck",
  default = true,
})
textAndDrawingsToggle:Checkbox({
  text = "Flares, Traps etc indicator            ",
  var = "trapEtcIndicator",
  default = true,
})
textAndDrawingsToggle:Checkbox({
  text = "Interrupt Immunity Alert           ",
  var = "kickImmunityAlert",
  default = true,
})

local InterruptOptional = {
    { label = awful.textureEscape(118, 22).."Polymorph", value = "Polymorph", tvalue = {118,161355,161354,161353,126819,61780,161372,61721,61305,28272,28271,277792,277787,391622}},
    { label = awful.textureEscape(51514, 22).."Hex", value = "Hex", tvalue = {51514, 211015, 211010,211004,210873,269352,277778,277784,} },
    { label = awful.textureEscape(20066, 22).."Repentance", value = 20066,},
    { label = awful.textureEscape(113724, 22).."Ring of Frost", value = 113724,},
    { label = awful.textureEscape(33786, 22).."Cyclone", value = 33786,},
    { label = awful.textureEscape(605, 22).."Mind Control", value = 605,},
    { label = awful.textureEscape(198898, 22).."Song of Chi-ji", value = 198898,},
    { label = awful.textureEscape(5782, 22).."Fear", value = 5782,},
    { label = awful.textureEscape(2637, 22).."Hibernate", value = 2637,},
    { label = awful.textureEscape(710, 22).."Banish", value = 710,},
    { label = awful.textureEscape(10326, 22).."Turn Evil", value = 10326,},
    { label = awful.textureEscape(360806, 22).."Sleep Walk", value = 360806,},
    { label = awful.textureEscape(691, 22).."Summon Felhunter", value = 691,},
    { label = awful.textureEscape(688, 22).."Summon Imp", value = 688,},
    { label = awful.textureEscape(712, 22).."Summon Succubus", value = 712,},
    { label = awful.textureEscape(32375, 22).."Mass Dispel", value = 32375,},
    { label = awful.textureEscape(314791, 22).."Shifting Power", value = 314791,},
    { label = awful.textureEscape(982, 22).."Revive Pet", value = 982,},
    { label = awful.textureEscape(191634, 22).."Stormkeeper", value = 191634,},
    { label = awful.textureEscape(326434, 22).."Kindred Spirits", value = 326434,},
    { label = awful.textureEscape(391528, 22).."Convoke", value = "Convoke", tvalue = {323764, 337433, 391528} },
    { label = awful.textureEscape(234153, 22).."Drain Life", value = 234153,},
    { label = awful.textureEscape(116858, 22).."Chaos Bolt", value = 116858,},
    { label = awful.textureEscape(203286, 22).."Greater Pyro", value = 203286,},
    { label = awful.textureEscape(199786, 22).."Glacial Spike", value = 199786,},
    { label = awful.textureEscape(6353, 22).."Soul Fire", value = 6353,},
    { label = awful.textureEscape(342938, 22).."Unstable Affliction", value = 342938,},
    { label = awful.textureEscape(265187, 22).."Summon Tyrant", value = 265187,},
    { label = awful.textureEscape(186723, 22).."Penance", value = "Penance", tvalue = {186723,69905,71139,163290,163291,165721,172098,172099,175944, 47758}},
    { label = awful.textureEscape(198013, 22).."Eye Beam", value = 198013,},
    { label = awful.textureEscape(263165, 22).."Void Torrent", value = 263165,},
    { label = awful.textureEscape(115175, 22).."Soothing Mist", value = 115175,},
    { label = awful.textureEscape(34914, 22).."Vampiric Touch", value = 34914,},
    { label = awful.textureEscape(105174, 22).."Hand of Guldan", value = 105174,},
    { label = awful.textureEscape(30146, 22).."Summon FelGuard", value = 30146,},
    { label = awful.textureEscape(365350, 22).."Arcane Surge", value = 365350,},
    { label = awful.textureEscape(202347, 22).."Stellar Flare", value = 202347,},
    { label = awful.textureEscape(378464, 22).."Nullifying Shroud", value = 378464,},
    { label = awful.textureEscape(382411, 22).."Eternity Surge", value = 382411,},
    { label = awful.textureEscape(356995, 22).."Disintegrate", value = 356995,},
    { label = awful.textureEscape(274283, 22).."Full Moon", value = 274283,},
    { label = awful.textureEscape(274282, 22).."Half Moon", value = 274282,},
    { label = awful.textureEscape(200652, 22).."Tyrs Deliverance", value = 200652,},
    { label = awful.textureEscape(30283, 22).."ShadowFury", value = 30283,},
    { label = awful.textureEscape(353082, 22).."Ring of Fire", value = 353082,},
    { label = awful.textureEscape(205021, 22).."Ray of Frost", value = 205021,},   
    { label = awful.textureEscape(375901, 22).."Mind Games", value = 375901},
}
local InterruptsDefault = {
    "Polymorph",
    "Hex",
    20066, --Repentance
    113724, --Ring of Frost
    33786, --Cyclone
    605, --Mind Control
    198898, --Song of Chi-ji
    5782, --Fear
    2637, --Hibernate
    710, --Banish
    10326, --Turn Evil
    360806, -- Sleep Walk
    691, --Summon Felhunter
    688, -- Summon Imp
    712, -- Summon Succubus
    32375, --Mass Dispel
    314791, --Shifting Power
    982, --Revive Pet
    191634, --Stormkeeper
    326434, --Kindred Spirits
    "Convoke",
    234153, --drainlife
    116858, -- Chaos Bolt
    203286, --Greater Pyro
    199786, --Glacial Spike
    6353, --Soul Fire
    342938, --unstable affliction
    265187, --summon tyrant
    "Penance",
    198013, --eye beam
    263165, --void torrent
    115175, --soothing mist
    34914, --Vampiric Touch
    105174, --Hand of Guldan
    365350, --Arcane Surge
    202347, --Stellar Flare
    378464, --Nullifying Shroud
    382411, --Eternity Surge
    356995, --Disintegrate
    274283, --Full Moon
    274282, --Half Moon
    200652, --Tyrs Deliverance
    30283, --ShadowFury
    353082, --Ring of Fire
    205021, --Ray of frost
    375901, --Mind Games
    30146, --summon felguard
}
local interrupts = gui:Tab("INTERRUPT")
interrupts:Dropdown({
	var = "interrupts",
	multi = true,
	tooltip = "Choose the spells you want to interrupt.",
    options = InterruptOptional,
    default = InterruptsDefault,
	placeholder = "Select spells",
	header = "Spells to interrupt:",
})
interrupts:Slider({
    text = "Interrupt all HEALER spells when DPS is below",
	var = "interruptHealer",
	min = 0,
	max = 100,
	default = 40,
	valueType = "%",
	tooltip = "What % to use Interrupt on healer"
})
interrupts:Slider({
	text = "Interrupt Delay",
	var = "interruptDelay",
	min = 0.5,
	max = 1.0,
    step = 0.1,
	default = 0.5,
	valueType = " Sec",
	tooltip = "Secounds delay before Interrupt"
})

local ReflectOptional = {
    { label = awful.textureEscape(118, 22).."Polymorph", value = "Polymorph", tvalue = {118,161355,161354,161353,126819,61780,161372,61721,61305,28272,28271,277792,277787,391622}},
    { label = awful.textureEscape(51514, 22).."Hex", value = "Hex", tvalue = {51514, 211015, 211010,211004,210873,269352,277778,277784,} },
    { label = awful.textureEscape(20066, 22).."Repentance", value = 20066,},
    { label = awful.textureEscape(33786, 22).."Cyclone", value = 33786,},
    { label = awful.textureEscape(605, 22).."Mind Control", value = 605,},
    { label = awful.textureEscape(198898, 22).."Song of Chi-ji", value = 198898,},
    { label = awful.textureEscape(5782, 22).."Fear", value = 5782,},
    { label = awful.textureEscape(360806, 22).."Sleep Walk", value = 360806,},
    { label = awful.textureEscape(323673, 22).."Mindgames", value = "Mindgames", tvalue = {323673, 375901} },
    { label = awful.textureEscape(191634, 22).."Stormkeeper", value = 191634,},
    { label = awful.textureEscape(391528, 22).."Convoke", value = "Convoke", tvalue = {323764, 337433, 391528} },

    { label = awful.textureEscape(264106, 22).."Deathbolt", value = 264106,},
    { label = awful.textureEscape(116858, 22).."Chaos Bolt", value = 116858,},
    { label = awful.textureEscape(342938, 22).."Unstable Affliction", value = 342938,},

    { label = awful.textureEscape(203286, 22).."Greater Pyro", value = 203286,},
    { label = awful.textureEscape(199786, 22).."Glacial Spike", value = 199786,},
    { label = awful.textureEscape(6353, 22).."Soul Fire", value = 6353,},
    { label = awful.textureEscape(116, 22).."Frost Bolt", value = 116,},
    { label = awful.textureEscape(323639, 22).."The Hunt", value = "The Hunt", tvalue = {323639, 370965, 323802} },
    { label = awful.textureEscape(6789, 22).."Mortal Coil", value = 6789,},
    { label = awful.textureEscape(382411, 22).."Eternity Surge", value = 382411,},
    { label = awful.textureEscape(116, 22).."Fire Bolt", value = 116,},
    { label = awful.textureEscape(133, 22).."Frost Bolt", value = 133,},
    { label = awful.textureEscape(11366, 22).."Pyro Blast", value = 11366,},
    { label = awful.textureEscape(257541, 22).."Phoenix Flames", value = 257541,},
    { label = awful.textureEscape(365350, 22).."Arcane Surge", value = 365350,},
}
local ReflectDefault = {
    61305, --cat poly
    161355, --penguin poly
    28271, --turtle poly
    118, --sheep poly
    28272, --pig poly
    332605, --hex poly
    20066, -- Repentance
    33786, -- Cyclone
    605, -- Mind Control
    198898, -- Song of Chi-ji
    5782, -- Fear
    360806, -- Sleep Walk
    323764, --Covoke
    323673, --mindGames
    191634, -- Stormkeeper
    264106, -- Deathbolt
    116858, -- Chaos Bolt
    203286, -- Greater Pyro
    199786, --glacial spike
    6353, --Soul Fire
    342938, --Unstable Affliction
    323639, --the hunt
    116, --Frost bolt
    6789, --mortal coil
    382411, --eternity surge
    133, --fireball
    116, --frostbolt
    11366, --pyroblast
    257541, --phoenixFlames
    365350, --arcaneSurge
}
local reflects = gui:Tab("REFLECT")
reflects:Dropdown({
	var = "reflects",
	multi = true,
	tooltip = "Choose the spells you want to Reflect.",
    options = ReflectOptional,
    default = ReflectDefault,
	placeholder = "Select spells",
	header = "Spells to Reflect:",
})

local StompOptional = {
    { label =  awful.textureEscape(204331, 22).."Counterstrike Totem", value =  105451},
    { label =  awful.textureEscape(8143, 22).."Tremor Totem", value =  5913},
    { label =  awful.textureEscape(204336, 22).."Grounding Totem", value =  5925},
    { label =  awful.textureEscape(204330, 22).."Skyfury Totem", value =  105427},
    { label =  awful.textureEscape(8512, 22).."Windfury Totem", value =  6112},
    { label =  awful.textureEscape(98008, 22).."Spirit Link Totem", value =  53006},
    { label =  awful.textureEscape(51485, 22).."Earthgrab Totem", value =  60561},
    { label =  awful.textureEscape(2484, 22).."Earthbind Totem", value =  2630},
    { label =  awful.textureEscape(192058, 22).."Capacitor Totem", value =  61245},
    { label =  awful.textureEscape(355580, 22).."Static Field Totem", value =  179867},
    { label =  awful.textureEscape(108280, 22).."Healing Tide Totem", value =  59764},
    { label =  awful.textureEscape(16191, 22).."Mana Tide Totem", value =  10467},
    { label =  awful.textureEscape(383013, 22).."Poison Cleansing Totem", value =  5923},
    { label =  awful.textureEscape(383017, 22).."Stoneskin Totem", value =  194117},
    { label =  awful.textureEscape(5394, 22).."Healing Stream Totem", value =  3527},
    { label =  awful.textureEscape(381930, 22).."Mana Spring Totem", value =  193620},
    { label =  awful.textureEscape(236320, 22).."War Banner", value =  119052},
    { label =  awful.textureEscape(211522, 22).."Psyfiend", value =  101398},
    { label =  awful.textureEscape(353601, 22).."Fel Obelisk", value =  179193},
    { label =  awful.textureEscape(324386, 22).."Vesper Totem", value =  166523},
    { label =  awful.textureEscape(201996, 22).."Observer", value =  107100},
}
local StompDefault = {
    105451, --Counterstrike Totem
    5913, --Tremor Totem
    5925, --Grounding Totem
    53006, --Spirit Link Totem
    60561, --Earthgrab Totem
    61245, --Capacitor Totem
    179867, --Static Field Totem
    59764, --Healing Tide Totem
    10467, --Mana Tide Totem
    119052, --War Banner
    101398, --Psyfiend
    179193, --Fel Obelisk
    166523, --Vesper Totem
    107100, --Observer
}
local stomps = gui:Tab("STOMP NORMAL PRIO")
stomps:Dropdown({
	var = "stomps",
	multi = true,
	tooltip = "Choose the enemy you want to stomp.",
    options = StompOptional,
    default = StompDefault,
	placeholder = "Select enemies",
	header = "Targets to Stomp:",
})

local StompHighOptional = {
    { label =  awful.textureEscape(204331, 22).."Counterstrike Totem", value =  105451},
    { label =  awful.textureEscape(236320, 22).."War Banner", value =  119052},
    { label =  awful.textureEscape(211522, 22).."Psyfiend", value =  101398},
    { label =  awful.textureEscape(353601, 22).."Fel Obelisk", value =  179193},
    { label =  awful.textureEscape(201996, 22).."Observer", value =  107100},
    { label =  awful.textureEscape(204330, 22).."Skyfury Totem", value =  105427},
}
local StompHighDefault = {
    105451, --Counterstrike Totem
    119052, --War Banner
    101398, --Psyfiend
    179193, --Fel Obelisk
    107100, --Observer
    204330, --Skyfury Totem

}
local stompsHigh = gui:Tab("STOMP HIGH PRIO")
stompsHigh:Dropdown({
	var = "stompsHigh",
	multi = true,
	tooltip = "Choose the enemy you want to stomp.",
    options = StompHighOptional,
    default = StompHighDefault,
	placeholder = "Select enemies",
	header = "Targets to Stomp:",
})
stomps:Slider({
	text = "Stomp Delay",
	var = "stompDelay",
	min = 0.0,
	max = 1.0,
    step = 0.1,
	default = 0.5,
	valueType = " Sec",
	tooltip = "Secounds delay before Stomp"
})

local dispelOptional = {
    { label = awful.textureEscape(118, 22).."Polymorph", value = "Polymorph", tvalue = {118,161355,161354,161353,126819,61780,161372,61721,61305,28272,28271,277792,277787,391622}},
    { label = awful.textureEscape(82691, 22).."Ring of Frost", value = 82691,},
    { label = awful.textureEscape(51514, 22).."Hex", value = "Hex", tvalue = {51514, 211015, 211010,211004,210873,269352,277778,277784,} },
    { label = awful.textureEscape(20066, 22).."Repentance", value = 20066,},
    { label = awful.textureEscape(105421, 22).."Blinding Light", value = 105421},
    { label = awful.textureEscape(853, 22).."Hammer of Justice", value = 853},
    { label = awful.textureEscape(10326, 22).."Turn Evil", value = 10326,},
    { label = awful.textureEscape(198909, 22).."Song of Chi-ji", value = 198909,},
    { label = awful.textureEscape(5782, 22).."Fear", value = 5782,},
    { label = awful.textureEscape(5484, 22).."Howl of Terror", value = 5484,},
    { label = awful.textureEscape(6358, 22).."Seduction", value = 6358,},
    { label = awful.textureEscape(386997, 22).."Soul Rot", value = 386997,},
    { label = awful.textureEscape(6789, 22).."Mortal Coil", value = 6789,},
    { label = awful.textureEscape(2637, 22).."Hibernate", value = 2637,},
    { label = awful.textureEscape(360806, 22).."Sleep Walk", value = 360806,},
    { label = awful.textureEscape(383005, 22).."Chrono Loop", value = 383005},
    { label = awful.textureEscape(3355, 22).."Freezing Trap", value = 3355},
    { label = awful.textureEscape(8122, 22).."Psychic Scream", value = 8122},
    { label = awful.textureEscape(64044, 22).."Psychic Horror", value = 64044},
    { label = awful.textureEscape(375901, 22).."Mindgames", value = 375901},
    { label = awful.textureEscape(226943, 22).."Mind Bomb (Fear)", value = 226943},
    { label = awful.textureEscape(205369, 22).."Mind Bomb (Debuff)", value = 205369},
}
local dispelDefault = {
    "Polymorph", -- value = "Polymorph", tvalue = {118,161355,161354,161353,126819,61780,161372,61721,61305,28272,28271,277792,277787}},
    82691, -- 22).."Ring of Frost", value = 82691,},
    "Hex", -- value = "Hex", tvalue = {51514, 211015, 211010,211004,210873,269352,277778,277784,} },
    20066, -- 22).."Repentance", value = 20066,},
    105421, -- 22).."Blinding Light", value = 105421},
    853, -- 22).."Hammer of Justice", value = 853},
    10326, -- 22).."Turn Evil", value = 10326,},
    198909, -- 22).."Song of Chi-ji", value = 198909,},
    5782, -- 22).."Fear", value = 5782,},
    5484, -- 22).."Howl of Terror", value = 5484,},
    6358, -- 22).."Seduction", value = 6358,},
    6789, -- 22).."Mortal Coil", value = 6789,},
    2637, -- 22).."Hibernate", value = 2637,},
    360806, -- 22).."Sleep Walk", value = 360806,},
    383005, -- 22).."Chrono Loop", value = 383005},
    3355, -- 22).."Freezing Trap", value = 3355},
    8122, -- 22).."Psychic Scream", value = 8122},
    64044, -- 22).."Psychic Horror", value = 64044},
    375901, -- 22).."Mindgames", value = 375901},
    226943, -- 22).."Mind Bomb (Fear)", value = 226943},
    205369, -- 22).."Mind Bomb (Debuff)", value = 205369},
}
local dispels = gui:Tab("DISPEL HEALER WITH IMP")
dispels:Dropdown({
	var = "dispelsList",
	multi = true,
	tooltip = "Choose spells you want to dispel",
    options = dispelOptional,
    default = dispelDefault,
	placeholder = "Select Dispels",
	header = "Spells to Dispel:",
})
dispels:Slider({
	text = "Dispel Delay",
	var = "dispelDelay",
	min = 0.0,
	max = 1.0,
    step = 0.1,
	default = 0.5,
	valueType = " Sec",
	tooltip = "Secounds delay before Dispel"
})

local curses = gui:Tab("CURSES")
curses:Checkbox({
  text = " Amplified Curse Of Tongues on Healers",
  var = "amplifiedCurseOfTonguesOnHealers",
  default = true,
})
curses:Checkbox({
  text = "Amplified Curse Of Tongues on Warlocks",
  var = "amplifiedCurseOfTonguesOnWarlocks",
  default = true,
})
curses:Checkbox({
  text = "Amplified Curse Of Weakness on DPS",
  var = "amplifiedCurseOfWeaknessOnDPS",
  default = true,
})
curses:Checkbox({
  text = "Curse Of Exhaustion on DPS",
  var = "curseOfExhaustionOnDPS",
  default = true,
})
curses:Checkbox({
  text = "Auto DOOM                 ",
  var = "autoDoom",
  default = true,
})

local crowdControl = gui:Tab("CROWD CONTROL")
crowdControl:Checkbox({
  text = "Auto Fear                            ",
  var = "autoFearToggle",
  default = true,
})
crowdControl:Checkbox({
  text = "Auto AxeToss (Demonology)              ",
  var = "autoAxeToss",
  default = true,
})
crowdControl:Checkbox({
  text = "Auto ShadowFury                        ",
  var = "autoAutoShadowFury",
  default = true,
})
crowdControl:Checkbox({
  text = "Auto Mortal Coil                        ",
  var = "autoAutoMortalCoil",
  default = true,
})
crowdControl:Checkbox({
  text = "Auto Shadow Rift                        ",
  var = "autoShadowRift",
  default = true,
})

local BanishOptional = {
    { label = awful.textureEscape(265187, 22).."Tyrant", value = 135002,},
    { label = awful.textureEscape(219467, 22).."Wrathguard", value = 58965,},
    { label = awful.textureEscape(219467, 22).."FelGuard", value = 17252,},
    { label = awful.textureEscape(688, 22).."Imp", value = 416,},
    { label = awful.textureEscape(688, 22).."Fel Imp", value = 58959,},
    { label = awful.textureEscape(691, 22).."Felhunter", value = 417,},
    { label = awful.textureEscape(712, 22).."Succubus", value = 1863,},
    { label = awful.textureEscape(112868, 22).."Shivarra", value = 58963,},
    { label = awful.textureEscape(240266, 22).."Shadow Succubus", value = 120527,},
    { label = awful.textureEscape(112867, 22).."Void Lord", value = 58960,},
    { label = awful.textureEscape(138789, 22).."Pit Lord", value = 196111,},
}
local BanishDefault = {
    135002, --Tyrant
    58965, --Wrathguard
    17252, --Felguard
    416, --Imp
    58959, --Fel Imp
    417, --Felhunter
    184600, --Sayaad
    1863, --Succubus
    58963, --Shivarra
    120527, --Shadow Succubus
    1860, --Voidwalker
    58960, --Voidlord
    196111, --Pit Lord
}
local banishes = gui:Tab("BANISH")
banishes:Dropdown({
	var = "banishes",
	multi = true,
	tooltip = "Choose the enemy you want to banish.",
    options = BanishOptional,
    default = BanishDefault,
	placeholder = "Select enemies",
	header = "Targets to Banish:",
})

local defensives = gui:Tab("DEFENSIVE")
defensives:Slider({
	text = "Dark Pact",
	var = "defensivesDarkPact",
	min = 0,
	max = 100,
	default = 70,
	valueType = "%",
	tooltip = "Use Dark Pact above %"
})
defensives:Slider({
	text = "Unending Resolve",
	var = "defensivesunendingResolve",
	min = 0,
	max = 100,
	default = 50,
	valueType = "%",
	tooltip = "What % to use Unending Resolve"
})
defensives:Slider({
	text = "Healthstone",
	var = "defensivesHealthstone",
	min = 0,
	max = 100,
	default = 30,
	valueType = "%",
	tooltip = "What % to use Healthstone"
})
defensives:Slider({
	text = "Heal Pet with HealthFunnel",
	var = "defensivesHealPetSlider",
	min = 0,
	max = 100,
	default = 50,
	valueType = "%",
	tooltip = "What % to use HealthFunnel"
})
defensives:Slider({
	text = "Spam Drain Life (Affliction)",
	var = "defensivesDrainLifeSpam",
	min = 0,
	max = 100,
	default = 70,
	valueType = "%",
	tooltip = "What % to use spam Drain Life"
})
defensives:Checkbox({
  text = "Auto Port                             ",
  var = "autoTeleportButton",
  default = true,
})
defensives:Slider({
	text = "Demonic Circle Teleport",
	var = "defensivesDemonicCircleTeleportSlider",
	min = 0,
	max = 100,
	default = 80,
	valueType = "%",
	tooltip = "What % to use Demonic Circle: Teleport"
})
defensives:Slider({
	text = "Demonic Circle Teleport Minimum Range",
	var = "defensivesDemonicCircleTeleportSliderRange",
	min = 0,
	max = 40,
	default = 10,
	valueType = " yards",
	tooltip = "Minimum for teleport to work"
})
defensives:Checkbox({
  text = "Teleport when atleast 1 enemy on me and used damage cooldowns                     ",
  var = "defensivesDemonicCircleTeleportDPSCDS",
  default = true,
})

local guiTrinkets = gui:Tab("TRINKET/RACIALS")
guiTrinkets:Checkbox({
  text = "Auto Berserking/BloodFury             ",
  var = "autoRacial",
  default = true,
})
guiTrinkets:Checkbox({
  text = "Auto DPS Trinket                      ",
  var = "autoTrinket",
  default = true,
})
guiTrinkets:Checkbox({
  text = "Auto CC Trinket                         ",
  var = "autoCCTrinket",
  default = true,
})
guiTrinkets:Checkbox({
  text = "Auto CC Racial(Human)                   ",
  var = "autoCCRacial",
  default = true,
})

local guiTrinkets = gui:Tab("DEVELOPER")
guiTrinkets:Checkbox({
  text = "GET CORDS",
  var = "developerTesting",
  default = false,
})

awful.addUpdateCallback(function()
    if settings.rotationBTN == true then
        sf:Show()
    end
    if settings.rotationBTN == false then
        sf:Hide()
    end
end)