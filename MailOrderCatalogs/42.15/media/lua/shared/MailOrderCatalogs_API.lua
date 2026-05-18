-- MailOrderCatalogs_API
MailOrderCatalogs_API = {}

--- registers a new delivery location
-- @param x (number) X coordinate
-- @param y (number) Y coordinate
-- @param z (number) Z coordinate (default = 0 if not provided)
function MailOrderCatalogs_API.registerDeliveryLocation(x, y, z)
    if type(x) ~= "number" or type(y) ~= "number" then
        print("[MailOrderCatalogs] API Error: Invalid coordinates passed to registerDeliveryLocation (x and y must be numbers)")
        return
    end
    z = z or 0

    local loc = { x = x, y = y, z = z }

    -- prevent duplicates
    local MailOrderCatalogs_DeliveryLocations = require("MailOrderCatalogs_DeliveryLocations")
    if MailOrderCatalogs_DeliveryLocations.isDeliveryLocation(x, y, z) then
        print(string.format("[MailOrderCatalogs] API Warning: Delivery location (%d,%d,%d) already exists, skipping", x, y, z))
        return
    end

    MailOrderCatalogs_DeliveryLocations.addLocation(loc)
end

---registers a computer sprite for Mail Order Catalog usage
-- @param spriteName (string) sprite name
-- @param facing (number)
-- facing values
-- 0 = north
-- 1 = east
-- 2 = south
-- 3 = west
function MailOrderCatalogs_API.registerComputer(spriteName, facing)
    if type(spriteName) ~= "string" then
        print("[MailOrderCatalogs] API Error: registerComputer spriteName must be a string")
        return
    end

    if type(facing) ~= "number" or facing < 0 or facing > 3 then
        print("[MailOrderCatalogs] API Error: registerComputer facing must be 0-3")
        return
    end

    local MailOrderCatalogs_Utils = require("MailOrderCatalogs_Utils")

    MailOrderCatalogs_Utils.validComputerSprites[spriteName] = true
    MailOrderCatalogs_Utils.computerFacingDirections[spriteName] = facing

    print(string.format("[MailOrderCatalogs] API General: Registered computer sprite '%s' with facing %d", spriteName, facing))
end