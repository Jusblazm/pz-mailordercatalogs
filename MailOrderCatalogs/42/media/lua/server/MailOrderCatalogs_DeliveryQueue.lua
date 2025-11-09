-- MailOrderCatalogs_DeliveryQueue
local DeliveryQueue = {}
DeliveryQueue.queued = DeliveryQueue.queued or {}
DeliveryQueue.queuedFluids = DeliveryQueue.queuedFluids or {}
DeliveryQueue.queuedZombies = DeliveryQueue.queuedZombies or {}

local function makeKey(x, y, z)
    return string.format("%d_%d_%d", x, y, z)
end

function DeliveryQueue.addDelivery(x, y, z, item, deliverAt)
    local key = makeKey(x, y, z)
    if not DeliveryQueue.queued[key] then
        DeliveryQueue.queued[key] = {}
    end
    table.insert(DeliveryQueue.queued[key], {
         item = item,
         deliverAt = deliverAt or 0
    })
    print(string.format("[MailOrderCatalogs] Debug: Queued item '%s' for %s at %0.2f hours", item, key, deliverAt))
end

function DeliveryQueue.addFluidDelivery(x, y, z, fluidData, deliverAt)
    local key = makeKey(x, y, z)
    if not DeliveryQueue.queuedFluids[key] then
        DeliveryQueue.queuedFluids[key] = {}
    end
    fluidData.deliverAt = deliverAt or 0
    table.insert(DeliveryQueue.queuedFluids[key], fluidData)
    print(string.format("[MailOrderCatalogs] Debug: Queued fluid item '%s' with RGB (%0.2f, %0.2f, %0.2f) for %s at %0.2f hours",
        fluidData.item, fluidData.r, fluidData.g, fluidData.b, key, deliverAt))
end

function DeliveryQueue.addZombieDelivery(x, y, z, deliverAt)
    local key = makeKey(x, y, z)
    if not DeliveryQueue.queuedZombies[key] then
        DeliveryQueue.queuedZombies[key] = {}
    end
    table.insert(DeliveryQueue.queuedZombies[key], {
        x = x,
        y = y,
        z = z,
        deliverAt = deliverAt or 0
    } )
    print(string.format("[MailOrderCatalogs] Debug: Queued zombies at %s for %0.2f hours", key, deliverAt))
end

function DeliveryQueue.spawnItem(x, y, z, itemFullType)
    local square = getCell():getGridSquare(x, y, z)
    if not square then return false end

    local container = DeliveryQueue.getOrCreateDropbox(square)
    if not container then return false end

    container:getContainer():AddItem(itemFullType)
    print(string.format("[MailOrderCatalogs] General: Delivered %s to %d, %d, %d", itemFullType, x, y, z))
    return true
end

function DeliveryQueue.spawnFluidItem(x, y, z, fluid)
    local square = getCell():getGridSquare(x, y, z)
    if not square then return false end

    local container = DeliveryQueue.getOrCreateDropbox(square)
    if not container then return false end

    local item = container:getContainer():AddItem(fluid.item)
    if item and instanceof(item, "DrainableComboItem") then
        item:setUsedDelta(1.0)
        item:setColor(ColorInfo.new(fluid.r, fluid.g, fluid.b, 1.0))
        print(string.format("[MailOrderCatalogs] General: Delivered %s to %d, %d, %d", fluid, x, y, z))
    end
    return true
end

local function SpawnHalloweenZombies(x, y, z)
    local square = getCell():getGridSquare(x, y, z)
    if not square then return false end

    sendClientCommand("MailOrderCatalogs", "SpawnHalloweenZombies", { x=x, y=y, z=z })
    return true
end

function DeliveryQueue.getOrCreateDropbox(square)
    local cell = getCell()
    local sprite = "trashcontainers_01_25"

    for i=0, square:getSpecialObjects():size()-1 do
        local obj = square:getSpecialObjects():get(i)
        if obj:getModData() and obj:getModData().isDeliveryPoint then
            return obj
        end
    end

    local container = IsoThumpable.new(cell, square, sprite, false, nil)
    container:setIsContainer(true)
    container:getModData().isDeliveryPoint = true
    container:getModData().CustomName = "Delivery Dropbox"
    container:setName("Delivery Dropbox")
    square:AddSpecialObject(container)
    square:RecalcProperties()

    return container
end

local function processQueue()
    local now = getGameTime():getWorldAgeHours()

    -- regular items
    for key, list in pairs(DeliveryQueue.queued) do
        for i = #list, 1, -1 do
            local entry = list[i]
            if now >= entry.deliverAt then
                local x, y, z = key:match("(%d+)_(%d+)_(%d+)")
                x, y, z = tonumber(x), tonumber(y), tonumber(z)
                if DeliveryQueue.spawnItem(x, y, z, entry.item) then
                    table.remove(list, i)
                end
            end
        end
        if #list == 0 then DeliveryQueue.queued[key] = nil end
    end

    -- fluid items
    for key, list in pairs(DeliveryQueue.queuedFluids) do
        for i = #list, 1, -1 do
            local entry = list[i]
            if now >= entry.deliverAt then
                local x, y, z = key:match("(%d+)_(%d+)_(%d+)")
                x, y, z = tonumber(x), tonumber(y), tonumber(z)
                if DeliveryQueue.spawnFluidItem(x, y, z, entry) then
                    table.remove(list, i)
                end
            end
        end
        if #list == 0 then DeliveryQueue.queuedFluids[key] = nil end
    end

    -- halloween zombies
    for key, list in pairs(DeliveryQueue.queuedZombies) do
        for i = #list, 1, -1 do
            local entry = list[i]
            if now >= entry.deliverAt then
                if SpawnHalloweenZombies(entry.x, entry.y, entry.z) then
                    table.remove(list, i)
                end
            end
        end
        if #list == 0 then DeliveryQueue.queuedZombies[key] = nil end
    end
end

Events.EveryHours.Add(processQueue)

return DeliveryQueue