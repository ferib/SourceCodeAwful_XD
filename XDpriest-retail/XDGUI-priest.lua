local Unlocker, awful, project = ...
awful.DevMode = true
if awful.player.class2 ~= "PRIEST" then return end
local Draw = awful.Draw
local player, target, focus, healer, enemyHealer = awful.player, awful.target, awful.focus, awful.healer, awful.enemyHealer
local AwfulFont = awful.createFont(12, "OUTLINE")
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
	title = "Priest                                    ",
	show = true, -- show on load by default
	width = 400,
	height = 500,
	scale = 1,
	colors = {
		-- color of our ui title in the top left
		title = white,
		-- primary is the primary text color
		primary = white,
		-- accent controls colors of elements and some element text in the UI. it should contrast nicely with the background.
		accent = yellow,
		background = dark,
	}
})

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
        if select(2,IsInInstance()) == "arena" then
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
    end
end)

--Draw EarthenWall
Draw(function(draw)
    if select(2,IsInInstance()) == "arena" and settings.totemDrawings then
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

local function RunSlashCmd(cmd) 
    local slash, rest = cmd:match("^(%S+)%s*(.-)$") 
    for name in pairs(SlashCmdList) do 
       local i = 1 
       local slashCmd 
       repeat 
          slashCmd = _G["SLASH_"..name..i] 

          if slashCmd == slash then 
             -- Call the handler  
             SlashCmdList[name](rest) 
             return true 
          end 
          i = i + 1 
       until not slashCmd 
    end 
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

cmd:New(function(msg)
    if msg == "hidebtn" then
        sf:Hide()
    end
    if msg == "showbtn" then
        sf:Show()
    end
end)

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
info:Text({
  text = "Hide button menu /xd hidebtn",
  header = true
})
info:Text({
  text = "Show button menu /xd showbtn",
  header = true
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
  text = "Auto Focus                            ",
  var = "autoFocusToggle",
  default = true,
})
togglePVP:Checkbox({
  text = "Auto ShadowMeld           ",
  var = "autoShadowMeld",
  default = true,
})
togglePVP:Checkbox({
  text = "Auto Reload on Talent Change           ",
  var = "autoReloadOnTalentChange",
  default = true,
})
togglePVP:Checkbox({
  text = "Never Target PETS or ALLIES           ",
  var = "onlyTargetEnemyPlayers",
  default = true,
})

local toggleDpsCds = gui:Tab("DAMAGE COOLDOWNS")
toggleDpsCds:Checkbox({
  text = "Auto Power Infusion                          ",
  var = "autoPowerInfusion",
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

local textAndDrawingsToggle = gui:Tab("TEXT/DRAWINGS")
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
textAndDrawingsToggle:Checkbox({
  text = "Psychic Scream Circle           ",
  var = "psCircle",
  default = true,
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

local crowdControl = gui:Tab("CROWD CONTROL")
crowdControl:Checkbox({
  text = "Auto Chain CC Healer                ",
  var = "autoChainCCHealer",
  default = true,
})

local defensives = gui:Tab("DEFENSIVE")
defensives:Slider({
	text = "Dispersion",
	var = "defensivesDispersion",
	min = 0,
	max = 100,
	default = 35,
	valueType = "%",
	tooltip = "What % to use Dispersion"
})
defensives:Slider({
	text = "Vampiric Embrace",
	var = "defensivesVampiricEmbrace",
	min = 0,
	max = 100,
	default = 50,
	valueType = "%",
	tooltip = "What % to use Vampiric Embrace"
})
defensives:Slider({
	text = "Desperate Prayer",
	var = "defensivesDesperatePrayer",
	min = 0,
	max = 100,
	default = 70,
	valueType = "%",
	tooltip = "What % to use Desperate Prayer"
})
defensives:Slider({
	text = "Fade",
	var = "defensivesFade",
	min = 0,
	max = 100,
	default = 90,
	valueType = "%",
	tooltip = "What % to use Fade"
})
defensives:Slider({
	text = "Void Shift",
	var = "defensivesVoidShift",
	min = 0,
	max = 100,
	default = 30,
	valueType = "%",
	tooltip = "What % to use Void Shift, will auto select highest hp friend"
})
defensives:Slider({
	text = "Healthstone",
	var = "defensivesHealthstone",
	min = 0,
	max = 100,
	default = 50,
	valueType = "%",
	tooltip = "What % to use"
})
defensives:Slider({
	text = "Power Word Shield",
	var = "defensivesPowerWordShield",
	min = 0,
	max = 100,
	default = 70,
	valueType = "%",
	tooltip = "What % to use"
})
defensives:Slider({
	text = "FlashHeal Myself x50 stacks",
	var = "defensivesFlashHealMyself",
	min = 0,
	max = 100,
	default = 50,
	valueType = "%",
	tooltip = "What % to use"
})
defensives:Slider({
	text = "Flash Heal Friend x50 stacks",
	var = "defensivesFlashHealFriend",
	min = 0,
	max = 100,
	default = 50,
	valueType = "%",
	tooltip = "What % to use"
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