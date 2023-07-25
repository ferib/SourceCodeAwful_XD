--#region setup
local Unlocker, awful, project = ...
awful.DevMode = true
if WOW_PROJECT_ID == 11 then return end
if awful.player.spec == "Demonology" then awful.print(awful.player.spec) end
if awful.player.spec ~= "Demonology" and awful.player.spec ~= "恶魔学识" then return end
local player, target, focus, healer, enemyHealer = awful.player, awful.target, awful.focus, awful.healer, awful.enemyHealer
local arena1, arena2, arena3 = awful.arena1, awful.arena2, awful.arena3
local party1, party2, party3, party4 = awful.party1, awful.party2, awful.party3, awful.party4
project.warlock = {}
project.warlock.demonology = awful.Actor:New({ spec = 2, class = "warlock" })
local demonology = project.warlock.demonology
demonology.ACTOR_TICKRATE = 0.02
local NewSpell = awful.NewSpell
local healthstone = awful.Item(5512)
local dpsTrinketEpic = awful.Item(205708)
local dpsTrinketBlue = awful.Item(205778)
local SpellStopCasting = awful.unlock("SpellStopCasting")
local Draw = awful.Draw
local AwfulFont = awful.createFont(12, "OUTLINE")
local time = awful.time
local trinketNameBlue = GetItemInfo(205779)
local trinketNameEpic = GetItemInfo(205711)

--#region Lists
local totalimmunity = {
    33786, -- Cyclone
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
}
local enemyReflect = {
    23920, --spell reflect
}
local enemyFearImmune = {
    227847, --bladestorm
    18499, --Berserker rage
    384100, --Berserker shout
    48707, --AMS
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
}
--#endregion

--#region Spellbook
awful.Populate({
    --## DMG ##--
    chaosBolt = NewSpell(116858, { damage = "magic", targeted = true, ignoreMoving = false }),
    soulFire = NewSpell(6353, { damage = "magic", targeted = true, ignoreMoving = false }),
    incinerate = NewSpell(29722, { damage = "magic", targeted = true, ignoreMoving = true }),
    immolate = NewSpell(348, { damage = "magic", targeted = true, ignoreMoving = false }),
    immolateDot = NewSpell(157736, { damage = "magic", targeted = true }),
    conflagrate = NewSpell(17962, { damage = "magic", targeted = true, ignoreMoving = false }),
    shadowBurn = NewSpell(17877, { damage = "magic", targeted = true, ignoreMoving = false }),
    dimensionalRift = NewSpell(387976, { damage = "magic", targeted = true, ignoreMoving = false }),
    bondOfFel = NewSpell(353753, { damage = "magic", diameter = 12, offsetMin = 0, offsetMax = 5.5, ignoreFacing = true }),
    doom = NewSpell(603, { damage = "magic", targeted = true, ignoreMoving = true, ignoreFacing = true }),
    dreadStalkers = NewSpell(104316, { damage = "magic", targeted = true, ignoreMoving = true, ignoreFacing = true }),
    summonDemonicTyrant = NewSpell(265187, { damage = "magic", targeted = false, ignoreMoving = false }),
    demonicStrength = NewSpell(267171, { damage = "magic", targeted = true, ignoreMoving = true }),
    handOfGuldan = NewSpell(105174, { damage = "magic", targeted = true, ignoreMoving = false }),
    demonBolt = NewSpell(264178, { damage = "magic", targeted = true, ignoreMoving = true }),
    shadowBolt = NewSpell(686, { damage = "magic", targeted = true, ignoreMoving = false }),
    soulStrike = NewSpell(264057, { damage = "magic", targeted = true, ignoreMoving = true, ignoreFacing = true }),
    grimorieFelguard = NewSpell(111898, { damage = "magic", targeted = true, ignoreMoving = true }),
    felObelisk = NewSpell(353601, { damage = "magic", targeted = true, ignoreMoving = false }),
    netherPortal = NewSpell(267217, { damage = "magic", targeted = false, ignoreMoving = false }),
    felStorm = NewSpell(89751, { damage = "magic", targeted = false, ignoreMoving = true }),
    summonVileFiend = NewSpell(264119, { damage = "magic", targeted = false, ignoreMoving = false }),
    callObserver = NewSpell(201996, { damage = "magic", targeted = false, ignoreMoving = true }),
    shadowRift = NewSpell(353294, { damage = "magic", diameter = 12, offsetMin = 0, offsetMax = 5.5, ignoreFacing = true }),
    shadowFury = NewSpell(30283, { damage = "magic", diameter = 12, offsetMin = 0, offsetMax = 5.5, ignoreFacing = true }),
    callFelLord = NewSpell(212459, { damage = "magic", targeted = false, ignoreMoving = true }),

    --## RACIALS ##--
    quakingPalm = NewSpell(107079, { effect = "physical", cc = "incapacitate", targeted = true, ignoreMoving = true, }),
    bloodFury = NewSpell(33702, { beneficial = true }),
    warStomp = NewSpell(1234, { effect = "physical", cc = "stun", ignoreFacing = true }),
    berserking = NewSpell(26297, { beneficial = true }),
    rocketBarrage = NewSpell(69041, { damage = "magic", targeted = true, ignoreMoving = true,}),
    rocketJump = NewSpell(69070, { beneficial = true }),
    bullRush = NewSpell(255654, { effect = "physical", cc = "stun", targeted = true, ignoreMoving = true, }),
    ancestralCall = NewSpell(274738, { beneficial = true }),
    bagofTricksDirectDmg = NewSpell(312411, { damage = "magic", targeted = true, ignoreMoving = true, }),
    fireblood = NewSpell(265221, { beneficial = true }),
    stoneform = NewSpell(20594, { beneficial = true }),
    haymaker = NewSpell(287712, { damage = "physical", effect = "physical", cc = "stun", targeted = true, ignoreMoving = true, }),
    bagofTricksDirectHeal = NewSpell(312411, { heal = true, ignoreFacing = true, ignoreMoving = true, targeted = true }),
    giftoftheNaaru = NewSpell(59547, { heal = true, ignoreMoving = true }),
    regeneratin = NewSpell(291944, { heal = true }),
    willToSurvive = NewSpell(59752, { beneficial = true, ignoreControl = true }),

    --## AOE ##--
    summonInfernal = NewSpell(1122, { damage = "magic", targeted = true, ignoreMoving = true}),
    guillotine = NewSpell(386833, { damage = "magic", diameter = 12, offsetMin = 0, offsetMax = 5.5, ignoreFacing = true, ignoreMoving = true }),

    --## INTERRUPTS ##--
    callFelHunter = NewSpell(212619, { effect = "magic", targeted = true, ignoreGCD = true, ignoreFacing = true, ignoreMoving = true}),

    --## DISPELLS ##--
    singeMagic2PureCommandDemonAbility = NewSpell(119898, { beneficial = true, targeted = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = false, ignoreControl = true }),
    singeMagicModifiedCommandDemonAbility = NewSpell(132411, { beneficial = true, targeted = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = false, ignoreControl = true }),
    
    singeMagicPetAbility = NewSpell(89808, { beneficial = true, targeted = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = false, ignoreControl = true }),
    singeMagicPet2ModifiedCommandDemonAbility = NewSpell(119905, { beneficial = true, targeted = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = false, ignoreControl = true }),

    --## CC ##--
    fear = NewSpell(5782, { effect = "magic", cc = "incapacitate", targeted = true, ignoreFacing = true, ignoreMoving = false }),
    mortalCoil = NewSpell(6789, { effect = "magic", cc = "incapacitate", targeted = true, ignoreMoving = true, ignoreFacing = false}),
    axeToss = NewSpell(119914, { damage = "magic", targeted = true, ignoreMoving = true, ignoreFacing = true }),
    banish = NewSpell(710, { effect = "magic", cc = "banish", targeted = true, ignoreFacing = true, ignoreMoving = false }),

    --## PETS ##--
    summonFelhunter = NewSpell(691, { beneficial = true, targeted = false, ignoreFacing = true, ignoreMoving = false }),
    summonVoidwalker = NewSpell(697, { beneficial = true, targeted = false, ignoreFacing = true, ignoreMoving = false }),
    summonFelguard = NewSpell(30146, { beneficial = true, targeted = false, ignoreFacing = true, ignoreMoving = false }),

    --## BUFFS ##--
    amplifyCurse = NewSpell(328774, { beneficial = true, targeted = false, ignoreFacing = true }),
    felDomination = NewSpell(333889, { beneficial = true, targeted = false, ignoreFacing = true }),
    grimoireOfSacrifice = NewSpell(108503, { beneficial = true, targeted = false, ignoreFacing = true }),
    grimoireOfSacrificeBuff = NewSpell(196099, { beneficial = true, targeted = false, ignoreFacing = true }),
    soulBurn = NewSpell(385899, { beneficial = true, targeted = false, ignoreFacing = true }),
    soulBurnBuff = NewSpell(387626, { beneficial = true, targeted = false, ignoreFacing = true }),
    backLash = NewSpell(387385, { damage = "magic" }),
    backDraftBuff = NewSpell(117828, { damage = "magic" }),
    madnessOfTheAzj = NewSpell(387409, { damage = "magic" }),
    ritualOfRuinProc = NewSpell(387157, { damage = "magic" }),
    demonicCore = NewSpell(264173, { damage = "magic" }),
    powerSiphon = NewSpell(264130, { damage = "magic" }),

    --## DEBUFFS ##--
    curseOfWeakness = NewSpell(702, { targeted = true, ignoreMoving = true }),
    curseOfTongues = NewSpell(1714, { targeted = true, ignoreMoving = true }),
    curseOfExhaustion = NewSpell(334275, { targeted = true, ignoreMoving = true }),
    baneOfHavoc = NewSpell(200548, { targeted = true, ignoreMoving = true }),
    havocDot = NewSpell(80240, { targeted = true, ignoreMoving = true }),
    eradication = NewSpell(196414, { targeted = true, ignoreMoving = true }),
    
    --## DEFENSIVE/UTILITY ##--
    darkPact = NewSpell(108416, { beneficial = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = true, ignoreControl = true  }),
    unendingResolve = NewSpell(104773, { beneficial = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = true, ignoreControl = true  }),
    netherWard = NewSpell(212295, { beneficial = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = true }),
    soulWell = NewSpell(29893, { ignoreMoving = false, ignoreFacing = true }),
    castingCircle = NewSpell(221703, { beneficial = true, ignoreMoving = false, ignoreFacing = true }),
    demonicCircleTeleport = NewSpell(48020, { beneficial = true, ignoreMoving = false, ignoreFacing = true }),
    healthFunnel = NewSpell(755, { beneficial = true, ignoreMoving = false, ignoreFacing = false }),
    soulRip = NewSpell(410598, { beneficial = true, ignoreMoving = true, ignoreControl = true }),
}, demonology, getfenv(1))
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
                if target.buffFrom(enemyReflect) and player.castID ~= summonDemonicTyrant.id and player.castID ~= summonVileFiend.id or awful.pet.hp >= 90 and player.channelID == healthFunnel.id or player.castID == demonBolt.id and player.casting then --stop casting on target if reflect
                    SpellStopCasting()
                end
                if curseOfWeakness:Castable(enemy) and enemy.buffFrom(enemyReflect) and not player.buff(amplifyCurse.id) then -- remove reflect
                    curseOfWeakness:Cast(enemy)
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
function EndOfCastFace()
    if target.enemy then
        if player.casting then
            if not target.playerFacing45 then
                if player.castPct > 85 then
                    player.face(target)
                end
            end
        end
    end
end
function stomp()
    awful.totems.stomp(function(totem, uptime)
        if project.settings.stompsHigh[totem.id] then
            if uptime < project.settings.stompDelay then return end
            if player.buff(demonicCore.id) and demonBolt:Castable(totem) then
                demonBolt:Cast(totem)
            end
        end

        if project.settings.stomps[totem.id] then
            if uptime < project.settings.stompDelay then return end
            if player.buff(demonicCore.id) and demonBolt:Castable(totem) then
                demonBolt:Cast(totem)
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
    zoneName = GetZoneText()
    print(zoneName)

    local x, y, z = player.position()
    print(x, y, z)
end

local function CCTrinket()
    if select(2,GetItemCooldown(205779)) <= 0 or select(2,GetItemCooldown(205711)) <= 0 then
        UseItemByName(trinketNameBlue)
        UseItemByName(trinketNameEpic)
    end
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
                duration = 3,
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

demonology:Init(function()
    if player.mounted then return end
    if player.dead then return end
    EndOfCastFace()
    WasCastingCheck()
    stomp()

    if project.settings.onlyTargetEnemyPlayers and (select(2,IsInInstance()) == "arena" or select(2,IsInInstance()) == "pvp") then
        if not target.enemy or not target.player then
           awful.call("ClearTarget")
        end
    end

    --CCtrinket
    if project.settings.autoCCRacial or project.settings.autoCCTrinket then
        if (player.cc or player.bcc) and player.ccRemains >= 3 and player.combat then
            C_Timer.After(0.5, function()
                CCTrinket()
                willToSurvive:Cast()
            end)
        end
    end

    --MORTAL COIL enemy fast
    if project.settings.autoAutoMortalCoil then
        awful.enemies.loop(function(enemy)
            if not enemy.dead and TargetCheck(enemy) then
                if enemy.player and not enemy.cc then
                    if enemy.speed > 25 then
                        if mortalCoil:Castable(enemy) and not enemy.buffFrom(enemyReflect) then
                            mortalCoil:Cast(enemy)
                        end
                    else
                        for _, id in pairs(leaps) do
                            if enemy.castID == id then
                                if mortalCoil:Castable(enemy) and not enemy.buffFrom(enemyReflect) then
                                    mortalCoil:Cast(enemy)    
                                end
                                break
                            end
                        end
                    end
                end
            end
        end)
    end

    --mortalCoil Healer
    if mortalCoil.cd == 0 and mortalCoil:Castable(enemyHealer) and enemyHealer.exists and not enemyHealer.mounted and enemyHealer.distance <= 20 then
        if project.settings.autoAutoMortalCoil and enemyHealer.incapDR >= 1 and enemyHealer.los and not enemyHealer.silence and not enemyhealer.cc then
            mortalCoil:Cast(enemyHealer)
            if project.settings.allText then
                awful.alert({
                    message = "Mortal Coil used on Healer: "..enemyHealer.name,
                    texture = mortalCoil.id,
                    duration = 3,
                })
            end
        end
    end

    --DISPELL HEALER
    if healer.debuffFrom(project.settings.dispelsList) then  
        local debuff = healer.debuffFrom(project.settings.dispelsList)[1]
        if healer.debuffUptime(debuff) < project.settings.dispelDelay then return end

        if project.settings.allText then
            awful.alert({
                message = healer.name.. " HEALER LONG CC",
                texture = singeMagicPetAbility.id,
                duration = 3,
            })
        end

        singeMagic2PureCommandDemonAbility:Cast(healer)
        singeMagicPetAbility:Cast(healer)

        singeMagicModifiedCommandDemonAbility:Cast(healer)
        singeMagicPet2ModifiedCommandDemonAbility:Cast(healer)
    end

    --Reflect
    if netherWard.cd == 0 then
        awful.enemies.loop(function(enemy)
            if TargetCheck(enemy) then
                if netherWard:Castable() and netherWard.cd == 0 and player.hasTalent(netherWard.id) then
                    if castCheck(project.settings.reflects, enemy.castID) or player.hp <= 30 then
                        if enemy.castTarget.isUnit(player) and enemy.castRemains <= 0.3 then
                            netherWard:Cast()
                            if project.settings.allText then
                                awful.alert({
                                    message = "Reflecting : "..enemy.name,
                                    texture = netherWard.id,
                                    duration = 3,
                                })
                            end
                        end
                    end
                end
            end
        end)
    end

    --Banish Pets
    if player.hasTalent(banish.id) then
        if banish.cd == 0 and not WasCasting[banish.id] then
            local banishActive = false
            awful.pets.loop(function(pet)
                if pet.debuff(banish.id) then
                    banishActive = true
                end
            end)
            awful.tyrants.loop(function(tyrants)
                if tyrants.debuff(banish.id) then
                    banishActive = true
                end
            end)

            if not banishActive then
                awful.tyrants.loop(function(tyrant)
                    if castCheck(project.settings.banishes, tyrant.id) and tyrant.enemy and (tyrant.incapDR >= 0.5 or tyrant.incapDR >= 0.25 and tyrant.bccRemains <= banish.castTime) then
                        if banish:Castable(tyrant) then
                            banish:Cast(tyrant)   
                        end
                    end
                end)
            end

            if not banishActive then
                awful.pets.loop(function(pet)
                    if castCheck(project.settings.banishes, pet.id) and pet.enemy and (pet.incapDR >= 0.5 or pet.incapDR >= 0.25 and pet.bccRemains <= banish.castTime) then
                        if banish:Castable(pet) then
                            banish:Cast(pet)   
                        end
                    end
                end)
            end
        end
    end

    --Fear Tyrant
    if not WasCasting[fear.id] then
        local isFearActive = false
        awful.tyrants.loop(function(tyrant)
            if tyrant.debuff(fear.id, player) then
                isFearActive = true
            end
        end)

        if not isFearActive then
            awful.tyrants.loop(function(tyrant)
                if tyrant.id == 135002 and tyrant.enemy and (tyrant.disorientDR >= 0.5 or tyrant.disorientDR >= 0.25 and tyrant.bccRemains <= fear.castTime) and not tyrant.bcc then
                    if fear:Castable(tyrant) then
                        fear:Cast(tyrant)   
                    end
                end
            end)
        end
    end

    --SOUL WELL
    if project.settings.autoSoulWell and (select(2,IsInInstance()) == "arena" or select(2,IsInInstance()) == "pvp") then
        if not player.combat then
            if not player.moving then
                if healthstone.count == 0 then 
                    soulWell:Cast()
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
                end
            end
        end
    end

    --Summon pet
    if project.settings.autoPet then
        if not WasCasting[summonFelguard.id] then
            if not WasCasting[112870] then --112870 wrathguard glyph
                if awful.pet.dead or awful.pet.exists == false or awful.pet.id ~= 17252 and awful.pet.id ~= 58965 then --58965 wrathguard glyph
                    if not player.moving then
                        if player.combat then
                            felDomination:Cast()
                            if player.buff(felDomination.id) then
                                summonFelguard:Cast()
                            end
                        end
                        if not player.combat then
                            C_Timer.After(1, function()
                                summonFelguard:Cast()
                            end)                         
                        end
                    end
                end
            end
        end
    end

    --DEFENSIVES
    if player.combat and not player.buff(32727) then
        if player.hp >= project.settings.defensivesDarkPact and player.hp <= 97 and darkPact.cd == 0 and player.combat then
            darkPact:Cast()
        end
        if player.hp <= project.settings.defensivesHealthstone and healthstone.cd == 0 then
            soulBurn:Cast()
            if player.buff(soulBurnBuff.id) then
                healthstone:Use()
            end
        end
        if player.hp <= project.settings.defensivesunendingResolve and unendingResolve.cd == 0 then
            unendingResolve:Cast()
        end
        if project.settings.autoAutoMortalCoil and mortalCoil:Castable(target) and player.hp <= 20 and mortalCoil.cd == 0 then
            mortalCoil:Cast(target)
        end
        if project.settings.autoTeleportButton and demonicCircleTeleport:Castable() and not player.buff(darkPact.id) and not player.buff(unendingResolve.id) then
            local total, melee, ranged, cooldowns = player.v2attackers()
            if total >= 1 and cooldowns >= 1 and project.settings.defensivesDemonicCircleTeleportDPSCDS or player.hp <= project.settings.defensivesDemonicCircleTeleportSlider then
                awful.objects.within(40).loop(function(object)
                    if object.creator.player and object.id == 191083 and object.distanceliteral >= project.settings.defensivesDemonicCircleTeleportSliderRange and demonicCircleTeleport.cd == 0 then
                        soulBurn:Cast()
                        if player.buff(soulBurnBuff.id) then
                            demonicCircleTeleport:Cast()
                        end
                    end
                end)
            end
        end
    end

    --change current target on immunity
    if project.settings.autoTargetToggle then
        if target.enemy then
            if not TargetCheck(target) and player.castID ~= summonDemonicTyrant.id and player.castID ~= summonVileFiend.id then
                SpellStopCasting()
                awful.enemies.loop(function(enemy) 
                    if not enemy.buffFrom(totalimmunity) and not enemy.debuffFrom(totalimmunity) and not enemy.bcc and enemy.los and enemy.player then
                        enemy.setTarget()
                    end
                end)
            end
        end
    end

    --TARGET ROTATION
    if TargetCheck(target) then

        if project.settings.autoFocusToggle and project.settings.allText and not project.settings.petAttackSpamFocus then
            awful.AutoFocus()
        end

        --pet attack spam
        if project.settings.petAttackSpam and awful.time - time > 1 and not target.bcc and not target.debuff(81261) then --solarbeam
            time = awful.time
            awful.call("PetAttack", "target")
        end

        --pet attack spam focus
        if project.settings.petAttackSpamFocus and enemyHealer.exists and not enemyHealer.bcc and awful.time - time > 1 and not enemyHealer.debuff(81261) then --solarbeam
            time = awful.time
            awful.AutoFocus()
            awful.call("PetAttack", "focus")
        end

        --summonDemonicTyrant
        if project.settings.autoSummonTyrant and summonDemonicTyrant.count >= 15 then
            if project.settings.tpTyrant then
                demonicCircleTeleport:Cast()
            end
            summonDemonicTyrant:Cast() 
        end

        --trinkets and racials
        if target.los and target.distance < 40 then
            if player.combat and project.settings.autoRacial then
                berserking:Cast()
                bloodFury:Cast()
            end
            if player.combat and project.settings.autoTrinket then
                dpsTrinketEpic:Use()
                dpsTrinketBlue:Use()
            end
        end

        --heal pet
        if awful.pet.hp < project.settings.defensivesHealPetSlider and player.hp > 70 then
            soulBurn:Cast()
            if player.buff(soulBurnBuff.id) then
                healthFunnel:Cast(awful.pet)
            end
        end

        --felObelisk
        if player.hasTalent(felObelisk.id) then
            if project.settings.autoSummonObelisk and summonDemonicTyrant.cd > 10 then
                felObelisk:AoECast(player) 
            end
        end

        --DREADSTALKERS proc
        if dreadStalkers:Castable(target) and player.buff(205146) then --Demonic Calling
            dreadStalkers:Cast(target)
        end
                         
        --curse with amplify
        if target.distance < 40 and target.los then
            awful.enemies.loop(function(enemy)
                if TargetCheck(enemy) and enemy.los then
                    if not enemy.buffFrom(totalimmunity) and not enemy.debuffFrom(totalimmunity) and not enemy.debuffFrom(enemyReflect) then
                        amplifyCurse:Cast()
                        if curseOfTongues:Castable(enemy) and player.buff(amplifyCurse.id) and (enemy.class == "Warlock" and project.settings.amplifiedCurseOfTonguesOnWarlocks or enemy.isUnit(enemyHealer) and project.settings.amplifiedCurseOfTonguesOnHealers) then
                            curseOfTongues:Cast(enemy)
                        elseif curseOfWeakness:Castable(enemy) and player.buff(amplifyCurse.id) and project.settings.amplifiedCurseOfWeaknessOnDPS and not enemy.isUnit(enemyHealer) then
                            curseOfWeakness:Cast(enemy)
                        end
                    end
                end
            end)
        end

        --DOOM SPREAD and MAINTAIN
        if not WasCasting[doom.id] and project.settings.autoDoom then
            awful.enemies.loop(function(enemy)
                if TargetCheck(enemy) then
                    if doom:Castable(enemy) then
                        if not enemy.debuff(doom.id, player) then
                            doom:Cast(enemy)
                        end
                    end
                end
            end)
        end

        --powerSiphon
        if powerSiphon.cd == 0 and powerSiphon:Castable() and player.buffStacks(demonicCore.id) <= 2 then
            powerSiphon:Cast()
        end

        --DEMONBOLT
        if demonBolt:Castable(target) then
            if player.buff(demonicCore.id) and player.shards <= 3 or player.buffStacks(demonicCore.id) >= 3 then
                demonBolt:Cast(target)
            end
        end

        --guillotine
        if player.hasTalent(guillotine.id) then
            if project.settings.autoGuillotine and target.speed <= 10 then
                if guillotine:Castable(target) and awful.pet.distanceTo(target) < 20 and awful.pet.losOf(target) and not awful.pet.cc and not awful.pet.dead and not awful.pet.rooted then
                    guillotine:SmartAoE(target, { movePredTime = 0.2 })
                end
            end
        end

        --netherPortal
        if player.hasTalent(netherPortal.id) then
            if netherPortal:Castable() and target.distance <= 40 and target.los then 
                netherPortal:Cast()
            end
        end

        --grimorieFelguard
        if project.settings.autoGrimoireFelGuard then
            awful.enemies.loop(function(enemy)
                if grimorieFelguard:Castable(enemy) and player.shards >= 1 and enemy.stunDR >= 1 and not enemy.cc then
                    grimorieFelguard:Cast(enemy)
                end
            end)
        end

        --shadowRift
        if player.hasTalent(shadowRift.id) and project.settings.autoShadowRift then
            local total, melee, ranged, cooldowns = player.v2attackers()
            if shadowRift:Castable(player) and melee >= 1 and not player.moving then
                shadowRift:AoECast(player) 
            end 
        end

        --callFelLord
        if player.hasTalent(callFelLord.id) and project.settings.autoFelLord then
            awful.enemies.loop(function(enemy)
                local total, melee, ranged, cooldowns = player.v2attackers()
                if callFelLord:Castable(player) and not player.moving and enemy.distance <= 5 and enemy.los and total >= 1 then
                    callFelLord:AoECast(player) 
                end 
            end)
        end

        --callObserver
        if player.hasTalent(callObserver.id) then
            if project.settings.autoCallObserver then
                if callObserver:Castable() and target.distance <= 20 and target.los then 
                    callObserver:Cast()
                end
            end
        end

        --bondOfFel cancel
        if player.casting and player.castID == bondOfFel.id then
            if target.speed > 10 then
                SpellStopCasting()
            end
        end

        --bondOfFel
        if player.hasTalent(bondOfFel.id) then
            if bondOfFel:Castable(target) and target.speed <= 10 and target.player then
                bondOfFel:SmartAoE(target, { movePredTime = 0.5 })
            end
        end

        --soulRip
        if player.hasTalent(soulRip.id) and project.settings.autoSoulRip then
            awful.enemies.loop(function(enemy) 
                if soulRip:Castable() and enemy.distance <= 20 and player.shards >= 1 and enemy.los then 
                    soulRip:Cast()
                end
            end)
        end

        --DREADSTALKERS 2 SHARDS
        if dreadStalkers:Castable(target) and player.shards >= 2 and not player.moving then
            dreadStalkers:Cast(target)
        end

        --summonVileFiend
        if player.shards >= 1 and target.distance < 40 then
            summonVileFiend:Cast()
        end

        --demonicStrength
        if player.hasTalent(demonicStrength.id) then
            if demonicStrength:Castable(target) and awful.pet.distanceTo(target) < 30 and awful.pet.losOf(target) and not awful.pet.cc and not awful.pet.dead and not awful.pet.rooted then
                demonicStrength:Cast(target)
            end
        end

        --axeToss
        if project.settings.autoAxeToss then
            awful.enemies.loop(function(enemy)
                if axeToss.cd == 0 and not enemy.cc and enemy.stunDR >= 1 and awful.pet.distanceTo(enemy) < 30 then
                    if axeToss:Castable(enemy) and awful.pet.losOf(enemy) and not awful.pet.cc and not awful.pet.dead and not awful.pet.rooted then
                        axeToss:Cast(enemy)
                    end
                end
            end)
        end

        --SOULSTRIKE
        if player.hasTalent(soulStrike.id) then
            if soulStrike:Castable(target) and not awful.pet.cc and not awful.pet.dead and not awful.pet.rooted and awful.pet.distanceTo(target) < 50 and awful.pet.losOf(target) then
                if player.shards <= 4 then
                    soulStrike:Cast(target)
                end
            end
        end

        --handOfGuldan
        if handOfGuldan:Castable(target) and player.shards >= 3 then
            handOfGuldan:Cast(target)
        end

        --shadowFury
        if project.settings.autoAutoShadowFury then
            --shadowFury cancel
            if player.casting and player.castID == shadowFury.id then
                if enemyHealer.speed > 10 then
                    SpellStopCasting()
                end
            end

            --shadowFury
            if player.hasTalent(shadowFury.id) then
                if shadowFury:Castable(enemyHealer) and enemyHealer.speed <= 10 and enemyHealer.distance <= 35 and (enemyHealer.cc and enemyHealer.ccRemains <= 1 and enemyHealer.stunDR >= 0.5 or not enemyHealer.cc and enemyHealer.stunDR >= 1) then
                    shadowFury:SmartAoE(enemyHealer, { movePredTime = 0.5 })
                end
            end
        end

        --FEAR
        if not WasCasting[fear.id] and project.settings.autoFearToggle and not player.buff(unendingResolve.id) and not player.buff(377360) and (select(2,IsInInstance()) == "arena" or select(2,IsInInstance()) == "pvp") then --377360 Precognition
            local isFearActive = false

            awful.enemies.loop(function(enemy)
                if enemy.debuff(fear.id, player) then
                    isFearActive = true
                    return false -- exit the loop
                end
            end)

            awful.tyrants.loop(function(tyrants)
                if tyrants.debuff(fear.id, player) then
                    isFearActive = true
                end
            end)

            if not isFearActive then
                --FEAR DPS WHEN ALLY LOW
                awful.friends.loop(function(friend)
                    if friend.hp <= 40 then
                        awful.enemies.loop(function(enemy)
                            if TargetCheck(enemy) and not enemy.isUnit(enemyHealer) and not enemy.isUnit(target) then
                                if fear:Castable(enemy) and (enemy.disorientDR >= 0.5 or enemy.disorientDR >= 0.25 and enemy.bccRemains <= fear.castTime) and not enemy.bcc then
                                    fear:Cast(enemy)
                                end
                            end
                        end)
                    end
                end)

                --FEAR HEALER WHEN FULL DR
                if TargetCheck(enemyHealer) then
                    if fear:Castable(enemyHealer) and (enemyHealer.disorientDR >= 0.5 or enemyHealer.disorientDR >= 0.25 and enemyHealer.bccRemains <= fear.castTime) and enemyHealer.los and not enemyHealer.isUnit(target) and not enemyHealer.bcc then
                        fear:Cast(enemyHealer)
                    end
                end

                --FEAR DPS WHEN FULL DR
                awful.enemies.loop(function(enemy)
                    if TargetCheck(enemy) and not enemy.isUnit(enemyHealer) and not enemy.isUnit(target) then
                        if fear:Castable(enemy) and (enemy.disorientDR >= 0.5 or enemy.disorientDR >= 0.25 and enemy.bccRemains <= fear.castTime) and enemy.los and not enemy.isUnit(target) and not enemy.bcc then
                            fear:Cast(enemy)
                        end
                    end
                end)
            end
        end

        --curse
        if not player.lockouts.shadow then
            awful.enemies.loop(function(enemy)
                if TargetCheck(enemy) then
                    if not enemy.buffFrom(slowImmune) and not enemy.debuffFrom(slowImmune) and not enemy.debuffFrom(enemyReflect) then
                        if not enemy.debuff(curseOfTongues.id, player) and not enemy.debuff(curseOfWeakness.id, player) and not enemy.debuff(curseOfExhaustion.id, player) then
                            if not player.buff(amplifyCurse.id) then
                                if enemy.class ~= "Warlock" and not enemy.isUnit(enemyHealer) and curseOfExhaustion:Castable(enemy) and project.settings.curseOfExhaustionOnDPS then
                                    curseOfExhaustion:Cast(enemy)
                                elseif (enemy.class == "Warlock" or enemy.isUnit(enemyHealer)) and curseOfTongues:Castable(enemy) then
                                    curseOfTongues:Cast(enemy)
                                end
                            end
                        end
                    end
                end
            end)
        end

        --SHADOWBOLT
        if not player.buff(demonicCore.id) and shadowBolt:Castable(target) and player.shards <= 2 then
            shadowBolt:Cast(target)
        end
    end
end)

C_Timer.After(0.5, function()
    awful.enabled = true
    awful.print("enabled")
end)