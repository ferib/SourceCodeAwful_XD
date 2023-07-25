--#region setup
local Unlocker, awful, project = ...
awful.DevMode = true
if WOW_PROJECT_ID == 11 then return end
if awful.player.spec == "Frost" then awful.print(awful.player.spec) end
if awful.player.spec ~= "Frost" and awful.player.spec ~= "冰霜" then return end
local player, target, focus, healer, enemyHealer = awful.player, awful.target, awful.focus, awful.healer, awful.enemyHealer
local arena1, arena2, arena3 = awful.arena1, awful.arena2, awful.arena3
local party1, party2, party3, party4 = awful.party1, awful.party2, awful.party3, awful.party4
project.mage = {}
project.mage.frost = awful.Actor:New({ spec = 3, class = "mage" })
local frost = project.mage.frost
frost.ACTOR_TICKRATE = 0.02
local NewSpell = awful.NewSpell
local healthstone = awful.Item(5512)
local magefood = awful.Item(113509)
local dpsTrinketEpic = awful.Item(205708)
local dpsTrinketBlue = awful.Item(205778)
local SpellStopCasting = awful.unlock("SpellStopCasting")
local Draw = awful.Draw
local AwfulFont = awful.createFont(12, "OUTLINE")
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
local cantRootOrKnock = {
    227847, --bladestorm
    48707, --AMS
}
local unSheepable = {
    5487, --bear form
    33891, --tree form
    768,   --cat
    6940, --pala sac
    199448, --pala sac pvp
    24858, -- moonkin form
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
    flurry = NewSpell(44614, { damage = "magic", targeted = true, ignoreMoving = true }),
    iceLance = NewSpell(30455, { damage = "magic", targeted = true, ignoreMoving = true }),
    glacialSpike = NewSpell(199786, { damage = "magic", targeted = true, ignoreMoving = false }),
    frostBolt = NewSpell(116, { damage = "magic", targeted = true, ignoreMoving = false }),
    iceNova = NewSpell(157997, { damage = "magic", targeted = true, ignoreMoving = true }),
    fireBlast = NewSpell(319836, { damage = "magic", targeted = true, ignoreMoving = true }),
    frostNova = NewSpell(122, { damage = "magic", targeted = false, ignoreMoving = true }),
    blastWave = NewSpell(157981, { damage = "magic", targeted = false, ignoreMoving = true }),
    dragonsBreath = NewSpell(31661, { damage = "magic", targeted = true, ignoreMoving = true }),
    coneOfCold = NewSpell(120, { damage = "magic", targeted = true, ignoreMoving = true }),
    frostBomb = NewSpell(390612, { damage = "magic", targeted = true, ignoreMoving = false }),

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
    shadowMeld = NewSpell(58984, { beneficial = true }),
    willToSurvive = NewSpell(59752, { beneficial = true, ignoreControl = true }),

    --## AOE ##--
    blizzard = NewSpell(190356, { damage = "magic", diameter = 12, offsetMin = 0, offsetMax = 5.5, ignoreFacing = true }),
    frozenOrb = NewSpell(198149, { damage = "magic", targeted = false, ignoreMoving = true, radius = 8, ignoreFacing = true }),
    ringOfFire = NewSpell(353082, { damage = "magic", diameter = 12, offsetMin = 5, offsetMax = 5.5, ignoreFacing = true }),
    ringOfFrost = NewSpell(113724, { effect = 'magic', cc = true, diameter = 12, offsetMin = 4.5, offsetMax = 5.5, ignoreFacing = true }),

    --## INTERRUPTS ##--
    counterspell = NewSpell(2139, { effect = "magic", targeted = true, ignoreGCD = true, ignoreFacing = true, ignoreMoving = true}),

    --## PURGES ##--
    spellSteal = NewSpell(30449, { targeted = true, ignoreMoving = true, ignoreFacing = true}),

    --## CC ##--
    polymorph = NewSpell(118, { effect = "magic", cc = "incapacitate", targeted = true, ignoreFacing = true, ignoreMoving = false }),

    --## BUFFS ##--
    coldSnap = NewSpell(235219, { beneficial = true, targeted = false, ignoreFacing = true }),
    fingersOfFrost = NewSpell(44544, { damage = "magic" }),
    shiftingPower = NewSpell(382440, { beneficial = true, targeted = false, ignoreFacing = true }),
    icyVeins = NewSpell(12472, { beneficial = true, targeted = false, ignoreFacing = true }),
    freezingRain = NewSpell(270232, { damage = "magic" }),
    arcaneIntellect = NewSpell(1459, { damage = "magic" }),
    removeCurse = NewSpell(475, { damage = "magic" }),
    invis = NewSpell(66, { damage = "magic" }),

    --## DEBUFFS ##--
    slow = NewSpell(31589, { damage = "magic", targeted = true, ignoreMoving = true }),
  
    --## DEFENSIVE/UTILITY ##--
    iceBarrier = NewSpell(11426, { beneficial = true, ignoreMoving = true, ignoreFacing = true }),
    iceBlock = NewSpell(45438, { beneficial = true, ignoreMoving = true, ignoreFacing = true, ignoreControl = true }),
    mirrorImage = NewSpell(55342, { beneficial = true, ignoreMoving = true, ignoreFacing = true }),
    greaterInvisibility = NewSpell(110959, { beneficial = true, ignoreMoving = true, ignoreFacing = true }),
    conjureRefreshment = NewSpell(190336, { beneficial = true, ignoreMoving = true, ignoreFacing = true }),
    shimmer = NewSpell(212653, { beneficial = true, ignoreMoving = true, ignoreFacing = true }),
    alterTime = NewSpell(342245, { beneficial = true, ignoreMoving = true, ignoreFacing = true }),
    alterTimeBack = NewSpell(342247, { beneficial = true, ignoreMoving = true, ignoreFacing = true }),
}, frost, getfenv(1))
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
                if target.buffFrom(enemyReflect) then --stop casting on target if reflect
                    SpellStopCasting()
                end
                if enemy.buffFrom(enemyReflect) then -- remove reflect
                    if fireBlast:Castable(enemy) and fireBlast.cd == 0 then
                        fireBlast:Cast(enemy)
                    elseif iceLance:Castable(enemy) and not player.lockouts.frost and not player.buff(fingersOfFrost.id) then
                        iceLance:Cast(enemy)
                    end
                end

                if iceLance:Castable(enemy) and unit.hp > 15 and enemy.hp < 15 and not enemy.buffFrom(totalimmunity) and not enemy.debuffFrom(totalimmunity) and not enemy.bcc and enemy.los and not enemy.buffFrom(enemyReflect) then
                    iceLance:Cast(enemy)
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
                if player.castPct > 80 then
                    player.face(target)
                    --iceNova
                    if not player.hasTalent(glacialSpike.id) and player.casting and player.castID == frostBolt.id or player.hasTalent(glacialSpike.id) and player.casting and player.castID == glacialSpike.id then
                        if iceNova:Castable(target) then
                            iceNova:Cast(target)
                        elseif flurry:Castable(target) then
                            flurry:Cast(target)
                        end
                    end
                end
            end
        end
    end
end
function stomp()
    awful.totems.stomp(function(totem, uptime)
        if project.settings.stomps[totem.id] then
            if uptime < project.settings.stompDelay then return end
            if fireBlast:Castable(totem) and fireBlast.cd == 0 then
                fireBlast:Cast(totem)
            elseif iceLance:Castable(totem) and not player.lockouts.frost and not player.buff(fingersOfFrost.id) then
                iceLance:Cast(totem)
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
if project.settings.autoShadowMeld then
    awful.onEvent(function(info, event, source, dest)
        local time = GetTime()
        if event ~= "SPELL_CAST_SUCCESS" then return end
        if not source.enemy then return end

        local spellID, spellName = select(12, unpack(info))
        local events = awful.events

        if shadowMeld.cd > 0 then return end
        if spellID == 107570 and dest.isUnit(player) then
            shadowMeld:Cast(player)
            awful.alert("Meld Bolt" , 107570)    
        end

        if shadowMeld.cd > 0 then return end
        if spellID == 6789 and dest.isUnit(player) then
            shadowMeld:Cast(player)
            awful.alert("Meld Coil" , 6789)
        end

        if dragonsBreath.cd == 0 then
            if spellID == 323639 and dest.isUnit(player) then
                player.face(source)
                dragonsBreath:Cast()
                awful.alert("The Hunt" , 323639)
            end
        elseif shadowMeld.cd == 0 then
           if spellID == 323639 and dest.isUnit(player) then
                shadowMeld:Cast(player)
                awful.alert("The Hunt" , 323639)
           end 
        end
    end)
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
            if x and y and z and unit.role and unit.class2 and unit.hp then
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
        end)
    end)
end

frost:Init(function()
    if target.dead then return end
    if player.mounted then return end
    if player.dead then return end
    EndOfCastFace()
    WasCastingCheck()
    if player.buff(110960) then return end --greater invis
    if player.buff(32612) or player.buff(66)  then return end --invis
    if player.buff(167152) then return end --eating/drinking food
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

    --healer CC alert
    if healer.debuffFrom(project.settings.dispelsList) then
        if project.settings.allText then
            awful.alert({
                message = healer.name.. " HEALER LONG CC",
                texture = 1714,
                duration = 3,
            })
        end
    end

    --iceNova
    if not player.hasTalent(glacialSpike.id) and WasCasting[frostBolt.id] or WasCasting[glacialSpike.id] then
        if iceNova:Castable(target) then
            iceNova:Cast(target) 
        elseif flurry:Castable(target) then
            flurry:Cast(target)
        end
    end

    --iceBarrier
    if not player.lockouts.frost and not player.buff(iceBarrier.id) then
        iceBarrier:Cast() 
    end

    --coldSnap
    if not player.lockouts.frost and iceBlock.cd > 3 and player.hp < 60 then
        coldSnap:Cast() 
    end

    --arcaneIntellect
    if not player.buff(arcaneIntellect.id) and not player.combat and player.manaPct > 70 then
        arcaneIntellect:Cast() 
    end

    --remove tongues + healer
    if project.settings.removeCurseButton then

        if player.debuffFrom(project.settings.dispelsList) then
            local debuff = player.debuffFrom(project.settings.dispelsList)[1]
            if player.debuffUptime(debuff) < project.settings.dispelDelay then return end  
            if removeCurse:Castable(player) then
                removeCurse:Cast(player)
            end
        end

        if healer.debuffFrom(project.settings.dispelsList) then
            local debuff = healer.debuffFrom(project.settings.dispelsList)[1]
            if healer.debuffUptime(debuff) < project.settings.dispelDelay then return end
            if removeCurse:Castable(healer) then
                removeCurse:Cast(healer)
            end
        end
    end

    --Interrupt
    if counterspell.cd == 0 then
        awful.enemies.loop(function(enemy)
            if TargetCheck(enemy) then
                if counterspell:Castable(enemy) and castCheck(project.settings.interrupts, enemy.castID) and not enemy.casting8 and enemy.casting then
                    if enemy.castTimeComplete > project.settings.interruptDelay then
                        counterspell:Cast(enemy)  
                        if project.settings.allText then
                            awful.alert({
                                message = "Interrupting: "..enemy.name,
                                texture = counterspell.id,
                                duration = 3,
                            })
                        end
                    end
                end
                if counterspell:Castable(enemyHealer) and enemy.hp <= project.settings.interruptHealer and not enemyHealer.casting8 and enemyHealer.casting then
                    if enemyHealer.castTimeComplete > project.settings.interruptDelay then
                        counterspell:Cast(enemyHealer)
                        if project.settings.allText then
                            awful.alert({
                                message = "Interrupting: "..enemyHealer.name,
                                texture = counterspell.id,
                                duration = 3,
                            })
                        end 
                    end
                end
            end
        end)
    end

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

    --foodTable
    if project.settings.autoMageTable and select(2,IsInInstance()) == "arena" then
        if not player.combat then
            if not player.moving then
                if magefood.count == 0 then 
                    conjureRefreshment:Cast()
                    local magetable = awful.objects.within(5).find(function(obj) return obj.id == 233282 and obj.creator.friend end)
                    if magetable then
                        if Unlocker.type == "daemonic" then
                            Interact(magetable.pointer)
                        else
                            ObjectInteract(magetable.pointer)
                        end
                        return
                    end
                end
            end
        end
    end

    --DEFENSIVES
    if player.combat and not player.buff(342246) and not player.buff(32727) then -- 342246 alterTime, 32727 arena prep
        if player.hp <= project.settings.defensivesHealthstone and healthstone.cd == 0 then
            healthstone:Use()
        end
        if player.hp <= project.settings.defensivesIceBlock and iceBlock.cd == 0 then
            iceBlock:Cast()
        end
        if player.hp <= project.settings.defensivesGreaterInvisibility and greaterInvisibility.cd == 0 then
            greaterInvisibility:Cast()
        end
        if player.hp <= project.settings.defensivesMirrorImage and mirrorImage.cd == 0 then
            mirrorImage:Cast()
        end
    end

    --change current target on immunity
    if project.settings.autoTargetToggle then
        if target.enemy then
            if not TargetCheck(target) then
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
    if TargetCheck(target) and not player.buff(110960) and not player.buff(32612) and not player.buff(66) then --greater invis + normal invis(66+32612)
        if project.settings.autoFocusToggle and project.settings.allText then
            awful.AutoFocus()
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

        --alterTime
        if project.settings.autoAlterTime then
            --alter time on CDs
            local total, melee, ranged, cooldowns = player.v2attackers()
            if cooldowns > 0 and not player.buff(342246) and player.hp > 80 then
                alterTime:Cast()
            end

            --alter time back
            if player.hp < 40 and player.buff(342246) then
                alterTimeBack:Cast()
            end
        end

        --dragonsBreath into ringOfFrost healer
        if dragonsBreath.cd == 0 and not player.lockouts.fire then
            if enemyHealer.distance < 5 and enemyHealer.disorientDR == 1 and TargetCheck(enemyHealer) and not enemyHealer.bcc and not enemyHealer.immuneCC then
                player.face(enemyHealer)
                dragonsBreath:Cast()
            end
        end
        if enemyhealer.debuff(dragonsBreath.id) then
            ringOfFrost:SmartAoE(enemyHealer, { movePredTime = 1 })
        end

        --glacialSpike
        if player.hasTalent(glacialSpike.id) then
            if not player.lockouts.frost and not player.moving and not player.buff(fingersOfFrost.id) and not player.buff(342246) then
                if glacialSpike:Castable(target) then
                    if glacialSpike:Cast(target) then
                        iceNova:Cast(target) 
                    end
                end
            end
        end

        --frostBolt ice buff
        if not player.lockouts.frost and not player.moving and player.buff(icyVeins.id) and not player.buff(freezingRain.id) and not player.buff(fingersOfFrost.id) then
            if frostBolt:Castable(target) then
                if frostBolt:Cast(target) then
                    iceNova:Cast(target) 
                end 
            end
        end

        --spellsteal
        if project.settings.spellStealButton and not WasCasting[spellSteal.id] and not player.buff(fingersOfFrost.id) then
            if player.manaPct > 50 then
                awful.enemies.loop(function(enemy)  
                    if TargetCheck(enemy) then
                        if spellSteal:Castable(enemy) then
                            if enemy.distance < spellSteal.range then
                                if enemy.purgeCount > 0 then
                                    spellSteal:Cast(enemy)
                                end
                            end
                        end
                    end
                end)
            end
        end

        --knock/freeze melee
        local total, melee, ranged, cooldowns = player.v2attackers()
        if melee > 0 then
            --blastWave
            if blastWave.cd == 0 and not player.lockouts.fire then
                local count, total, objects = awful.enemies.around(player, 5)
                for i = 1, count do
                    local unit = objects[i]
                    if unit.melee and not unit.bcc and TargetCheck(unit) and not unit.buffFrom(cantRootOrKnock) and not unit.immuneCC and not unit.rooted then
                        blastWave:Cast()
                    end
                end
            --dragonsBreath
            elseif dragonsBreath.cd == 0 and not player.lockouts.fire then
                local count, total, objects = awful.enemies.around(player, 5)
                for i = 1, count do
                    local unit = objects[i]
                    if unit.melee and unit.disorientDR == 1 and TargetCheck(unit) and not unit.bcc and not unit.immuneCC then
                        player.face(unit)
                        dragonsBreath:Cast()
                    end
                end
            --coneOfCold
            elseif coneOfCold.cd == 0 and not player.lockouts.frost then
                local count, total, objects = awful.enemies.around(player, 5)
                for i = 1, count do
                    local unit = objects[i]
                    if unit.melee and TargetCheck(unit) and not unit.bcc then
                        player.face(unit)
                        coneOfCold:Cast()
                    end
                end
            --frostNova
            elseif frostNova.cd == 0 and not WasCasting[frostNova.id] and not player.lockouts.frost then
                local count, total, objects = awful.enemies.around(player, 5)
                for i = 1, count do
                    local unit = objects[i]
                    if (unit.melee or unit.pet) and unit.rootDR >= 0.5 and not unit.bcc and TargetCheck(unit) and not unit.buffFrom(cantRootOrKnock) and not unit.immuneCC then
                        frostNova:Cast()
                    end
                end
            --ringOfFrost
            elseif project.settings.ringOfFrostToggle and ringOfFrost.cd == 0 and not player.lockouts.frost then
                ringOfFrost:SmartAoE(player)
            end
        end

        --ringOfFrost pets
        awful.pets.loop(function(pet)
            if project.settings.ringOfFrostToggle and ringOfFrost:Castable(pet) and pet.enemy then
                ringOfFrost:SmartAoE(pet, { movePredTime = 1 })
            end
        end)

        --frozenOrb
        if not player.lockouts.frost and project.settings.autoFrozenOrb then
            if frozenOrb:Castable(target) then
                frozenOrb:AoECast(target) 
            end
        end

        --blizzard proc
        if not player.lockouts.frost and player.buff(freezingRain.id) then
            if blizzard:Castable(target) then
                blizzard:SmartAoE(target, { movePredTime = 1 })
            end
        end

        --icyVeins
        if not player.lockouts.frost and project.settings.autoIcyVeins and player.combat and project.settings.burstButton then
            icyVeins:Cast()
        end

        if frostBomb:Castable(target) then
            frostBomb:Cast(target)
        end

        --iceLance
        if not player.lockouts.frost and player.buff(fingersOfFrost.id) then
            if iceLance:Castable(target) then
                iceLance:Cast(target) 
            end
        end

        --ringOfFire
        if not player.lockouts.fire then
            if ringOfFire:Castable(target) then
                ringOfFire:SmartAoE(target, { movePredTime = 1 })
            end
        end

        --polymorph
        if select(2,IsInInstance()) == "arena" and not WasCasting[polymorph.id] and project.settings.autoSheep and not player.buff(377360) then --377360 Precognition
            local isPolymorphActive = false

            awful.enemies.loop(function(enemy)
                if enemy.debuff(polymorph.id, player) then
                    isPolymorphActive = true
                    return false -- exit the loop
                end
            end)

            if not isPolymorphActive then
                --polymorph DPS WHEN ALLY LOW
                awful.friends.loop(function(friend)
                    if friend.hp <= 40 then
                        awful.enemies.loop(function(enemy)
                            if TargetCheck(enemy) and not enemy.isUnit(enemyHealer) and not enemy.isUnit(target) then
                                if polymorph:Castable(enemy) and (enemy.incapacitateDR >= 0.5 or enemy.incapacitateDR >= 0.25 and enemy.bccRemains <= polymorph.castTime) and enemy.los and not enemy.buffFrom(unSheepable) then
                                    polymorph:Cast(enemy)
                                end
                            end
                        end)
                    end
                end)

                --polymorph HEALER WHEN FULL DR
                if TargetCheck(enemyHealer) then
                    if polymorph:Castable(enemyHealer) and (enemyHealer.incapacitateDR >= 0.5 or enemyHealer.incapacitateDR >= 0.25 and enemyHealer.bccRemains <= polymorph.castTime) and enemyHealer.los and not enemyHealer.isUnit(target) and not enemyHealer.buffFrom(unSheepable) then
                        polymorph:Cast(enemyHealer)
                    end
                end

                --polymorph DPS WHEN FULL DR
                awful.enemies.loop(function(enemy)
                    if TargetCheck(enemy) and not enemy.isUnit(enemyHealer) and not enemy.isUnit(target) then
                        if polymorph:Castable(enemy) and (enemy.incapacitateDR >= 0.5 or enemy.incapacitateDR >= 0.25 and enemy.bccRemains <= polymorph.castTime) and enemy.los and not enemy.isUnit(target) and not enemy.buffFrom(unSheepable) then
                            polymorph:Cast(enemy)
                        end
                    end
                end)
            end
        end

        --slow
        if not WasCasting[slow.id] and not target.debuff(slow.id, player) and not target.buffFrom(totalimmunity) and TargetCheck(target) and not target.buffFrom(cantRootOrKnock) and not target.immuneCC then 
            if slow:Castable(target) and project.settings.autoSlow and not target.buffFrom(slowImmune) and not target.debuffFrom(slowImmune) and not target.debuffFrom(enemyReflect) then
                slow:Cast(target) 
            end
        end

        --blizzard
        if not player.lockouts.frost then
            if blizzard:Castable(target) then
                blizzard:SmartAoE(target, { movePredTime = 1 })
            end
        end

        --shiftingPower
        if not player.buff(fingersOfFrost.id) and ringOfFire.cd > 1 and frozenOrb.cd > 1 and not player.moving then
            if shiftingPower:Castable() then
                if not player.moving and shiftingPower.cd == 0 then
                    if shiftingPower:Cast() then
                        awful.alert({
                            message = awful.colors.red.."CASTING SHIFTING POWER",
                            texture = shiftingPower.id,
                            duration = 3,
                        })
                    end
                end
            end
        end

        --frostBolt
        if not player.lockouts.frost and not player.moving then
            if frostBolt:Castable(target) then
                if frostBolt:Cast(target) then
                    iceNova:Cast(target) 
                end 
            end
        end

        --flurry
        if not player.lockouts.frost and not player.buff(fingersOfFrost.id) then
            if flurry:Castable(target) then
                flurry:Cast(target) 
            end
        end

        --iceLance
        if not player.lockouts.frost then
            if iceLance:Castable(target) then
                iceLance:Cast(target) 
            end
        end
    end
end)

C_Timer.After(0.5, function()
    awful.enabled = true
    awful.print("enabled")
end)