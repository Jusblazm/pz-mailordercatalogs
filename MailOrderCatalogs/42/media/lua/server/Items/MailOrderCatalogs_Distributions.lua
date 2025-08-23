-- MailOrderCatalogs_Distributions
require "Items/ProceduralDistributions"
require "Items/Distributions"

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

local baseWeight = 0.5

local locationMultipliers = {
    ["BathroomCounter"] = 2,
    ["BathroomShelf"] = 0.3,
    ["BedroomDresser"] = 1.5,
    ["BedroomSidetable"] = 2.4,
    ["BedroomSidetableClassy"] = 1.8,
    ["BedroomSidetableRedneck"] = 0.8,
    ["BinBathroom"] = 1.5,
    ["BinDumpster"] = 1.9,
    ["BinGeneric"] = 1,
    ["BreakRoomCounter"] = 1.1,
    ["BreakRoomShelves"] = 1.1,
    ["CarDealerDesk"] = 1,
    ["CrateRandomJunk"] = 3,
    ["DerelictHouseJunk"] = 3.2,
    ["DerelictHouseSquatter"] = 2.1,
    ["JunkHoard"] = 3,
    ["KitchenBook"] = 2,
    ["KitchenRandom"] = 1,
    ["LivingRoomShelf"] = 1.4,
    ["LivingRoomShelfRedneck"] = 2.3,
    ["LivingRoomSideTable"] = 2.4,
    ["LivingRoomSideTableClassy"] = 1,
    ["LivingRoomSideTableRedneck"] = 1.3,
    ["OfficeDeskHome"] = 1.8,
    ["OfficeDeskStressed"] = 0.9,
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

local postboxWeight = 6

local postbox = Distributions[1].all.postbox
if postbox and postbox.items then
    local items = postbox.items
    for _, catalog in ipairs(catalogs) do
        table.insert(items, catalog)
        table.insert(items, postboxWeight)
    end
end