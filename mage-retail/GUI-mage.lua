local Unlocker, awful, project = ...
awful.DevMode = true
if awful.player.class2 ~= "MAGE" then return end
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
	title = "Mage                                   ",
	show = true, -- show on load by default
	width = 500,
	height = 500,
	scale = 1,
	colors = {
		-- color of our ui title in the top left
		title = {3, 138, 255},
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

cmd:New(function(msg)
    if msg == "burst" then
        if project.settings.burstButton then
            project.settings.burstButton = false
            awful.print("Burst OFF")
        else
            project.settings.burstButton = true
            awful.print("Burst ON")
        end
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
if awful.player.spec == "Frost" then
    info:Text({
      text = "Toggle spikeprio button /xd spikeprio",
      header = true
    })
end
info:Text({
  text = "Burst toggle /xd burst",
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
  text = "Auto MageTable                       ",
  var = "autoMageTable",
  default = true,
})
togglePVP:Checkbox({
  text = "Auto Spellsteal                          ",
  var = "spellStealButton",
  default = true,
})
togglePVP:Checkbox({
  text = "Auto ShadowMeld           ",
  var = "autoShadowMeld",
  default = true,
})
togglePVP:Checkbox({
  text = "BURSTMODE, for toggle do /xd burst           ",
  var = "burstButton",
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
  text = "Icy Veins (Frost)",
  var = "autoIcyVeins",
  default = true,
})
toggleDpsCds:Checkbox({
  text = "Frozen Orb (Frost)",
  var = "autoFrozenOrb",
  default = true,
})
toggleDpsCds:Checkbox({
  text = "Combustion (Fire)",
  var = "autoCombustion",
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
  text = "All text that pops up",
  var = "allText",
  default = true,
})
textAndDrawingsToggle:Checkbox({
  text = "Totem Drawings              ",
  var = "totemDrawings",
  default = true,
})
textAndDrawingsToggle:Checkbox({
  text = "Melee Range Indicator         ",
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
  text = "Flamecannon Range Indicator (Fire)         ",
  var = "FlamecannonRangeCheck",
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
    { label = awful.textureEscape(111771, 22).."Demonic Gateway", value = 111771,},
    { label = awful.textureEscape(300728, 22).."Door of Shadows", value = 300728,},
    { label = awful.textureEscape(32375, 22).."Mass Dispel", value = 32375,},
    { label = awful.textureEscape(323673, 22).."Mindgames", value = "Mindgames", tvalue = {323673, 375901} },
    { label = awful.textureEscape(64901, 22).."Symbol of Hope", value = 64901,},
    { label = awful.textureEscape(64843, 22).."Divine Hymn", value = 64843,},
    { label = awful.textureEscape(325013, 22).."Boon of the Ascended", value = 325013,},
    { label = awful.textureEscape(324220, 22).."Deathborne", value = 324220,},
    { label = awful.textureEscape(314791, 22).."Shifting Power", value = 314791,},
    { label = awful.textureEscape(982, 22).."Revive Pet", value = 982,},
    { label = awful.textureEscape(191634, 22).."Stormkeeper", value = 191634,},
    { label = awful.textureEscape(305483, 22).."Lightning Lasso", value = 305483,},
    { label = awful.textureEscape(326434, 22).."Kindred Spirits", value = 326434,},
    { label = awful.textureEscape(391528, 22).."Convoke", value = "Convoke", tvalue = {323764, 337433, 391528} },

    { label = awful.textureEscape(34914, 22).."Vampiric Touch", value = 34914,},
    { label = awful.textureEscape(8092, 22).."Mind Blast", value = 8092,},
    { label = awful.textureEscape(73510, 22).."Mind Spike", value = 73510,},
    { label = awful.textureEscape(263165, 22).."Void Torrent", value = 263165,},
    { label = awful.textureEscape(228260, 22).."Void Eruption", value = 228260,},

    { label = awful.textureEscape(198590, 22).."Drain Soul", value = 198590,},
    { label = awful.textureEscape(234153, 22).."Drain Life", value = 234153,},
    { label = awful.textureEscape(264106, 22).."Deathbolt", value = 264106,},
    { label = awful.textureEscape(116858, 22).."Chaos Bolt", value = 116858,},
    { label = awful.textureEscape(342938, 22).."Unstable Affliction", value = 342938,},
    { label = awful.textureEscape(48181, 22).."Haunt", value = 48181,},
    { label = awful.textureEscape(386997, 22).."Soul Rot", value = 386997,},
    { label = awful.textureEscape(324536, 22).."Malefic Rapture", value = 324536,},

    { label = awful.textureEscape(203286, 22).."Greater Pyro", value = 203286,},
    { label = awful.textureEscape(199786, 22).."Glacial Spike", value = 199786,},
    { label = awful.textureEscape(6353, 22).."Soul Fire", value = 6353,},
    { label = awful.textureEscape(198013, 22).."Eye Beam", value = 198013,},
    { label = awful.textureEscape(5143, 22).."Arcane Missle", value = 5143,},

    { label = awful.textureEscape(357208, 22).."Fire Breath", value = 357208,},
    { label = awful.textureEscape(356995, 22).."Disintegrate", value = 356995,},
    { label = awful.textureEscape(265187, 22).."Summon Tyrant", value = 265187,},

    { label = awful.textureEscape(82326, 22).."Holy Light", value = 82326,},
    { label = awful.textureEscape(19750, 22).."Flash of Light(Paladin)", value = 19750,},
    { label = awful.textureEscape(2061, 22).."Flash Heal(Priest)", value = 2061,},

    { label = awful.textureEscape(115175, 22).."Soothing Mist", value = 115175,},
    { label = awful.textureEscape(355936, 22).."Dream Breath", value = 355936,},
    { label = awful.textureEscape(367226, 22).."Spiritbloom", value = 367226,},
    { label = awful.textureEscape(355936, 22).."Dream Breath Modified", value = 382614,},
    { label = awful.textureEscape(367226, 22).."Spiritbloom Modified", value = 382731,},
    { label = awful.textureEscape(186723, 22).."Penance", value = "Penance", tvalue = {186723,69905,71139,163290,163291,165721,172098,172099,175944, 47758}},
}
local InterruptsDefault = {
    "Polymorph",
    "Hex",
    "Penance",
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
    "Convoke",
    "Mindgames",
    691, --Summon Felhunter
    688, -- Summon Imp
    712, -- Summon Succubus
    111771, --Demonic Gateway
    300728, -- Door of Shadows
    32375, --Mass Dispel
    64901, --Symbol of Hope
    64843, --Divine Hymn
    325013, --Boon of the Ascended
    324220, --Deathborne
    314791, --Shifting Power
    982, --Revive Pet
    191634, --Stormkeeper
    326434, --Kindred Spirits
    264106, --Deathbolt
    116858, -- Chaos Bolt
    203286, --Greater Pyro
    199786, --Glacial Spike
    6353, --Soul Fire
    342938, --unstable affliction
    265187, --summon tyrant
    355936, --Dream Breath
    367226, --Spiritbloom
    382614, --Dream Breath Modified
    382731, --Spiritbloom Modified
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
	tooltip = "Secounds delay before Stomp"
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
    { label = awful.textureEscape(51514, 22).."Hex", value = "Hex", tvalue = {51514, 211015, 211010,211004,210873,269352,277778,277784,} },
    { label = awful.textureEscape(980, 22).."Agony", value = 980,},
    { label = awful.textureEscape(80240, 22).."Havoc", value = 80240},
    { label = awful.textureEscape(334275, 22).."Curse of Exhaustion", value = 334275},
    { label = awful.textureEscape(702, 22).."Curse of Weakness", value = 702},
    { label = awful.textureEscape(1714, 22).."Curse of Tongues", value = 1714},
}
local dispelDefault = {
    "Hex", -- value = "Hex", tvalue = {51514, 211015, 211010,211004,210873,269352,277778,277784,} },
    980, --"Agony"
    80240, --"Havoc"
    334275, --"Curse of Exhaustion"
    702, --"Curse of Weakness"
    1714, --"Curse of Tongues"
}
local dispels = gui:Tab("REMOVE CURSE")
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
dispels:Checkbox({
  text = "Auto Remove Curse               ",
  var = "removeCurseButton",
  default = true,
})

local sheeps = gui:Tab("CROWD CONTROL")
sheeps:Checkbox({
  text = "Auto Sheep                ",
  var = "autoSheep",
  default = true,
})
sheeps:Checkbox({
  text = "Auto Slow                    ",
  var = "autoSlow",
  default = true,
})
sheeps:Checkbox({
  text = "Auto Ring Of Frost                 ",
  var = "ringOfFrostToggle",
  default = true,
})

local defensives = gui:Tab("DEFENSIVE")
defensives:Slider({
	text = "Ice Block",
	var = "defensivesIceBlock",
	min = 0,
	max = 100,
	default = 25,
	valueType = "%",
	tooltip = "What % to use"
})
defensives:Slider({
	text = "Greater Invisibility",
	var = "defensivesGreaterInvisibility",
	min = 0,
	max = 100,
	default = 50,
	valueType = "%",
	tooltip = "What % to use"
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
	text = "Mirror Image",
	var = "defensivesMirrorImage",
	min = 0,
	max = 100,
	default = 70,
	valueType = "%",
	tooltip = "What % to use"
})
defensives:Slider({
	text = "Mass Invisibility",
	var = "defensivesMassInvis",
	min = 0,
	max = 100,
	default = 30,
	valueType = "%",
	tooltip = "What % to use"
})
defensives:Checkbox({
  text = "Auto Alter Time",
  var = "autoAlterTime",
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