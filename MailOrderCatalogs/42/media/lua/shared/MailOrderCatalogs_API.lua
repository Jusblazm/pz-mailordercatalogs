-- MailOrderCatalogs_API
MailOrderCatalogs = {}

--- registers a new ATM sprite
-- @param spriteName (string) The sprite name, e.g. "my_custom_atm_sprite"
-- @param facingDir (number) The facing direction: 0 = North, 1 = East, 2 = South, 3 = West
function MailOrderCatalogs.RegisterATM(spriteName, facingDir)
    if not spriteName or type(spriteName) ~= "string" then
        print("[MailOrderCatalogs] Error: Invalid spriteName passed to RegisterATM")
        return
    end
    if type(facingDir) ~= "number" or facingDir < 0 or facingDir > 3 then
        print("[MailOrderCatalogs] Error: Invalid facingDir passed to RegisterATM (must be 0=North, 1=East, 2=South, 3=West)")
        return
    end

    -- insert into ATM tables
    MailOrderCatalogs_Utils.validATMSprites[spriteName] = true
    MailOrderCatalogs_Utils.ATMFacingDirections[spriteName] = facingDir
end

--- registers a new delivery location
-- @param x (number) X coordinate
-- @param y (number) Y coordinate
-- @param z (number) Z coordinate (default = 0 if not provided)
function MailOrderCatalogs.RegisterDeliveryLocation(x, y, z)
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