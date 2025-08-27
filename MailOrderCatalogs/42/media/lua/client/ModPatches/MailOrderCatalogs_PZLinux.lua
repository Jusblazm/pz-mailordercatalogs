-- MailOrderCatalogs_PZLinux
local MailOrderCatalogs_Utils = require("MailOrderCatalogs_Utils")
local MailOrderCatalogs_BankServer = require("MailOrderCatalogs_BankServer")

-- stops infinite sync loop on setBalance
local syncingFromPZLinux = false

-- makes PZLinux and MailOrderCatalogs bank share the same balance
local function mergeBankAccountsIfPZLinuxPresent()
    if getActivatedMods():contains("\\B42_PZLinux") then
        print("[MailOrderCatalogs] General: PZLinux is installed, merging bank account details")

        local original_saveAtmBalance = saveAtmBalance
        local original_deposit = MailOrderCatalogs_BankServer.deposit
        local original_withdraw = MailOrderCatalogs_BankServer.withdraw
        local original_setBalance = MailOrderCatalogs_BankServer.setBalance

        function saveAtmBalance(balance)
            if original_saveAtmBalance then
                original_saveAtmBalance(balance)
            end

            if balance then
                local player = getPlayer()
                local card = MailOrderCatalogs_Utils.getPlayerCard(player)
                if not card then
                    print("[MailOrderCatalogs] General: No Credit Card found.")
                else
                    local modData = card:getModData()
                    syncingFromPZLinux = true
                    MailOrderCatalogs_BankServer.setBalance(modData, balance)
                    syncingFromPZLinux = false
                    print("[MailOrderCatalogs] General: Synced bank accounts between PZLinux and MailOrderCatalogs")
                end
            end
        end

        function MailOrderCatalogs_BankServer.deposit(accountID, amount)
            local success = original_deposit(accountID, amount)

            if success and amount and amount > 0 then
                local player = getPlayer()
                local modData = player:getModData()
                local newBalance = MailOrderCatalogs_BankServer.getAccountByID(accountID).balance
                modData.PZLinuxBank = newBalance
                print("[MailOrderCatalogs] General: Synced deposit to PZLinux. Balance: " .. tostring(newBalance))
            end
            return success
        end

        function MailOrderCatalogs_BankServer.withdraw(accountID, amount)
            local success = original_withdraw(accountID, amount)

            if success and amount and amount > 0 then
                local player = getPlayer()
                local modData = player:getModData()
                local newBalance = MailOrderCatalogs_BankServer.getAccountByID(accountID).balance
                modData.PZLinuxBank = newBalance
                print("[MailOrderCatalogs] General: Synced withdraw to PZLinux. Balance: " .. tostring(newBalance))
            end
            return success
        end

        function MailOrderCatalogs_BankServer.setBalance(card, newBalance)
            local success = original_setBalance(card, newBalance)

            if not syncingFromPZLinux and success then
                local player = getPlayer()
                local modData = player:getModData()
                modData.PZLinuxBank = newBalance
                print("[MailOrderCatalogs] General: Synced setBalance to PZLinux. Balance: " .. tostring(newBalance))
            end
            return success
        end
    else
        print("[MailOrderCatalogs] General: PZLinux is not installed")
    end
end

Events.OnGameStart.Add(mergeBankAccountsIfPZLinuxPresent)