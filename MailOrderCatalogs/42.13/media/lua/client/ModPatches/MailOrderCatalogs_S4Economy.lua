-- MailOrderCatalogs_S4Economy
local MailOrderCatalogs_Utils = require("MailOrderCatalogs_Utils")

--[[
    this patch fixes a computer sprite error when using both mods
]]

local function patchComputerSpriteError()
    if not getActivatedMods():contains("\\S4_Economy") then
        print("[MailOrderCatalogs] General: S4 Economy is not installed")
        return
    end
    print("[MailOrderCatalogs] General: S4 Economy detected, patching computer sprite")

    function MailOrderCatalogs_Utils.setPowerState(object, isOn)
        if not object then return end
        local modData = object:getModData()
        modData.ComputerIsOn = isOn
    end
end

Events.OnGameStart.Add(patchComputerSpriteError)