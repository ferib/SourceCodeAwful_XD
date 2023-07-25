--#region setup
local Unlocker, awful, project = ...
awful.DevMode = true
if WOW_PROJECT_ID == 11 then return end
if awful.player.spec == "Balance" then awful.print(awful.player.spec) end
if awful.player.spec ~= "Balance" then return end
local player, target, focus, healer, enemyHealer = awful.player, awful.target, awful.focus, awful.healer, awful.enemyHealer
local arena1, arena2, arena3 = awful.arena1, awful.arena2, awful.arena3
local party1, party2, party3, party4 = awful.party1, awful.party2, awful.party3, awful.party4
project.druid = {}
project.druid.balance = awful.Actor:New({ spec = 1, class = "druid" })
local balance = project.druid.balance
balance.ACTOR_TICKRATE = 0.02
local NewSpell = awful.NewSpell
local healthstone = awful.Item(5512)
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
    moonFire = NewSpell(8921, { damage = "magic", targeted = true, ignoreMoving = true, ignoreFacing = true  }),
    moonFireDot = NewSpell(164812, { damage = "magic", targeted = true, ignoreMoving = true, ignoreFacing = true  }),
    sunFire = NewSpell(93402, { damage = "magic", targeted = true, ignoreMoving = true, ignoreFacing = true  }),
    sunFireDot = NewSpell(164815, { damage = "magic", targeted = true, ignoreMoving = true }),
    starSurge = NewSpell(78674, { damage = "magic", targeted = true, ignoreMoving = true }),
    starFire = NewSpell(194153, { damage = "magic", targeted = true, ignoreMoving = true }),
    furyOfElune = NewSpell(202770, { damage = "magic", targeted = true, ignoreMoving = true, ignoreFacing = true  }),
    starFall = NewSpell(191034, { damage = "magic", targeted = true, ignoreMoving = true }),
    wrath = NewSpell(190984, { damage = "magic", targeted = true, ignoreMoving = false }),

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
    shadowMeld = NewSpell(58984, { beneficial = true }),
    willToSurvive = NewSpell(59752, { beneficial = true, ignoreControl = true }),

    --## INTERRUPTS ##--
    solarBeam = NewSpell(78675, { effect = "magic", targeted = true, ignoreGCD = true, ignoreFacing = true, ignoreMoving = true }),
    
    --## CC ##--
    cyclone = NewSpell(33786, { effect = "magic", cc = "disorient", targeted = true, ignoreFacing = true }),
    massEntanglement = NewSpell(102359, { damage = "magic", targeted = true, ignoreMoving = true, ignoreFacing = true }),
    mightyBash = NewSpell(5211, { effect = "magic", cc = "stun", targeted = true, ignoreFacing = true }),
    typhoon = NewSpell(132469, { effect = "magic", cc = "knock", targeted = true, ignoreFacing = false }),

    --## BUFFS ##--
    incarnationChosenOfElune = NewSpell(102560, { beneficial = true, targeted = false, ignoreFacing = true }),
    incarnationChosenOfEluneAOE = NewSpell(390414, { effect = 'magic', diameter = 8, ignoreFacing = true }),
    markOfTheWild = NewSpell(1126, { beneficial = true, targeted = false, ignoreFacing = true }),
    moonkinForm = NewSpell(24858, { beneficial = true, targeted = false, ignoreFacing = true }),
    bearForm = NewSpell(5487, { beneficial = true, targeted = false, ignoreFacing = true }),
    catForm = NewSpell(768, { beneficial = true, targeted = false, ignoreFacing = true }),
    prowl = NewSpell(5215, { beneficial = true, targeted = false, ignoreFacing = true }),
    
    --## DEFENSIVE/UTILITY ##--
    barkSkin = NewSpell(22812, { beneficial = true, ignoreFacing = true, ignoreGCD = true, ignoreControl = true }),
    renewal = NewSpell(108238, { beneficial = true, ignoreFacing = true, ignoreGCD = true, ignoreControl = true }),
    frenziedRegeneration = NewSpell(22842, { beneficial = true, ignoreFacing = true, ignoreGCD = false }),
    rejuvenation = NewSpell(774, { beneficial = true, ignoreFacing = true, ignoreGCD = false }),
    heartOfTheWild = NewSpell(319454, { beneficial = true, targeted = false, ignoreFacing = true }),
    swiftMend = NewSpell(18562, { beneficial = true, targeted = false, ignoreFacing = true }),
    naturesVigil = NewSpell(124974, { beneficial = true, targeted = false, ignoreFacing = true }),
}, balance, getfenv(1))
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
                if moonFire:Castable(enemy) and enemy.buffFrom(enemyReflect) then -- remove reflect
                    moonFire:Cast(enemy)
                end
                if unit.hp > 15 and enemy.hp < 15 and not enemy.buffFrom(totalimmunity) and not enemy.debuffFrom(totalimmunity) and not enemy.bcc and enemy.los and not enemy.buffFrom(enemyReflect) then
                    if starSurge:Castable(enemy) then
                        starSurge:Cast(enemy)
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
            if moonFire:Castable(totem) then
                moonFire:Cast(totem)
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

        if shadowMeld.cd == 0 then
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

balance:Init(function()
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

    --SOUL WELL
    if not player.combat then
        if not player.moving then
            if healthstone.count == 0 then
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

    --markOfTheWild
    if not player.buff(markOfTheWild.id) and not player.combat then
        markOfTheWild:Cast()
    end

    --prowl
    if player.buff(32727) then -- arena prep
        if not player.buff(catForm.id) then
            catForm:Cast() 
        end
        if player.buff(catForm.id) and not player.buff(prowl.id) then
            prowl:Cast()
        end
    end

    --Interrupt
    if project.settings.CCHealerOnly == false then
        if solarBeam.cd == 0 and massEntanglement.cd == 0 then
            awful.enemies.loop(function(enemy)
                if TargetCheck(enemy) then
                    if solarBeam:Castable(enemy) and castCheck(project.settings.interrupts, enemy.castID) and not enemy.casting8 and enemy.casting and enemy.distance < 30 then
                        if enemy.castTimeComplete > project.settings.interruptDelay then
                            solarBeam:Cast(enemy)
                            if project.settings.allText then
                                awful.alert({
                                    message = "Interrupting: "..enemy.name,
                                    texture = solarBeam.id,
                                    duration = 3,
                                })
                            end
                        end
                    end
                    if solarBeam:Castable(enemyHealer) and enemy.hp <= project.settings.interruptHealer and not enemyHealer.casting8 and enemyHealer.casting and enemyHealer.distance < 30 then
                        if enemyHealer.castTimeComplete > project.settings.interruptDelay then
                            solarBeam:Cast(enemyHealer)
                            if project.settings.allText then
                                awful.alert({
                                    message = "Interrupting: "..enemyHealer.name,
                                    texture = solarBeam.id,
                                    duration = 3,
                                })
                            end 
                        end
                    end
                end
            end)
        end
    end

    --solarBeam
    if solarBeam:Castable(enemyHealer) and not enemyHealer.cc and not enemyHealer.bcc and not enemyHealer.silence and project.settings.CCHealerOnly and enemyHealer.distance < 35 and enemyHealer.combat then
        solarBeam:Cast(enemyHealer)
    end

    --massEntanglement
    awful.enemies.loop(function(enemy)
        if massEntanglement:Castable(enemy) and enemy.debuff(81261) then --solarbeam
            massEntanglement:Cast(enemy)
        end
    end)

    --knock/freeze melee
    local total, melee, ranged, cooldowns = player.v2attackers()
    if melee > 0 then
        if typhoon.cd == 0 or mightyBash.cd == 0 then
            local count, total, objects = awful.enemies.around(player, 10)
            for i = 1, count do
                local unit = objects[i]
                if unit.melee and TargetCheck(unit) and not unit.bcc and not unit.immuneCC then
                    player.face(unit)
                    typhoon:Cast()
                end
                if TargetCheck(unit) and not unit.bcc and not unit.immuneCC and unit.stunDR >= 1 and project.settings.BashMelee then
                    player.face(unit)
                    mightyBash:Cast(unit)
                end
            end
        end          
    end  

    --mightyBash healer
    if project.settings.BashHealer then
        if mightyBash.cd == 0 then
            if enemyHealer.distance < 10 and enemyHealer.stunDR == 1 and TargetCheck(enemyHealer) and not enemyHealer.bcc and not enemyHealer.immuneCC and not enemyHealer.cc and not enemyHealer.silence then
                player.face(enemyHealer)
                mightyBash:Cast(enemyHealer)
            end
        end
    end

    --DEFENSIVES
    if player.combat and not player.buff(32727) then
        if player.hp <= project.settings.defensiveBarkSkin and barkSkin.cd == 0 then
            barkSkin:Cast()
        end
        if player.hp <= project.settings.defensiveRenewal and renewal.cd == 0 then
            renewal:Cast()
        end
        if player.hp <= project.settings.defensivesHealthstone and healthstone.cd == 0 then
            healthstone:Use()
        end
        if player.hp <= project.settings.defensivesFrenziedRegeneration and frenziedRegeneration.cd == 0 then
            if not player.buff(bearForm.id) then
                heartOfTheWild:Cast()
                bearForm:Cast()
            end
            if player.buff(bearForm.id) then
                heartOfTheWild:Cast()
                frenziedRegeneration:Cast()
            end
        end
        if player.hp <= project.settings.bearformHp and not player.buff(bearForm.id) then
            heartOfTheWild:Cast()
            bearForm:Cast()
        end
        if player.hp <= project.settings.rejuvenationSwiftMend then
            if not player.buff(rejuvenation.id) then
                rejuvenation:Cast(player)
            end
            if player.buff(rejuvenation.id) then
                swiftMend:Cast(player)
            end
        end
        if player.hp <= project.settings.naturesVigilDef then 
            naturesVigil:Cast()
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

    --target ROTATION
    if TargetCheck(target) then  
        if target.distance > 40 then return end
        if player.hp <= project.settings.bearformHp then return end

        if project.settings.autoFocusToggle and project.settings.allText then
            awful.AutoFocus()
        end

        --moonkinForm
        if not player.buff(moonkinForm.id) and player.combat then
            moonkinForm:Cast() 
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

        --starFall
        if target.distance < 45 then
            starFall:Cast()
        end

        --starSurge
        if starSurge:Castable(target) and not player.hasTalent(starFall.id) or player.buff(393944) then --393942 starweavers wrap
            starSurge:Cast(target)
        end

        --furyOfElune
        if player.hasTalent(furyOfElune.id) then
            if furyOfElune:Castable(target) then
                furyOfElune:Cast(target) 
            end
        end

        --incarnationChosenOfElune
        if incarnationChosenOfElune:Castable() and target.distance < 40 and project.settings.autoIncarnationChosenOfElune then
            incarnationChosenOfElune:Cast() 
        end

        --starFire
        if starFire:Castable(target) and target.distance < 40 and enemies.around(target) >= 1 and not player.moving or player.buff(157228) then
            starFire:Cast(target)
        end

        --dots
        awful.enemies.loop(function(enemy)
            if TargetCheck(enemy) then
                if massEntanglement:Castable(enemy) and enemy.debuff(81261) then --solarbeam
                    massEntanglement:Cast(enemy)
                end
                if moonFire:Castable(enemy) then
                    if not enemy.debuff(moonFireDot.id, player) then
                        moonFire:Cast(enemy)
                    end
                end
                if sunFire:Castable(enemy) then
                    if not enemy.debuff(sunFireDot.id, player) then
                        sunFire:Cast(enemy)
                    end
                end 
            end
        end)

        --incarnationChosenOfEluneAOE
        if incarnationChosenOfEluneAOE:Castable(target) and target.distance < 40 and project.settings.autoIncarnationChosenOfElune then
            incarnationChosenOfEluneAOE:AoECast(target) 
        end

        --cyclone
        if select(2,IsInInstance()) == "arena" and not WasCasting[cyclone.id] and not player.buff(377360) then --377360 Precognition
            local isCycloneActive = false

            awful.enemies.loop(function(enemy)
                if enemy.debuff(cyclone.id, player) then
                    isCycloneActive = true
                    return false -- exit the loop
                end
            end)

            if not isCycloneActive then
                --cyclone DPS WHEN ALLY LOW
                awful.friends.loop(function(friend)
                    if friend.hp <= 40 then
                        awful.enemies.loop(function(enemy)
                            if TargetCheck(enemy) and not enemy.isUnit(enemyHealer) and not enemy.isUnit(target) then
                                if cyclone:Castable(enemy) and (enemy.disorientDR >= 0.5 or enemy.disorientDR >= 0.25 and enemy.bccRemains <= cyclone.castTime) and enemy.los and not enemy.bcc then
                                    cyclone:Cast(enemy)
                                end
                            end
                        end)
                    end
                end)

                --cyclone HEALER WHEN FULL DR
                if TargetCheck(enemyHealer) then
                    if cyclone:Castable(enemyHealer) and (enemyHealer.disorientDR >= 0.5 or enemyHealer.disorientDR >= 0.25 and enemyHealer.bccRemains <= cyclone.castTime) and enemyHealer.los and not enemyHealer.isUnit(target) and not enemyHealer.bcc then
                        cyclone:Cast(enemyHealer)
                    end
                end

                --cyclone DPS WHEN FULL DR
                awful.enemies.loop(function(enemy)
                    if TargetCheck(enemy) and not enemy.isUnit(enemyHealer) and not enemy.isUnit(target) then
                        if cyclone:Castable(enemy) and (enemy.disorientDR >= 0.5 or enemy.disorientDR >= 0.25 and enemy.bccRemains <= cyclone.castTime) and enemy.los and not enemy.isUnit(target) and not enemy.bcc then
                            cyclone:Cast(enemy)
                        end
                    end
                end)
            end
        end

        --wrath
        if wrath:Castable(target) and not player.moving and enemies.around(target) == 0 then
            wrath:Cast(target)
        end

        --moonFire
        if moonFire:Castable(target) and player.moving then
            moonFire:Cast(target)
        end  
    end
end)

C_Timer.After(0.5, function()
    awful.enabled = true
    awful.print("enabled")
end)