-- MailOrderCatalogs_BanditsWeekOne
local MailOrderCatalogs_Utils = require("MailOrderCatalogs_Utils")
local MailOrderCatalogs_BankServer = require("MailOrderCatalogs_BankServer")

-- allows BanditsWeekOne to access MailOrderCatalogs' player bank accounts for purchasing
local function payUsingCreditCardsIfBanditsWeekOnePresent()
    if not getActivatedMods():contains("\\BanditsWeekOne") then
        print("[MailOrderCatalogs] General: Week One is not installed")
        return
    end

    --[[
        currently only accepts player's actual credit card
        future update could allow stolen cards to be used
    ]]
    print("[MailOrderCatalogs] General: Week One is installed, allowing player to pay with credit cards")

    local original_BWOPlayer_Pay = BWOPlayer.Pay

    BWOPlayer.Pay = function(character, cnt)
        
        local function predicateMoney(item)
            return item:getType() == "Money"
        end

        local inventory = character:getInventory()
        local items = ArrayList.new()
        inventory:getAllEvalRecurse(predicateMoney, items)
        
        local cashAvailable = items:size()
        local amountRemaining = cnt

        if cashAvailable > 0 then
            local toRemove = math.min(cashAvailable, amountRemaining)
            for i=1, toRemove do
                inventory:RemoveOneOf("Money", true)
            end
            amountRemaining = amountRemaining - toRemove
        end

        if amountRemaining > 0 then
            local card = MailOrderCatalogs_Utils.getPlayerCard(character)
            if card then
                local modData = card:getModData()
                local account = MailOrderCatalogs_BankServer.getAccountByID(modData.accountID)
                if account and account.balance >= amountRemaining then
                    MailOrderCatalogs_BankServer.withdraw(modData.accountID, amountRemaining)
                    amountRemaining = 0
                end
            end
        end

        if amountRemaining == 0 then
            character:addLineChatElement("Paid: -$" .. cnt .. ".00", 0, 1, 0)
        else
            character:addLineChatElement("No money, item stolen!", 1, 0, 0)
            BWOPlayer.ActivateWitness(character, 18)
        end
    end
end

Events.OnGameStart.Add(payUsingCreditCardsIfBanditsWeekOnePresent)