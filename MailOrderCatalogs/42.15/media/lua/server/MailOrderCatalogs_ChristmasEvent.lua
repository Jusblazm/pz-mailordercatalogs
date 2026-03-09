-- MailOrderCatalogs_ChristmasEvent
local MailOrderCatalogs_Utils = require("MailOrderCatalogs_Utils")
local MailOrderCatalogs_DeliveryQueue = require("MailOrderCatalogs_DeliveryQueue")

local function spawnChristmasReward(x, y, z, player, forceQueued)
    if SandboxVars.MailOrderCatalogs and SandboxVars.MailOrderCatalogs.EnableChristmasEvent == false then
        return
    end

    if SandboxVars.MailOrderCatalogs and SandboxVars.MailOrderCatalogs.OnlyDecember then
        local gameTime = getGameTime()
        local month = gameTime:getMonth()
        if month ~= 11 then return end
    end

    if not player then return end
    local modData = player:getModData()

    if not modData.lastPurchaseAmount then
        print("[MailOrderCatalogs] General -> No last purchase history; skipping refund.")
        modData.lastPurchaseAmount = 0
    end

    if ZombRand(100) < 5 then 
        print("[MailOrderCatalogs] General -> No Christmas gifts this time :(")
        return 
    end

    local delayHours = MailOrderCatalogs_Utils.getDeliverySpeed()
    local deliveryTime = getGameTime():getWorldAgeHours() + delayHours
    local shouldQueue = forceQueued or delayHours > 0

    local roll = ZombRand(100)
    if roll < 70 then
        local goodRoll = ZombRand(100)

        if goodRoll < 40 then
            if not shouldQueue then
                MailOrderCatalogs_DeliveryQueue.spawnItem(x, y, z, "Base.Candycane")
            else
                MailOrderCatalogs_DeliveryQueue.addChristmasItem(x, y, z, "Base.Candycane", deliveryTime)
            end
        elseif goodRoll < 70 then
            local count = ZombRand(1, 4)
            if not shouldQueue then
                MailOrderCatalogs_DeliveryQueue.spawnItem(x, y, z, "Base.Milk")
                MailOrderCatalogs_DeliveryQueue.spawnItems(x, y, z, "Base.CookieChocolateChip", count)
            else
                MailOrderCatalogs_DeliveryQueue.addChristmasItem(x, y, z, "Base.Milk", deliveryTime)
                MailOrderCatalogs_DeliveryQueue.addChristmasItems(x, y, z, "Base.CookieChocolateChip", count, deliveryTime)
            end
        else
            local amount = tonumber(modData.lastPurchaseAmount) or 0
            if amount <= 0 then return end

            local refundTypeRoll = ZombRand(100)
            local refundAmount = 0

            if refundTypeRoll < 5 then
                refundAmount = math.floor(amount + 0.5)
            elseif refundTypeRoll < 25 then
                refundAmount = math.floor(amount * 0.50 + 0.5)
            else 
                refundAmount = math.floor(amount * 0.25 + 0.5)
            end

            if refundAmount > 0 then
                if not shouldQueue then
                    MailOrderCatalogs_DeliveryQueue.spawnItems(x, y, z, "Base.Money", refundAmount)
                else
                    MailOrderCatalogs_DeliveryQueue.addChristmasRefund(x, y, z, refundAmount, deliveryTime)
                end
                modData.lastPurchaseAmount = 0
            end
        end
    else
        if not shouldQueue then
            MailOrderCatalogs_DeliveryQueue.spawnItem(x, y, z, "Base.ChristmasCoal")
        else
            MailOrderCatalogs_DeliveryQueue.addChristmasItem(x, y, z, "Base.ChristmasCoal", deliveryTime)
        end
    end
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module == "MailOrderCatalogs" and command == "SpawnChristmasEvent" then
        if args and args.x and args.y and args.z then
            spawnChristmasReward(args.x, args.y, args.z, player, args.forceQueued)
        end
    end
end)