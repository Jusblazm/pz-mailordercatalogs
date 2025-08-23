-- MailOrderCatalogs_DeliveryQueue
local DeliveryQueue = {}
DeliveryQueue.queued = {}
DeliveryQueue.queuedFluids = {}

function DeliveryQueue.addDelivery(x, y, z, item)
    local key = string.format("%d_%d_%d", x, y, z)
    if not DeliveryQueue.queued[key] then
        DeliveryQueue.queued[key] = {}
    end
    table.insert(DeliveryQueue.queued[key], item)
    print(string.format("[MailOrderCatalogs] Queued item '%s' for %s", item, key))
end

function DeliveryQueue.addFluidDelivery(x, y, z, fluidData)
    local key = string.format("%d_%d_%d", x, y, z)
    if not DeliveryQueue.queuedFluids[key] then
        DeliveryQueue.queuedFluids[key] = {}
    end
    table.insert(DeliveryQueue.queuedFluids[key], fluidData)
    print(string.format("[MailOrderCatalogs] Queued fluid item '%s' with RGB (%0.2f, %0.2f, %0.2f) for %s",
        fluidData.item, fluidData.r, fluidData.g, fluidData.b, key))
end

function DeliveryQueue.tryDeliver(square)
    local x, y, z = square:getX(), square:getY(), square:getZ()
    local key = string.format("%d_%d_%d", x, y, z)

    if DeliveryQueue.queued[key] then
        local modData = square:getModData()
        local cell = getCell()
        local sprite = "trashcontainers_01_25"
        local container

        -- check for existing delivery box
        for i=0, square:getSpecialObjects():size()-1 do
            local obj = square:getSpecialObjects():get(i)
            if obj:getModData() and obj:getModData().isDeliveryPoint then
                container = obj
                break
            end
        end

        -- if not already spawned, spawn a new one
        if not container then
            container = IsoThumpable.new(cell, square, sprite, false, nil)
            container:setIsContainer(true)
            container:getModData().isDeliveryPoint = true
            container:getModData().CustomName = "Delivery Dropbox"
            container:setName("Delivery Dropbox")
            square:AddSpecialObject(container)
            square:RecalcProperties()
            modData.deliverySpawned = true
            print(string.format("[MailOrderCatalogs] General: Delivery Dropbox spawned at %d, %d, %d", x, y, z))
        end

        -- add queued items to container
        for _, itemFullType in ipairs(DeliveryQueue.queued[key]) do
            local item = container:getContainer():AddItem(itemFullType)
            if item then
                print(string.format("[MailOrderCatalogs] Debug: Delivered %s to %d, %d, %d", itemFullType, x, y, z))
            end
        end
        DeliveryQueue.queued[key] = nil -- clear delivered items
    end
    DeliveryQueue.tryDeliverFluids(square)
end

function DeliveryQueue.tryDeliverFluids(square)
    local x, y, z = square:getX(), square:getY(), square:getZ()
    local key = string.format("%d_%d_%d", x, y, z)

    if DeliveryQueue.queuedFluids[key] then
        local modData = square:getModData()
        local cell = getCell()
        local sprite = "trashcontainers_01_25"
        local container

        for i=0, square:getSpecialObjects():size()-1 do
            local obj = square:getSpecialObjects():get(i)
            if obj:getModData() and obj:getModData().isDeliveryPoint then
                container = obj
                break
            end
        end

        if not container then
            container = IsoThumpable.new(cell, square, sprite, false, nil)
            container:setIsContainer(true)
            container:getModData().isDeliveryPoint = true
            container:getModData().CustomName = "Delivery Dropbox"
            container:setName("Delivery Dropbox")
            square:AddSpecialObject(container)
            square:RecalcProperties()
            modData.deliverySpawned = true
            print(string.format("[MailOrderCatalogs] General: Delivery Dropbox spawned at %d, %d, %d", x, y, z))
        end

        for _, fluid in ipairs(DeliveryQueue.queuedFluids[key]) do
            local item = container:getContainer():AddItem(fluid.item)
            if item and instanceof(item, "DrainableComboItem") then
                item:setUsedDelta(1.0)
                local color = ColorInfo.new(fluid.r, fluid.g, fluid.b, 1.0)
                item:setColor(color)
                print(string.format("[MailOrderCatalogs] Delivered fluid item '%s' with custom color at %d, %d, %d",
                    fluid.item, x, y, z))
            else
                print(string.format("[MailOrderCatalogs] Warning: Failed to color fluid item '%s'", fluid.item))
            end
        end
        DeliveryQueue.queuedFluids[key] = nil
    end
end

return DeliveryQueue
