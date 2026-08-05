-- MailOrderCatalogs_DeliveryLocations
local MailOrderCatalogs_DeliveryLocations = {}

local deliveryLocations = {
    { x = 2046, y = 5912, z = 0 },      -- Brandenberg
    { x = 684,  y = 9861, z = 0 },      -- Ekron
    { x = 7262, y = 8489, z = 0 },      -- Fallas Lake
    { x = 2446, y = 14532, z = 0 },     -- Irvington
    { x = 12628, y = 2077, z = 0 },     -- Louisville
    { x = 10106, y = 12719, z = 0 },    -- March Ridge
    { x = 6166, y = 5244, z = 0 },      -- Riverside
    { x = 8130, y = 11288, z = 0 },     -- Rosewood
    { x = 11970, y = 6918, z = 0 },     -- West Point
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