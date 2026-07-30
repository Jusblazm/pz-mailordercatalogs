-- MailOrderCatalogs_SpecialLootSpawns
SpecialLootSpawns = SpecialLootSpawns or {}

SpecialLootSpawns.OnCreateCatalog = function(item)
    if not item then return end
    item:getModData().literatureTitle = item:getFullType()
end