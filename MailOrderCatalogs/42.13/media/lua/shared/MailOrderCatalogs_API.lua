-- MailOrderCatalogs_API
MailOrderCatalogs_API = {}

--- registers a new delivery location
-- @param x (number) X coordinate
-- @param y (number) Y coordinate
-- @param z (number) Z coordinate (default = 0 if not provided)
function MailOrderCatalogs_API.RegisterDeliveryLocation(x, y, z)
    if type(x) ~= "number" or type(y) ~= "number" then
        print("[MailOrderCatalogs] Error: Invalid coordinates passed to RegisterDeliveryLocation (x and y must be numbers)")
        return
    end
    z = z or 0

    local loc = { x = x, y = y, z = z }

    -- prevent duplicates
    local MailOrderCatalogs_DeliveryLocations = require("MailOrderCatalogs_DeliveryLocations")
    if MailOrderCatalogs_DeliveryLocations.isDeliveryLocation(x, y, z) then
        print(string.format("[MailOrderCatalogs] Warning: Delivery location (%d,%d,%d) already exists, skipping", x, y, z))
        return
    end

    MailOrderCatalogs_DeliveryLocations.addLocation(loc)
end