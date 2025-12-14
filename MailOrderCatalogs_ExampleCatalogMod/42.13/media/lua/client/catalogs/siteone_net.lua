-- siteone_net

--[[
    this site is set up with translation in mind.
    sitetwo_com is set up without translation in mind.
]]

return {
    siteName = "siteone.net", -- url users can enter to visit site
    description = getText("UI_ExampleCatalogMod_SiteDescription_SiteOneNet"), -- site description (for lore)
    items = {
        {
            name = "Base.Belt2", -- item ID
            price = 5, -- price in 1 Base.Money
            description = getText("UI_ExampleCatalogMod_ItemDescription_Belt2"), -- description (for lore)
        },
        {
            name = "Base.MeatCleaver", -- item ID
            price = 8, -- price in 1 Base.Money
            description = getText("UI_ExampleCatalogMod_ItemDescription_MeatCleaver"), -- description (for lore)
        }
    }
}