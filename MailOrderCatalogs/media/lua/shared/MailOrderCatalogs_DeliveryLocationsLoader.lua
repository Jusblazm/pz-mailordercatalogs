-- MailOrderCatalogs_DeliveryLocationsLoader
local DeliveryData = require("MailOrderCatalogs_DeliveryLocations")

Events.OnInitWorld.Add(function()
    if DeliveryData then
        -- MailOrderCatalogs.RegisterDeliveryLocation(8076, 11735, 0)
    end
end)
