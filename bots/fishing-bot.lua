--#region setup
local Unlocker, awful, project = ...
local player, target, focus, healer, enemyHealer = awful.player, awful.target, awful.focus, awful.healer, awful.enemyHealer
local dullSpinedClam = awful.Item(198395)
local wasLooting = nil
local castFish = nil
local Fish = awful.NewSpell({51294,33095,18248,7732,7731,7620})

local function FishingBot()
    --Ticker Reset
    if castFish and awful.time - castFish > 0.3 then castFish = nil end
    if wasLooting and awful.time - wasLooting > 0.75 then wasLooting = nil end

    --Ticker
    if wasLooting then return end
    if castFish then return end

    --General Checks
    if player.dead then return end
    if player.combat then return end

    if player.mounted then return end
    if player.timeStandingStill < 2 then return end

    --Fish
    if not LootFrame:IsVisible() and not player.channeling then
        Fish:Cast()
        castFish = awful.time
    end

    if dullSpinedClam.count > 0 then 
        dullSpinedClam:Use()
    end

    --Loot
    if LootFrame and LootFrame:IsVisible() then
        for i = 1, GetNumLootItems() do
            if LootSlotHasItem(i) then
                local texture, item, quantity, currencyID, itemQuality, locked = GetLootSlotInfo(i);
                if itemQuality >= 1 then
                    LootSlot(i)
                    ConfirmLootSlot(i)
                else
                    CloseLoot()
                end
            end
        end
    end

    if dullSpinedClam.count > 0 then 
        dullSpinedClam:Use()
    end

    --Fishing Bobber Interact
    awful.objects.loop(function(object)
        if object.id == 35591 then
            if object.creator.exists and object.creator.guid == player.guid then
                if Unlocker.type == "daemonic" then
                    local animationFlags = UnitAnimationFlags(object.pointer)
                    if animationFlags then
                        local Normal = bit.band(animationFlags, 0xFFFF) == 0
                        local Hooked = bit.band(animationFlags, 0xFFFF) == 1
                        if Hooked then
                            Interact(object.pointer)
                            wasLooting = awful.time
                        end
                    end

                else
                    local _, animationFlags = ObjectFlags(object.pointer)
                    if animationFlags then
                        local Normal = animationFlags == 0
                        local Hooked = animationFlags == 1
                        if Hooked then
                            ObjectInteract(object.pointer)
                            wasLooting = awful.time
                        end
                    end
                end
            end
        end
    end)
end

awful.addUpdateCallback(function()
    if project.settingsFishingBot.autoFish and select(2,IsInInstance()) == "none" then
        FishingBot()
    end
    if select(2,IsInInstance()) ~= "none" then
        project.settingsFishingBot.autoFish = false
    end
    if select(2,IsInInstance()) == "none" and project.settingsFishingBot.autoFishInQueue then
        project.settingsFishingBot.autoFish = true
    end
end)