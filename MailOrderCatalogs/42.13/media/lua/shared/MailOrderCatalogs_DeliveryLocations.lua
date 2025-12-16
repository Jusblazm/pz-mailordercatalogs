-- MailOrderCatalogs_DeliveryLocations
local MailOrderCatalogs_DeliveryLocations = {}

local deliveryLocations = {
    { x = 6319, y = 5261, z = 0 },      -- Riverside
    { x = 688,  y = 9860, z = 0 },      -- Ekron
    { x = 2046, y = 5912, z = 0 },      -- Brandenberg
    { x = 2446, y = 14532, z = 0 },     -- Irvington
    { x = 11964, y = 6914, z = 0 },     -- West Point
    { x = 12628, y = 2077, z = 0 },     -- Louisville
    { x = 10079, y = 12774, z = 0 },    -- March Ridge
}

local function isDeliveryLocation(x, y, z)
    for _, loc in ipairs(deliveryLocations) do
        if loc.x == x and loc.y == y and loc.z == z then
            return true
        end
    end
    return false
end

return {
    deliveryLocations = deliveryLocations,
    addLocation = function(location)
        table.insert(deliveryLocations, location)
    end,
    isDeliveryLocation = isDeliveryLocation,
}

-- return MailOrderCatalogs_DeliveryLocations