--#region setup
local Unlocker, awful, project = ...
local player, target, focus, healer, enemyHealer = awful.player, awful.target, awful.focus, awful.healer, awful.enemyHealer
local demonicCircleTeleport = awful.Spell(48020, { beneficial = true, ignoreMoving = false, ignoreFacing = true })
local demonicCircle = awful.Spell(48018, { beneficial = true, ignoreMoving = false, ignoreFacing = true })
local hover = awful.Spell(358267, { beneficial = true, ignoreMoving = true })
local willToSurvive = awful.Spell(59752, { beneficial = true, ignoreControl = true })
local nilifyingShroud = awful.Spell(378464, { beneficial = true, ignoreFacing = false, ignoreMoving = true })
local divineSteed = awful.Spell(190784, { beneficial = true, ignoreFacing = false, ignoreMoving = true })
local queuedIn3s = false
local queuedIn2s = false
local timeNow = awful.time
local timeNowH = awful.time
local timeNowJump = awful.time
local dist = 0
local trinketNameBlue = GetItemInfo(205779)
local trinketNameEpic = GetItemInfo(205711)
local roll = awful.Spell(109132, { beneficial = true, targeted = false, ignoreFacing = true })
local chiTorpedo = awful.Spell(115008, { beneficial = true, targeted = false, ignoreFacing = true })
local divineShield = awful.Spell(642, { beneficial = true, ignoreControl = true })
local emeraldCommunion = awful.Spell(370960, { beneficial = true, ignoreFacing = true, ignoreControl = true, ignoreMoving = true })
local FieldMedicsHazardPayout = GetItemInfo(203724)
local VictoriousContendersStrongbox = GetItemInfo(201250)
local ShadowflameResidueSack = GetItemInfo(205423)
local LargeShadowflameResidueSack = GetItemInfo(205682)
local WhelplingsShadowflameCrestFragment = GetItemInfo(204075)
local WhelplingsShadowflameCrestFragmentItem = awful.Item(204075)
local mounted = false
local arena1, arena2, arena3 = awful.arena1, awful.arena2, awful.arena3
local party1, party2, party3 = awful.party1, awful.party2, awful.party3
local autoAttack = awful.Spell(6603, {damage = "physical"})
local shadowWordDeath = awful.Spell(32379, { damage = "magic", targeted = true, ignoreFacing = true, ignoreMoving = true, castableWhileChanneling = true, castableWhileCasting = true, ignoreCasting = true, ignoreChanneling = true })

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
    409293 --burrow
}

local totalimmunityMelee = {
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
    409293, --burrow
    1022 --bop
}

local closeFollow = {
    "Black Rook Hold Arena",
    "Enigma Crucible",
    "Empyrean Domain",
    "The Robodrome",
    "Dalaran Arena"
}

local disableMoveTo = {
    "Blade's Edge Arena",
    "Black Rook Hold Arena",
    "Mugambala",
    "Nagrand Arena",
    "Ashamane's Fall",
    "Nokhudon Proving Grounds",
    "Ruins of Lordaeron",
    "The Tiger's Peak",
    "Tol'viron Arena",
    "The Ring of Valor",
    "Maldraxxus Coliseum",
    "Hook Point"
}

local function table_contains(tbl, x)
    local found = false
    for _, v in pairs(tbl) do
        if v == x then 
            found = true 
        end
    end
    return found
end

--removed code here for opensource

local function isFistweaver()
    if player.class2 == "MONK" and player.hasTalent(388023) then
        return true
    else
        return false
    end
end

local function disableDontFollow()
    if not player.healer then return end
    if isFistweaver == true then return end
    project.settingsArenaBot.dontFollowFriend = false
end

local function swdCheck()
    if player.class2 ~= "PRIEST" then return end
    if not player.combat then return end
    if player.used(shadowWordDeath.id, 1.5) then
        return true
    else
        return false
    end
end

local function CCTrinket()
    if select(2,GetItemCooldown(205779)) <= 0 or select(2,GetItemCooldown(205711)) <= 0 then
        UseItemByName(trinketNameBlue)
        UseItemByName(trinketNameEpic)
    end
end

local antiafk = 0
local function AntiAfk()
    if project.settingsArenaBot.antiAfk then
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
        if project.settingsArenaBot.antiAfk and UnitIsAFK("player") then
            awful.call("JumpOrAscendStart")
        end
    end
end

local function gapCloser()
    local zoneNameV = GetZoneText()
    if target.exists and IsMounted() == false and player.combat and target.los then
        if isFistweaver() == true and target.distance >= 8 and not player.hasTalent(chiTorpedo.id) and zoneNameV ~= "Blade's Edge Arena" then
            if roll.charges >= 1 then 
		        player.face(target)
                roll:Cast()
            end
        elseif isFistweaver() == true and player.hasTalent(chiTorpedo.id) and target.distance >= 15 and zoneNameV ~= "Blade's Edge Arena" then
            if chiTorped.charges >= 1 then
		        player.face(target)
                chiTorpedo:Cast()
            end
	    elseif LowestUnit ~= nil and player.class2 == "PALADIN" and player.hasTalent(divineSteed.id) and LowestUnit.distance >= 55 and player.healer then
	        if divineSteed.charges >= 1 then
                divineSteed:Cast()
            end
        elseif player.class2 == "PALADIN" and player.hasTalent(divineSteed.id) and target.distance >= 15 then
            if divineSteed.charges >= 1 then
                divineSteed:Cast()
            end
        end
    end
end

local function bubbleLowFriend()
    if not player.class2 == "PALADIN" and not player.spec == "HOLY" then return end
    if select(2,GetItemCooldown(205779)) <= 0 or select(2,GetItemCooldown(205711)) <= 0 then return end
    if LowestUnit then
		if LowestUnit.isUnit(player) then return end
		if LowestHealth > 25 then return end
		if player.silence then return end
		if divineShield.cd > 0 then return end
		if player.cc and player.ccRemains >= 3 then
			divineShield:Cast()
		elseif player.bcc and player.bccRemains >= 3 then
			divineShield:Cast()
		end
	end
end

local function distanceToTarget()
    zoneName = GetZoneText()
    if player.class2 == "EVOKER" or player.healer and isFistweaver() == false then --not fistweaver
       dist = project.settingsArenaBot.healerRange
    elseif player.melee or isFistweaver() == true then --fistweaver or melee
        dist = 2
    else
       dist = 30
    end

    if not player.combat then
        if zoneName == "Black Rook Hold Arena" then
            dist = 0
        end
    else
        if player.class2 == "EVOKER" or player.healer and isFistweaver() == false then --fistweaver
            dist = project.settingsArenaBot.healerRange
        elseif player.melee or isFistweaver() == true then --fistweaver or melee
            dist = 2
        else
            dist = 30
        end
    end

    if zoneName == "Blade's Edge Arena" and not player.melee and isFistweaver() == false then 
        dist = 10
    end
end

--CCtrinket
local function autoTrinket()
    if player.class2 == "EVOKER" and player.buff(370960) and LowestUnit.distance < 40 then return end
    if swdCheck() == true then return end
    if not project.settingsArenaBot.autoCCTrinket then return end
    if (player.cc or player.bcc) and player.ccRemains >= 3 and player.combat then
        C_Timer.After(0.5, function()
            CCTrinket()
            willToSurvive:Cast()
        end)
    end
end

local function dontFollowFriend()
    if player.buff(32727) then return end
    if not project.settingsArenaBot.dontFollowFriend then return end
    if player.combat then return end
    if player.buff(32727) then return end
    if enemyHealer.exists and enemyHealer ~= nil then
        local path = awful.path(player, enemyHealer)
        path.draw()
        path.follow()
        if awful.time - timeNow > 1 then
            local x, y, z = enemyHealer.position()
            if x == nil or y == nil or z == nil then return end
            MoveTo(x, y, z,0)
            timeNow = awful.time
        end

        if enemyHealer ~= nil and (enemyHealer.distance >= dist or not enemyHealer.los) and not player.casting and not player.channeling and not player.channel8 then
            local path = awful.path(player, enemyHealer)
            path.draw()
            path.follow()
            return
        end
    else
        if arena1 ~= nil then
            local path = awful.path(player, arena1)
            path.draw()
            path.follow()
            if awful.time - timeNow > 1 then
                local x, y, z = arena1.position()
                if x == nil or y == nil or z == nil then return end
                MoveTo(x, y, z,0)
                timeNow = awful.time
            end

            if arena1 ~= nil and (arena1.distance >= dist or not arena1.los) and not player.casting and not player.channeling and not player.channel8 then
                local path = awful.path(player, arena1)
                path.draw()
                path.follow()
                return
            end
        elseif arena2 ~= nil then
            local path = awful.path(player, arena2)
            path.draw()
            path.follow()
            if awful.time - timeNow > 1 then
                local x, y, z = arena2.position()
                if x == nil or y == nil or z == nil then return end
                MoveTo(x, y, z,0)
                timeNow = awful.time
            end

            if arena2 ~= nil and (arena2.distance >= dist or not arena2.los) and not player.casting and not player.channeling and not player.channel8 then
                local path = awful.path(player, arena2)
                path.draw()
                path.follow()
                return
            end
        end
    end
    if player.distanceTo(target) <= dist then
        awful.call("Dismount")
        autoAttack:Cast(target)
    end
end

local function dontAttackHealer()
    if not project.settingsArenaBot.dontAttackHealer then return end
    if not player.combat then return end
    if not target.isUnit(enemyHealer) then return end
    LowestUnitEnemy = nil
    awful.call("ClearTarget")
end

local function avoidSolarBeam()
    --move out of solarbeam
    if player.debuff(81261) then
        awful.call("StrafeRightStart")
    elseif not player.debuff(81261) then
        awful.call("StrafeRightStop")
    end
end

local function autoJump()
    if not project.settingsArenaBot.autoJump then return end
    if player.channeling then return end
    if player.casting then return end
    if awful.time - timeNowJump < 2 then return end
    if not player.moving then return end
    local zoneName = GetZoneText()
    if zoneName ~= "Blade's Edge Arena" then
        awful.call("JumpOrAscendStart")
        timeNowJump = awful.time
    end
end

local function stopMovingAttack()
    if LowestUnitEnemy == nil then return end
    if not player.moving then return end
    if LowestUnitEnemy.distance > dist then return end
    if not LowestUnitEnemy.los then return end
    awful.call("MoveForwardStart")
    awful.call("MoveForwardStop")
end

local function stopMovingCast()
    if not player.casting then return end
    if not player.channeling or not player.channel8 then return end
    awful.call("MoveForwardStop")
end

local function faceTarget()
    if not target.enemy then return end
    if player.moving then return end
    if player.casting then return end
    if player.channeling then return end
    if player.channel8 then return end
    if target.playerFacing45 then return end
    player.face(target)
end

local function followFriend()
    if player.buff(32727) then return end
    if zoneName == "Black Rook Hold Arena" then return end
    if party1.combat or party2.combat or player.combat then return end
    if project.settingsArenaBot.dontFollowFriend then return end
    local dontFollowClass = {"ROGUE","MAGE","DRUID", "HUNTER"}
    local followDist = 15
    if table_contains(closeFollow, zoneName) then
        followDist = 0
    end
    if party1.exists and not party1.isUnit(player) and (not table_contains(dontFollowClass, party1.class2) or party1.combat) then
        if party1 ~= nil and not table_contains(disableMoveTo, zoneName) and party1.distance >= followDist and awful.time - timeNow > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
            local x, y, z = party1.position()
            if x == nil or y == nil or z == nil then return end
            MoveTo(x, y, z,0)
            timeNow = awful.time
        end
    
        --Move to party1
        if party1 ~= nil and (party1.distance >= followDist or not party1.los) and not player.casting and not player.channeling and not player.channel8 then
            local path = awful.path(player, party1)
            path.draw()
            path.follow()
            return
        end
    elseif party2.exists and not party2.isUnit(player) and (not table_contains(dontFollowClass, party2.class2) or party2.combat) then
        if party2 ~= nil and not table_contains(disableMoveTo, zoneName) and party2.distance >= followDist and awful.time - timeNow > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
            local x, y, z = party2.position()
            if x == nil or y == nil or z == nil then return end
            MoveTo(x, y, z,0)
            timeNow = awful.time
        end
        
        --Move to party2
        if party2 ~= nil and (party2.distance >= followDist or not party2.los) and not player.casting and not player.channeling and not player.channel8 then
            local path = awful.path(player, party2)
            path.draw()
            path.follow()
            return
        end
    elseif party1.exists and party1.isUnit(player) then
        if party2 ~= nil and not table_contains(disableMoveTo, zoneName) and party2.distance >= followDist and awful.time - timeNow > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
            local x, y, z = party2.position()
            if x == nil or y == nil or z == nil then return end
            MoveTo(x, y, z,0)
            timeNow = awful.time
        end
        
        --Move to party2
        if party2 ~= nil and (party2.distance >= followDist or not party2.los) and not player.casting and not player.channeling and not player.channel8 then
            local path = awful.path(player, party2)
            path.draw()
            path.follow()
            return
        end
    elseif party2.exists and party2.isUnit(player) then
        if party1 ~= nil and not table_contains(disableMoveTo, zoneName) and party1.distance >= followDist and awful.time - timeNow > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
            local x, y, z = party1.position()
            if x == nil or y == nil or z == nil then return end
            MoveTo(x, y, z,0)
            timeNow = awful.time
        end
    
        --Move to party1
        if party1 ~= nil and (party1.distance >= followDist or not party1.los) and not player.casting and not player.channeling and not player.channel8 then
            local path = awful.path(player, party1)
            path.draw()
            path.follow()
            return
        end
    end
end

local function rangedSetTarget()
    if isFistweaver == true then return end
    if player.melee then return end
    if player.healer then return end
    if not party1.combat and not party2.combat and not player.combat then return end
    targetTooFar = false
    if project.settingsArenaBot.dontAttackHealer then
        if not LowestUnitEnemy.buffFrom(totalimmunity) or not SecondLowestUnitEnemy.buffFrom(totalimmunity) then
            if not LowestUnitEnemy.isUnit(player) then
                if LowestUnitEnemy and LowestUnitEnemy.enemy and LowestUnitEnemy.distance < dist and LowestUnitEnemy.los and player.combat and not LowestUnitEnemy.bcc and not LowestUnitEnemy.buffFrom(totalimmunity) and not LowestUnitEnemy.healer then
                    LowestUnitEnemy.setTarget()
                elseif SecondLowestUnitEnemy and SecondLowestUnitEnemy.enemy and SecondLowestUnitEnemy.distance < dist and SecondLowestUnitEnemy.los and player.combat and not SecondLowestUnitEnemy.bcc and not SecondLowestUnitEnemy.buffFrom(totalimmunity) and not SecondLowestUnitEnemy.healer then
                    SecondLowestUnitEnemy.setTarget()
                else
                    targetTooFar = true
                end
            elseif arena1 ~= nil then
                arena1.setTarget()
                if arena1.distance > dist then
                    targetTooFar = true
                else
                    targetTooFar = false
                end
            elseif arena2 ~= nil then
                arena2.setTarget()
                if arena2.distance > dist then
                    targetTooFar = true
                else
                    targetTooFar = false
                end
            elseif arena3 ~= nil then
                arena3.setTarget()
                if arena3.distance > dist then
                    targetTooFar = true
                else
                    targetTooFar = false
                end
            end
        elseif ThirdLowestUnitEnemy and not ThirdLowestUnitEnemy.isUnit(player) and not ThirdLowestUnitEnemy.healer then
            if ThirdLowestUnitEnemy and ThirdLowestUnitEnemy.enemy and ThirdLowestUnitEnemy.distance < dist and ThirdLowestUnitEnemy.los and player.combat and not ThirdLowestUnitEnemy.bcc and not ThirdLowestUnitEnemy.buffFrom(totalimmunity) then
                ThirdLowestUnitEnemy.setTarget()
            end
        end
    end
    if not project.settingsArenaBot.dontAttackHealer then
        if not LowestUnitEnemy.buffFrom(totalimmunity) or not SecondLowestUnitEnemy.buffFrom(totalimmunity) then
            if LowestUnitEnemy ~= nil then
                if not LowestUnitEnemy.isUnit(player) then
                    if LowestUnitEnemy and LowestUnitEnemy.enemy and LowestUnitEnemy.distance < dist and LowestUnitEnemy.los and player.combat and not LowestUnitEnemy.bcc and not LowestUnitEnemy.buffFrom(totalimmunity) then
                        LowestUnitEnemy.setTarget()
                    elseif SecondLowestUnitEnemy and SecondLowestUnitEnemy.enemy and SecondLowestUnitEnemy.distance < dist and SecondLowestUnitEnemy.los and player.combat and not SecondLowestUnitEnemy.bcc and not SecondLowestUnitEnemy.buffFrom(totalimmunity) then
                        SecondLowestUnitEnemy.setTarget()
                    else
                        targetTooFar = true
                    end
                end
            elseif arena1 ~= nil then
                arena1.setTarget()
                if arena1.distance > dist then
                    targetTooFar = true
                else
                    targetTooFar = false
                end
            elseif arena2 ~= nil then
                arena2.setTarget()
                if arena2.distance > dist then
                    targetTooFar = true
                else
                    targetTooFar = false
                end
            elseif arena3 ~= nil then
                arena3.setTarget()
                if arena3.distance > dist then
                    targetTooFar = true
                else
                    targetTooFar = false
                end
            end
        elseif ThirdLowestUnitEnemy and not ThirdLowestUnitEnemy.isUnit(player)  then
            if ThirdLowestUnitEnemy and ThirdLowestUnitEnemy.enemy and ThirdLowestUnitEnemy.distance < dist and ThirdLowestUnitEnemy.los and player.combat and not ThirdLowestUnitEnemy.bcc and not ThirdLowestUnitEnemy.buffFrom(totalimmunity) then
                ThirdLowestUnitEnemy.setTarget()
            end
        end
    end
end

local function rangedMovementLowest()
    if not party1.combat and not party2.combat and not player.combat then return end
    if targetTooFar == false then return end
    if not player.isRanged then return end
    if isFistweaver() == true then return end
    if not target.exists then return end
    if target.buffFrom(totalimmunity) then return end

    if target ~= nil and target.exists and target.distance > dist and not player.buff(32727) and awful.time - timeNow > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
        local x, y, z = target.position()
        if x == nil or y == nil or z == nil then return end
        MoveTo(x, y, z,0)
        timeNow = awful.time
    end
    
    --Move to target
    if target ~= nil and target.distance > dist or not target.los and not player.casting and not player.channeling and not player.channel8 then
        if player.castID ~= 265187 and player.castID ~= 264119 and not target.debuff(80240, player) then -- 265187 tyrant and 264119 vile 80240 havoc
            local path = awful.path(player, target)
            path.draw()
            path.follow()
            return
        end
    end
end

local function meleeMovementLowestImmunity()
    if not party1.combat and not party2.combat and not player.combat then return end
    if not player.isMelee then return end
    if isFistweaver() == true then return end
    LowestEnemy()
    if LowestUnitEnemy == nil then return end
    if not LowestUnitEnemy.buffFrom(totalimmunityMelee) then return end
    if SecondLowestUnitEnemy ~= nil and SecondLowestUnitEnemy.exists and SecondLowestUnitEnemy.distance > dist and not player.buff(32727) and awful.time - timeNow > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
        local x, y, z = SecondLowestUnitEnemy.position()
        if x == nil or y == nil or z == nil then return end
        MoveTo(x, y, z,0)
        timeNow = awful.time
    end

    --Move to SecondLowestUnitEnemy
    if SecondLowestUnitEnemy ~= nil and SecondLowestUnitEnemy.distance > dist or not SecondLowestUnitEnemy.los and not player.casting and not player.channeling and not player.channel8 then
        local path = awful.path(player, SecondLowestUnitEnemy)
        path.draw()
        path.follow() 
        return
    end
end

local function burstOn()
    if not project.settingsArenaBot.autoBurst then return end
    if not player.combat then return end
    if player.distanceTo(Target) > dist then return end
    if not target.los then return end
    awful.call("RunMacroText", "/awful burst")
end

local function meleeMovementLowest()
    if not party1.combat and not party2.combat and not player.combat then return end
    if not player.isMelee then return end
    if isFistweaver() == true then return end
    LowestEnemy()
    if LowestUnitEnemy == nil then return end
    if LowestUnitEnemy.buffFrom(totalimmunityMelee) then return end
    if LowestUnitEnemy ~= nil and LowestUnitEnemy.exists and LowestUnitEnemy.distance > dist and not player.buff(32727) and awful.time - timeNow > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
        local x, y, z = LowestUnitEnemy.position()
        if x == nil or y == nil or z == nil then return end
        MoveTo(x, y, z,0)
        timeNow = awful.time
    end

    --Move to LowestUnitEnemy
    if LowestUnitEnemy ~= nil and LowestUnitEnemy.distance > dist or not LowestUnitEnemy.los and not player.casting and not player.channeling and not player.channel8 then
        local path = awful.path(player, LowestUnitEnemy)
        path.draw()
        path.follow() 
        return
    end
end

local function fwMovementLowest()
    if not party1.combat and not party2.combat and not player.combat then return end
    if isFistweaver() == false then return end
    if LowestUnitEnemy == nil then return end
    if LowestUnit == nil then
        if LowestUnitEnemy ~= nil and not table_contains(disableMoveTo, zoneName) and LowestUnitEnemy.exists and LowestUnitEnemy.distance > dist and not player.buff(32727) and awful.time - timeNow > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
            local x, y, z = LowestUnitEnemy.position()
            if x == nil or y == nil or z == nil then return end
            MoveTo(x, y, z,0)
            timeNow = awful.time
        end

        --Move to LowestUnitEnemy
        if LowestUnitEnemy ~= nil and LowestUnitEnemy.distance > dist or not LowestUnitEnemy.los and not player.casting and not player.channeling and not player.channel8 then
            if player.castID ~= 265187 and player.castID ~= 264119 and not LowestUnitEnemy.debuff(80240, player) then -- 265187 tyrant and 264119 vile 80240 havoc
                local path = awful.path(player, LowestUnitEnemy)
                path.draw()
                path.follow() 
                return
            end
        end
    else
        if LowestUnit.distanceTo(LowestUnitEnemy) <= 30 and not LowestUnitEnemy.buffFrom(totalimmunityMelee) then
            if LowestUnitEnemy ~= nil and not table_contains(disableMoveTo, zoneName) and LowestUnitEnemy.exists and LowestUnitEnemy.distance > dist and not player.buff(32727) and awful.time - timeNow > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
                local x, y, z = LowestUnitEnemy.position()
                if x == nil or y == nil or z == nil then return end
                MoveTo(x, y, z,0)
                timeNow = awful.time
            end

            --Move to LowestUnitEnemy
            if LowestUnitEnemy ~= nil and LowestUnitEnemy.distance > dist or not LowestUnitEnemy.los and not player.casting and not player.channeling and not player.channel8 then
                if player.castID ~= 265187 and player.castID ~= 264119 and not LowestUnitEnemy.debuff(80240, player) then -- 265187 tyrant and 264119 vile 80240 havoc
                    local path = awful.path(player, LowestUnitEnemy)
                    path.draw()
                    path.follow() 
                    return
                end
            end
        elseif not SecondLowestUnitEnemy.buffFrom(totalimmunityMelee) then
            if SecondLowestUnitEnemy ~= nil and not table_contains(disableMoveTo, zoneName) and SecondLowestUnitEnemy.exists and SecondLowestUnitEnemy.distance > dist and not player.buff(32727) and awful.time - timeNow > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
                local x, y, z = SecondLowestUnitEnemy.position()
                if x == nil or y == nil or z == nil then return end
                MoveTo(x, y, z,0)
                timeNow = awful.time
            end
    
            --Move to SecondLowestUnitEnemy
            if SecondLowestUnitEnemy ~= nil and SecondLowestUnitEnemy.distance > dist or not SecondLowestUnitEnemy.los and not player.casting and not player.channeling and not player.channel8 then
                local path = awful.path(player, SecondLowestUnitEnemy)
                path.draw()
                path.follow()
                return
            end
        elseif not ThirdLowestUnitEnemy.isUnit(player) and not ThirdLowestUnitEnemy.buffFrom(totalimmunityMelee) then
            if ThirdLowestUnitEnemy ~= nil and not table_contains(disableMoveTo, zoneName) and ThirdLowestUnitEnemy.exists and ThirdLowestUnitEnemy.distance > dist and not player.buff(32727) and awful.time - timeNow > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
                local x, y, z = ThirdLowestUnitEnemy.position()
                if x == nil or y == nil or z == nil then return end
                MoveTo(x, y, z,0)
                timeNow = awful.time
            end

            --Move to ThirdLowestUnitEnemy
            if ThirdLowestUnitEnemy ~= nil and ThirdLowestUnitEnemy.distance > dist or not ThirdLowestUnitEnemy.los and not player.casting and not player.channeling and not player.channel8 then
                local path = awful.path(player, ThirdLowestUnitEnemy)
                path.draw()
                path.follow() 
                return
            end
        end
    end
end

local function lowestUnitCheck()
    if LowestUnit.isUnit(player) then
        LowestUnit = SecondLowestUnit
    end
end

local function nilShroud()
    if player.class2 ~= "EVOKER" then return end
    if nilifyingShroud.cd > 0 then return end
    if player.combat then return end
    if nilifyingShroud:Castable() then
        nilifyingShroud:Cast()
    end
    if mounted == false and not player.combat and project.settingsArenaBot.autoMount and project.settingsArenaBot.arenaBot and not player.moving and not player.casting then
        C_Timer.After(5, function()
            C_MountJournal.SummonByID(0)
        end)
        mounted = true
    end
end

local function evokerHover()
    if player.class2 ~= "EVOKER" then return end
    if hover.cd > 0 then return end
    if player.buff(hover.id) then return end
    if player.buff(32727) then return end
    if player.casting then return end
    if player.channeling then return end
    if not player.combat and not LowestUnit.combat then return end
    if zoneName == "Blade's Edge Arena" and not player.moving then
        if not LowestUnit.isUnit(player) then 
            player.face(LowestUnit)
        end
        hover:Cast()
    elseif zoneName ~= "Blade's Edge Arena" and player.moving then
        if not LowestUnit.isUnit(player) then 
            player.face(LowestUnit)
        end
        hover:Cast()
    end
end

local function healerStopMoving()
    if not party1.combat and not party2.combat and not player.combat then return end
    if LowestUnit == nil then return end
    if not player.moving then return end
    if LowestUnit.distance > dist then return end
    if not LowestUnit.los then return end
    if player.buff(emeraldCommunion.id) then return end
    awful.call("MoveForwardStart")
    awful.call("MoveForwardStop")
end

local function stopMovingCastHealer()
    if not player.casting and not player.channeling and not player.channel8 then return end
    if player.buff(emeraldCommunion.id) then return end
    if zoneName == "Blade's Edge Arena" and player.castID ~= nilifyingShroud.id then return end
    awful.call("MoveForwardStop")
end

local function healerFollowFriend()
    if player.buff(32727) then return end
    if zoneName == "Black Rook Hold Arena" then return end
    if party1.combat or party2.combat or player.combat then return end
    local dontFollowClass = {"ROGUE","MAGE","DRUID", "HUNTER"}
    local followDist = 15
    if table_contains(closeFollow, zoneName) then
        followDist = 0
    end
    if party1.exists and not party1.isUnit(player) and (not table_contains(dontFollowClass, party1.class2) or party1.combat) then
        if party1 ~= nil and not table_contains(disableMoveTo, zoneName) and party1.distance >= followDist and awful.time - timeNowH > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
            local x, y, z = party1.position()
            if x == nil or y == nil or z == nil then return end
            MoveTo(x, y, z,0)
            timeNowH = awful.time
        end
    
        --Move to party1
        if party1 ~= nil and (party1.distance >= followDist or not party1.los) and not player.casting and not player.channeling and not player.channel8 then
            local path = awful.path(player, party1)
            path.draw()
            path.follow()
            return
        end
    elseif party2.exists and not party2.isUnit(player) and (not table_contains(dontFollowClass, party2.class2) or party2.combat) then
        if party2 ~= nil and not table_contains(disableMoveTo, zoneName) and party2.distance >= followDist and awful.time - timeNowH > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
            local x, y, z = party2.position()
            if x == nil or y == nil or z == nil then return end
            MoveTo(x, y, z,0)
            timeNowH = awful.time
        end
        
        --Move to party2
        if party2 ~= nil and (party2.distance >= followDist or not party2.los) and not player.casting and not player.channeling and not player.channel8 then
            local path = awful.path(player, party2)
            path.draw()
            path.follow()
            return
        end
    elseif party1.exists and not party1.isUnit(player) then
        if party1 ~= nil and not table_contains(disableMoveTo, zoneName) and party1.distance >= followDist and awful.time - timeNowH > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
            local x, y, z = party1.position()
            if x == nil or y == nil or z == nil then return end
            MoveTo(x, y, z,0)
            timeNowH = awful.time
        end
    
        --Move to party1
        if party1 ~= nil and (party1.distance >= followDist or not party1.los) and not player.casting and not player.channeling and not player.channel8 then
            local path = awful.path(player, party1)
            path.draw()
            path.follow()
            return
        end
    elseif party2.exists and not party2.isUnit(player) then
        if party2 ~= nil and not table_contains(disableMoveTo, zoneName) and party2.distance >= followDist and awful.time - timeNowH > 1 and not player.combat and not player.casting and not player.channeling and not player.channel8 then
            local x, y, z = party2.position()
            if x == nil or y == nil or z == nil then return end
            MoveTo(x, y, z,0)
            timeNowH = awful.time
        end
        
        --Move to party2
        if party2 ~= nil and (party2.distance >= followDist or not party2.los) and not player.casting and not player.channeling and not player.channel8 then
            local path = awful.path(player, party2)
            path.draw()
            path.follow()
            return
        end
    end
end

local function healerMoveTo()
    if not party1.combat and not party2.combat and not player.combat then return end
    if IsMounted() == true then
        awful.call("Dismount")
    end
    if LowestUnit == nil then return end
    --MoveTo LowestUnit 
    if LowestUnit.distance >= dist and awful.time - timeNow > 1 and zoneName ~= "Mugambala" then
        if not player.casting and not player.channeling and not player.channel8 then
            local x, y, z = LowestUnit.position()
            if x == nil or y == nil or z == nil then return end
            MoveTo(x, y, z,0)
            timeNow = awful.time
        end
    end

    --Move to LowestUnit
    if (LowestUnit.distance >= dist or not LowestUnit.los) and not player.buff(32727) then 
        if (not player.casting or zoneName == "Black Rook Hold Arena" and player.castID == nilifyingShroud.id) and not player.channeling and not player.channel8 or player.buff(emeraldCommunion.id) then
            local path = awful.path(player, LowestUnit)
            path.draw()
            path.follow()
            return
        end
    end
end

local function prepBRHA()
    if not player.buff(32727) then return end
    if player.moving then return end
    if zoneName ~= "Black Rook Hold Arena" then return end

    brha = math.random(1,2)
    --Side 1
    if player.distanceTo(1372.1285400391,1247.1910400391,32.103939056396) <= 19 then
        if brha == 1 then
            MoveTo(1383.1468505859,1228.9708251953,33.254123687744)
        elseif brha == 2 then
            MoveTo(1382.4438476562,1261.4749755859,33.250583648682)
        end
    end
    --side 2
    if player.distanceTo(1472.6961669922,1275.1579589844,32.110370635986) <= 19 then
        if brha == 1 then
            MoveTo(1467.3065185547,1252.9398193359,33.226348876953)
        elseif brha == 2 then
            MoveTo(1450,2937011719,1280.4202880859,33.254543304443)
        end
    end
end

local function unstuckBRHADps()
    if player.healer then return end
    if player.buff(32727) then return end
    if not player.combat then return end
    if target.los then return end
    if zoneName ~= "Black Rook Hold Arena" then return end
    --side 1
    if player.distanceTo(1372.1285400391,1247.1910400391,32.103939056396) < 13 then
        if player.distanceTo(1383.1468505859,1228.9708251953,33.254123687744) < player.distanceTo(1382.4438476562,1261.4749755859,33.250583648682) then
            if player.distanceTo(1383.1468505859,1228.9708251953,33.254123687744) > 3 then
                path = awful.path(player, 1383.1468505859,1228.9708251953,33.254123687744)
                path.draw()
                path.follow()
            end
        elseif player.distanceTo(1382.4438476562,1261.4749755859,33.250583648682) < player.distanceTo(1383.1468505859,1228.9708251953,33.254123687744) then
            if player.distanceTo(1383.1468505859,1228.9708251953,33.254123687744) > 3 then
                path = awful.path(player, 1383.1468505859,1228.9708251953,33.254123687744)
                path.draw()
                path.follow()
            end
        end
    end
    --side 2
    if player.distanceTo(1472.6961669922,1275.1579589844,32.110370635986) < 18 then
        if player.distanceTo(1467.3065185547,1252.9398193359,33.226348876953) < player.distanceTo(1450.2937011719,1280.4202880859,33.254543304443) then
            if player.distanceTo(1467.3065185547,1252.9398193359,33.226348876953) > 3 then
                path = awful.path(player, 1467.3065185547,1252.9398193359,33.226348876953)
                path.draw()
                path.follow()
            end
        elseif player.distanceTo(1450.2937011719,1280.4202880859,33.254543304443) < player.distanceTo(1467.3065185547,1252.9398193359,33.226348876953) then
            if player.distanceTo(1450.2937011719,1280.4202880859,33.254543304443) > 3 then
                path = awful.path(player, 1450.2937011719,1280.4202880859,33.254543304443)
                path.draw()
                path.follow()
            end
        end
    end
end

local function unstuckBRHAHealer()
    if player.buff(32727) then return end
    if not player.combat then return end
    if not player.healer then return end
    if isFistweaver == true then return end
    if LowestUnit.los then return end
    if zoneName ~= "Black Rook Hold Arena" then return end
    --side 1
    if player.distanceTo(1372.1285400391,1247.1910400391,32.103939056396) < 13 then
        if player.distanceTo(1383.1468505859,1228.9708251953,33.254123687744) < player.distanceTo(1382.4438476562,1261.4749755859,33.250583648682) then
            if player.distanceTo(1383.1468505859,1228.9708251953,33.254123687744) > 3 then
                path = awful.path(player, 1383.1468505859,1228.9708251953,33.254123687744)
                path.draw()
                path.follow()
            end
        elseif player.distanceTo(1382.4438476562,1261.4749755859,33.250583648682) < player.distanceTo(1383.1468505859,1228.9708251953,33.254123687744) then
            if player.distanceTo(1383.1468505859,1228.9708251953,33.254123687744) > 3 then
                path = awful.path(player, 1383.1468505859,1228.9708251953,33.254123687744)
                path.draw()
                path.follow()
            end
        end
    end
    --side 2
    if player.distanceTo(1472.6961669922,1275.1579589844,32.110370635986) < 18 then
        if player.distanceTo(1467.3065185547,1252.9398193359,33.226348876953) < player.distanceTo(1450.2937011719,1280.4202880859,33.254543304443) then
            if player.distanceTo(1467.3065185547,1252.9398193359,33.226348876953) > 3 then
                path = awful.path(player, 1467.3065185547,1252.9398193359,33.226348876953)
                path.draw()
                path.follow()
            end
        elseif player.distanceTo(1450.2937011719,1280.4202880859,33.254543304443) < player.distanceTo(1467.3065185547,1252.9398193359,33.226348876953) then
            if player.distanceTo(1450.2937011719,1280.4202880859,33.254543304443) > 3 then
                path = awful.path(player, 1450.2937011719,1280.4202880859,33.254543304443)
                path.draw()
                path.follow()
            end
        end
    end
end

local function unstuckBRHAFw()
    if isFistweaver == false then return end
    if player.buff(32727) then return end
    if not player.combat then return end
    if target.los then return end
    if zoneName ~= "Black Rook Hold Arena" then return end
    --side 1
    if player.distanceTo(1372.1285400391,1247.1910400391,32.103939056396) < 13 then
        if player.distanceTo(1383.1468505859,1228.9708251953,33.254123687744) < player.distanceTo(1382.4438476562,1261.4749755859,33.250583648682) then
            if player.distanceTo(1383.1468505859,1228.9708251953,33.254123687744) > 3 then
                path = awful.path(player, 1383.1468505859,1228.9708251953,33.254123687744)
                path.draw()
                path.follow()
            end
        elseif player.distanceTo(1382.4438476562,1261.4749755859,33.250583648682) < player.distanceTo(1383.1468505859,1228.9708251953,33.254123687744) then
            if player.distanceTo(1383.1468505859,1228.9708251953,33.254123687744) > 3 then
                path = awful.path(player, 1383.1468505859,1228.9708251953,33.254123687744)
                path.draw()
                path.follow()
            end
        end
    end
    --side 2
    if player.distanceTo(1472.6961669922,1275.1579589844,32.110370635986) < 18 then
        if player.distanceTo(1467.3065185547,1252.9398193359,33.226348876953) < player.distanceTo(1450.2937011719,1280.4202880859,33.254543304443) then
            if player.distanceTo(1467.3065185547,1252.9398193359,33.226348876953) > 3 then
                path = awful.path(player, 1467.3065185547,1252.9398193359,33.226348876953)
                path.draw()
                path.follow()
            end
        elseif player.distanceTo(1450.2937011719,1280.4202880859,33.254543304443) < player.distanceTo(1467.3065185547,1252.9398193359,33.226348876953) then
            if player.distanceTo(1450.2937011719,1280.4202880859,33.254543304443) > 3 then
                path = awful.path(player, 1450.2937011719,1280.4202880859,33.254543304443)
                path.draw()
                path.follow()
            end
        end
    end
end

local function ArenaBot()
    if player.dead then return end
    if GetBattlefieldWinner() ~= nil then return end
    if select(2,IsInInstance()) ~= "arena" then return end
    Lowest()
    LowestEnemy()
    prepBRHA()
    unstuckBRHADps()
    unstuckBRHAFw()
    distanceToTarget()
    autoTrinket()
    gapCloser()
    bubbleLowFriend()
    followFriend()
    dontAttackHealer()
    avoidSolarBeam()
    autoJump()
    stopMovingAttack()
    stopMovingCast()
    faceTarget()
    dontFollowFriend()
    rangedSetTarget()
    rangedMovementLowest()
    meleeMovementLowestImmunity()
    meleeMovementLowest()
    fwMovementLowest()
    burstOn()
end

local function ArenaBotHealer()
    if player.dead then return end
    zoneName = GetZoneText()
    if GetBattlefieldWinner() ~= nil then return end
    if select(2,IsInInstance()) ~= "arena" then return end
    disableDontFollow()
    Lowest()
    lowestUnitCheck()
    prepBRHA()
    unstuckBRHAHealer()
    unstuckBRHAFw()
    distanceToTarget()
    autoTrinket()
    gapCloser()
    bubbleLowFriend()
    nilShroud()
    evokerHover()
    autoJump()
    avoidSolarBeam()
    healerStopMoving()
    stopMovingCastHealer()
    healerFollowFriend()
    healerMoveTo()
end

local function NeedsRepair()
    for i = 1, 18 do -- Iterate through the item slots that can have armor equipped
        local itemLink = GetInventoryItemLink("player", i)
        local current, max = GetInventoryItemDurability(i)

        if itemLink and current and max then
            -- If durability is less than 100%, armor needs repair
            if current < max then
                return true
            end
        end
    end

    return false -- All equipped gear is fully repaired
end

local function repairNow()
    if NeedsRepair() == false then return end
    local repairVendor = awful.units.find(function(obj) return obj.id == 193659 end)
    if repairVendor == nil then return end
    
    awful.alert("Your equipped gear needs repair!")

    local path = awful.path(player, repairVendor)
    path.draw()
    path.follow()
    if repairVendor.distance <= 1 then
        if Unlocker.type == "daemonic" then
            Interact(repairVendor.pointer)
        else
            ObjectInteract(repairVendor.pointer)
        end
        local info = C_GossipInfo.GetOptions()
	    for i, v in pairs(info) do
	        C_GossipInfo.SelectOption(v.gossipOptionID)
	    end

        RepairAllItems(false)
    end
end


local alerted = 0
awful.addUpdateCallback(function()
    AntiAfk()
    local zoneName = GetZoneText()
    if project.settingsArenaBot.arenaBot and project.settingsArenaBot.autoRepair and select(2,IsInInstance()) == "none" and zoneName == "Valdrakken" then
        repairNow()
    end
    if project.settingsArenaBot.arenaBot and select(2,IsInInstance()) == "arena" then
        if player.healer and not player.hasTalent(388023) then --fistweaver
            ArenaBotHealer()
        else
            ArenaBot()
        end
    end
    if project.settingsArenaBot.queueSoloShuffle and select(2,IsInInstance()) == "none" then
        local battlefieldStatus = GetBattlefieldStatus(1)
        if battlefieldStatus == "confirm" then
            if awful.time - alerted > 3 then
                PlaySound(5775, "Master")
                alerted = awful.time
            end
            if GetBattlefieldPortExpiration(1) > 10 then return end
        end
        if GetBattlefieldPortExpiration(1) > 8 and project.settingsArenaBot.arenaBot then
            awful.call("AcceptBattlefieldPort", 0, true)
            awful.call("AcceptBattlefieldPort", 1, true)
            awful.call("AcceptBattlefieldPort", 2, true)
        end
        local battlefieldStatus = GetBattlefieldStatus(1)
        if select(2,IsInInstance()) ~= "arena" and GetBattlefieldTimeWaited(1) == 0 and battlefieldStatus ~= "confirm" and not player.debuff(368798) then
            awful.call("JoinRatedSoloShuffle")
        end
    end
    if project.settingsArenaBot.queueSkirmish and select(2,IsInInstance()) == "none" then
        awful.call("AcceptBattlefieldPort", 0, true)
        awful.call("AcceptBattlefieldPort", 1, true)
        awful.call("AcceptBattlefieldPort", 2, true)
        local battlefieldStatus = GetBattlefieldStatus(1)
        if select(2,IsInInstance()) ~= "arena" and GetBattlefieldTimeWaited(1) == 0 and battlefieldStatus ~= "confirm" and not player.debuff(368798) then
            JoinSkirmish(4, false)
        end
    end
    if project.settingsArenaBot.queue3Arena and select(2,IsInInstance()) == "none" then
        awful.call("AcceptBattlefieldPort", 0, true)
        awful.call("AcceptBattlefieldPort", 1, true)
        awful.call("AcceptBattlefieldPort", 2, true)
        local battlefieldStatus = GetBattlefieldStatus(1)
        if select(2,IsInInstance()) ~= "pvp" and GetBattlefieldTimeWaited(0) == 0 and battlefieldStatus ~= "confirm" and not player.debuff(368798) and queuedIn3s == false then
            awful.call("JoinArena")
            queuedIn3s = true
        end
    end
    if project.settingsArenaBot.queue2Arena and select(2,IsInInstance()) == "none" then
        awful.call("AcceptBattlefieldPort", 0, true)
        awful.call("AcceptBattlefieldPort", 1, true)
        awful.call("AcceptBattlefieldPort", 2, true)
        local battlefieldStatus = GetBattlefieldStatus(1)
        if select(2,IsInInstance()) ~= "pvp" and GetBattlefieldTimeWaited(0) == 0 and battlefieldStatus ~= "confirm" and not player.debuff(368798) and queuedIn2s == false then
            awful.call("JoinArena")
            queuedIn2s = true
        end
    end
    if project.settingsArenaBot.arenaBot then
        local function eventTrace(self,event,...)
            if (event == "PVP_MATCH_COMPLETE" or event == "PVP_RATED_STATS_UPDATE") and project.settingsArenaBot.autoLeave then
                C_Timer.After(10, function()
                    if PVPMatchResults and PVPMatchResults:IsShown() then
                        if PVPMatchResults.buttonContainer.leaveButton then
                            PVPMatchResults.buttonContainer.leaveButton:Click()
                        end
                    end
                    queuedIn3s = false
                    queuedIn2s = false
                end)
            end
            if event == "LFG_ROLE_CHECK_UPDATE" then
                CompleteLFGRoleCheck(true)
            end
        end

        Events = CreateFrame("Frame")
        local function RegisterEvents(self, ...)
	        for i=1,select('#', ...) do
		        self:RegisterEvent(select(i, ...))
	        end
        end
        Events.RegisterEvents = RegisterEvents
        Events:RegisterEvents("PVP_MATCH_COMPLETE")
        Events:RegisterEvents("PVP_RATED_STATS_UPDATE")
        Events:RegisterEvent("LFG_ROLE_CHECK_UPDATE")
        Events:SetScript("OnEvent", eventTrace)
    end
    if project.settingsArenaBot.autoBox and select(2,IsInInstance()) == "none" and not player.casting and not player.dead and not player.mounted then 
        UseItemByName(FieldMedicsHazardPayout)
        UseItemByName(VictoriousContendersStrongbox)
        if select(2,GetItemCooldown(205423)) <= 0 or select(2,GetItemCooldown(205682)) <= 0 or select(2,GetItemCooldown(204075)) <= 0 then
            UseItemByName(ShadowflameResidueSack)
            UseItemByName(LargeShadowflameResidueSack)
            if WhelplingsShadowflameCrestFragmentItem.count >= 15 and not player.moving then
                UseItemByName(WhelplingsShadowflameCrestFragment)
            end
        end
        --Loot
        if LootFrame and LootFrame:IsVisible() then
            for i = 1, GetNumLootItems() do
                if LootSlotHasItem(i) then
                    LootSlot(i)
                    ConfirmLootSlot(i)
                    CloseLoot()
                end
            end
        end
    end
    if project.settingsArenaBot.autoMount and project.settingsArenaBot.arenaBot then
        if IsMounted() == false and not player.combat and player.buff(32727) then
            if mounted == false then
                C_Timer.After(5, function()
                    if player.moving then
                        awful.call("MoveForwardStart")
                        awful.call("MoveForwardStop")
                    end
                    C_MountJournal.SummonByID(0)
                end)
                mounted = true
            end
        end
        if IsMounted() == true and (player.combat or target.combat or awful.party1.combat or awful.party2.combat) then
            awful.call("Dismount")
            mounted = false
        end
    end
end)
C_Timer.After(0.5, function()
    awful.enabled = true
    awful.print("Enabled New Arena Bot")
end)
