-- MailOrderCatalogs_JeevesPC
local MailOrderCatalogs_Utils = require("MailOrderCatalogs_Utils")

--[[
    this patch allows Mail Order Catalogs to function on Jeeve's PCs
]]

local function patchJeevesPCs()
    if not getActivatedMods():contains("JeevesPC") then
        print("[MailOrderCatalogs] General: Jeeve's PC is not installed")
        return
    end
    print("[MailOrderCatalogs] General: Jeeve's PC detected patching acceptable PC lists")

    --[[
        facing values
        0 = north
        1 = east
        2 = south
        3 = west
    ]]
    local facings = { 2, 3, 0, 1 }

    for i = 0, 23 do
        local sprite = "jpc_tiles_01_" .. i
        local facing = facings[(i%4)+1]

        MailOrderCatalogs_API.registerComputer(sprite, facing)
    end
end

Events.OnGameStart.Add(patchJeevesPCs)