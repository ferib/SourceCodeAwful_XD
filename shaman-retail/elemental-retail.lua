--#region setup
local Unlocker, awful, project = ...
awful.DevMode = true
if WOW_PROJECT_ID == 11 then return end
if awful.player.spec == "Elemental" then awful.print(awful.player.spec) end
if awful.player.spec ~= "Elemental" then return end
local player, target, focus, healer, enemyHealer = awful.player, awful.target, awful.focus, awful.healer, awful.enemyHealer
local arena1, arena2, arena3 = awful.arena1, awful.arena2, awful.arena3
local party1, party2, party3, party4 = awful.party1, awful.party2, awful.party3, awful.party4
project.shaman = {}
project.shaman.elemental = awful.Actor:New({ spec = 1, class = "shaman" })
local elemental = project.shaman.elemental
elemental.ACTOR_TICKRATE = 0.02
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
local tremorList = {
    5782, -- 22).."Fear", value = 5782,},
    5484, -- 22).."Howl of Terror", value = 5484,},
    6358, -- 22).."Seduction", value = 6358,},
    6789, -- 22).."Mortal Coil", value = 6789,},
    360806, -- 22).."Sleep Walk", value = 360806,},
    8122, -- 22).."Psychic Scream", value = 8122},
}
--#endregion

--#region Spellbook
awful.Populate({
    --## EXCEPTIONS ## --
    frostShockReflect = NewSpell(196840, { targeted = true,  alwaysFace = true, ignoreMoving = true, ignoreCasting = true, ignoreGCD = true }),

    --## DAMAGE ##--
    crashLightning = NewSpell(187874, { damage = "magic", targeted = false, alwaysFace = true, ignoreMoving = true }),
    stormstrike = NewSpell(17364, { damage = "physical", targeted = true,  alwaysFace = true, }),
    windstrike = NewSpell(115356, { damage = "physical", targeted = true,  alwaysFace = true, }),
    lavaLash = NewSpell(60103, { damage = "magic", targeted = true,  alwaysFace = true, }),
    flameShock = NewSpell(188389, { damage = "magic", effect = "magic", targeted = true,  alwaysFace = true, ignoreMoving = true, }),
    frostShock = NewSpell(196840, { damage = "magic", effect = "magic", slow = true, targeted = true,  alwaysFace = true, ignoreMoving = true, }),
    earthShock = NewSpell(8042, { damage = "magic", targeted = true,  alwaysFace = true, ignoreMoving = true, }),
    lightningLasso = NewSpell(305483, { damage = "magic", effect = "physical", cc = "stun", targeted = true, alwaysFace = true, ignoreMoving = true, }),
    chainLightning = NewSpell(188443, { damage = "magic", targeted = true, alwaysFace = true, ignoreMoving = true }),
    lavaBeam = NewSpell(114074, { damage = "magic", targeted = true, alwaysFace = true, ignoreMoving = true }),
    lightningBolt = NewSpell(188196, { damage = "magic", targeted = true, alwaysFace = true, ignoreMoving = true }),
    lavaBurst = NewSpell(51505, { damage = "magic", targeted = true, alwaysFace = true, ignoreMoving = true }),
    elementalBlast = NewSpell(117014, { damage = "magic", targeted = true, alwaysFace = true, ignoreMoving = true }),
    staticDischarge = NewSpell(342243, { damage = "magic", targeted = true, alwaysFace = true, }),
    primordialWave = NewSpell(375982, { damage = "magic", effect = "magic", targeted = true,  alwaysFace = true, ignoreMoving = true, castById = true }),
    earthquake = NewSpell(61882, { effect = "magic", targeted = false, ignoreMoving = true, ignoreFacing = true, radius = 8, ignoreFriends = true }),
    primalStrike = NewSpell(73899, { damage = "magic", targeted = true, alwaysFace = true, ignoreMoving = true, }),
    feralSpirit = NewSpell(51533, { damage = "physical", targeted = false, ignoreMoving = true, ignoreFacing = true }),
    doomWinds = NewSpell(384252, { damage = "physical", targeted = true, ignoreMoving = true, alwaysFace = true}),
    sundering = NewSpell(197214, { damage = "magic", effect = "physical", cc = "incapacitate", targeted = false, alwaysFace = true, ignoreMoving = true, }),
    icefury = NewSpell(210714, { damage = "magic", targeted = true, alwaysFace = true, ignoreMoving = true }),
    fireNova = NewSpell(333974, { damage = "magic", targeted = false, ignoreFacing = true, ignoreMoving = true, }),

    --## INTERRUPTS ##--
    windShear = NewSpell(57994, { effect = "magic", targeted = true,  alwaysFace = true, ignoreGCD = true, ignoreCasting = true }),

    --## DISPELS ##--
    cleanseSpirit = NewSpell(51886, { beneficial = true, targeted = true, ignoreMoving = true, ignoreFacing = true }),

    --## PURGES ##--
    purge = NewSpell(370, { targeted = true, ignoreMoving = true, ignoreFacing = true }),
    greaterPurge = NewSpell(378773, { targeted = true, ignoreMoving = true, ignoreFacing = true }),

    --## MOBILITY ##--

    --## CC ##--
    hex = NewSpell(51514, { effect = "magic", cc = "incapacitate", targeted = true, ignoreFacing = true }),

    --## UTILITY ##--
    unleashShield = NewSpell(356736, { effect = "magic", targeted = true, ignoreMoving = true, alwaysFace = true,}),
    ghostWolf = NewSpell(2645, { beneficial = true, ignoreMoving = true, ignoreFacing = true, }),
    thunderstorm = NewSpell(51490, { castableInCC = true, ignoreMoving = true, ignoreFacing = true,}),
    spiritwalkersGrace = NewSpell(79206, { targeted = false, castableWhileChanneling = true, castableWhileCasting = true, ignoreGCD = true, ignoreMoving = true, ignoreFacing = true, }),
    astralShift = NewSpell(108271, { beneficial = true, ignoreMoving = true, ignoreFacing = true, }),
    burrow = NewSpell(409293, { beneficial = true, ignoreMoving = true, ignoreFacing = true, }),
    ascendance = NewSpell(114050, { beneficial = true, ignoreMoving = true, ignoreFacing = true, }),
    ancestralGuidance = NewSpell(108281, { beneficial = true, ignoreMoving = true, ignoreFacing = true, }),
    stormkeeper = NewSpell(191634, { beneficial = true, ignoreMoving = false, ignoreFacing = true }),
    heroism = NewSpell(32182, { beneficial = true, ignoreMoving = true, ignoreFacing = true }),
    bloodlust = NewSpell(2825, { beneficial = true, ignoreMoving = true, ignoreFacing = true }),
    shamanismA = NewSpell(204362, { beneficial = true, ignoreMoving = true, ignoreFacing = true }),
    shamanismH = NewSpell(204361, { beneficial = true, ignoreMoving = true, ignoreFacing = true }),
    naturesSwiftness = NewSpell(378081, { beneficial = true, ignoreMoving = true, ignoreFacing = true }),
    spiritWalk = NewSpell(58875, { beneficial = true, ignoreMoving = true, ignoreFacing = true, }),
    gustofWind = NewSpell(192063, { beneficial = true, ignoreMoving = true, ignoreFacing = true, }),
    feralLunge = NewSpell(196884, { targeted = true, ignoreMoving = true, alwaysFace = true, }),
    arenaPrep = NewSpell(32727),   
    bgPrep = NewSpell(44521),  

    --## WEAPONS ##--
    flametongueWeapon = NewSpell(318038, { beneficial = true }),
    windfuryWeapon = NewSpell(33757, { beneficial = true }),

    --## RESS ##--

    --## HEALS ##--
    chainHeal = NewSpell(1064, { targeted = true, heal = true, ignoreMoving = true }),
    healingSurge = NewSpell(8004, { targeted = true, heal = true, ignoreMoving = true }),

    --## SHIELDS ##--
    lightningShield = NewSpell(192106, { beneficial = true }),
    earthShield = NewSpell(974, { targeted = true, heal = true }),
    waterShield = NewSpell(52127, { beneficial = true }),

    --## PETS ##--
    earthElemental = NewSpell(198103, { beneficial = true, targeted = false, ignoreFacing = true }),
    fireElemental = NewSpell(198067, { beneficial = true, targeted = false, ignoreFacing = true }),
    stormElemental = NewSpell(192249, { beneficial = true, targeted = false, ignoreFacing = true, }),
    meteor = NewSpell(117588, { damage = "magic", targeted = true, ignoreFacing = true, }),
    tempest = NewSpell(157375, { damage = "magic", targeted = true, ignoreFacing = true, }),
    hardenSkin = NewSpell(118337, { ignoreFacing = true, }),

    --## TOTEMS ##--
    windfuryTotem = NewSpell(8512, { beneficial = true, ignoreMoving = true, ignoreFacing = true }),
    totemicProjection = NewSpell(108287, { beneficial = true, ignoreMoving = true, ignoreFacing = true, radius = 3,}),
    totemicProjectionLMT = NewSpell(108287, { beneficial = true, ignoreMoving = true, ignoreFacing = true, radius = 8, ignoreFriends = true}),
    totemicRecall = NewSpell(108285, { beneficial = true, ignoreMoving = true, ignoreFacing = true, }),
    healingStreamTotem = NewSpell(5394, { beneficial = true, ignoreMoving = true }),
    manaSpringTotem = NewSpell(381939, { beneficial = true, ignoreMoving = true }),
    vesperTotem = NewSpell(324386, { beneficial = true, ignoreMoving = true }),
    vesperTotemMove = NewSpell(324519, { beneficial = true, ignoreMoving = true }),
    windRushTotem = NewSpell(192077, { beneficial = true, ignoreMoving = true }),
    tremorTotem = NewSpell(8143, { beneficial = true, ignoreFacing = true, ignoreMoving = true }),
    skyfuryTotem = NewSpell(204330, { beneficial = true, ignoreMoving = true }),
    counterstrikeTotem = NewSpell(204331, { beneficial = true, ignoreMoving = true }),
    groundingTotem = NewSpell(204336, { beneficial = true, ignoreMoving = true, ignoreCasting = true, ignoreGCD = true}),
    stoneskinTotem = NewSpell(383017, { beneficial = true, ignoreMoving = true }),
    tranquilAirTotem = NewSpell(383019, { beneficial = true, ignoreMoving = true }),
    poisonCleansingTotem = NewSpell(383013, { beneficial = true, ignoreMoving = true }),
    liquidMagmaTotem = NewSpell(192222, { damage = "magic", targeted = false, ignoreFacing = true, ignoreMoving = true, radius = 8, ignoreFriends = true }),
    earthgrabTotem = NewSpell(51485, { effect = "magic", cc = "root", targeted = false, ignoreFacing = true, radius = 8, ignoreFriends = true }),
    earthbindTotem = NewSpell(2484, { effect = "magic", slow = true, targeted = false, ignoreFacing = true, radius = 8, ignoreFriends = true }),
    capacitorTotem = NewSpell(192058, { effect = "magic", cc = "stun", targeted = false, ignoreFacing = true, radius = 8, ignoreFriends = true }),
    staticFieldTotem = NewSpell(355580, { effect = "magic", targeted = false, ignoreFacing = true, radius = 8, ignoreFriends = true }),

    --## RACIALS ##--
    quakingPalm = NewSpell(107079, { effect = "physical", cc = "incapacitate", targeted = true, alwaysFace = true, ignoreMoving = true, }),
    bloodFury = NewSpell(33697, { beneficial = true }),
    warStomp = NewSpell(1234, { effect = "physical", cc = "stun", ignoreFacing = true }),
    berserking = NewSpell(26297, { beneficial = true }),
    rocketBarrage = NewSpell(69041, { damage = "magic", targeted = true, alwaysFace = true, ignoreMoving = true,}),
    rocketJump = NewSpell(69070, { beneficial = true }),
    bullRush = NewSpell(255654, { effect = "physical", cc = "stun", targeted = true, alwaysFace = true, ignoreMoving = true, }),
    ancestralCall = NewSpell(274738, { beneficial = true }),
    bagofTricksDirectDmg = NewSpell(312411, { damage = "magic", targeted = true, alwaysFace = true, ignoreMoving = true, }),
    fireblood = NewSpell(265221, { beneficial = true }),
    stoneform = NewSpell(20594, { beneficial = true }),
    haymaker = NewSpell(287712, { damage = "physical", effect = "physical", cc = "stun", targeted = true, alwaysFace = true, ignoreMoving = true, }),
    bagofTricksDirectHeal = NewSpell(312411, { heal = true, ignoreFacing = true, ignoreMoving = true, targeted = true }),
    giftoftheNaaru = NewSpell(59547, { heal = true, ignoreMoving = true }),
    regeneratin = NewSpell(291944, { heal = true }),
}, elemental, getfenv(1))
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
                if frostShock:Castable(enemy) and enemy.buffFrom(enemyReflect) then -- remove reflect
                    frostShock:Cast(enemy)
                end
                if unit.hp > 15 and enemy.hp < 15 and not enemy.buffFrom(totalimmunity) and not enemy.debuffFrom(totalimmunity) and not enemy.bcc and enemy.los and not enemy.buffFrom(enemyReflect) then
                    if earthShock:Castable(enemy) then
                        earthShock:Cast(enemy)
                    end
                    if lavaBurst:Castable(enemy) and player.buff(77762) and enemy.debuff(flameShock.id, player) then
                        lavaBurst:Cast(enemy)
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
            if uptime <= 0.5 then return end
            if frostShock:Castable(totem) then
                frostShock:Cast(totem)
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
    print(player.speed)
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

elemental:Init(function()
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

    --Interrupt
    if windShear.cd == 0 then
        awful.enemies.loop(function(enemy)
            if TargetCheck(enemy) then
                if windShear:Castable(enemy) and not enemy.casting8 and (castCheck(project.settings.interrupts, enemy.castID) and enemy.casting or castCheck(project.settings.interrupts, enemy.channelID) and enemy.channeling) then
                    C_Timer.After(0.5, function()
                        if windShear:Castable(enemy) and not enemy.casting8 and (castCheck(project.settings.interrupts, enemy.castID) and enemy.casting or castCheck(project.settings.interrupts, enemy.channelID) and enemy.channeling) then
                            if windShear:Cast(enemy) then
                                awful.alert({
                                    message = "Interrupting: "..enemy.name, 
                                    texture = windShear.id,
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
    if windShear.cd == 0 and enemyHealer.exists and LowestUnitEnemy.hp <= 30 and not LowestUnitEnemy.buffFrom(totalimmunity) and not LowestUnitEnemy.debuffFrom(totalimmunity) then
        if TargetCheck(enemyHealer) then
            if windShear:Castable(enemyHealer) and not enemyHealer.casting8 and (enemyHealer.casting or enemyHealer.channeling) then
                C_Timer.After(0.5, function()
                    if windShear:Castable(enemyHealer) and not enemyHealer.casting8 and (enemyHealer.casting or enemyHealer.channeling) then
                        if windShear:Cast(enemyHealer) then
                            awful.alert({
                                message = "Enemy is below 30% HP interrupting anything from HEALER", 
                                texture = windShear.id,
                                duration = 1,
                            })
                        end
                    end
                end)
            end
        end
    end

    --groundingTotem
    if groundingTotem.cd == 0 then
        awful.enemies.loop(function(enemy)
            if TargetCheck(enemy) then
                if groundingTotem:Castable() and (castCheck(project.settings.interrupts, enemy.castID) and enemy.casting or castCheck(project.settings.interrupts, enemy.channelID) and enemy.channeling) then
                    C_Timer.After(1, function()
                        if groundingTotem:Castable() and (castCheck(project.settings.interrupts, enemy.castID) and enemy.casting or castCheck(project.settings.interrupts, enemy.channelID) and enemy.channeling) then
                            if groundingTotem:Cast() then
                                awful.alert({
                                    message = "groundingTotem", 
                                    texture = groundingTotem.id,
                                    duration = 1,
                                })
                            end
                        end
                    end)
                end
            end
        end)
    end

    --tremorTotem
    if tremorTotem.cd == 0 and tremorTotem:Castable() and healer.distance <= 30 then
        if healer.debuffFrom(tremorList) then
            tremorTotem:Cast()
        end
    end

    --unleashShield
    if unleashShield.cd == 0 then
        awful.enemies.loop(function(enemy)
            if not enemy.dead then
                if enemy.player and not enemy.cc then
                    if enemy.speed > 25 then
                        if unleashShield:Castable(enemy) and not enemy.buffFrom(enemyReflect) then
                            unleashShield:Cast(enemy)
                        end
                    else
                        for _, id in pairs(leaps) do
                            if enemy.castID == id then
                                if unleashShield:Castable(enemy) and not enemy.buffFrom(enemyReflect) then
                                    unleashShield:Cast(enemy)    
                                end
                                break
                            end
                        end
                    end
                end
            end
        end)
    end

    --earthShield
    if not player.buff(383648) then
        earthShield:Cast()
    end

    --lightningShield
    if not player.buff(lightningShield.id) then
        lightningShield:Cast()
    end

    --flametongueWeapon
    if not player.buff(382028) then
        flametongueWeapon:Cast()
    end

    --PURGE
    if greaterPurge.cd == 0 then
        awful.enemies.loop(function(enemy)  
            if TargetCheck(enemy) then
                if greaterPurge:Castable(enemy) then
                    if enemy.distance < greaterPurge.range then
                        if enemy.purgeCount > 0 then
                            greaterPurge:Cast(enemy)
                        end
                    end
                end
            end
        end)
    end

    --DEFENSIVES
    if player.combat and not player.buff(arenaPrep.id) then
        if healthstone.cd == 0 and (player.hp <= 50 and not player.buff(obsidianScales.id) and not player.buff(renewingBlaze.id) or player.hp <= 30) then
            healthstone:Use()
        end
        if burrow.cd == 0 and player.hp <= project.settings.defensivesBurrow then
            burrow:Cast()
        end
        if astralShift.cd == 0 and player.hp <= project.settings.defensivesAstralShift then
            astralShift:Cast()
        end
        if healingStreamTotem.cd == 0 and player.hp <= project.settings.defensivesHealingStreamTotem then
            healingStreamTotem:Cast()
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

    --change current target on immunity
    if project.settings.autoTargetToggle then
        if target.enemy then
            if not TargetCheck(target) and player.castID ~= incinerate.id then
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

        if player.buff(77762) and target.debuff(flameShock.id, player) then --flameShock
            if lavaBurst:Castable(target) and TargetCheck(target) then
                lavaBurst:Cast(target)
            end
        end

        if player.buffStacks(381933) == 20 then --magma chamber
            if earthShock:Castable(target) then
                earthShock:Cast(target)
            end
        end

        if flameShock:Castable(target) then
            if not target.debuff(flameShock.id, player) or target.debuffRemains(flameShock.id, player) <= 2 then
                flameShock:Cast(target)
            end
        end

        if fireElemental.cd == 0 and player.combat then
            fireElemental:Cast()
        end

        --dots AOE
        awful.enemies.loop(function(enemy)
            if TargetCheck(enemy) and enemy.los then
                if flameShock:Castable(enemy) then
                    if not enemy.debuff(flameShock.id, player) or enemy.debuffRemains(flameShock.id, player) <= 2 then
                        flameShock:Cast(enemy)
                    end
                end
            end
        end)

        if primordialWave:Castable(target) then
            if target.debuff(flameShock.id, player) then
                primordialWave:Cast(target)
            end
        end

        --hex tyrant
        awful.tyrants.loop(function(tyrant)
             if tyrant.id == 135002 and tyrant.enemy and tyrant.disorientDR >= 0.2 and not tyrant.bcc and not tyrant.cc and (player.moving and player.buff(spiritwalkersGrace.id) or not player.moving) then
                if hex:Castable(tyrant) then
                    if hex:Cast(tyrant) then
                        awful.alert({
                        message = "CC tyrant",
                            texture = hex.id,
                            duration = 1,
                        })
                    end
                end
            end
        end)

        --hex
        if LowestUnit.hp >= 70 then
            if TargetCheck(enemyHealer) and enemyHealer.distance <= 25 then 
                if hex:Castable(enemyHealer) and enemyHealer.disorientDR >= 0.5 and totalenemyHealer == 0 and not enemyHealer.bcc and not enemyHealer.cc or totalenemyHealer == 0 and enemyHealer.disorientDR >= 0.2 and (enemyHealer.cc and enemyHealer.ccRemains <= hex.castTime or enemyHealer.bcc and enemyHealer.bccRemains <= hex.castTime) then
                    if not enemyHealer.debuffFrom(enemySleepImmune) and not enemyHealer.buffFrom(enemySleepImmune) and (player.moving and player.buff(spiritwalkersGrace.id) or not player.moving) then
                        if oppressingRoar.cd == 0 and enemyHealer.los then
                            player.face(enemyHealer)
                            oppressingRoar:Cast() 
                        end
                        if player.hasTalent(oppressingRoar.id) and oppressingRoar.cd >= 2 or not player.hasTalent(oppressingRoar.id) then
                            if hex:Cast(enemyHealer) then
                                awful.alert({
                                message = "CC enemyHealer",
                                    texture = hex.id,
                                    duration = 1,
                                })
                            end
                        end
                    end
                end
            end
        end

        if icefury:Castable(target) then
            icefury:Cast(target)
        end

        if player.buff(210714) and not target.debuff(382089) then --icefury buff and debuff
            if frostShock:Castable(target) then
                frostShock:Cast(target)
            end
        end
    end
end)

C_Timer.After(0.5, function()
    awful.enabled = true
    awful.print("enabled")
end)