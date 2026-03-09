-- MailOrderCatalogs_DeliveryQueue
local DeliveryQueue = {}
DeliveryQueue.queued = DeliveryQueue.queued or {}
DeliveryQueue.queuedFluids = DeliveryQueue.queuedFluids or {}
DeliveryQueue.queuedZombies = DeliveryQueue.queuedZombies or {}
DeliveryQueue.queuedChristmas = DeliveryQueue.queuedChristmas or {}

local function makeKey(x, y, z)
    return string.format("%d_%d_%d", x, y, z)
end

local function saveQueue()
    local data = ModData.getOrCreate("MailOrderCatalogs_Delivery")

    data.queued = DeliveryQueue.queued
    data.queuedFluids = DeliveryQueue.queuedFluids
    data.queuedZombies = DeliveryQueue.queuedZombies
    data.queuedChristmas = DeliveryQueue.queuedChristmas
end

local function loadQueue()
    local data = ModData.getOrCreate("MailOrderCatalogs_Delivery")

    DeliveryQueue.queued = data.queued or {}
    DeliveryQueue.queuedFluids = data.queuedFluids or {}
    DeliveryQueue.queuedZombies = data.queuedZombies or {}
    DeliveryQueue.queuedChristmas = data.queuedChristmas or {}
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
    saveQueue()
    print(string.format("[MailOrderCatalogs] Debug: Queued item '%s' for %s at %0.2f hours", item, key, deliverAt))
end

function DeliveryQueue.addFluidDelivery(x, y, z, fluidData, deliverAt)
    local key = makeKey(x, y, z)
    if not DeliveryQueue.queuedFluids[key] then
        DeliveryQueue.queuedFluids[key] = {}
    end
    fluidData.deliverAt = deliverAt or 0
    table.insert(DeliveryQueue.queuedFluids[key], fluidData)
    saveQueue()
    print(string.format("[MailOrderCatalogs] Debug: Queued fluid item '%s' with RGB (%0.2f, %0.2f, %0.2f) for %s at %0.2f hours",
        fluidData.item, fluidData.r, fluidData.g, fluidData.b, key, deliverAt))
end

function DeliveryQueue.addZombieDelivery(x, y, z, deliverAt)
    local key = makeKey(x, y, z)
    if not DeliveryQueue.queuedZombies[key] then
        DeliveryQueue.queuedZombies[key] = {}
    end
    table.insert(DeliveryQueue.queuedZombies[key], {
        x=x, y=y, z=z,
        deliverAt = deliverAt or 0
    })
    saveQueue()
    print(string.format("[MailOrderCatalogs] Debug: Queued zombies at %s for %0.2f hours", key, deliverAt))
end

function DeliveryQueue.addChristmasItem(x, y, z, item, deliverAt)
    local key = makeKey(x, y, z)
    if not DeliveryQueue.queuedChristmas[key] then
        DeliveryQueue.queuedChristmas[key] = {}
    end
    table.insert(DeliveryQueue.queuedChristmas[key], {
        x=x, y=y, z=z,
        item = item,
        deliverAt = deliverAt or 0
    })
    saveQueue()
    print(string.format("[MailOrderCatalogs] Debug: Queued Christmas item '%s' for %s at %0.2f hours", item, key, deliverAt))
end

function DeliveryQueue.addChristmasItems(x, y, z, item, count, deliverAt)
    local key = makeKey(x, y, z)
    if not DeliveryQueue.queuedChristmas[key] then
        DeliveryQueue.queuedChristmas[key] = {}
    end

    count = count or 1

    for i=1, count do
        table.insert(DeliveryQueue.queuedChristmas[key], {
            x=x, y=y, z=z,
            item = item,
            deliverAt = deliverAt or 0
        })
    end
    saveQueue()
    print(string.format("[MailOrderCatalogs] Debug: Queued Christmas item '%s' x%d for %s at %0.2f hours", item, count, key, deliverAt))
end

function DeliveryQueue.addChristmasRefund(x, y, z, amount, deliverAt)
    local key = makeKey(x, y, z)
    if not DeliveryQueue.queuedChristmas[key] then
        DeliveryQueue.queuedChristmas[key] = {}
    end
    
    table.insert(DeliveryQueue.queuedChristmas[key], {
        x=x, y=y, z=z,
        refund = amount,
        deliverAt = deliverAt or 0
    })
    saveQueue()
    print(string.format("[MailOrderCatalogs] Debug: Queued Christmas refund of %s for %s at %0.2f hours", amount, key, deliverAt))
end

function DeliveryQueue.spawnItem(x, y, z, itemFullType)
    local square = getCell():getGridSquare(x, y, z)
    if not square then return false end

    local containerObj = DeliveryQueue.getOrCreateDropbox(square)
    if not containerObj then return false end

    container = containerObj:getContainer()
    local item = instanceItem(itemFullType)
    container:AddItem(item)
    sendAddItemToContainer(container, item)
    print(string.format("[MailOrderCatalogs] General: Delivered %s to %d, %d, %d", itemFullType, x, y, z))
    return true
end

function DeliveryQueue.spawnItems(x, y, z, itemFullType, amount)
    local square = getCell():getGridSquare(x, y, z)
    if not square then return false end

    local containerObj = DeliveryQueue.getOrCreateDropbox(square)
    if not containerObj then return false end

    local container = containerObj:getContainer()

    local items = ArrayList.new()

    for i=1, amount do
        local item = instanceItem(itemFullType)
        if item then
            container:AddItem(item)
            items:add(item)
        end
    end

    if items:size() > 0 then
        sendAddItemsToContainer(container, items)
    end
    print(string.format("[MailOrderCatalogs] General: Delivered %d %s to %d, %d, %d", amount, itemFullType, x, y, z))
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

local function spawnHalloweenZombies(x, y, z)
    local square = getCell():getGridSquare(x, y, z)
    if not square then return false end

    sendClientCommand("MailOrderCatalogs", "SpawnHalloweenZombies", { x=x, y=y, z=z })
    return true
end

local function spawnChristmasEvent(x, y, z, player)
    local square = getCell():getGridSquare(x, y, z)
    if not square then return false end
    
    sendClientCommand("MailOrderCatalogs", "SpawnChristmasEvent", { x=x, y=y, z=z, player })
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
    local deliveryColor = { r = 1.0, g = 0.6, b = 0.2, a = 1.0 }
    container:setIsContainer(true)
    container:getModData().isDeliveryPoint = true
    container:getModData().CustomName = "Delivery Dropbox"
    container:setName("Delivery Dropbox")
    container:setCustomColor(deliveryColor.r, deliveryColor.g, deliveryColor.b, deliveryColor.a)
    container:getModData().deliveryColor = deliveryColor
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
                if spawnHalloweenZombies(entry.x, entry.y, entry.z) then
                    table.remove(list, i)
                end
            end
        end
        if #list == 0 then DeliveryQueue.queuedZombies[key] = nil end
    end

    -- christmas item and refund
    for key, list in pairs(DeliveryQueue.queuedChristmas) do
        for i = #list, 1, -1 do
            local entry = list[i]
            if now >= entry.deliverAt then
                local x, y, z = key:match("(%d+)_(%d+)_(%d+)")
                x, y, z = tonumber(x), tonumber(y), tonumber(z)
                if entry.refund then
                    DeliveryQueue.spawnItems(x, y, z, "Base.Money", entry.refund)
                    table.remove(list, i)
                else
                    DeliveryQueue.spawnItem(x, y, z, entry.item)
                    table.remove(list, i)
                end
            end
        end
        if #list == 0 then DeliveryQueue.queuedChristmas[key] = nil end 
    end
    saveQueue()
end

Events.EveryHours.Add(processQueue)
Events.OnInitGlobalModData.Add(loadQueue)

return DeliveryQueue