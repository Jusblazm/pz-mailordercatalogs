-- MailOrderCatalogs_Delivery
local MailOrderCatalogs_DeliveryLocations = require("MailOrderCatalogs_DeliveryLocations")
local MailOrderCatalogs_Delivery = {}

function MailOrderCatalogs_Delivery.spawnDeliveryPoint()
    local player = getPlayer()
    local x = player:getX() + 3
    local y = player:getY()
    local z = player:getZ()
    local cell = getCell()
    local square = cell:getGridSquare(x, y, z)

    if square then
        local sprite = "trashcontainers_01_25"
        local container = IsoThumpable.new(cell, square, sprite, false, nil)
        container:setIsContainer(true)
        container:getModData().isDeliveryPoint = true
        container:getModData().CustomName = "Delivery Dropbox"
        container:setName("Delivery Dropbox")

        square:AddSpecialObject(container)
        square:RecalcProperties()
        print(string.format("[MailOrderCatalogs] Debug: Delivery Dropbox spawned at %d, %d, %d", x, y, z))
    else
        print(string.format("[MailOrderCatalogs] Error: Delivery Dropbox failed to spawn at %d, %d, %d", x, y, z))
    end
end

function MailOrderCatalogs_Delivery.findNearestDeliveryPoint(radius)
    local player = getPlayer()
    local cell = getCell()
    local px, py, pz = player:getX(), player:getY(), player:getZ()
    local closestObj = nil
    local closestDistance = radius * radius

    -- search nearby grid squares for spawned delivery boxes
    for x = px - radius, px + radius do
        for y = py - radius, py + radius do
            local square = cell:getGridSquare(x, y, pz)
            if square then
                for i = 0, square:getSpecialObjects():size() - 1 do
                    local obj = square:getSpecialObjects():get(i)
                    if obj:getModData() and obj:getModData().isDeliveryPoint then
                        local dx = x - px
                        local dy = y - py
                        local dist = dx * dx + dy * dy
                        if dist < closestDistance then
                            closestDistance = dist
                            closestObj = obj
                        end
                    end
                end
            end
        end
    end

    -- found a nearby delivery object
    if closestObj then
        return { type = "object", object = closestObj }
    end

    -- find closest *known* delivery point location
    local nearestLocation = nil
    local bestDistSq = math.huge

    for _, loc in ipairs(MailOrderCatalogs_DeliveryLocations.deliveryLocations) do
        local dx = loc.x - px
        local dy = loc.y - py
        local distSq = dx * dx + dy * dy
        if distSq < bestDistSq then
            bestDistSq = distSq
            nearestLocation = loc
        end
    end

    if nearestLocation then
        return { type = "location", location = nearestLocation }
    end

    return nil
end

-- not fully implemented yet
function MailOrderCatalogs_Delivery.deliverColoredFluidItem(itemName, rgb, player)
    local result = MailOrderCatalogs_Delivery.findNearestDeliveryPoint(50)
    print("ITEM NAME " .. tostring(itemName))
    print("RGB OPTION " .. tostring(rgb[1]) .. " " .. tostring(rgb[2]) .. " " .. tostring(rgb[3]))

    if result then
        if result.type == "object" then
            -- immediate delivery
            local obj = result.object
            if obj and obj:getContainer() then
                obj:getContainer():AddItem(itemName)
                print("[MailOrderCatalogs] Debug: Delivered " .. itemName .. " to the nearest delivery box.")
            else
                print("[MailOrderCatalogs] Error: Delivery object found but container missing.")
            end
        elseif result.type == "location" then
            -- queue delivery to be spawned server-side
            sendClientCommand("MailOrderCatalogs", "QueueDelivery", {
                x = result.location.x,
                y = result.location.y,
                z = result.location.z,
                item = itemName
            })
            print(string.format("[MailOrderCatalogs] General: Queued delivery of '%s' to fallback location (%d, %d, %d)",
                itemName, result.location.x, result.location.y, result.location.z))
        end
    else
        print("[MailOrderCatalogs] Error: No delivery point found nearby or in fallback locations.")
    end
end

function MailOrderCatalogs_Delivery.deliverItem(itemName, player)
    local result = MailOrderCatalogs_Delivery.findNearestDeliveryPoint(50)

    if result then
        if result.type == "object" then
            -- immediate delivery
            local obj = result.object
            if obj and obj:getContainer() then
                obj:getContainer():AddItem(itemName)
                print("[MailOrderCatalogs] Debug: Delivered " .. itemName .. " to the nearest delivery box.")
                player:Say(getText("IGUI_MailOrderCatalogs_PlayerText_PackageNearby"))
            else
                print("[MailOrderCatalogs] Error: Delivery object found but container missing.")
            end
        elseif result.type == "location" then
            -- queue delivery to be spawned server-side
            sendClientCommand("MailOrderCatalogs", "QueueDelivery", {
                x = result.location.x,
                y = result.location.y,
                z = result.location.z,
                item = itemName
            })
            print(string.format("[MailOrderCatalogs] Debug: Queued delivery of '%s' to fallback location (%d, %d, %d)",
                itemName, result.location.x, result.location.y, result.location.z))
                player:Say(getText("IGUI_MailOrderCatalogs_PlayerText_PackagePostOffice"))
        end
    else
        print("[MailOrderCatalogs] Error: No delivery point found nearby or in fallback locations.")
    end
end

return MailOrderCatalogs_Delivery