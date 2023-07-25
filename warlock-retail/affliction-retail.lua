--#region setup
local Unlocker, awful, project = ...
awful.DevMode = true
if WOW_PROJECT_ID == 11 then return end
if awful.player.spec == "Affliction" then awful.print(awful.player.spec) end
if awful.player.spec ~= "Affliction" and awful.player.spec ~= "痛苦" then return end
local player, target, focus, healer, enemyHealer = awful.player, awful.target, awful.focus, awful.healer, awful.enemyHealer
local arena1, arena2, arena3 = awful.arena1, awful.arena2, awful.arena3
local party1, party2, party3, party4 = awful.party1, awful.party2, awful.party3, awful.party4
project.warlock = {}
project.warlock.affliction = awful.Actor:New({ spec = 1, class = "warlock" })
local affliction = project.warlock.affliction
affliction.ACTOR_TICKRATE = 0.02
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
    corruptiondot = NewSpell(146739, { damage = "magic", targeted = false, ignoreMoving = true }),
    bondOfFel = NewSpell(353753, { damage = "magic", diameter = 12, offsetMin = 0, offsetMax = 5.5, ignoreFacing = true }),
    vileTaint = NewSpell(278350, { damage = "magic", diameter = 12, offsetMin = 0, offsetMax = 5.5, ignoreFacing = true }),
    shadowBolt = NewSpell(686, { damage = "magic", targeted = true, ignoreMoving = false }),
    corruption = NewSpell(172, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = true }),
    agony = NewSpell(980, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = true }),
    unstableAffliction = NewSpell(342938, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = false }),
    summonDarkglare = NewSpell(205180, { damage = "magic", targeted = false, ignoreMoving = false }),
    phantomSingularity = NewSpell(205179, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = true }),
    soulrot = NewSpell(386997, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = false }),
    haunt = NewSpell(48181, { damage = "magic", targeted = true, ignoreFacing = false, ignoreMoving = false }),
    maleficRapture = NewSpell(324536, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = false }),
    maleficRaptureProc = NewSpell(324536, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = true }),
    drainLife = NewSpell(234153, { damage = "magic", targeted = true, ignoreFacing = false, ignoreMoving = true }),
    drainSoul = NewSpell(198590, { damage = "magic", targeted = true, ignoreFacing = false, ignoreMoving = true }),
    rapidContagion = NewSpell(344566, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = true, ignoreControl = true }),
    soulSwap = NewSpell(386951, { damage = "magic", targeted = true, ignoreFacing = false, ignoreMoving = true }),
    siphonLife = NewSpell(63106, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = true }),
    deathBolt = NewSpell(264106, { damage = "magic", targeted = true, ignoreMoving = false }),
    callObserver = NewSpell(201996, { damage = "magic", targeted = false, ignoreMoving = true }),
    shadowRift = NewSpell(353294, { damage = "magic", diameter = 12, offsetMin = 0, offsetMax = 5.5, ignoreFacing = true }),
    shadowFury = NewSpell(30283, { damage = "magic", diameter = 12, offsetMin = 0, offsetMax = 5.5, ignoreFacing = true }),

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

    --## INTERRUPTS ##--
    spellLockPet = NewSpell(19647, { effect = "magic", targeted = true, ignoreGCD = true, ignoreFacing = true, ignoreMoving = true}),
    spellLock = NewSpell(132409, { effect = "magic", targeted = true, ignoreGCD = true, ignoreFacing = true, ignoreMoving = true}),

    --## PURGES ##--
    devourMagicPet = NewSpell(19505, { targeted = true, ignoreMoving = true, ignoreFacing = true}),

    --## DISPELLS ##--
    singeMagic2PureCommandDemonAbility = NewSpell(119898, { beneficial = true, targeted = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = false, ignoreControl = true }),
    singeMagicModifiedCommandDemonAbility = NewSpell(132411, { beneficial = true, targeted = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = false, ignoreControl = true }),
    
    singeMagicPetAbility = NewSpell(89808, { beneficial = true, targeted = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = false, ignoreControl = true }),
    singeMagicPet2ModifiedCommandDemonAbility = NewSpell(119905, { beneficial = true, targeted = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = false, ignoreControl = true }),

    --## CC ##--
    fear = NewSpell(5782, { effect = "magic", cc = "disorient", targeted = true, ignoreFacing = true, ignoreMoving = false }),
    mortalCoil = NewSpell(6789, { effect = "magic", cc = "incapacitate", targeted = true, ignoreMoving = true, ignoreFacing = false}),
    banish = NewSpell(710, { effect = "magic", cc = "banish", targeted = true, ignoreFacing = true, ignoreMoving = false }),

    --## PETS ##--
    summonFelhunter = NewSpell(691, { beneficial = true, targeted = false, ignoreFacing = true, ignoreMoving = false }),
    summonVoidwalker = NewSpell(697, { beneficial = true, targeted = false, ignoreFacing = true, ignoreMoving = false }),
    summonImp = NewSpell(688, { beneficial = true, targeted = false, ignoreFacing = true, ignoreMoving = false }),

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
    nightFall = NewSpell(264571, { damage = "magic" }),
    tormentedCrescendo = NewSpell(387079, { damage = "magic" }),
    inevitableDemise = NewSpell(334320, { damage = "magic" }),

    --## DEBUFFS ##--
    curseOfWeakness = NewSpell(702, { targeted = true, ignoreMoving = true }),
    curseOfTongues = NewSpell(1714, { targeted = true, ignoreMoving = true }),
    curseOfExhaustion = NewSpell(334275, { targeted = true, ignoreMoving = true }),
    
    --## DEFENSIVE/UTILITY ##--
    darkPact = NewSpell(108416, { beneficial = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = true, ignoreControl = true }),
    unendingResolve = NewSpell(104773, { beneficial = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = true, ignoreControl = true }),
    netherWard = NewSpell(212295, { beneficial = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = true }),
    soulWell = NewSpell(29893, { ignoreMoving = false, ignoreFacing = true }),
    castingCircle = NewSpell(221703, { beneficial = true, ignoreMoving = false, ignoreFacing = true }),
    demonicCircleTeleport = NewSpell(48020, { beneficial = true, ignoreMoving = false, ignoreFacing = true }),
    healthFunnel = NewSpell(755, { beneficial = true, ignoreMoving = false, ignoreFacing = false }),
    soulRip = NewSpell(410598, { beneficial = true, ignoreMoving = true, ignoreControl = true }),
}, affliction, getfenv(1))
--#endregion

function TargetCheck(unit)
    if not unit.enemy then return false end
    if unit.dead then return false end
    if not player.canAttack(unit) then return false end  
    if unit.id == 60849 then return false end --monk statue
    if unit.id == 189617 then return false end --golem tanking dummy
    if unit.id == 194649 then return false end --tanking dummy
    if not unit.los then return false end

    if unit.buffFrom(totalimmunity) or unit.debuffFrom(totalimmunity) then return false end
    if project.settings.autoStopAttackOnCCTarget then
        if unit.bcc then return false end
    end

    if select(2,IsInInstance()) == "arena" then
        awful.enemies.loop(function(enemy)
            if enemy.player then
                if target.buffFrom(enemyReflect) and player.channelID ~= drainLife.id or awful.pet.hp >= 90 and player.channelID == healthFunnel.id then --stop casting on target if reflect
                    SpellStopCasting()
                end
                if curseOfWeakness:Castable(enemy) and enemy.buffFrom(enemyReflect) and not player.buff(amplifyCurse.id) then -- remove reflect
                    curseOfWeakness:Cast(enemy)
                end
                if drainSoul:Castable(enemy) and unit.hp > 20 and enemy.hp < 20 and not enemy.buffFrom(totalimmunity) and not enemy.debuffFrom(totalimmunity) and not enemy.bcc and enemy.los and not enemy.buffFrom(enemyReflect) and enemy.los then
                    drainSoul:Cast(enemy)
                    return true
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
        end

        if project.settings.stomps[totem.id] then
            if uptime < project.settings.stompDelay then return end           
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
local function AutoQueue()
    local queued = awful.call("GetBattlefieldTimeWaited", 1)
    awful.print(queued)
    if queued == 0 then
        awful.call("JoinBattlefield", 1)
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

affliction:Init(function()
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
            if not enemy.dead then
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

    --Interrupt or Reflect
    if (spellLock.cd == 0 or spellLockPet.cd == 0) or netherWard.cd == 0 then
        awful.enemies.loop(function(enemy)
            if TargetCheck(enemy) then
                if (spellLock:Castable(enemy) and spellLock.cd == 0 or spellLockPet:Castable(enemy) and spellLockPet.cd == 0) and castCheck(project.settings.interrupts, enemy.castID) and not enemy.casting8 and enemy.casting then
                    if enemy.castTimeComplete > project.settings.interruptDelay then
                        spellLock:Cast(enemy)
                        spellLockPet:Cast(enemy)      
                        if project.settings.allText then
                            awful.alert({
                                message = "Interrupting: "..enemy.name,
                                texture = spellLock.id,
                                duration = 3,
                            })
                        end
                    end
                end
                if (spellLock:Castable(enemyHealer) and spellLock.cd == 0 or spellLockPet:Castable(enemyHealer) and spellLockPet.cd == 0) and enemy.hp <= project.settings.interruptHealer and not enemyHealer.casting8 and enemyHealer.casting then
                    if enemyHealer.castTimeComplete > project.settings.interruptDelay then
                        spellLock:Cast(enemyHealer)
                        spellLockPet:Cast(enemyHealer)
                        if project.settings.allText then
                            awful.alert({
                                message = "Interrupting: "..enemyHealer.name,
                                texture = spellLock.id,
                                duration = 3,
                            })
                        end 
                    end
                end
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

    --PURGE
    if devourMagicPet.cd == 0 then
        awful.enemies.loop(function(enemy)  
            if TargetCheck(enemy) then
                if devourMagicPet:Castable(enemy) then
                    if enemy.distance < devourMagicPet.range then
                        if enemy.purgeCount > 0 then
                            devourMagicPet:Cast(enemy)
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

    --buff grimoireOfSacrifice
    if player.hasTalent(grimoireOfSacrifice.id) then
        if project.settings.autoGrimoireOfSacrifice then
            if player.hasTalent(grimoireOfSacrifice.id) then
                if not player.buff(grimoireOfSacrificeBuff.id) then
                    if awful.pet.exists then
                        grimoireOfSacrifice:Cast()
                    end
                end
            end 
        end
    end

    --Summon pet
    if project.settings.autoPet then
        if not WasCasting[summonFelhunter.id] and not WasCasting[summonVoidwalker.id] and not WasCasting[summonImp.id]  then
            if not player.lockouts.shadow then
                if awful.pet.dead or awful.pet.exists == false then
                    if not player.moving then
                        if player.combat then
                            if not player.hasTalent(grimoireOfSacrifice.id) then
                                felDomination:Cast()
                                if player.buff(felDomination.id) then
                                    if project.settings.summonFelhunter then
                                        summonFelhunter:Cast()
                                    end
                                    if project.settings.summonVoidwalker then
                                        summonVoidwalker:Cast()
                                    end
                                    if project.settings.summonImp then
                                        summonImp:Cast()
                                    end
                                end
                            end
                        end
                        if not player.combat and not player.buff(grimoireOfSacrificeBuff.id) then
                            if project.settings.summonFelhunter then
                                C_Timer.After(1, function()
                                    if awful.pet.exists == false then
                                        summonFelhunter:Cast()
                                    end
                                end) 
                            end
                            if project.settings.summonVoidwalker then
                                C_Timer.After(1, function()
                                    if awful.pet.exists == false then
                                        summonVoidwalker:Cast()
                                    end
                                end) 
                            end
                            if project.settings.summonImp then
                                C_Timer.After(1, function()
                                    if awful.pet.exists == false then
                                        summonImp:Cast()
                                    end
                                end) 
                            end
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
            if not TargetCheck(target) and player.channelID ~= drainLife.id then
                SpellStopCasting()
                awful.enemies.loop(function(enemy) 
                    if not enemy.buffFrom(totalimmunity) and not enemy.debuffFrom(totalimmunity) and not enemy.bcc and enemy.los and enemy.player then
                        enemy.setTarget()
                    end
                end)
            end
        end
    end

    --target ROTATION
    if TargetCheck(target) then

        if project.settings.autoFocusToggle and project.settings.allText and not project.settings.petAttackSpamFocus then
            awful.AutoFocus()
        end

        --pet attack spam
        if project.settings.petAttackSpam and awful.time - time > 1 then
            time = awful.time
            awful.call("PetAttack", "target")
        end

        --pet attack spam focus
        if project.settings.petAttackSpamFocus and enemyHealer.exists and awful.time - time > 1 then
            time = awful.time
            awful.AutoFocus()
            awful.call("PetAttack", "focus")
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

        --drain life with soulrot
        if target.debuff(soulrot.id, player) then
            soulBurn:Cast()
            awful.enemies.loop(function(enemy)
                if drainLife:Castable(enemy) and TargetCheck(enemy) and not enemy.isUnit(target) and enemy.los and player.buff(soulBurnBuff.id) and player.buffStacks(inevitableDemise.id) == 50 then
                    drainLife:Cast(enemy)
                end
            end)
        end

        --heal pet
        if awful.pet.hp < project.settings.defensivesHealPetSlider and player.hp > 70 then
            soulBurn:Cast()
            if player.buff(soulBurnBuff.id) then
                healthFunnel:Cast(awful.pet)
            end
        end

        --drain life spam defensive
        if player.hp < project.settings.defensivesDrainLifeSpam then
            soulBurn:Cast()
            if drainLife:Castable(enemy) and TargetCheck(target) and target.los and player.buff(soulBurnBuff.id) then
                drainLife:Cast(enemy)
            end
        end

        --Malefic Rapture proc
        if player.buff(tormentedCrescendo.id) then
            if target.debuff(unstableAffliction.id, player) then
                maleficRaptureProc:Cast()
            end
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

        --soulswap
        if soulSwap.cd == 0 then
            awful.enemies.loop(function(enemy)
                if soulSwap:Castable(enemy) and not enemy.debuff(unstableAffliction.id, player) and enemy.los and player.shards >= 1 and TargetCheck(enemy) then
                    awful.enemies.loop(function(enemy2)
                        if soulSwap:Castable(enemy2) and enemy2.debuff(unstableAffliction.id, player) and enemy2.debuffRemains(unstableAffliction.id, player) > 15 and soulSwap.cd == 0 and not player.buff(399680) and enemy2.distance < soulSwap.range and enemy2.los and TargetCheck(enemy2) then --399680 soulSwap buff     
                            soulSwap:Cast(enemy2)
                        end
                    end)
                end
            end)
        end

        --exhale soulswap
        if player.buff(399680) then --399680 soulswap buff
            awful.enemies.loop(function(enemy)
                if soulSwap:Castable(enemy) and not enemy.debuff(unstableAffliction.id, player) and enemy.los and player.shards >= 1 and enemy.distance < soulSwap.range and TargetCheck(enemy) then  
                    soulSwap:Cast(enemy)
                end
            end)
        end

        --Phantom Singularity
        if phantomSingularity:Castable(target) then
            if TargetCheck(target) and target.los then
                phantomSingularity:Cast(target)
            end
        end

        --callObserver
        if project.settings.autoCallObserver then
            if callObserver:Castable() and target.distance <= 20 and target.los then 
                callObserver:Cast()
            end
        end

        --shadowRift
        if player.hasTalent(shadowRift.id) and project.settings.autoShadowRift then
            local total, melee, ranged, cooldowns = player.v2attackers()
            if shadowRift:Castable(player) and melee >= 1 and not player.moving then
                shadowRift:AoECast(player) 
            end 
        end

        --Soul Rot
        if soulrot.cd == 0 then
            awful.enemies.loop(function(enemy)
                if TargetCheck(enemy) and enemy.los then
                    if soulrot:Castable(enemy) then
                        if player.buffStacks(inevitableDemise.id) == 50 or enemies.around(enemy) >= 1 then
                            if TargetCheck(enemy) then
                                soulrot:Cast(enemy)
                            end
                        end
                    end
                end
            end)
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

        --vileTaint
        if player.hasTalent(vileTaint.id) then
            if vileTaint:Castable(target) and target.speed <= 10 and player.shards >= 1 then
                vileTaint:SmartAoE(target, { movePredTime = 0.5 })
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

        --summonDarkglare
        if summonDarkglare:Castable() and target.distance < 40 and target.los and target.debuff(corruptiondot.id, player) and target.debuff(agony.id, player) and target.debuff(unstableAffliction.id, player) then
            summonDarkglare:Cast()
        end

        --rapidContagion
        if player.hasTalent(rapidContagion.id) then
            if target.debuff(unstableAffliction.id, player) and player.shards >= 3 then
                rapidContagion:Cast()
            end 
        end

        --deathbolt
        if player.hasTalent(deathBolt.id) then
            if deathBolt.cd == 0 and summonDarkglare.cd > 5 then
                if not player.moving then
                    awful.enemies.loop(function(enemy)
                        if TargetCheck(enemy) then
                            if deathBolt:Castable(enemy) then
                                if player.shards >= 3 and enemy.debuffRemains(unstableAffliction.id, player) > 10 and enemy.debuffRemains(corruptiondot.id, player) > 10 and enemy.debuffRemains(agony.id, player) > 10 then 
                                    deathBolt:Cast(enemy)
                                end
                            end
                        end
                    end)
                end
            end
        end

        --haunt
        if player.hasTalent(haunt.id) then
            if target.debuff(unstableAffliction.id, player) then
                haunt:Cast(target)
            end                      
        end

        --dots AOE
        if player.buffStacks(inevitableDemise.id) < 50 then
            awful.enemies.loop(function(enemy)
                if TargetCheck(enemy) and enemy.los then

                    if unstableAffliction:Castable(enemy) and not WasCasting[unstableAffliction.id] then
                        if not enemy.debuff(unstableAffliction.id, player) or enemy.debuffRemains(unstableAffliction.id, player) <= 5 then
                            unstableAffliction:Cast(enemy)
                        end
                    end
                    
                    if agony:Castable(enemy) then
                        if not enemy.debuff(agony.id, player) or enemy.debuffRemains(agony.id, player) <= 5 then
                            agony:Cast(enemy)
                        end
                    end

                    if corruption:Castable(enemy) then
                        if not enemy.debuff(corruptiondot.id, player) or enemy.debuffRemains(corruptiondot.id, player) <= 5 then
                            corruption:Cast(enemy)
                        end
                    end

                end
            end)
        end

        --drainlife 50 stacks current target 
        if not target.debuff(soulrot.id, player) and target.los and player.buffStacks(inevitableDemise.id) == 50 or player.buffStacks(inevitableDemise.id) == 50 then
            soulBurn:Cast()
            if drainLife:Castable(target) and player.buff(soulBurnBuff.id) and soulrot.cd >= 10 then
                drainLife:Cast(target)
            end
        end

        --maleficRapture
        if player.shards >= 1 and rapidContagion.cd > 5 then
            maleficRapture:Cast()
        end

        --Nightfall drainSoul
        if drainSoul:Castable(target) and player.buff(nightFall.id) then
            if target.debuff(corruptiondot.id, player) and target.debuff(agony.id, player) then
                if TargetCheck(target) then
                    drainSoul:Cast(target)
                end
            end
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

        --filler
        if drainSoul:Castable(target) then
            if target.debuff(corruptiondot.id, player) and target.debuff(agony.id, player) and target.debuff(unstableAffliction.id, player) and player.shards == 0 then
                if TargetCheck(target) then
                    drainSoul:Cast(target)
                end
            elseif target.debuff(corruptiondot.id, player) and target.debuff(agony.id, player) and target.debuff(unstableAffliction.id, player) then
                maleficRapture:Cast()
            end
        end
    end
end)

C_Timer.After(0.5, function()
    awful.enabled = true
    awful.print("enabled")
end)