local Unlocker, awful, project = ...
awful.DevMode = true
if WOW_PROJECT_ID == 11 then return end
if awful.player.spec == "Shadow" then awful.print(awful.player.spec .. " v7") end
if awful.player.spec ~= "Shadow" then return end
local player, target, focus, healer, enemyHealer = awful.player, awful.target, awful.focus, awful.healer, awful.enemyHealer
local arena1, arena2, arena3 = awful.arena1, awful.arena2, awful.arena3
local party1, party2, party3, party4 = awful.party1, awful.party2, awful.party3, awful.party4
project.priest = {}
project.priest.shadow = awful.Actor:New({ spec = 3, class = "priest" })
local shadow = project.priest.shadow
shadow.ACTOR_TICKRATE = 0.02
local NewSpell = awful.NewSpell
local healthstone = awful.Item(5512)
local dpsTrinketEpic = awful.Item(205708)
local dpsTrinketBlue = awful.Item(205778)
local CCTrinketEpic = awful.Item(205711)
local CCTrinketBlue = awful.Item(205779)
local SpellStopCasting = awful.unlock("SpellStopCasting")
local Draw = awful.Draw
local AwfulFont = awful.createFont(12, "OUTLINE")
local healerCounter = 0

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
    212295 --nether ward
}
local enemyReflect = {
    23920 --spell reflect
}
local enemyFearImmune = {
    227847, --bladestorm
    18499, --Berserker rage
    384100, --Berserker shout
    48707 --AMS
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
    108273 -- Wind Walk
}
local antiKickBuffs = {
    378077, -- Spiritwalker's Aegis
    377360, --Precognition
    317929, --Aura Mastery
    642, --divine shield
    104773, --unendingResolve
    209584, --Zen Focus Tea
    212295, --Nether Ward
    186265 --Aspect of the Turtle
}
local cantBeKicked = {
    377360, --Precognition
    377362, --Precognition
    104773, --unendingResolve
    1022, --Blessing of Protection
    317929 --Aura Mastery 
}
local cantRootOrKnock = {
    227847, --bladestorm
    48707 --AMS
}
local massDispelList = {
    45438, -- Ice Block
    642 -- Divine Shield
}
local slowImmune = {
    305395, --blessing of freedom
    1044, --blessing of freedom
    79811, --Dispersion
    47585 --dispersion
}
--#endregion

--#region Spellbook
awful.Populate({
    --## DMG ##--
    shadowWordPain = NewSpell(589, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = true }),
    vampiricTouch = NewSpell(34914, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = false }),
    mindSpike = NewSpell(73510, { damage = "magic", targeted = true, ignoreFacing = false, ignoreMoving = false }),
    mindBlast = NewSpell(8092, { damage = "magic", targeted = true, ignoreFacing = false, ignoreMoving = false }),
    mindGames = NewSpell(375901, { damage = "magic", targeted = true, ignoreFacing = false, ignoreMoving = false }),
    devouringPlague = NewSpell(335467, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = true }),
    damnation = NewSpell(341374, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = true }),
    mindFlay = NewSpell(15407, { damage = "magic", targeted = true, ignoreFacing = false, ignoreMoving = false }),
    shadowWordDeath = NewSpell(32379, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = true }),
    voidBolt = NewSpell(205448, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = true }),
    voidTorrent = NewSpell(263165, { damage = "magic", targeted = true, ignoreMoving = false }),

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

    --## INTERRUPTS ##--
    silence = NewSpell(15487, { effect = "magic", targeted = true, ignoreGCD = true, ignoreFacing = true, ignoreMoving = true}),

    --## PURGES ##--
    devourMagicPet = NewSpell(19505, { targeted = true, ignoreMoving = true, ignoreFacing = true}),

    --## DISPELLS ##--
    dispelMagic = NewSpell(528, { targeted = true, ignoreMoving = true, ignoreFacing = true}),

    --## AOE ##--
    shadowClash = NewSpell(205385, { damage = "magic", diameter = 12, offsetMin = 0, offsetMax = 5.5, ignoreFacing = true }),
    massDispel = NewSpell(32375, { diameter = 30 }),
    angelicFeather = NewSpell(121536, { damage = "magic", targeted = true, ignoreMoving = true}),

    --## CC ##--
    psychicHorror = NewSpell(64044, { effect = "magic", cc = "incapacitate", targeted = true, ignoreMoving = true , ignoreFacing = true}),
    voidTendrils = NewSpell(108920, { effect = "magic", cc = "root", targeted = false, ignoreMoving = true , ignoreFacing = true}),
    psychicScream = NewSpell(8122, { effect = "magic", cc = "disorient", targeted = false, ignoreMoving = true , ignoreFacing = true}),

    --## PETS ##--
    psyFiend = NewSpell(211522, { beneficial = true, targeted = true, ignoreFacing = true, ignoreMoving = true }),
    mindBender = NewSpell(200174, { beneficial = true, targeted = false, ignoreFacing = true, ignoreMoving = true }),
    shadowFiend = NewSpell(34433, { beneficial = true, targeted = false, ignoreFacing = true, ignoreMoving = true }),

    --## BUFFS ##--
    powerWordFortitude = NewSpell(21562, { beneficial = true, targeted = false, ignoreFacing = true }),
    powerInfusion = NewSpell(10060, { beneficial = true, targeted = false, ignoreFacing = true }),
    darkAscension = NewSpell(391109, { beneficial = true, targeted = false, ignoreFacing = true }),
    shadowForm = NewSpell(232698, { beneficial = true, targeted = false, ignoreFacing = true }),
    mindMelt = NewSpell(391092, { beneficial = true, targeted = false, ignoreFacing = true }),
    unfurlingDarkness = NewSpell(341282, { beneficial = true, targeted = false, ignoreFacing = true }),
    deathSpeaker = NewSpell(392511, { beneficial = true, targeted = false, ignoreFacing = true }),
    surgeOfDarkness = NewSpell(87160, { beneficial = true, targeted = false, ignoreFacing = true }),
    mindSpikeInsanity = NewSpell(407468, { beneficial = true, targeted = false, ignoreFacing = true }),
    mindFlayInsanity = NewSpell(391401, { beneficial = true, targeted = false, ignoreFacing = true }),
    shadowyInsight = NewSpell(375981, { beneficial = true, targeted = false, ignoreFacing = true }),
    caltharsis = NewSpell(391314, { beneficial = true, targeted = false, ignoreFacing = true }),
    voidEruption = NewSpell(228260, { beneficial = true, targeted = false, ignoreFacing = true }),
    
    --## DEFENSIVE/UTILITY ##--
    dispersion = NewSpell(47585, { beneficial = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = false, ignoreControl = true }),
    vampiricEmbrace = NewSpell(15286, { beneficial = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = true, ignoreControl = false }),
    desperatePrayer = NewSpell(19236, { beneficial = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = true, ignoreControl = false }),
    fade = NewSpell(586, { beneficial = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = true, ignoreControl = false }),
    powerWordShield = NewSpell(17, { beneficial = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = false, ignoreControl = false }),
    voidShift = NewSpell(108968, { beneficial = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = true, ignoreControl = false }),
    flashHeal = NewSpell(2061, { beneficial = true, ignoreMoving = false, ignoreFacing = true, ignoreGCD = false, ignoreControl = false }),
    powerWordLife = NewSpell(373481, { beneficial = true, ignoreMoving = true, ignoreFacing = true, ignoreGCD = false, ignoreControl = false }),
}, shadow, getfenv(1))
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
                if shadowWordPain:Castable(enemy) and enemy.buffFrom(enemyReflect) then -- remove reflect
                    shadowWordPain:Cast(enemy)
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
                end
            end
        end
    end
end
function stomp()
    awful.totems.stomp(function(totem, uptime)
        if project.settings.stompsHigh[totem.id] then
            if uptime < project.settings.stompDelay then return end
            if shadowWordPain:Castable(totem) then
                shadowWordPain:Cast(totem)
                totem.setTarget()
            end
        end

        if project.settings.stomps[totem.id] then
            if uptime < project.settings.stompDelay then return end
            if shadowWordPain:Castable(totem) then
                shadowWordPain:Cast(totem)
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

Draw(function(draw)
    if project.settings.psCircle then
        local px, py, pz = player.position()
        awful.enemies.within(40).loop(function(enemy)

            -- Check if the enemyHealer more than 8 yards of the player
            if enemyHealer.distance > 8 then
                -- Set the color of the circle (red with 100 alpha)
                -- RGBA: Red (255), Green (0), Blue (0), Alpha (100)
                draw:SetColor(255, 0, 0, 100)
    
                -- Draw the circle around the enemyHealer using the enemyHealer's position and a fixed radius (e.g., 2)
                draw:Circle(px, py, pz, 8)
            else -- else enemyHealer is within 8 yards of the player
                -- Set the color of the circle (green with 100 alpha)
                -- RGBA: Red (0), Green (255), Blue (0), Alpha (100)
                draw:SetColor(0, 255, 0, 100)
    
                -- Draw the circle around the enemyHealer using the enemyHealer's position and a fixed radius (e.g., 2)
                draw:Circle(px, py, pz, 8)
            end
        end)
    end
end)

shadow:Init(function()
    if player.mounted then return end
    if player.dead then return end
    EndOfCastFace()
    WasCastingCheck()

    if project.settings.onlyTargetEnemyPlayers and (select(2,IsInInstance()) == "arena" or select(2,IsInInstance()) == "pvp") then
        if not target.enemy or not target.player then
           awful.call("ClearTarget")
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

    --angelicFeather
    if player.moving and not player.buff(121557) and player.combat then -- 121557 angelicFeather buff
        angelicFeather:Cast(player)
    end

    --powerWordFortitude
    if not player.buff(powerWordFortitude.id) and not player.combat then
        powerWordFortitude:Cast() 
    end
	if select(2,IsInInstance()) == "arena" and not player.combat then
        awful.friends.loop(function(friend)
            if not friend.combat and not friend.buff(powerWordFortitude.id) then
                return powerWordFortitude:Cast(friend)
            end
        end)
    end

    --shadowform
    if not player.buff(shadowForm.id) then
        shadowForm:Cast() 
    end

    --save friend with voidShift
    if voidShift.cd == 0 then
        awful.friends.loop(function(friend)
            if friend.hp <= 30 and player.hp >= 50 then 
                voidShift:Cast(friend)
            --second check
            elseif friend.hp <= 10 and player.hp >= 40 then 
                voidShift:Cast(friend)
            end
        end)
    end

    --powerWordLife
    if player.hp < 30 then
        if powerWordLife:Castable(player) then
            powerWordLife:Cast(player)
        end
    end

    --Surge of Light procs
    if player.buffStacks(114255) >= 1 then
        if player.hp <= 60 then
            flashHeal:Cast(player)
        else
            awful.friends.loop(function(friend)
                if friend.hp < project.settings.defensivesFlashHealFriend then
                    flashHeal:Cast(friend)
                end
            end)
        end
    end

    --use flash heal stacks
    if player.buffStacks(390617) == 50 then
        awful.friends.loop(function(friend)
            if friend.hp < project.settings.defensivesFlashHealFriend then
                flashHeal:Cast(friend)
            end
        end)
    end


    --DEFENSIVES
    if player.combat and not player.buff(32727) then
        if player.hp <= project.settings.defensivesDispersion and dispersion.cd == 0 then
            dispersion:Cast()
        end
        if player.hp <= project.settings.defensivesVampiricEmbrace and vampiricEmbrace.cd == 0 then
            vampiricEmbrace:Cast()
        end
        if player.hp <= project.settings.defensivesDesperatePrayer and desperatePrayer.cd == 0 then
            desperatePrayer:Cast()
        end
        if player.hp <= project.settings.defensivesFade and fade.cd == 0 then
            fade:Cast()
        end
        if player.hp <= project.settings.defensivesVoidShift and voidShift.cd == 0 and dispersion.cd > 5 then
            awful.friends.loop(function(friend)
                if friend.hp > 80 then 
                    voidShift:Cast(friend)
                end
            end)
        end

        if player.hp <= project.settings.defensivesPowerWordShield and powerWordShield.cd == 0 and player.manaPct > 50 then
            powerWordShield:Cast(player)
        end

        if player.hp <= project.settings.defensivesHealthstone and healthstone.cd == 0 then
            healthstone:Use()
        end
        if player.hp <= project.settings.defensivesFlashHealMyself then
            if player.buffStacks(390617) == 50 then
                flashHeal:Cast(player)
            end
        end
    end

    --Heal if out of LoS and below 70%
    --Shield if in LoS and below 70%
    if player.hp < 70 then
        if not target.los and player.manaPct >= 72 then
            awful.call("ClearTarget")
            flashHeal:Cast(player)
        end
    end


    --remove divineShield and iceblock
    if select(2,IsInInstance()) == "arena" then
        awful.enemies.loop(function(enemy)
            if enemy.distance < 40 then
                if enemy.buff(642) or enemy.buff(45438) then
                    awful.call("ClearTarget")
                    massDispel:SmartAoE(enemy)
                    if project.settings.allText then
                        awful.alert({
                            message = "massDispel - "..enemy.classString,
                            texture = massDispel.id,
                            duration = 3,
                        })
                    end
                end
            end
        end)
    end

    stomp()


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

        --psychicScream healer
        if psychicScream.cd == 0 then
            if enemyHealer.distance <= 8 and enemyHealer.disorientDR >= 1 and TargetCheck(enemyHealer) and not enemyHealer.bcc and not enemyHealer.immuneCC then
                psychicScream:Cast()
            end
        end

        --psyFiend
        if TargetCheck(target) then
            if psyFiend:Castable(target) then
                if target.debuff(shadowWordPain.id, player) and target.debuff(vampiricTouch.id, player) then
                    psyFiend:Cast(target)
                end
            end
        end

        --mindGames
        if TargetCheck(target) and target.cc then
            if mindGames:Castable(target) then
                mindGames:Cast(target)
            end
        end


        --remove CC on healer
        if healer.cc and healer.stun ~= 408 and healer.disorient ~= 5246 and healer.incap ~= 6770 and healer.ccRemains >= 4 
        or healer.bcc and healer.stun ~= 408 and healer.disorient ~= 5246 and healer.incap ~= 6770 and healer.bccRemains >= 4 then
            if healer.distance < 40 then
                massDispel:SmartAoE(healer)
                if project.settings.allText then
                    awful.alert({
                        message = "massDispel on OUR HEALER",
                        texture = massDispel.id, 
                        duration = 3,
                    })
                end
            end
        end
		
        --Healer Chain
        --If no healer, cc dps
        if select(2,IsInInstance()) == "arena" and player.combat and project.settings.autoChainCCHealer then
            awful.enemies.loop(function(enemy)
                if enemy.healer then
                    healerCounter = 1
                end 
            end)
            if healerCounter == 0 then
                if target.melee or target.class2 == "HUNTER" then
                    if psychicHorror:Castable(target) and not target.cc and not target.silence then
                        psychicHorror:Cast(target)
                    end
                else
                    if silence:Castable(target) and not target.cc and not target.silence then
                        silence:Cast(target)    
                    end
                end
            end
            --if healer, chain healer
            if healerCounter == 1 and enemyHealer.combat and target.debuff(vampiricTouch.id, player) then
                if silence:Castable(enemyHealer) and not enemyHealer.cc and not enemyHealer.silence and not enemyHealer.bcc then
                    silence:Cast(enemyHealer)
                end
                if enemyHealer.stunDR >= 1 then 
                    if psychicHorror:Castable(enemyHealer) and not enemyHealer.cc and not enemyHealer.silence and not enemyHealer.bcc then
                        psychicHorror:Cast(enemyHealer)
                    end
                end
            end
        end  
        
        --voidBolt procs
        if TargetCheck(target) then
            if voidBolt:Castable(target) then
                voidBolt:Cast(target)
            end
        end

        --mindBlast procs
        if TargetCheck(target) then
            if mindBlast:Castable(target) and (player.buffStacks(mindMelt.id) >= 1 or player.buff(shadowyInsight.id)) then
                if target.debuff(shadowWordPain.id, player) and target.debuff(vampiricTouch.id, player) then
                    mindBlast:Cast(target)
                end
            end
        end

        --devouringPlague single target
        if TargetCheck(target) then
            if devouringPlague:Castable(target) and player.insanity >= 55 then
                devouringPlague:Cast(target)
            end
        end

		--dots
        awful.enemies.loop(function(enemy)
            if TargetCheck(enemy) then
                if damnation:Castable(enemy) then
                    if not enemy.debuff(shadowWordPain.id, player) and not enemy.debuff(vampiricTouch.id, player) then
                        damnation:Cast(enemy)
                    end
                end
                if shadowWordDeath:Castable(enemy) then
                    if enemy.hp <= 25 or player.buff(deathSpeaker.id) then
                        shadowWordDeath:Cast(enemy)
                    end
                end
                if vampiricTouch:Castable(enemy) then
                    if not enemy.debuff(vampiricTouch.id, player) or enemy.debuffRemains(vampiricTouch.id, player) < 5 then
                        vampiricTouch:Cast(enemy)
                    end
                end
                if devouringPlague:Castable(enemy) then
                    devouringPlague:Cast(enemy)
                end
                if shadowWordPain:Castable(enemy) then
                    if not enemy.debuff(shadowWordPain.id, player) or enemy.debuffRemains(shadowWordPain.id, player) < 5 then
                        shadowWordPain:Cast(enemy)
                    end
                end
            end
        end)

        --mindFlay procs
        if TargetCheck(target) then
            if mindFlay:Castable(target) and player.buff(mindFlayInsanity.id) then
                if target.debuff(shadowWordPain.id, player) and target.debuff(vampiricTouch.id, player) then
                    mindFlay:Cast(target)
                end
            end
        end

        --mindSpike procs
        if TargetCheck(target) then
            if mindSpike:Castable(target) and player.buffStacks(mindMelt.id) < 2 and player.buff(mindSpikeInsanity.id) then
                if target.debuff(shadowWordPain.id, player) and target.debuff(vampiricTouch.id, player) then
                    mindSpike:Cast(target)
                end
            end
        end

        --knock/freeze melee
        local total, melee, ranged, cooldowns = player.v2attackers()
        if melee > 0 then
            --psychicScream
            --[[
            if psychicScream.cd == 0 and psychicScream:Castable() then
                local count, total, objects = awful.enemies.around(player, 5)
                for i = 1, count do
                    local unit = objects[i]
                    if unit.melee and unit.disorientDR == 1 and TargetCheck(unit) and not unit.bcc and not unit.immuneCC then
                        psychicScream:Cast()
                    end
                end
            --voidTendrils
            else]]
            if voidTendrils.cd == 0 and voidTendrils:Castable() then
                local count, total, objects = awful.enemies.around(player, 5)
                for i = 1, count do
                    local unit = objects[i]
                    if (unit.melee or unit.pet) and unit.rootDR >= 0.5 and not unit.bcc and TargetCheck(unit) and not unit.buffFrom(cantRootOrKnock) and not unit.immuneCC then
                        voidTendrils:Cast()
                        if project.settings.allText then
                            awful.alert({
                                message = "Void Tendrils USED",
                                texture = voidTendrils.id, 
                                duration = 3,
                            })
                        end
                    end
                end
            end
        end

        --shadowClash
        if shadowClash:Castable(target) and target.distance < 40 and target.combat then
            shadowClash:SmartAoE(target, { movePredTime = 1 })
        end

        --shadowWordDeath single target 
        if TargetCheck(target)then 
            if shadowWordDeath:Castable(target) then
                if target.hp <= 25 or player.buff(deathSpeaker.id) then
                    shadowWordDeath:Cast(target)
                end
            end
        end

        --devouringPlague single target
        if TargetCheck(target) then
            if devouringPlague:Castable(target) then
                devouringPlague:Cast(target)
            end
        end

        --shadowWordPain single target
        if TargetCheck(target) then
            if shadowWordPain:Castable(target) then
                if not target.debuff(shadowWordPain.id, player) or target.debuffRemains(shadowWordPain.id, player) < 15 then
                    shadowWordPain:Cast(target)
                end
            end
        end

        --voidEruption
        if TargetCheck(target) then
            if voidEruption:Castable(target) then
                if target.debuff(shadowWordPain.id, player) and target.debuff(vampiricTouch.id, player) then
                    voidEruption:Cast(target)
                end
            end
        end
  
        --vampiricTouch single target
        if TargetCheck(target) then
            if vampiricTouch:Castable(target) then
                if not target.debuff(vampiricTouch.id, player) or target.debuffRemains(vampiricTouch.id, player) < 5 or player.buff(unfurlingDarkness.id) then
                    vampiricTouch:Cast(target)
                end
            end
        end

        --damnation single target
        if TargetCheck(target) then
            if damnation:Castable(target) then
                if not target.debuff(devouringPlague.id, player) then
                    damnation:Cast(target)
                end
            end
        end

        --mindBender
        if TargetCheck(target) then
            if mindBender:Castable(target) then
                if target.debuff(shadowWordPain.id, player) and target.debuff(vampiricTouch.id, player) then
                    mindBender:Cast(target)
                end
            end
        end

        --shadowfiend
        if TargetCheck(target) then
            if shadowFiend:Castable(target) then
                if target.debuff(shadowWordPain.id, player) and target.debuff(vampiricTouch.id, player) then
                    shadowFiend:Cast(target)
                end
            end
        end

        --darkAscension
        if TargetCheck(target) then
            if darkAscension:Castable(player) then
                if target.debuff(shadowWordPain.id, player) and target.debuff(vampiricTouch.id, player) then
                    darkAscension:Cast(player)
                end
            end
        end

        --mindGames
        if TargetCheck(target) then
            if mindGames:Castable(target) then
                if target.debuff(shadowWordPain.id, player) and target.debuff(vampiricTouch.id, player) then
                    mindGames:Cast(target)
                end
            end
        end

        --powerInfusion
        if project.settings.autoPowerInfusion then
            awful.friends.loop(function(friend)
                if not friend.isUnit(healer) and player.combat and target.los and target.distance < 40 then 
                    powerInfusion:Cast(friend)
                end
            end)
        end

        --voidTorrent
        if voidTorrent:Castable(target) then
            voidTorrent:Cast(target)
        end

        --mindSpike
        if TargetCheck(target) then
            if mindSpike:Castable(target) and player.buffStacks(mindMelt.id) < 2 then
                if target.debuff(shadowWordPain.id, player) and target.debuff(vampiricTouch.id, player) then
                    mindSpike:Cast(target)
                end
            end
        end

        --dispelMagic
        if player.manaPct >= 70 then
            if not WasCasting[dispelMagic.id] then
                awful.enemies.loop(function(enemy)  
                    if TargetCheck(enemy) then
                        if dispelMagic:Castable(enemy) then
                            if enemy.distance < dispelMagic.range then
                                if enemy.purgeCount > 0 then
                                    dispelMagic:Cast(enemy)
                                end
                            end
                        end
                    end
                end)
            end
        end

        --powerInfusion
        if project.settings.autoPowerInfusion then
            if TargetCheck(target) and player.combat then
                if powerInfusion:Castable() then
                    powerInfusion:Cast()
                end
            end
        end

        --mindFlay filler
        if TargetCheck(target) then
            if mindFlay:Castable(target) then
                if target.debuff(shadowWordPain.id, player) and target.debuff(vampiricTouch.id, player) then
                    mindFlay:Cast(target)
                end
            end
        end
    end
end)

C_Timer.After(0.5, function()
    awful.enabled = true
    awful.print("enabled")
end)