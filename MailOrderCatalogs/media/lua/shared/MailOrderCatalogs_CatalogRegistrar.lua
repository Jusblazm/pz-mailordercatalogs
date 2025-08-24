-- MailOrderCatalogs_CatalogRegistrar
local MailOrderCatalogs_CatalogRegistrar = {}
MailOrderCatalogs_CatalogRegistrar.Websites = {}
MailOrderCatalogs_CatalogRegistrar.ItemToSiteMap = {}

function MailOrderCatalogs_CatalogRegistrar.registerWebsite(data, catalogItemID)
    if not data or not data.siteName then return end

    MailOrderCatalogs_CatalogRegistrar.Websites[data.siteName] = data
    print("[MailOrderCatalogs] General: Registered " .. tostring(data.siteName))

    -- optionally bind to a catalog item
    if catalogItemID then
        MailOrderCatalogs_CatalogRegistrar.ItemToSiteMap[catalogItemID] = data.siteName
        print("[MailOrderCatalogs] General: Bound catalog item " .. catalogItemID .. " to site " .. data.siteName)
    end
end

function MailOrderCatalogs_CatalogRegistrar.getWebsiteFromItem(item)
    if not item then return nil end
    local fullType = item:getFullType()
    local siteName = MailOrderCatalogs_CatalogRegistrar.ItemToSiteMap[fullType]
    if siteName then
        return MailOrderCatalogs_CatalogRegistrar.Websites[siteName]
    end
    return nil
end

return MailOrderCatalogs_CatalogRegistrar