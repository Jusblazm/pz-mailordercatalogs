-- ExampleCatalogMod_Distributions
require "Items/ProceduralDistributions"
require "Items/SuburbsDistributions"

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
    ["PostOfficeBooks"] = 0.5,
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