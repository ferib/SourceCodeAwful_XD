--#region setup
local Unlocker, awful, project = ...
awful.DevMode = true
if WOW_PROJECT_ID == 11 then return end
if awful.player.spec ~= "Preservation" then return end
local player, target, focus, healer, enemyHealer = awful.player, awful.target, awful.focus, awful.healer, awful.enemyHealer
local arena1, arena2, arena3 = awful.arena1, awful.arena2, awful.arena3
local party1, party2, party3, party4 = awful.party1, awful.party2, awful.party3, awful.party4
project.evoker = {}
project.evoker.preservation = awful.Actor:New({ spec = 2, class = "evoker" })
local preservation = project.evoker.preservation
preservation.ACTOR_TICKRATE = 0.02
local NewSpell = awful.NewSpell
local healthstone = awful.Item(5512)
local dpsTrinketEpic = awful.Item(205708)
local dpsTrinketBlue = awful.Item(205778)
local SpellStopCasting = awful.unlock("SpellStopCasting")
local Draw = awful.Draw
local AwfulFont = awful.createFont(12, "OUTLINE")
local noSleepWalkActive = true
local UseItemByName = awful.unlock("UseItemByName")
local trinketNameBlue = GetItemInfo(205779)
local trinketNameEpic = GetItemInfo(205711)
local fireBreathChanneling = false
local spiritBloomChanneling = false

--#region Lists
local totalimmunity = {
    33786, -- Cyclone
    45438, -- Ice Block
    642, -- Divine Shield
    186265, -- Aspect of the Turtle
    710, -- Banish
    203340, -- Diamond Ice
    362486, -- Tranquility PVP Talent
    31224, -- Cloak of shadows
    79811, --Dispersion
    47585, --dispersion
    196555, --netherwalk
    8178, -- Grounding totem effect
    212295, --nether ward
    409293, --burrow
    217832, --Imprison
    221527, --Imprison
    116849, --Life Cocoon
}
local healImmunity = {
    33786, -- Cyclone
    375901, --MindGames
    217832, --Imprison
    221527, --Imprison
}
local enemyReflect = {
    23920, --spell reflect
}
local enemySleepImmune = {
    408558, --Phase Shift
    213610, --holy ward
    388615, --Restoral
    8178, -- Grounding totem effect
    33786, -- Cyclone
    642, -- Divine Shield
    45438, -- Ice Block
    642, -- Divine Shield
    186265, -- Aspect of the Turtle
    221527, -- Imprison
    710, -- Banish
    203340, -- Diamond Ice
    362486, -- Tranquility PVP Talent
    31224, -- Cloak of shadows
    79811, --Dispersion
    47585, --dispersion
    196555, --netherwalk
    8178, -- Grounding totem effect
    212295, --nether ward
    409293, --burrow
    6940, --Blessing of Sacrifice
    217832, --Imprison
    221527, --Imprison
}
local leaps = {
    6544, -- Heroic Leap
    36554, -- Shadowstep
    1953, -- Blink
    100, -- Charge
    1850, -- Dash  
    781, -- Disengage  
    109132, -- Roll   
    2983, -- Sprint  
    108273, -- Wind Walk
}
local antiKickBuffs = {
    378077, -- Spiritwalker's Aegis
    377360, --Precognition
    317929, --Aura Mastery
    642, --divine shield
    104773, --unendingResolve
    209584, --Zen Focus Tea
    212295, --Nether Ward
    186265, --Aspect of the Turtle
}
local cantBeKicked = {
    377360, --Precognition
    377362, --Precognition
    104773, --unendingResolve
    1022, --Blessing of Protection
    317929, --Aura Mastery 
}
local slowImmune = {
    305395, --blessing of freedom
    1044, --blessing of freedom
    79811, --Dispersion
    47585, --dispersion
    409293, --burrow
}
local dispelPoison = {
    1943, --"Rupture"
    703, --"Garrote"
    118000, --"Dragon Roar"
    1079, --"rip"
}
--#endregion

--#region Spellbook
awful.Populate({
    --## DMG ##--
    fireBreath = NewSpell(357208, { damage = "magic", targeted = false, ignoreMoving = true }),
    fireBreathRank4 = NewSpell(382266, { damage = "magic", targeted = false, ignoreMoving = true }),
    disintegrate = NewSpell(356995, { damage = "magic", targeted = true, ignoreMoving = true }),
    azureStrike = NewSpell(362969, { damage = "magic", targeted = true, ignoreMoving = true }),
    livingFlame = NewSpell(361469, { damage = "magic", targeted = true, ignoreMoving = true, ignoreFacing = true }),
    unravel = NewSpell(368432, { damage = "magic", targeted = true, ignoreMoving = true, ignoreFacing = true }),
    chronoLoop = NewSpell(383005, { damage = "magic", targeted = true, ignoreMoving = true, ignoreFacing = true, ignoreCasting = true, ignoreChanneling = true }),

    --## HEAL ##--
    echo = NewSpell(364343, { beneficial = true, targeted = true, ignoreMoving = true }),
    reversion = NewSpell(366155, { beneficial = true, targeted = true, ignoreMoving = true }),
    reversion2 = NewSpell(367364, { beneficial = true, targeted = true, ignoreMoving = true }),
    dreamBreath = NewSpell(382614, { beneficial = true, targeted = false, ignoreMoving = true }),
    dreamBreathChannel = NewSpell(355936, { beneficial = true, targeted = false, ignoreMoving = true }),
    spiritBloom = NewSpell(382731, { beneficial = true, targeted = false, ignoreMoving = true }),
    spiritBloomChannel = NewSpell(367226, { beneficial = true, targeted = false, ignoreMoving = true }),
    rewind = NewSpell(363534, { beneficial = true, targeted = false, ignoreMoving = true, ignoreCasting = true, ignoreChanneling = true }),
    emeraldCommunion = NewSpell(370960, { beneficial = true, ignoreFacing = true, ignoreControl = true, ignoreMoving = true, ignoreCasting = true, ignoreChanneling = true }),
    verdantEmbrace = NewSpell(360995, { beneficial = true, ignoreFacing = true, ignoreMoving = true }),
    obsidianScales = NewSpell(363916, { beneficial = true, ignoreFacing = true, ignoreMoving = true }),
    renewingBlaze = NewSpell(374348, { beneficial = true, ignoreFacing = true, ignoreMoving = true, ignoreGCD = true }),
    emeraldBlossom = NewSpell(355913, { beneficial = true, ignoreFacing = true, ignoreMoving = true }),
    stasis = NewSpell(370537, { beneficial = true, ignoreFacing = true, ignoreGCD = true }),
    timeDilation = NewSpell(357170, { beneficial = true, ignoreFacing = true, ignoreMoving = true, ignoreGCD = true }),
    dreamProjection = NewSpell(377509, { beneficial = true, targeted = false, ignoreMoving = true }),
    dreamProjectionExpunge = NewSpell(381414, { beneficial = true, targeted = false, ignoreControl = true, ignoreMoving = true }),

    --## RACIALS ##--
    quakingPalm = NewSpell(107079, { effect = "physical", cc = "incapacitate", targeted = true, ignoreMoving = true }),
    bloodFury = NewSpell(33702, { beneficial = true }),
    warStomp = NewSpell(1234, { effect = "physical", cc = "stun", ignoreFacing = true }),
    berserking = NewSpell(26297, { beneficial = true }),
    rocketBarrage = NewSpell(69041, { damage = "magic", targeted = true, ignoreMoving = true }),
    rocketJump = NewSpell(69070, { beneficial = true }),
    bullRush = NewSpell(255654, { effect = "physical", cc = "stun", targeted = true, ignoreMoving = true }),
    ancestralCall = NewSpell(274738, { beneficial = true }),
    bagofTricksDirectDmg = NewSpell(312411, { damage = "magic", targeted = true, ignoreMoving = true }),
    stoneform = NewSpell(20594, { beneficial = true }),
    haymaker = NewSpell(287712, { damage = "physical", effect = "physical", cc = "stun", targeted = true, ignoreMoving = true }),
    bagofTricksDirectHeal = NewSpell(312411, { heal = true, ignoreFacing = true, ignoreMoving = true, targeted = true }),
    giftoftheNaaru = NewSpell(59547, { heal = true, ignoreMoving = true }),
    regeneratin = NewSpell(291944, { heal = true }),
    willToSurvive = NewSpell(59752, { beneficial = true, ignoreControl = true }),
    glide = NewSpell(358733, { beneficial = true, ignoreMoving = true, ignoreGCD = true, targeted = false, ignoreCasting = true, ignoreChanneling = true }),

    --## INTERRUPTS ##--
    quell = NewSpell(351338, { effect = "magic", targeted = true, ignoreGCD = true, ignoreFacing = false, ignoreMoving = true, ignoreCasting = true, ignoreChanneling = true }),

    --## DISPELLS ##--   
    naturalize = NewSpell(360823, { beneficial = true, targeted = true, ignoreFacing = true, ignoreMoving = true, ignoreGCD = false, ignoreCasting = true, ignoreChanneling = true }),
    cauterizingFlame = NewSpell(374251, { beneficial = true, targeted = true, ignoreFacing = true, ignoreMoving = true, ignoreGCD = false, ignoreCasting = true, ignoreChanneling = true }),
    
    --## CC ##--
    sleepWalk = NewSpell(360806, { effect = "magic", cc = "disorient", targeted = true, ignoreFacing = true, ignoreMoving = true }),
    oppressingRoar = NewSpell(372048, { effect = "magic", targeted = false }),
    landSlide = NewSpell(358385, { effect = 'magic', cc = "root", diameter = 8, ignoreFacing = true, ignoreMoving = true }),
    deepBreath = NewSpell(357210, { effect = 'magic', cc = "stun", diameter = 8, ignoreFacing = true, ignoreMoving = true }),

    --## BUFFS ##--
    tipTheScales = NewSpell(370553, { beneficial = true, targeted = false, ignoreFacing = true, ignoreGCD = true, ignoreCasting = true, ignoreChanneling = true }), 
    blessingOfTheBronze = NewSpell(364342, { beneficial = true, targeted = false, ignoreFacing = true }),
    leapingFlames = NewSpell(370901, { beneficial = true }),
    ancientFlame = NewSpell(375583, { beneficial = true }),
    ouroboros = NewSpell(387350, { beneficial = true }),
    callOfYsera = NewSpell(373835, { beneficial = true }),
    temporalCompression = NewSpell(362877, { beneficial = true }),
    essenceBurst = NewSpell(369299, { beneficial = true }),
    fontOfMagic = NewSpell(375783, { beneficial = true }),
    empath = NewSpell(376138, { beneficial = true }),
    lifeGiversFlame = NewSpell(371426, { beneficial = true }),
    terrorOfTheSkies = NewSpell(371032, { beneficial = true }),
    energyLoop = NewSpell(372233, { beneficial = true }),  
    arenaPrep = NewSpell(32727),   
    bgPrep = NewSpell(44521),  
    stasisBuff = NewSpell(370562),

    --## DEFENSIVE/UTILITY ##--
    hover = NewSpell(358267, { beneficial = true, ignoreFacing = true }),
    rescue = NewSpell(370665, { beneficial = true, targeted = true, ignoreFacing = true, ignoreGCD = false }),
    wingBuffet = NewSpell(357214, { beneficial = true, ignoreFacing = false }),
    tailSwipe = NewSpell(368970, { beneficial = true, ignoreFacing = false }),
    timeSpiral = NewSpell(374968, { beneficial = true, ignoreFacing = false }),
    nullifyingShroud = NewSpell(378464, { beneficial = true, ignoreFacing = false }),
}, preservation, getfenv(1))
--#endregion

function TargetCheck(unit)
    if not unit.enemy then return false end
    if unit.dead then return false end
    if not player.canAttack(unit) then return false end  
    if unit.id == 60849 then return false end --monk statue
    if unit.id == 189617 then return false end --golem tanking dummy
    if unit.id == 194649 then return false end --tanking dummy

    if unit.buffFrom(totalimmunity) or unit.debuffFrom(totalimmunity) then return false end
    if project.settings.autoStopAttackOnCCTarget then
        if unit.bcc then return false end
    end

    if select(2,IsInInstance()) == "arena" then
        awful.enemies.loop(function(enemy)
            if enemy.player then
                if azureStrike:Castable(enemy) and enemy.buffFrom(enemyReflect) then -- remove reflect
                    azureStrike:Cast(enemy)
                end
            end
        end)
    end
    return true
end

local WasCasting = { }
function WasCastingCheck()
    local time = awful.time
    if player.casting then
        WasCasting[player.castingid] = time
    end
    for spell, when in pairs(WasCasting) do
        if time - when > 0.100+awful.latency then
            WasCasting[spell] = nil
        end
    end
end
function stomp()
    awful.totems.stomp(function(totem, uptime)
        if project.settings.stomps[totem.id] then
            if uptime <= 0.5 then return end
            if azureStrike:Castable(totem) then
                azureStrike:Cast(totem)
            end
        end
    end)
end
local alerted = 0
function QueueAlertAndAccept()
    local battlefieldStatus = GetBattlefieldStatus(1)
    if project.settings.alertQueue then
        if battlefieldStatus == "confirm" then
            if awful.time - alerted > 3 then
                PlaySound(5775, "Master")
                alerted = awful.time
            end
            if GetBattlefieldPortExpiration(1) > 10 then return end
        end
    end
    if project.settings.acceptQueue and GetBattlefieldPortExpiration(1) > 8 then
        awful.call("AcceptBattlefieldPort", 1, true)
    end
end
local antiafk = 0
local function AntiAfk()
    if project.settings.antiAfk then
        if awful.time - antiafk > 60 then
            if ResetAfk then
                ResetAfk()
                antiafk = awful.time
            elseif SetLastHardwareActionTime then
                SetLastHardwareActionTime(awful.time*1000)
                antiafk = awful.time
            end
            antiafk = awful.time
        end
        if project.settings.antiAfk and UnitIsAFK("player") then
            awful.call("JumpOrAscendStart")
        end
    end
end
function castCheck(list, castId)
    for k, v in pairs(list) do
        if k == castId and v == true then return true end
        if type(v) == "table" then
            for _, id in ipairs(v) do
                if castId == id then return true end
            end
        end
    end
end

local function developerTesting()
    glide:Cast()
end

local function grabFlag()
    if select(2,IsInInstance()) == "pvp" then
        local flag = awful.objects.find(function(obj) return obj.id == 227741 or obj.id == 227740 or obj.id == 227745 end)
        if flag then
            local distance = flag.distanceLiteral
            if distance <= 10 then
                if Unlocker.type == "daemonic" then
                    Interact(flag.pointer)
                else
                    ObjectInteract(flag.pointer)
                end
            end
        end
    end
end

--removed from open source

local function LowestEnemy()
    LowestHealthEnemy = 100
    LowestUnitEnemy = player
    LowestPetHealthEnemy = 100
    LowestPetUnitEnemy = player
    SecondLowestHealthEnemy = 100
    SecondLowestUnitEnemy = player
    LowestActualHealthEnemy = 200000
    LowestActualUnitEnemy = nil
    piFriend = player
    local badDebuff = {"Forgeborne Reveries", "Cyclone", "Shadowy Duel", 203337, 221527}
    local badBuff = {"Alter Time", "Spirit of Redemption", "Podtender", "Forgeborne Reveries"}
    awful.enemies.loop(function(unit, i, uptime)
        if not unit.dead and not unit.debuffFrom(badDebuff) and not unit.buffFrom(badBuff) and unit.los then
            if unit.hp < LowestHealthEnemy then
                SecondLowestHealthEnemy = LowestHealthEnemy
                SecondLowestUnitEnemy = LowestUnitEnemy
                LowestHealthEnemy = unit.hp
                LowestUnitEnemy = unit
            end
            if unit.hp > LowestHealthEnemy and unit.hp < SecondLowestHealthEnemy then
                SecondLowestHealthEnemy = unit.hp
                SecondLowestUnitEnemy = unit
            end
            if not unit.isUnit(player) and unit.health < LowestActualHealthEnemy then
                LowestActualHealthEnemy = unit.health
                LowestActualUnitEnemy = unit
            end
        end
    end)
end

local function CCTrinket()
    if select(2,GetItemCooldown(205779)) <= 0 or select(2,GetItemCooldown(205711)) <= 0 then
        UseItemByName(trinketNameBlue)
        UseItemByName(trinketNameEpic)
    end
end

awful.addUpdateCallback(function() 
    if player.channelID == fireBreathRank4.id or player.channelID == fireBreath.id then
        fireBreathChanneling = true
    end
    if player.channelID == spiritBloomChannel.id or player.channelID == spiritBloom.id then
        spiritBloomChanneling = true
    end

    --dreamProjection
    if player.casting and player.castID == dreamProjection.id then
        C_Timer.After(dreamProjection.castTime + 0.4, function()
            awful.call("RunMacroText", "/cancelaura Dream Projection")
        end)
    end

    --fireBreath aimbot
    if fireBreathChanneling and not player.moving then
        if PlayerCastingBarFrame.CurrSpellStage >= 1 and not LowestUnitEnemy.playerFacing45 and (player.channelID == fireBreathRank4.id or player.channelID == fireBreath.id) then
            player.face(LowestUnitEnemy)
        end
        if PlayerCastingBarFrame.CurrSpellStage >= 4 and player.hasTalent(fontOfMagic.id) or PlayerCastingBarFrame.CurrSpellStage >= 3 and not player.hasTalent(fontOfMagic.id) then
            if LowestUnitEnemy.distance <= 25 and LowestUnitEnemy.los and LowestUnitEnemy.player and not LowestUnitEnemy.bcc then
                if TargetCheck(LowestUnitEnemy) then
                    fireBreath:Release() 
                    fireBreathChanneling = false
                    awful.alert({
                        message = "Aimbot on lowest enemy unit",
                        texture = fireBreath.id,
                        duration = 1,
                    })
                end
            elseif SecondLowestUnitEnemy.distance <= 25 and SecondLowestUnitEnemy.los and SecondLowestUnitEnemy.player and not SecondLowestUnitEnemy.bcc then
                if TargetCheck(SecondLowestUnitEnemy) then
                    player.face(SecondLowestUnitEnemy)
                    fireBreath:Release() 
                    fireBreathChanneling = false
                    awful.alert({
                        message = "Aimbot on secound lowest enemy unit",
                        texture = fireBreath.id,
                        duration = 1,
                    })
                end
            end
        end
    end

    --spiritBloom
    if spiritBloomChanneling then
        if PlayerCastingBarFrame.CurrSpellStage >= 3 then
            spiritBloom:Release()
            spiritBloomChanneling = false
        end
    end

    --SpellStopCasting
    if player.casting == sleepWalk.id and (enemyHealer.debuffFrom(enemySleepImmune) or enemyHealer.buffFrom(enemySleepImmune)) then
        awful.alert({
            message = "Cancel CC enemyHealer is IMMUNE",
            texture = sleepWalk.id,
            duration = 1,
        })
        SpellStopCasting()
    end

    --antiknock
    if select(2,IsInInstance()) == "arena" then
        awful.enemies.loop(function(enemy)
            if enemy.distance <= 20 and enemy.lastCast == 51490 or enemy.lastCast == 157981 or enemy.lastCast == 357214 or enemy.lastCast == 132469 then
                if glide:Cast() then
                    awful.alert({
                        message = "Anti knockback",
                        texture = glide.id,
                        duration = 1,
                    })
                end
            end
        end)
    end
end)

local alertedPreCog = 0
awful.addUpdateCallback(function()
    grabFlag()
    QueueAlertAndAccept()
    AntiAfk()
    if player.buffFrom(cantBeKicked) and awful.time - alertedPreCog > 3 then
        if project.settings.kickImmunityAlert then
            PlaySound(8051, "Master") 
            awful.alert({
                message = "YOU ARE INTERRUPT IMMUNE",
                texture = 377360,
                duration = 1,
            })
            alertedPreCog = awful.time
        end
    end
    if project.settings.developerTesting then
        developerTesting()
    end
end)

if project.settings.playerEspToggle then
    local iconTexture = {
        ["DEATHKNIGHT"] = 265145,
        ["DEMONHUNTER"] = 1260827,
        ["DRUID"] = 625999,
        ["HUNTER"] = 626000,
        ["MAGE"] = 626001,
        ["MONK"] = 626002,
        ["PALADIN"] = 626003,
        ["PRIEST"] = 626004,
        ["ROGUE"] = 626005,
        ["SHAMAN"] = 626006,
        ["WARLOCK"] = 626007,
        ["WARRIOR"] = 626008,
        ["EVOKER"] = 4574311
    }

    local roleTexture = {
        ["tank"] = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:0:19:22:41|t",
        ["healer"] = "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:1:20|t",
        ["melee"] = "",--"|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:22:41|t",
        ["ranged"] = "",--"|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:22:41|t",
    }

    local function DynamicColor(hp)
        if hp >= 66 then
            return "|cff5fd729"
        elseif hp >= 33 and hp < 66 then
            return "|cffFF8300"
        elseif hp < 33 then
            return "|cfff44336"
        end
    end

    Draw(function(draw)
        awful.allEnemies.loop(function(unit)
            if not unit then return end
            if unit.dead then return end
            if not unit.player then return end
            local x, y, z = unit.position()
            if x and y and z and unit.role and unit.class2 and unit.hp and not (unit.debuff(702) or unit.debuff(1714) or unit.debuff(334275)) then
                draw:SetColor(255, 0, 0, 200)
                draw:Text(((unit.buff(156618) and awful.textureEscape(156618, 24) or 
                unit.buff(156621) and awful.textureEscape(156621, 24)) or 
                "")..
                roleTexture[unit.role]..
                awful.textureEscape(iconTexture[unit.class2], 12)..
                DynamicColor(unit.hp)..
                string.format("%.0f", unit.hp).."%", 
                AwfulFont, x, y, z+0.5)
            end
            if x and y and z and unit.role and unit.class2 and unit.hp and unit.debuff(702) then
                draw:SetColor(255, 0, 0, 200)
                draw:Text(((unit.buff(156618) and awful.textureEscape(156618, 24) or 
                unit.buff(156621) and awful.textureEscape(156621, 24)) or 
                "")..
                roleTexture[unit.role]..
                awful.textureEscape(iconTexture[unit.class2], 12)..
                awful.textureEscape(702, 12)..
                awful.textureEscape(328774, 30)..
                DynamicColor(unit.hp)..
                string.format("%.0f", unit.hp).."%", 
                AwfulFont, x, y, z+0.5)
            end
            if x and y and z and unit.role and unit.class2 and unit.hp and unit.debuff(1714) then
                draw:SetColor(255, 0, 0, 200)
                draw:Text(((unit.buff(156618) and awful.textureEscape(156618, 24) or 
                unit.buff(156621) and awful.textureEscape(156621, 24)) or 
                "")..
                roleTexture[unit.role]..
                awful.textureEscape(iconTexture[unit.class2], 12)..
                awful.textureEscape(1714, 12)..
                DynamicColor(unit.hp)..
                string.format("%.0f", unit.hp).."%", 
                AwfulFont, x, y, z+0.5)
            end
            if x and y and z and unit.role and unit.class2 and unit.hp and unit.debuff(334275) then
                draw:SetColor(255, 0, 0, 200)
                draw:Text(((unit.buff(156618) and awful.textureEscape(156618, 24) or 
                unit.buff(156621) and awful.textureEscape(156621, 24)) or 
                "")..
                roleTexture[unit.role]..
                awful.textureEscape(iconTexture[unit.class2], 12)..
                awful.textureEscape(334275, 12)..
                DynamicColor(unit.hp)..
                string.format("%.0f", unit.hp).."%", 
                AwfulFont, x, y, z+0.5)
            end
        end)
    end)
end

preservation:Init(function()
    if player.mounted then return end
    if player.dead then return end
    WasCastingCheck()
    Lowest()
    LowestEnemy()

    --v2attackers LowestUnit
    local totalLowest, meleeLowest, rangedLowest, cooldownsLowest = LowestUnit.v2attackers()
    local totalPlayer = player.v2attackers()
    local totalenemyHealer = enemyHealer.v2attackers()

    --CCtrinket 
    if project.settings.autoCCRacial or project.settings.autoCCTrinket then
        if not LowestUnit.buff(rewind.id) and not player.buff(emeraldCommunion.id) and emeraldCommunion.cd >= 2 and rewind.cd >= 2 and LowestUnit.hp <= 50 and (player.cc and player.ccRemains >= 1 or player.bcc and player.bccRemains >= 1 or player.silence and player.silenceRemains >= 1 or player.charmed) then
            C_Timer.After(0.3, function()
                CCTrinket()
            end)
        end
    end

    --DPSTrinket
    if player.combat then
        dpsTrinketEpic:Use()
        dpsTrinketBlue:Use()
    end

    --chronoLoop 
    if LowestUnitEnemy.player and LowestUnitEnemy.distance <= 25 and LowestUnitEnemy.los then 
        if TargetCheck(LowestUnitEnemy) and not LowestUnitEnemy.buff(48707) then
            if chronoLoop:Castable(LowestUnitEnemy) and LowestUnitEnemy.hp <= 40 then
                if chronoLoop:Cast(LowestUnitEnemy) then 
                    awful.alert({
                    message = "Enemy below 40%",
                        texture = chronoLoop.id,
                        duration = 1,
                    })
                end
            end
        end
    end

    --fireBreath with tip of the scales
    if player.gcdRemains <= 0.5 and LowestUnitEnemy.player and LowestUnitEnemy.distance <= 25 and LowestUnitEnemy.los and (LowestUnitEnemy.hp <= 20 or player.buff(tipTheScales.id) and LowestUnitEnemy.hp <= 35) then
        if TargetCheck(LowestUnitEnemy) and not player.cc and not player.bcc and fireBreathRank4.cd == 0 then
            if tipTheScales.cd == 0 then
                tipTheScales:Cast()
            end
            if fireBreathRank4.cd == 0 and player.buff(tipTheScales.id) and LowestUnitEnemy.los then
                SpellStopCasting()
                player.face(LowestUnitEnemy)
                fireBreath:Cast()
                awful.alert({
                message = "Enemy DPS is below 20% EXECUTE with tipTheScales",
                    texture = fireBreath.id,
                    duration = 1,
                })
            end
        end
    end

    --timeDilation
    if (LowestUnit.hp <= 50 and totalLowest >= 1 or LowestUnit.hp <= 80 and totalLowest >= 2 or totalLowest >= 2 and cooldownsLowest >= 2) and not LowestUnit.buffFrom(totalimmunity) and not LowestUnit.debuffFrom(totalimmunity) then
        if timeDilation:Castable(LowestUnit) then
            if timeDilation:Cast(LowestUnit) then
                awful.alert({
                message = "Friend getting BURSTED",
                    texture = timeDilation.id,
                    duration = 1,
                })
            end
        end
    end

    --rescue
    if (LowestUnit.hp <= 50 and totalLowest >= 1 or LowestUnit.hp <= 80 and totalLowest >= 2 or totalLowest >= 2 and cooldownsLowest >= 2) and not LowestUnit.buffFrom(totalimmunity) and not LowestUnit.debuffFrom(totalimmunity) and project.settings.autoRescue then
        if rescue:Castable(LowestUnit) and not player.rooted and not LowestUnit.rooted and LowestUnit.los then
            if LowestUnit.isUnit(player) then
                if party1.distance <= 30 and not party1.isUnit(player) and party1.los then
                    party1.setTarget()
                    if rescue:AoECast(party1) then
                        awful.alert({
                        message = "I am getting bursted go to friend",
                            texture = rescue.id,
                            duration = 1,
                        })
                        return
                    end
                elseif party2.distance <= 30 and not party2.isUnit(player) and party2.los then
                    party2.setTarget()
                    if rescue:AoECast(party2) then
                        awful.alert({
                        message = "I am getting bursted go to friend",
                            texture = rescue.id,
                            duration = 1,
                        })
                        return
                    end
                elseif party3.distance <= 30 and not party3.isUnit(player) and party3.los then
                    party3.setTarget()
                    if rescue:AoECast(party3) then
                        awful.alert({
                        message = "I am getting bursted go to friend",
                            texture = rescue.id,
                            duration = 1,
                        })
                        return
                    end
                end            
            end
            if not LowestUnit.isUnit(player) then
                if LowestUnit.melee then
                    LowestUnit.setTarget()
                    if rescue:AoECast(LowestUnitEnemy) then
                        awful.alert({
                        message = "Melee friend getting bursted move to enemy",
                            texture = rescue.id,
                            duration = 1,
                        })
                    end
                end
                if LowestUnit.ranged then
                    LowestUnit.setTarget()
                    if rescue:AoECast(player) then
                        awful.alert({
                        message = "Ranged friend getting bursted move to me",
                            texture = rescue.id,
                            duration = 1,
                        })
                    end
                end
            end
        end
    end

    --rewind 
    if not player.buff(arenaPrep.id) and not LowestUnit.buff(rewind.id) and not player.buff(emeraldCommunion.id) and not WasCasting[rewind.id] and rewind.cd == 0 and LowestUnit.hp <= 36 and LowestUnit.distance <= 39 and not LowestUnit.buffFrom(totalimmunity) and not LowestUnit.debuffFrom(totalimmunity) and player.castID ~= livingFlame.id then
        if player.cc and player.ccRemains >= 1 or player.bcc and player.bccRemains >= 1 or player.silence and player.silenceRemains >= 1 then
            if emeraldCommunion.cd >= 2 or player.debuffFrom({33786, 221527}) then 
                C_Timer.After(0.3, function()
                    CCTrinket()
                end)
            end
        end
        if not player.cc and not player.bcc and not player.silence then
            if rewind:Cast() then
                awful.alert({
                message = "Friend dropped below 35%",
                    texture = rewind.id,
                    duration = 1,
                })
            end
        end
    end

    --verdantEmbrace 
    if LowestUnit.hp <= 70 and not player.rooted and LowestUnit.los and not LowestUnit.buffFrom(healImmunity) and not LowestUnit.debuffFrom(healImmunity) then
        if verdantEmbrace:Castable(LowestUnit) then
            if verdantEmbrace:Cast(LowestUnit) then
                awful.alert({
                message = "Friend below 70% HP",
                    texture = verdantEmbrace.id,
                    duration = 1,
                })
            end
        end
    end

    --emeraldCommunion
    if player.combat and LowestUnit.los and not WasCasting[emeraldCommunion.id] and not player.buff(arenaPrep.id) and emeraldCommunion.cd == 0 and LowestUnit.hp <= 36 and LowestUnit.distance <= 39 and not LowestUnit.buffFrom(totalimmunity) and not LowestUnit.debuffFrom(totalimmunity) and not LowestUnit.buff(rewind.id) and not player.buff(emeraldCommunion.id) and player.castID ~= livingFlame.id then
        if rewind.cd >= 2 and player.debuffFrom({33786, 221527}) then 
            C_Timer.After(0.3, function()
                CCTrinket()
            end)
        end
        if not player.debuffFrom({33786, 221527}) then --cyclone and banish
            if emeraldCommunion:Cast() then
                awful.alert({
                    message = "Friend dropped below 35%",
                    texture = emeraldCommunion.id,
                    duration = 1,
                })
            end
        end
    end

    --sleepWalk tyrant
    awful.tyrants.loop(function(tyrant)
        if tyrant.id == 135002 and tyrant.enemy and tyrant.disorientDR >= 0.2 and not tyrant.bcc and not tyrant.cc and (player.moving and player.buff(hover.id) or not player.moving) then
            if sleepWalk:Castable(tyrant) then
                if sleepWalk:Cast(tyrant) then
                    awful.alert({
                    message = "CC tyrant",
                        texture = sleepWalk.id,
                        duration = 1,
                    })
                end
            end
        end
    end)

    --dreamBreath+spiritBloom
    if LowestUnit.combat and player.buffStacks(temporalCompression.id) >= 4 and player.buffRemains(temporalCompression.id) >= 2 and totalLowest >= 1 and not LowestUnit.buffFrom(healImmunity) and not LowestUnit.debuffFrom(healImmunity) and LowestUnit.distance <= 25 and LowestUnit.los and not player.moving and LowestUnit.buff(echo.id, player) then
        if dreamBreath:Castable() then
            if player.buff(tipTheScales.id) then
                player.face(LowestUnit)
            end
            if dreamBreath:Cast() then
                awful.alert({
                    message = "Using on lowest HP friend",
                    texture = dreamBreath.id,
                    duration = 1,
                })
            end
            dreamBreath:Release()
        end

        if spiritBloom:Castable() then
            if spiritBloom:Cast() then
                awful.alert({
                message = "Using on lowest HP friend",
                    texture = spiritBloom.id,
                    duration = 1,
                })
            end
            spiritBloom:Release()
        end 
    end

    --leapingFlames+livingFlame enemy
    if LowestUnit.hp >= 60 and player.buff(leapingFlames.id) and player.buff(ancientFlame.id) and not LowestUnitEnemy.bcc and not WasCasting[sleepWalk.id] then
        if LowestUnitEnemy.distance <= 30 and LowestUnitEnemy.los and not LowestUnitEnemy.bcc and LowestUnitEnemy.player then
            if TargetCheck(LowestUnitEnemy) and (player.moving and player.buff(hover.id) or not player.moving) then
                if not LowestUnitEnemy.playerFacing45 then
                    player.face(LowestUnitEnemy)
                end
                if livingFlame:Cast(LowestUnitEnemy) then
                    awful.alert({
                    message = "Friends above 60% HP, using proc on lowestEnemy",
                        texture = leapingFlames.id,
                        duration = 1,
                    })
                end
            end
        end
    end

    --blessingOfTheBronze
    if not player.combat and not player.buff(381748) then
        C_Timer.After(3, function()
            blessingOfTheBronze:Cast(player)
        end)
    end

    --nullifyingShroud
    if IsMounted() == false then
        if select(2,IsInInstance()) == "none" and not player.combat then return end
        if LowestUnit.hp >= 40 and player.combat or not player.combat then
            nullifyingShroud:Cast() 
        end
    end
    
    --get in combat
    if not player.combat and select(2,IsInInstance()) == "arena" then
        awful.enemies.loop(function(enemy)
            if azureStrike:Castable(enemy) then
                if azureStrike:Cast(enemy) then
                    awful.alert({
                        message = "Trying to get in combat",
                        texture = azureStrike.id,
                        duration = 1,
                    })
                end
            end
        end)
    end

    --Interrupt
    if quell.cd == 0 then
        awful.enemies.loop(function(enemy)
            if TargetCheck(enemy) then
                if quell:Castable(enemy) and not enemy.casting8 and (castCheck(project.settings.interrupts, enemy.castID) and enemy.casting or castCheck(project.settings.interrupts, enemy.channelID) and enemy.channeling) then
                    C_Timer.After(0.5, function()
                        if quell:Castable(enemy) and not enemy.casting8 and (castCheck(project.settings.interrupts, enemy.castID) and enemy.casting or castCheck(project.settings.interrupts, enemy.channelID) and enemy.channeling) then
                            if quell:Cast(enemy) then
                                awful.alert({
                                    message = "Interrupting: "..enemy.name, 
                                    texture = quell.id,
                                    duration = 1,
                                })
                            end
                        end
                    end)
                end
            end
        end)
    end

    --Interrupt healer
    if quell.cd == 0 and enemyHealer.exists and LowestUnitEnemy.hp <= 30 and not LowestUnitEnemy.buffFrom(totalimmunity) and not LowestUnitEnemy.debuffFrom(totalimmunity) then
        if TargetCheck(enemyHealer) then
            if quell:Castable(enemyHealer) and not enemyHealer.casting8 and (enemyHealer.casting or enemyHealer.channeling) then
                C_Timer.After(0.5, function()
                    if quell:Castable(enemyHealer) and not enemyHealer.casting8 and (enemyHealer.casting or enemyHealer.channeling) then
                        if quell:Cast(enemyHealer) then
                            awful.alert({
                                message = "Enemy is below 30% HP interrupting anything from HEALER", 
                                texture = quell.id,
                                duration = 1,
                            })
                        end
                    end
                end)
            end
        end
    end

    --dispels
    awful.fullGroup.loop(function(unit, i, uptime)
        if not unit.buffFrom(totalimmunity) and not unit.debuffFrom(totalimmunity) then
            if not unit.debuff(342938) and not unit.debuff(34914) or unit.debuff(34914) and LowestUnit.hp >= 80 or unit.debuff(342938) and LowestUnit.hp >= 95 and player.hp >= 95 then --342938 unstableaffliction 34914 VT
                --DISPELL
                if unit.debuffFrom(project.settings.dispelsList) and naturalize.cd == 0 then  
                    local debuff = unit.debuffFrom(project.settings.dispelsList)[1]
                    if unit.debuffUptime(debuff) <= 0.5 then return end
                    if naturalize:Castable(unit) and naturalize:Cast(unit) then
                        awful.alert({
                            message = "Dispel " ..unit.name,
                            texture = naturalize.id,
                            duration = 1,
                        })
                    end
                end

                --DISPELL root
                if naturalize:Castable(unit) and unit.rooted and naturalize.cd == 0 then
                    naturalize:Cast(unit)  
                    awful.alert({
                        message = "Dispel Root " ..unit.name,
                        texture = naturalize.id,
                        duration = 1,
                    })
                end

                --DISPELL Curse+Bleeds+Poison
                if cauterizingFlame:Castable(unit) and unit.debuffFrom(project.settings.dispelsCurseList) and cauterizingFlame.cd == 0 then  
                    local debuff = unit.debuffFrom(project.settings.dispelsCurseList)[1]
                    if unit.debuffUptime(debuff) <= 0.5 then return end
                    cauterizingFlame:Cast(unit) 
                    awful.alert({
                        message = "Dispel bleed/curse/poison " ..unit.name,
                        texture = cauterizingFlame.id,
                        duration = 1,
                    })
                end
            end
        end
    end)

    --soulWell
    local soulwelled = awful.objects.within(5).find(function(obj) return obj.id == 303148 and obj.creator.friend end)
    if healthstone.count < 1 then
        if soulwelled then
            if Unlocker.type == "daemonic" then
                Interact(soulwelled.pointer)
            else
                ObjectInteract(soulwelled.pointer)
            end
            return
        end
    end

    --knock/freeze melee
    local count, total, objects = awful.enemies.around(player, 5)

    --knocks
    if project.settings.knockbacks then
        --wingBuffet
        if wingBuffet.cd == 0 then
            for i = 1, count do
                local unit = objects[i]
                if wingBuffet:Castable() and unit.melee and not unit.cc and not unit.bcc and TargetCheck(unit) and not unit.immuneCC and not unit.rooted and not player.channel8 then
                    player.face(unit)
                    wingBuffet:Cast(unit)
                end
            end
        --tailSwipe
        elseif tailSwipe.cd == 0 then
            for i = 1, count do
                local unit = objects[i]
                if tailSwipe:Castable() and unit.melee and not unit.cc and not unit.bcc and TargetCheck(unit) and not unit.immuneCC and not unit.rooted and not player.channel8 then
                    tailSwipe:Cast(unit)
                end
            end
        end
    end

    --DEFENSIVES
    if player.combat and not player.buff(arenaPrep.id) then
        if healthstone.cd == 0 and (player.hp <= 50 and not player.buff(obsidianScales.id) and not player.buff(renewingBlaze.id) or player.hp <= 30) then
            healthstone:Use()
        end
        if renewingBlaze.cd == 0 and (player.hp <= 80 and not player.buff(obsidianScales.id) and totalPlayer >= 1 or player.hp <= 50) then
            renewingBlaze:Cast()
        end
        if obsidianScales.cd == 0 and (player.hp <= 70 and not player.buff(obsidianScales.id) and not player.buff(renewingBlaze.id) and totalPlayer >= 1 or player.hp <= 50 and not player.buff(obsidianScales.id)) then
            obsidianScales:Cast()
        end
    end

    --deepBreath enemyHealer
    if not enemyHealer.debuffFrom(totalimmunity) and not enemyHealer.buffFrom(totalimmunity) and LowestUnit.hp >= 50 and player.hasTalent(terrorOfTheSkies.id) or totalPlayer >= 2 and not player.buff(renewingBlaze.id) then
        if select(2,IsInInstance()) == "none" and not player.combat then return end
        if deepBreath.cd == 0 then
            if deepBreath:Castable() and not player.rooted and enemyHealer.distance <= 45 and enemyHealer.distance >= 15 and not enemyHealer.buffFrom(totalimmunity) and not enemyHealer.debuffFrom(totalimmunity) and (LowestUnitEnemy.hp <= 40 or totalPlayer >= 2 and not player.buff(renewingBlaze.id)) then
                if enemyHealer.stunDR >= 0.5 and enemyHealer.speed <= 10 and enemyHealer.los then 
                    local x, y, z = enemyHealer.predictPosition(0.5)
                    if deepBreath:AoECast(x,y,z) then
                        awful.alert({
                        message = "Enemy DPS is below 40% CC enemyHealer",
                            texture = deepBreath.id,
                            duration = 1,
                        })
                    end
                end
            end
        end
    end

    --dreamBreath aimbot
    if (player.channelID == 355936 or player.channelID == 382614) and LowestUnit.distance <= 30 and not player.moving then
        if LowestUnit.isUnit(player) and not SecondLowestUnit.playerFacing45 then
            player.face(SecondLowestUnit)
        elseif not LowestUnit.playerFacing45 then
            player.face(LowestUnit)
        end
    end

    --livingFlame aimbot
    if player.buff(leapingFlames.id) and player.castID == livingFlame.id and player.casting and not LowestUnitEnemy.playerFacing45 then
        if TargetCheck(LowestUnitEnemy) then
            player.face(LowestUnitEnemy)
        end
    end

    --tipTheScales on low 
    if LowestUnit.hp <= 50 and LowestUnit.los and rewind.cd >= 2 and emeraldCommunion.cd >= 2 and (spiritBloom.cd == 0 or dreamBreath.cd == 0) then
        if tipTheScales.cd == 0 then
            tipTheScales:Cast()
        end
        if player.buff(tipTheScales.id) then
            player.face(LowestUnit)
            dreamBreath:Cast()
            spiritBloom:Cast()
            awful.alert({
            message = "Rewind on CD and emeraldCommunion on CD, using tipTheScales for healing",
                texture = tipTheScales.id,
                duration = 1,
            })
        end
    end

    --disintegrate low mana 
    if player.hasTalent(energyLoop.id) and disintegrate:Castable(LowestUnitEnemy) and LowestUnitEnemy.player and (player.manaPct <= 10 or LowestUnit.hp >= 80 and player.manaPct <= 90) then
        if TargetCheck(LowestUnitEnemy) and not LowestUnitEnemy.bcc and not WasCasting[sleepWalk.id] and (player.moving and player.buff(hover.id) or not player.moving) then
            player.face(LowestUnitEnemy)
            if disintegrate:Cast(LowestUnitEnemy) then
                awful.alert({
                    message = "need mana",
                    texture = disintegrate.id,
                    duration = 1,
                })
            end
        end
    end

    --echo 
    if player.hasTalent(energyLoop.id) and player.manaPct > 10 or not player.hasTalent(energyLoop.id) then
        if not player.buff(arenaPrep.id) and not player.buff(bgPrep.id) then
            if select(2,IsInInstance()) == "none" and not player.combat then return end
            if echo:Castable(LowestUnit) and not LowestUnit.buffFrom(healImmunity) and not LowestUnit.debuffFrom(healImmunity) and not LowestUnit.buff(echo.id, player) and (player.essence >= 2 or player.buff(essenceBurst.id)) then
                if echo:Cast(LowestUnit) then
                    awful.alert({
                    message = "Putting hots up on lowest HP friend",
                        texture = echo.id,
                        duration = 1,
                    })
                end
            end
            if player.essence >= 2 or player.buff(essenceBurst.id) then
                if echo:Castable(party1) and not party1.buff(echo.id, player) and not party1.buffFrom(healImmunity) and not party1.debuffFrom(healImmunity) then
                    echo:Cast(party1) 
                end
                if echo:Castable(party2) and not party2.buff(echo.id, player) and not party2.buffFrom(healImmunity) and not party2.debuffFrom(healImmunity) then
                    echo:Cast(party2) 
                end
                if echo:Castable(party3) and not party3.buff(echo.id, player) and not party3.buffFrom(healImmunity) and not party3.debuffFrom(healImmunity) then
                    echo:Cast(party3) 
                end
                if echo:Castable(party4) and not party4.buff(echo.id, player) and not party4.buffFrom(healImmunity) and not party4.debuffFrom(healImmunity) then
                    echo:Cast(party4) 
                end
            end
        end
    end

    --reversion
    if not player.buff(arenaPrep.id) and not player.buff(bgPrep.id) then 
        if select(2,IsInInstance()) == "none" and not player.combat then return end
        if reversion:Castable(LowestUnit) and not LowestUnit.buff(reversion.id, player) and LowestUnit.buff(echo.id, player) and not LowestUnit.buffFrom(healImmunity) and not LowestUnit.debuffFrom(healImmunity) then
            if reversion:Cast(LowestUnit) then
                awful.alert({
                message = "Putting hots up on lowest HP friend",
                    texture = reversion.id,
                    duration = 1,
                })
            end
        end
        if player.buffStacks(temporalCompression.id) <= 3 then 
            if reversion:Castable(party1) and not party1.buff(reversion.id, player) and party1.buff(echo.id, player) and not party1.buffFrom(healImmunity) and not party1.debuffFrom(healImmunity) then
                reversion:Cast(party1) 
            end
            if reversion:Castable(party2) and not party2.buff(reversion.id, player) and party2.buff(echo.id, player) and not party2.buffFrom(healImmunity) and not party2.debuffFrom(healImmunity) then
                reversion:Cast(party2) 
            end
            if reversion:Castable(party3) and not party3.buff(reversion.id, player) and party3.buff(echo.id, player) and not party3.buffFrom(healImmunity) and not party3.debuffFrom(healImmunity) then
                reversion:Cast(party3) 
            end
            if reversion:Castable(party4) and not party4.buff(reversion.id, player) and party4.buff(echo.id, player) and not party4.buffFrom(healImmunity) and not party4.debuffFrom(healImmunity) then
                reversion:Cast(party4) 
            end
        end
    end

    --disintegrate execute
    if TargetCheck(LowestUnitEnemy) and tipTheScales.cd >= 2 and LowestUnitEnemy.hp <= 20 then
        if disintegrate:Castable(LowestUnitEnemy) and LowestUnitEnemy.player and not LowestUnitEnemy.bcc and (player.moving and player.buff(hover.id) or not player.moving) then
            player.face(LowestUnitEnemy)
            if disintegrate:Cast(LowestUnitEnemy) then
                awful.alert({
                    message = "Enemy below 20% HP EXECUTE",
                    texture = disintegrate.id,
                    duration = 1,
                })
            end
        end
    end

    --unravel removeShields
    if unravel.cd == 0 and player.hasTalent(unravel.id) then
        if LowestUnitEnemy.absorbs >= 50000 and LowestUnitEnemy.distance <= 25 and LowestUnitEnemy.los then
            LowestUnitEnemy.setTarget()
            if target.isUnit(LowestUnitEnemy) and not player.bcc and not player.cc and not player.silence then
                if unravel:Cast(LowestUnitEnemy) then
                    awful.alert({
                    message = "Remove lowest HP enemy absorb shield",
                        texture = unravel.id,
                        duration = 1,
                    })
                end
            end
        end
    end

    --sleepWalk
    if LowestUnit.hp >= 70 then
        if TargetCheck(enemyHealer) and enemyHealer.distance <= 25 then 
            if sleepWalk:Castable(enemyHealer) and enemyHealer.disorientDR >= 0.5 and totalenemyHealer == 0 and not enemyHealer.bcc and not enemyHealer.cc or totalenemyHealer == 0 and enemyHealer.disorientDR >= 0.2 and (enemyHealer.cc and enemyHealer.ccRemains <= sleepWalk.castTime or enemyHealer.bcc and enemyHealer.bccRemains <= sleepWalk.castTime) then
                if not enemyHealer.debuffFrom(enemySleepImmune) and not enemyHealer.buffFrom(enemySleepImmune) and (player.moving and player.buff(hover.id) or not player.moving) then
                    if oppressingRoar.cd == 0 and enemyHealer.los then
                        player.face(enemyHealer)
                        oppressingRoar:Cast() 
                    end
                    if player.hasTalent(oppressingRoar.id) and oppressingRoar.cd >= 2 or not player.hasTalent(oppressingRoar.id) then
                        if sleepWalk:Cast(enemyHealer) then
                            awful.alert({
                            message = "CC enemyHealer",
                                texture = sleepWalk.id,
                                duration = 1,
                            })
                        end
                    end
                end
            end
        end
    end

    --landSlide
    if enemyHealer.distance <= 40 and enemyHealer.distance >= 15 and enemyHealer.los then
        local x, y, z = enemyHealer.predictPosition(0.5)
        if landSlide:AoECast(x,y,z) then
            awful.alert({
            message = "Rooting enemyHealer",
                texture = landSlide.id,
                duration = 1,
            })
        end
    end

    --stasis 
    if (stasis.cd == 0 or player.buff(stasisBuff.id)) and LowestUnit.hp <= 70 and (not LowestUnit.buff(355941) or player.buffRemains(stasisBuff.id) <= 15 or LowestUnit.hp <= 30) then --dreamBreath hot 
        if player.buff(stasisBuff.id) and not player.cc and not player.bcc and not player.silence and not player.casting and not player.channeling and LowestUnit.los and not LowestUnit.buffFrom(healImmunity) and not LowestUnit.debuffFrom(healImmunity) then
            player.face(LowestUnit)
            awful.call("RunMacroText", "/cancelaura Stasis")
            awful.alert({
            message = "Released",
                texture = stasis.id,
                duration = 1,
            })
        elseif player.manaPct >= 10 then
            if stasis:Cast() then
                awful.alert({
                message = "Casted",
                    texture = stasis.id,
                    duration = 1,
                })
            end
        end
    end

    --dreamProjection 
    if LowestUnit.hp <= 80 and totalLowest >= 1 and not player.moving and dreamProjection:Castable() and not LowestUnit.isUnit(player) and not SecondLowestUnit.debuff(342938) and not player.debuff(342938) and not LowestUnit.debuff(342938) and LowestUnit.distance <= 20 and not LowestUnit.buffFrom(healImmunity) and not LowestUnit.debuffFrom(healImmunity) then
        player.face(LowestUnit)
        if dreamProjection:Cast() then
            awful.alert({
                message = "Using on lowest HP friend",
                texture = dreamProjection.id,
                duration = 1,
            })
            C_Timer.After(dreamProjection.castTime + 0.4, function()
                awful.call("RunMacroText", "/cancelaura Dream Projection")
            end)
        end
    end

    --fireBreath
    if fireBreathRank4.cd == 0 and LowestUnit.hp >= 70 and TargetCheck(LowestUnitEnemy) and not player.buff(tipTheScales.id) and player.buffStacks(temporalCompression.id) >= 4 and player.buffRemains(temporalCompression.id) >= 2 and not player.moving then
        if fireBreath:Castable() and LowestUnitEnemy.distance <= 25 and LowestUnitEnemy.los and not LowestUnitEnemy.bcc and LowestUnitEnemy.player then
            if fireBreath:Cast() then
                awful.alert({
                message = "Friends above 70% HP, I am doing damage",
                    texture = fireBreath.id,
                    duration = 1,
                })
            end
        end
    end

    --livingFlame friend
    if LowestUnit.hp <= 70 and not player.buff(leapingFlames.id) and LowestUnit.player and (player.moving and player.buff(hover.id) or not player.moving) and not LowestUnit.buffFrom(healImmunity) and not LowestUnit.debuffFrom(healImmunity) then
        if dreamBreath.cd >= 2 or LowestUnit.hp <= 50 then
            if livingFlame:Castable(LowestUnit) then
                if livingFlame:Cast(LowestUnit) then
                    awful.alert({
                    message = "Heal filler on friend below 70% HP",
                        texture = livingFlame.id,
                        duration = 1,
                    })
                end
            end
        end
    end

    --livingFlame enemy
    if LowestUnit.hp >= 70 and (player.moving and player.buff(hover.id) or not player.moving) and not WasCasting[sleepWalk.id] and not LowestUnitEnemy.bcc then
        if livingFlame:Castable(LowestUnitEnemy) and LowestUnitEnemy.enemy and LowestUnitEnemy.player then
            if not LowestUnitEnemy.playerFacing45 then
                player.face(LowestUnitEnemy)
            end
            if livingFlame:Cast(LowestUnitEnemy) then
                awful.alert({
                message = "Friends above 70% HP damage filler",
                    texture = livingFlame.id,
                    duration = 1,
                })
            end
        end
    end

    stomp()
end)

C_Timer.After(0.5, function()
    awful.enabled = true
    awful.print("Enabled Preservation Rotation")
end)