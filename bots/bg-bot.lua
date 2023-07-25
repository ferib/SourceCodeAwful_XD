--#region setup
local Unlocker, awful, project = ...
local player, target, focus, healer, enemyHealer = awful.player, awful.target, awful.focus, awful.healer, awful.enemyHealer
local timeNow = awful.time
local timeNowJump = awful.time
local dist = 0
local trinketNameBlue = GetItemInfo(205779)
local trinketNameEpic = GetItemInfo(205711)
local willToSurvive = awful.Spell(59752, { beneficial = true, ignoreControl = true })
local roll = awful.Spell(109132, { beneficial = true, targeted = false, ignoreFacing = true })
local chiTorpedo = awful.Spell(115008, { beneficial = true, targeted = false, ignoreFacing = true })
local divineSteed = awful.Spell(190784, { beneficial = true, targeted = false, ignoreFacing = true })

if player.class2 == "EVOKER" then
   dist = 15
elseif player.melee or (player.class2 == "MONK" and player.hasTalent(388023)) then
   dist = 2
else
   dist = 30
end

local function CCTrinket()
    if select(2,GetItemCooldown(205779)) <= 0 or select(2,GetItemCooldown(205711)) <= 0 then
        UseItemByName(trinketNameBlue)
        UseItemByName(trinketNameEpic)
    end
end

local antiafk = 0
local function AntiAfk()
    if project.settingsBGBOT.antiAfk then
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
        if project.settingsBGBOT.antiAfk and UnitIsAFK("player") then
            awful.call("JumpOrAscendStart")
        end
    end
end

--removed code from opensource

local function gapCloser()
    if dist ~= 2 then return end
    if target.exists and target.distance >= 10 and not target.meleeRange and IsMounted() == false and player.combat and target.los then
        if player.class2 == "MONK" and player.hasTalent(388023) and not player.hasTalent(chiTorpedo.id) then
            if roll.charges >= 1 then 
		    player.face(target)
                roll:Cast()
            end
            elseif player.class2 == "MONK" and player.hasTalent(388023) and player.hasTalent(chiTorpedo.id) and target.distance >= 15 then
            if chiTorped.charges >= 1 then
		    player.face(target)
                chiTorpedo:Cast()
            end
	        elseif LowestUnit.exists and player.class2 == "PALADIN" and player.hasTalent(divineSteed.id) and LowestUnit.distance >= 55 and player.healer then
	        if divineSteed.charges >= 1 then
                divineSteed:Cast()
            end 
        end
    end
end

local function BGbot()
    if select(2,IsInInstance()) ~= "pvp" then return end
    if LowestUnit == nil or LowestUnit.dead or not LowestUnit.combat then
        Lowest()
    end

    if player.dead then
        RepopMe()
    end
    if player.dead then return end
    if GetBattlefieldWinner() ~= nil then return end
    if not target.enemy or not target.player or target.bcc then
       awful.call("ClearTarget")
    end
    gapCloser()
    --CCtrinket
    if project.settingsBGBOT.autoCCTrinket then
        if (player.cc or player.bcc) and player.ccRemains >= 3 and player.combat then
            C_Timer.After(0.5, function()
                CCTrinket()
                willToSurvive:Cast()
            end)
        end
    end

    if IsMounted() == true and target.exists and target.distance < 40 and target.los then
        awful.call("Dismount")
    end

    if not player.combat and IsMounted() == false and IsIndoors() == false and project.settingsBGBOT.autoMountBG and target.distance > 100 and not player.casting then
        if player.moving then
            awful.call("MoveForwardStart")
            awful.call("MoveForwardStop")
        end
        C_MountJournal.SummonByID(0)
    end

    if not player.combat and IsMounted() == false and IsIndoors() == false and project.settingsBGBOT.autoMountBG then return end

    if not player.combat and not player.casting and awful.time - timeNowJump >= 10 and not player.buff(44521) then
        awful.call("JumpOrAscendStart")
        timeNowJump = awful.time
    end

    --standard targetting 
    if (not target.exists or target.distance > dist) and not player.buff(44521) then
        awful.enemies.loop(function(enemy)
            if enemy.combat and enemy.distance < dist and enemy.los then
                enemy.setTarget()
            end
        end)
    end

    if target.exists and target.distance < dist and target.los then
        if not player.casting and not player.moving and not target.playerFacing then
            player.face(target)
        end
        if player.moving then
            awful.call("MoveForwardStart")
            awful.call("MoveForwardStop")
        end
    end

    if not player.combat then
        --MoveTo
        if LowestUnit.exists then
            if LowestUnit.distance >= dist and awful.time - timeNow > 1 and not player.combat and not LowestUnit.dead then
                local x, y, z = LowestUnit.position()
                MoveTo(x, y, z,0)
                timeNow = awful.time
            end
        end

        --Move to LowestUnit
        if LowestUnit.exists then
            if (LowestUnit.distance >= dist or not LowestUnit.los) and not LowestUnit.dead then
                local path = awful.path(player, LowestUnit)
                path.draw()
                path.follow()
                return
            end
        end
    else
        --MoveTo
        if target.exists and (target.distance > dist or not target.los) and not player.buff(32727) and awful.time - timeNow > 1 then
            local x, y, z = target.position()
            MoveTo(x, y, z,0)
            timeNow = awful.time
        end

        --Move to target
        if target.exists and target.distance > dist or not target.los then
            local path = awful.path(player, target)
            path.draw()
            path.follow()
            return
        end
    end
end

local function BGbotHealer()
    if select(2,IsInInstance()) ~= "pvp" then return end
    if LowestUnit == nil or LowestUnit.dead or not LowestUnit.combat then
        Lowest()
    end
    if player.dead then
        RepopMe()
    end
    if player.dead then return end
    if GetBattlefieldWinner() ~= nil then return end

    if IsMounted() == true and LowestUnit.exists and LowestUnit.distance < dist and LowestUnit.los and LowestUnit.combat then
        awful.call("Dismount") 
    end
    gapCloser()
    if not player.combat and LowestUnit.exists and IsMounted() == false and IsIndoors() == false and project.settingsBGBOT.autoMountBG and LowestUnit.distance >= 100 and not player.casting then
        if player.moving then
            awful.call("MoveForwardStart")
            awful.call("MoveForwardStop")
        end
        C_MountJournal.SummonByID(0)
    end

    if not player.combat and IsMounted() == false and IsIndoors() == false and project.settingsBGBOT.autoMountBG then return end
    
    --CCtrinket
    if project.settingsBGBOT.autoCCTrinket then
        if (player.cc or player.bcc) and player.ccRemains >= 3 and player.combat then
            C_Timer.After(0.5, function()
                CCTrinket()
                willToSurvive:Cast()
            end)
        end
    end

    if not player.combat and not player.casting and awful.time - timeNowJump >= 10 and not player.buff(44521) then
        awful.call("JumpOrAscendStart")
        timeNowJump = awful.time
    end

    if LowestUnit.exists and LowestUnit.distance < dist and LowestUnit.los then
        if not player.casting and not player.moving and not LowestUnit.playerFacing then
            player.face(LowestUnit)
        end
        if player.moving then
            awful.call("MoveForwardStart")
            awful.call("MoveForwardStop")
        end
    end
    
    --MoveTo
    if LowestUnit.exists then
        if LowestUnit.distance >= dist and awful.time - timeNow > 1 and not player.combat and not LowestUnit.dead then
            local x, y, z = LowestUnit.position()
            MoveTo(x, y, z,0)
            timeNow = awful.time
        end
    end

    --Move to LowestUnit
    if LowestUnit.exists then
        if (LowestUnit.distance >= dist or not LowestUnit.los) and not LowestUnit.dead then
            local path = awful.path(player, LowestUnit)
            path.draw()
            path.follow()
            return
        end
    end
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

awful.addUpdateCallback(function()
    AntiAfk()
    local zoneName = GetZoneText()
    if project.settingsBGBOT.bgBotStart and project.settingsBGBOT.autoRepair and select(2,IsInInstance()) == "none" and zoneName == "Valdrakken" then
        repairNow()
    end
    if project.settingsBGBOT.bgBotStart and select(2,IsInInstance()) == "pvp" then
        if player.healer and not (player.class2 == "MONK" and player.hasTalent(388023)) then
            BGbotHealer()
        else
            BGbot()
        end
    end
    if project.settingsBGBOT.queueBGBot and select(2,IsInInstance()) == "none" then
        awful.call("AcceptBattlefieldPort", 0, true)
        awful.call("AcceptBattlefieldPort", 1, true)
        awful.call("AcceptBattlefieldPort", 2, true)
        local battlefieldStatus = GetBattlefieldStatus(1)
        if select(2,IsInInstance()) ~= "pvp" and GetBattlefieldTimeWaited(1) == 0 and battlefieldStatus ~= "confirm" and not player.debuff(26013) then
            awful.call("JoinBattlefield", 32)
        end
    end
    if project.settingsBGBOT.bgBotStart then
        local function eventTrace(self,event,...)
            if event == "PVP_MATCH_COMPLETE" and project.settingsBGBOT.autoLeave then
                C_Timer.After(10, function()
                   if PVPMatchResults and PVPMatchResults:IsShown() then
                        if PVPMatchResults.buttonContainer.leaveButton then
                            PVPMatchResults.buttonContainer.leaveButton:Click()
                        end
                    end
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
        Events:RegisterEvent("LFG_ROLE_CHECK_UPDATE")
        Events:SetScript("OnEvent", eventTrace)
    end
end)
C_Timer.After(0.5, function()
    awful.enabled = true
    awful.print("Enabled BG Bot")
end)
