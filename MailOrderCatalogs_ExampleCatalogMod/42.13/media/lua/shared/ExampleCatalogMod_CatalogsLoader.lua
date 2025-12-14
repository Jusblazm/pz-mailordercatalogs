-- ExampleCatalogMod_CatalogsLoader
local gameVersion = getCore():getVersionNumber()
local MailOrderCatalogs = nil

if gameVersion and tonumber(gameVersion) >= 42 then
    MailOrderCatalogs = "\\JusMailOrderCatalogs"
else
    MailOrderCatalogs = "JusMailOrderCatalogs"
end

if getActivatedMods():contains(MailOrderCatalogs) then
    local registrar = require("MailOrderCatalogs_CatalogRegistrar")

    local function registerCatalogs()
        --[[
            if you want to bind your catalog to an item
            you can do so using the second example.
                
            if the player has the item in their inventory
            they will see the website in their quick access list.

            for secret websites, you don't need to include a catalog item.
        ]]

        local site = require("catalogs/siteone_net")
        registrar.registerWebsite(site)

        local site = require("catalogs/sitetwo_com")
        local catalog = "Base.ExampleCatalog"
        registrar.registerWebsite(site, catalog)
    end
    Events.OnInitGlobalModData.Add(registerCatalogs)
    Events.OnGameStart.Add(registerCatalogs)
end