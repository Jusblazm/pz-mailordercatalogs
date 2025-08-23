-- MailOrderCatalogs_DeliverySpawner
local MailOrderCatalogs_DeliveryLocations = require("MailOrderCatalogs_DeliveryLocations")
local DeliveryQueue = require("MailOrderCatalogs_DeliveryQueue")

Events.LoadGridsquare.Add(function(square)
    local x, y, z = square:getX(), square:getY(), square:getZ()

    if MailOrderCatalogs_DeliveryLocations.isDeliveryLocation(x, y, z) then
        local modData = square:getModData()
        if not modData.deliverySpawned then
            local cell = getCell()
            local sprite = "trashcontainers_01_25"
            local container = IsoThumpable.new(cell, square, sprite, false, nil)
            local deliveryColor = { r = 1.0, g = 0.6, b = 0.2, a = 1.0 }

            container:setIsContainer(true)
            container:getModData().isDeliveryPoint = true
            container:getModData().CustomName = "Delivery Dropbox"
            container:setName("Delivery Dropbox")
            container:setCustomColor(deliveryColor.r, deliveryColor.g, deliveryColor.b, deliveryColor.a)
            container:getModData().deliveryColor = deliveryColor

            square:AddSpecialObject(container)
            local containerObj = container:getContainer()
            -- if containerObj then
            --     containerObj:setCustomName(true)
            --     containerObj:setName("Delivery Dropbox")
            -- end
            square:RecalcProperties()
            modData.deliverySpawned = true
            print(string.format("[MailOrderCatalogs] General: Delivery Dropbox spawned at %d, %d, %d", x, y, z))
        end
    end

    for i=0, square:getObjects():size()-1 do
        local obj = square:getObjects():get(i)
        if instanceof(obj, "IsoThumpable") and obj:getModData().isDeliveryPoint then
            local color = obj:getModData().deliveryColor
            if color then
                obj:setCustomColor(color.r, color.g, color.b, color.a)
            end
        end
    end
    
    -- attempt to deliver any queued items
    DeliveryQueue.tryDeliver(square)
end)
