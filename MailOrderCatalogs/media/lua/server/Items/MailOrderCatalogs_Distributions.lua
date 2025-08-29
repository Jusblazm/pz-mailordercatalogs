-- MailOrderCatalogs_Distributions
require "Items/ProceduralDistributions"
require "Items/SuburbsDistributions"

local catalogs = {
    "Base.AwlWorkAndSewPlayCatalog1",
    "Base.AwlWorkAndSewPlayCatalog2",
    "Base.AwlWorkAndSewPlayCatalog3",
    "Base.AwlWorkAndSewPlayCatalog4",
    "Base.AwlWorkAndSewPlayCatalog5",
    "Base.AwlWorkAndSewPlayCatalog6",
    "Base.BookNakedCatalog1",
    "Base.BookNakedCatalog2",
    "Base.BookNakedCatalog3",
    "Base.DressedToThe90sCatalog1",
    "Base.EnigmaBooksCatalog1",
    "Base.EPToolsCatalog1",
    "Base.EPToolsCatalog2",
    "Base.EPToolsCatalog3",
    "Base.FamilyFashionCatalog1",
    "Base.FarmingAndRuralSupplyCatalog1",
    "Base.FarmingAndRuralSupplyCatalog2",
    "Base.FiligreeFashionsCatalog1",
    "Base.LouisvilleBruiserCatalog",
    "Base.MedUWellCatalog1",
    "Base.PharmahugCatalog1",
    "Base.SaucyCatalog1",
    "Base.TheExquisitePearlCatalog1",
    "Base.TheExquisitePearlCatalog2",
    "Base.TheExquisitePearlCatalog3",
    "Base.TheExquisitePearlCatalog4",
    "Base.TheExquisitePearlCatalog5",
    "Base.ThumbsOfGreenCatalog1",
    "Base.ThumbsOfGreenCatalog2",
    "Base.ThumbsOfGreenCatalog3",
    "Base.ThumbsOfGreenCatalog4",
    "Base.ThumbsOfGreenCatalog5",
    "Base.ThumbsOfGreenCatalog6",
    "Base.ThumbsOfGreenCatalog7",
    "Base.ThumbsOfGreenCatalog8",
    "Base.ThumbsOfGreenCatalog9",
    "Base.ThumbsOfGreenCatalog10",
    "Base.ThumbsOfGreenCatalog11",
    "Base.ThumbsOfGreenCatalog12",
    "Base.ThumbsOfGreenCatalog13",
    "Base.ThumbsOfGreenCatalog14",
    "Base.WormOfBooksCatalog1",
    "Base.YourClosetCatalog1",
    "Base.YourClosetCatalog2",
    "Base.ZacsHardwareCatalog1",
    "Base.ZacsHardwareCatalog2"
}

----------------------------------------
-- Procedural Distributions
----------------------------------------

local baseWeight = 0.2

local locationMultipliers = {
    ["BathroomCounter"] = 1.1,
    ["BathroomShelf"] = 0.3,
    ["BedroomDresser"] = 1.5,
    ["BedroomSidetable"] = 1.3,
    ["BedroomSidetableClassy"] = 1.8,
    ["BedroomSidetableRedneck"] = 0.8,
    ["BinBathroom"] = 1.5,
    ["BinDumpster"] = 1.9,
    ["BinGeneric"] = 1,
    ["BreakRoomCounter"] = 1.1,
    ["BreakRoomShelves"] = 1.1,
    ["CarDealerDesk"] = 1,
    ["CrateRandomJunk"] = 1.9,
    ["DerelictHouseJunk"] = 1.5,
    ["DerelictHouseSquatter"] = 0.7,
    ["JunkHoard"] = 1.9,
    ["KitchenBook"] = 0.9,
    ["KitchenRandom"] = 0.5,
    ["LivingRoomShelf"] = 0.6,
    ["LivingRoomShelfRedneck"] = 1,
    ["LivingRoomSideTable"] = 1,
    ["LivingRoomSideTableClassy"] = 1,
    ["LivingRoomSideTableRedneck"] = 1.3,
    ["OfficeDeskHome"] = 1.1,
    ["OfficeDeskStressed"] = 0.7,
    ["OfficeDrawers"] = 0.9,
    ["PostOfficeBooks"] = 2,
    ["PostOfficeMagazines"] = 2,
    ["PostOfficeNewspapers"] = 2,
    ["SafehouseBin"] = 1.2,
    ["SafehouseBin_Mid"] = 1.5,
    ["SafehouseBin_Late"] = 2,
    ["SafehouseFireplace"] = 0.5,
    ["SafehouseFireplace_Late"] = 0.1,
    ["JanitorMisc"] = 0.9,
    ["RandomFiller"] = 0.1,
    ["OtherGeneric"] = 0.1,
    ["ShelfGeneric"] = 0.1
}

for location, multiplier in pairs(locationMultipliers) do
    local dist = ProceduralDistributions.list[location]
    if dist and dist.items then
        local items = dist.items
        for _, catalog in ipairs(catalogs) do
            table.insert(items, catalog)
            table.insert(items, baseWeight * multiplier)
        end
    end
end

----------------------------------------
-- Distributions: Mailbox
----------------------------------------

local postboxWeight = 2
local distro = SuburbsDistributions
if distro and distro.all and distro.all.postbox and distro.all.postbox.items then
    local items = distro.all.postbox.items
    for _, catalog in ipairs(catalogs) do
        table.insert(items, catalog)
        table.insert(items, postboxWeight)
    end
end