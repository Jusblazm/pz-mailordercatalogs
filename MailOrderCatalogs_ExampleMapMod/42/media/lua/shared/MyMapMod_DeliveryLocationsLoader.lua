-- MyMapMod_DeliveryLocationsLoader
local DeliveryData = require("MailOrderCatalogs_DeliveryLocations")
local gameVersion = getCore():getVersionNumber()
local MailOrderCatalogsVersion = nil

if gameVersion and tonumber(gameVersion) >= 42 then
    MailOrderCatalogsVersion = "\\JusMailOrderCatalogs"
else
    MailOrderCatalogsVersion = "JusMailOrderCatalogs"
end

if getActivatedMods():contains(MailOrderCatalogsVersion) then
    if DeliveryData then
        MailOrderCatalogs.RegisterDeliveryLocation(1111, 2222, 0) -- x, y, z
    end
end