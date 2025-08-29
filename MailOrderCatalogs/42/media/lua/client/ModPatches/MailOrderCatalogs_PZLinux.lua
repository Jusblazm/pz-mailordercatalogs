-- MailOrderCatalogs_PZLinux
local MailOrderCatalogs_Utils = require("MailOrderCatalogs_Utils")
local MailOrderCatalogs_BankServer = require("MailOrderCatalogs_BankServer")
require("MailOrderCatalogs_Hooks")

--[[
    this patch ensures PZLinux and MailOrderCatalogs share the same bank account
]]

-- stops infinite sync loop
local syncingFromPZLinux = false

local function setupPZLinuxHooks()
    if not getActivatedMods():contains("\\B42_PZLinux") then
        print("[MailOrderCatalogs] General: PZLinux is not installed")
        return
    end
    print("[MailOrderCatalogs] General: PZLinux detected, enabling hooks")

    MailOrderCatalogs_Hooks.wrapFunction(MailOrderCatalogs_BankServer, "deposit")
    MailOrderCatalogs_Hooks.wrapFunction(MailOrderCatalogs_BankServer, "withdraw")
    MailOrderCatalogs_Hooks.wrapFunction(MailOrderCatalogs_BankServer, "setBalance")

    MailOrderCatalogs_Hooks.add("deposit", function(result, accountID, amount)
        local success = result[1]
        if success and amount and amount > 0 then
            local player = getPlayer()
            local modData = player:getModData()
            local newBalance = MailOrderCatalogs_BankServer.getAccountByID(accountID).balance
            modData.PZLinuxBank = newBalance
            print("[MailOrderCatalogs] General: Synced deposit to PZLinux. Balance: " .. tostring(newBalance))
        end
    end)

    MailOrderCatalogs_Hooks.add("withdraw", function(result, accountID, amount)
        local success = result[1]
        if success and amount and amount > 0 then
            local player = getPlayer()
            local modData = player:getModData()
            local newBalance = MailOrderCatalogs_BankServer.getAccountByID(accountID).balance
            modData.PZLinuxBank = newBalance
            print("[MailOrderCatalogs] General: Synced withdraw to PZLinux. Balance: " .. tostring(newBalance))
        end
    end)

    MailOrderCatalogs_Hooks.add("setBalance", function(result, card, newBalance)
        local success = result[1]
        if not syncingFromPZLinux and success then
            local player = getPlayer()
            local modData = player:getModData()
            modData.PZLinuxBank = newBalance
            print("[MailOrderCatalogs] General: Synced balance to PZLinux. Balance: " .. tostring(newBalance))
        end
    end)

    local original_saveAtmBalance = saveAtmBalance
    function saveAtmBalance(balance)
        if original_saveAtmBalance then
            original_saveAtmBalance(balance)
        end

        if balance then
            local player = getPlayer()
            local card = MailOrderCatalogs_Utils.getPlayerCard(player)
            if card then
                local modData = card:getModData()
                syncingFromPZLinux = true
                MailOrderCatalogs_BankServer.setBalance(modData, balance)
                syncingFromPZLinux = false
                print("[MailOrderCatalogs] General: Synced bank accounts between PZLinux and MailOrderCatalogs")
            else
                print("[MailOrderCatalogs] General: No Credit Card found")
            end
        end
    end
end

Events.OnGameStart.Add(setupPZLinuxHooks)