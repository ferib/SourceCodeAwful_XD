--#region setup
local Unlocker, awful, project = ...
awful.DevMode = true
if WOW_PROJECT_ID == 11 then return end
if awful.player.spec == "Devastation" then awful.print(awful.player.spec) end
if awful.player.spec ~= "Devastation" then return end
local player, target, focus, healer, enemyHealer = awful.player, awful.target, awful.focus, awful.healer, awful.enemyHealer
local arena1, arena2, arena3 = awful.arena1, awful.arena2, awful.arena3
local party1, party2, party3, party4 = awful.party1, awful.party2, awful.party3, awful.party4
project.evoker = {}
project.evoker.devastation = awful.Actor:New({ spec = 1, class = "evoker" })
local devastation = project.evoker.devastation
devastation.ACTOR_TICKRATE = 0.02
local NewSpell = awful.NewSpell
local healthstone = awful.Item(5512)
local dpsTrinketEpic = awful.Item(205708)
local dpsTrinketBlue = awful.Item(205778)
local SpellStopCasting = awful.unlock("SpellStopCasting")
local Draw = awful.Draw
local AwfulFont = awful.createFont(12, "OUTLINE")
local noSleepWalkActive = true
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
    fireBreath = NewSpell(357208, { damage = "magic", targeted = false }),
    fireBreathCD = NewSpell(382266, { damage = "magic", targeted = false }),
    pyre = NewSpell(357211, { damage = "magic", targeted = true }),
    dragonRage = NewSpell(375087, { damage = "magic", targeted = false }),
    eternitySurge = NewSpell(382411, { damage = "magic", targeted = true, ignoreMoving = false }),
    disintegrate = NewSpell(356995, { damage = "magic", targeted = true }),
    azureStrike = NewSpell(362969, { damage = "magic", targeted = true, ignoreMoving = true }),
    shatteringStar = NewSpell(370452, { damage = "magic", targeted = true }),
    livingFlame = NewSpell(361469, { damage = "magic", targeted = true, ignoreMoving = true }),

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
    fireblood = NewSpell(265221, { beneficial = true }),
    stoneform = NewSpell(20594, { beneficial = true }),
    haymaker = NewSpell(287712, { damage = "physical", effect = "physical", cc = "stun", targeted = true, ignoreMoving = true }),
    bagofTricksDirectHeal = NewSpell(312411, { heal = true, ignoreFacing = true, ignoreMoving = true, targeted = true }),
    giftoftheNaaru = NewSpell(59547, { heal = true, ignoreMoving = true }),
    regeneratin = NewSpell(291944, { heal = true }),
    willToSurvive = NewSpell(59752, { beneficial = true, ignoreControl = true }),

    --## INTERRUPTS ##--
    quell = NewSpell(351338, { effect = "magic", targeted = true, ignoreGCD = true, ignoreFacing = false }),

    --## DISPELLS ##--
    cauterizingFlame = NewSpell(374251, { beneficial = true, targeted = true, ignoreFacing = true, ignoreGCD = false, ignoreControl = true }),   
    expunge = NewSpell(365585, { beneficial = true, targeted = true, ignoreFacing = true, ignoreGCD = false, ignoreControl = true }),
    
    --## CC ##--
    sleepWalk = NewSpell(360806, { effect = "magic", cc = "disorient", targeted = true, ignoreFacing = true }),
    oppressingRoar = NewSpell(372048, { effect = "magic", targeted = false }),
    landSlide = NewSpell(358385, { effect = 'magic', cc = "root", diameter = 8, ignoreFacing = true }),
    deepBreath = NewSpell(357210, { effect = 'magic', cc = "stun", diameter = 8, ignoreFacing = true}),

    --## BUFFS ##--
    tipTheScales = NewSpell(370553, { beneficial = true, targeted = false, ignoreFacing = true }),
    blessingOfTheBronze = NewSpell(364342, { beneficial = true, targeted = false, ignoreFacing = true }),
    
    --## DEFENSIVE/UTILITY ##--
    obsidianScales = NewSpell(363916, { beneficial = true, ignoreFacing = true, ignoreGCD = true, ignoreControl = true  }),
    renewingBlaze = NewSpell(374348, { beneficial = true, ignoreFacing = true, ignoreGCD = true, ignoreControl = true  }),
    emeraldBlossom = NewSpell(355913, { beneficial = true, ignoreFacing = true, ignoreGCD = true, ignoreControl = true  }),
    verdantEmbrace = NewSpell(360995, { beneficial = true, ignoreFacing = true, ignoreGCD = true, ignoreControl = true  }),
    hover = NewSpell(358267, { beneficial = true, ignoreFacing = true }),
    rescue = NewSpell(370665, { beneficial = true, ignoreFacing = true }),
    wingBuffet = NewSpell(357214, { beneficial = true, ignoreFacing = false }),
    tailSwipe = NewSpell(368970, { beneficial = true, ignoreFacing = false }),
    timeSpiral = NewSpell(374968, { beneficial = true, ignoreFacing = false }),
}, devastation, getfenv(1))
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
                if target.buffFrom(enemyReflect) and target.los then --stop casting on target if reflect
                    SpellStopCasting()
                end
                if azureStrike:Castable(enemy) and enemy.buffFrom(enemyReflect) then -- remove reflect
                    azureStrike:Cast(enemy)
                end
                if unit.hp > 15 and enemy.hp < 15 and not enemy.buffFrom(totalimmunity) and not enemy.debuffFrom(totalimmunity) and not enemy.bcc and enemy.los and not enemy.buffFrom(enemyReflect) then
                    if disintegrate:Castable(enemy) then
                        disintegrate:Cast(enemy)
                    end
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
        if project.settings.stomps[totem.id] then
            if uptime < project.settings.stompDelay then return end
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

devastation:Init(function()
if target.dead then return end
    if player.mounted then return end
    if player.dead then return end
    EndOfCastFace()
    WasCastingCheck()

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

    --blessingOfTheBronze
    if not player.buff(381748) and not player.combat then
        blessingOfTheBronze:Cast() 
    end

    --dispel poison
    if project.settings.autoDispel and not player.buff(dragonRage.id) then
        if player.debuffFrom(dispelPoison) then
            if expunge:Castable(player) then
                expunge:Cast(player) 
            end           
        end
        if healer.debuffFrom(dispelPoison) then
            if expunge:Castable(healer) then
                expunge:Cast(healer) 
            end         
        end
    end

    --dispel
    if project.settings.autoDispel and not player.buff(dragonRage.id) then
        if player.debuffFrom(project.settings.dispelsList) then
            local debuff = player.debuffFrom(project.settings.dispelsList)[1]
            if player.debuffUptime(debuff) < project.settings.dispelDelay then return end 
            if cauterizingFlame:Castable(player) then
                cauterizingFlame:Cast(player) 
            end           
        end
        if healer.debuffFrom(project.settings.dispelsList) then
            local debuff = healer.debuffFrom(project.settings.dispelsList)[1]
            if healer.debuffUptime(debuff) < project.settings.dispelDelay then return end
            if cauterizingFlame:Castable(healer) then
                cauterizingFlame:Cast(healer) 
            end         
        end
    end

    --Interrupt
    if quell.cd == 0 then
        awful.enemies.loop(function(enemy)
            if TargetCheck(enemy) then
                if quell:Castable(enemy) and castCheck(project.settings.interrupts, enemy.castID) and not enemy.casting8 and enemy.casting then
                    if enemy.castTimeComplete > project.settings.interruptDelay then
                        quell:Cast(enemy)  
                        if project.settings.allText then
                            awful.alert({
                                message = "Interrupting: "..enemy.name,
                                texture = quell.id,
                                duration = 3,
                            })
                        end
                    end
                end
                if quell:Castable(enemyHealer) and enemy.hp <= project.settings.interruptHealer and not enemyHealer.casting8 and enemyHealer.casting then
                    if enemyHealer.castTimeComplete > project.settings.interruptDelay then
                        quell:Cast(enemyHealer)
                        if project.settings.allText then
                            awful.alert({
                                message = "Interrupting: "..enemyHealer.name,
                                texture = quell.id,
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

    --timespiral
    if hover.cd > 5 then
        if timeSpiral:Castable() then
            timeSpiral:Cast()
        end
    end

    --DEFENSIVES
    if player.combat and not player.buff(32727) then
        if player.hp <= project.settings.defensivesHealthstone and healthstone.cd == 0 then
            healthstone:Use()
        end
        if player.hp <= project.settings.defensiveObsidianScales and obsidianScales.cd == 0 and not player.buff(obsidianScales.id) then
            obsidianScales:Cast()
        end
        if player.hp <= project.settings.defensiveRenewingBlaze and renewingBlaze.cd == 0 then
            renewingBlaze:Cast()
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

        if project.settings.burstButton then 
            
            --oppressingRoar
            if oppressingRoar:Castable() and target.distance < 25 and target.los and target.distance > 10 and deepBreath.cd == 0 then
                player.face(target)
                oppressingRoar:Cast() 
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

            --deepBreath
            if deepBreath:Castable(target) and target.distance < 25 then
                local x, y, z = target.predictPosition(0.5)
                deepBreath:AoECast(x,y,z) 
            end

            --shatteringStar
            if shatteringStar:Castable(target) then
                shatteringStar:Cast(target)         
            end

            --dragonRage
            if dragonRage:Castable() and target.distance < 25 and target.los then
                dragonRage:Cast()         
            end

            --fireBreath
            if fireBreath:Castable() and (tipTheScales.cd == 0 or player.buff(tipTheScales.id)) and dragonRage.cd > 3 and shatteringStar.cd > 3 and target.distance < 25 and target.los then
                if tipTheScales:Castable() then
                    tipTheScales:Cast()
                end

                if player.buff(tipTheScales.id) then
                    player.face(target)
                    fireBreath:Cast()
                end
            end

            --livingFlame buff
            if livingFlame:Castable(target) and player.buff(375802) then --375802 burnout
                livingFlame:Cast(target)         
            end

            --eternitySurge
            if eternitySurge:Castable(target) and not player.buff(tipTheScales.id) and tipTheScales.cd > 3 then
                eternitySurge:Cast(target)
                eternitySurge:Release()
            end

            --pyre at 20 stacks buff
            if player.buffStacks(370454) == 20 and dragonRage.cd > 3 then
                if pyre:Castable(target) then
                    pyre:Cast(target)         
                end
            end

            --fireBreath lvl 1
            if fireBreath:Castable() and not player.moving and target.distance < 30 and target.los and tipTheScales.cd > 25 then
                player.face(target)
                fireBreath:Cast()
                fireBreath:Release()
            end            

            if eternitySurge.cd > 3 and fireBreathCD.cd > 3 then    

                --knock/freeze melee
                local total, melee, ranged, cooldowns = player.v2attackers()
                if melee > 0 then
                    local count, total, objects = awful.enemies.around(player, 5)
                    --wingBuffet
                    if wingBuffet.cd == 0 then
                        for i = 1, count do
                            local unit = objects[i]
                            if unit.melee and not unit.bcc and TargetCheck(unit) and not unit.immuneCC and not unit.rooted then
                                player.face(unit)
                                wingBuffet:Cast(unit)
                            end
                        end
                    --tailSwipe
                    elseif tailSwipe.cd == 0 then
                        for i = 1, count do
                            local unit = objects[i]
                            if unit.melee and TargetCheck(unit) and not unit.bcc and not unit.immuneCC then
                                tailSwipe:Cast(unit)
                            end
                        end
                    elseif landSlide.cd == 0 then
                        for i = 1, count do
                            local unit = objects[i]
                            if unit.melee and not unit.bcc and TargetCheck(unit) and not unit.immuneCC and not unit.rooted and unit.distance > 10 then
                                landSlide:AoECast(unit)
                            end
                        end
                    end
                end

                --disintegrate
                if disintegrate:Castable(target) and not player.buff(tipTheScales.id) then
                    disintegrate:Cast(target)         
                end

                stomp()
        
                --sleepWalk
                if select(2,IsInInstance()) == "arena" and not WasCasting[sleepWalk.id] and not player.buff(tipTheScales.id) and not player.buff(dragonRage.id) then 
                    noSleepWalkActive = true

                    --check if active sleepWalk 
                    awful.enemies.loop(function(enemy)
                        if TargetCheck(enemy) and enemy.debuff(sleepWalk.id, player) then
                            noSleepWalkActive = false
                        end
                    end)
            
                    if noSleepWalkActive then
                        --sleepWalk DPS WHEN ALLY LOW
                        awful.friends.loop(function(friend)
                            if friend.hp <= 40 then
                                awful.enemies.loop(function(enemy)
                                    if TargetCheck(enemy) and not enemy.isUnit(enemyHealer) and not enemy.isUnit(target) then
                                        if sleepWalk:Castable(enemy) and (enemy.disorientDR >= 0.5 or enemy.disorientDR >= 0.25 and enemy.bccRemains <= sleepWalk.castTime) and enemy.los then
                                            sleepWalk:Cast(enemy)
                                        end
                                    end
                                end)
                            end
                        end)

                        --sleepWalk HEALER WHEN FULL DR
                        if TargetCheck(enemyHealer) then
                            if sleepWalk:Castable(enemyHealer) and (enemyHealer.disorientDR >= 0.5 or enemyHealer.disorientDR >= 0.25 and enemyHealer.bccRemains <= sleepWalk.castTime) and enemyHealer.los and not enemyHealer.isUnit(target) then
                                sleepWalk:Cast(enemyHealer)
                            end
                        end

                        --sleepWalk DPS WHEN FULL DR
                        awful.enemies.loop(function(enemy)
                            if TargetCheck(enemy) and not enemy.isUnit(enemyHealer) and not enemy.isUnit(target) then
                                if sleepWalk:Castable(enemy) and (enemy.disorientDR >= 0.5 or enemy.disorientDR >= 0.25 and enemy.bccRemains <= sleepWalk.castTime) and enemy.los and not enemy.isUnit(target) then
                                    sleepWalk:Cast(enemy)
                                end
                            end
                        end)
                    end
                end

                --azureStrike
                if azureStrike:Castable(target) and player.essence < 3 then
                    azureStrike:Cast(target)         
                end   
            end
        else
            --disintegrate
            if disintegrate:Castable(target) then
                disintegrate:Cast(target)         
            end
            --sleepWalk
            if select(2,IsInInstance()) == "arena" and not WasCasting[sleepWalk.id] then 
                noSleepWalkActive = true

                --check if active sleepWalk 
                awful.enemies.loop(function(enemy)
                    if TargetCheck(enemy) and enemy.debuff(sleepWalk.id, player) then
                        noSleepWalkActive = false
                    end
                end)
            
                if noSleepWalkActive then
                    --sleepWalk DPS WHEN ALLY LOW
                    awful.friends.loop(function(friend)
                        if friend.hp <= 40 then
                            awful.enemies.loop(function(enemy)
                                if TargetCheck(enemy) and not enemy.isUnit(enemyHealer) then
                                    if sleepWalk:Castable(enemy) and enemy.disorientDR >= 0.5 and enemy.los then
                                        sleepWalk:Cast(enemy)
                                    end
                                end
                            end)
                        end
                    end)

                    --sleepWalk HEALER WHEN FULL DR
                    if TargetCheck(enemyHealer) then
                        if sleepWalk:Castable(enemyHealer) and enemyHealer.disorientDR >= 1 and enemyHealer.los and not enemyHealer.isUnit(target) then
                            sleepWalk:Cast(enemyHealer)
                        end
                    end

                    --sleepWalk DPS WHEN FULL DR
                    awful.enemies.loop(function(enemy)
                        if TargetCheck(enemy) and not enemy.isUnit(enemyHealer) then
                            if sleepWalk:Castable(enemy) and enemy.disorientDR >= 1 and enemy.los and not enemy.isUnit(target) then
                                sleepWalk:Cast(enemy)
                            end
                        end
                    end)
                end
            end
            --azureStrike
            if azureStrike:Castable(target) then
                azureStrike:Cast(target)         
            end  
        end
    end
end)

C_Timer.After(0.5, function()
    awful.enabled = true
    awful.print("enabled")
end)