-- ExampleCatalogMod_Distributions
require "Items/ProceduralDistributions"
require "Items/Distributions"

--[[
    I've been attempting to create a dynamic distributions list
    so that you don't need to modify this one yourself, but
    I haven't been having any luck with it.
    Maybe one day I'll figure it out.

    For now, any catalogs you create, add them to local catalogs = {}.
    Everything else is taken care of by the rest of the file.
]]

local catalogs = {
    "Base.ExampleCatalog"
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