-- MailOrderCatalogs_ContextMenu
local MailOrderCatalogs_ATMUI = require("MailOrderCatalogs_ATMUI")
local MailOrderCatalogs_CardSelectorUI = require("MailOrderCatalogs_CardSelectorUI")
local MailOrderCatalogs_ComputerUI = require("MailOrderCatalogs_ComputerUI")
local MailOrderCatalogs_Utils = require("MailOrderCatalogs_Utils")

local function onFillWorldObjectContextMenu(playerIndex, context, worldObjects, test)
    local player = getSpecificPlayer(playerIndex)

    for _, obj in ipairs(worldObjects) do
        local sprite = obj:getSprite()
        if sprite then
            local spriteName = sprite:getName()

            -- handle ATM logic
            if spriteName and MailOrderCatalogs_Utils.isValidATMSprite(spriteName) then
                if MailOrderCatalogs_Utils.isATMPowered(obj) then
                    local cards = MailOrderCatalogs_Utils.getAllCreditCards(player)
                    if #cards > 0 then
                        context:addOption(getText("ContextMenu_MailOrderCatalogs_ATM_UseATM"), obj, function()
                            local frontSquare = MailOrderCatalogs_Utils.getFrontSquareOfATM(obj)

                            if frontSquare and frontSquare:isFree(false) then
                                ISTimedActionQueue.add(ISWalkToTimedAction:new(player, frontSquare))
                                ISTimedActionQueue.add(MailOrderCatalogs_AccessATMAction:new(player, obj, cards))
                            else
                                local square = obj:getSquare()
                                local fallback = AdjacentFreeTileFinder.Find(square, player)
                                if fallback then
                                    ISTimedActionQueue.add(ISWalkToTimedAction:new(player, fallback))
                                    ISTimedActionQueue.add(MailOrderCatalogs_AccessATMAction:new(player, obj, cards))
                                else
                                    player:Say(getText("IGUI_MailOrderCatalogs_PlayerText_CantReachATM"))
                                end
                            end
                        end)
                    end
                    break
                end
            end

            -- handle Computer logic
            if spriteName and MailOrderCatalogs_Utils.isValidComputerSprite(spriteName) then
                context:addOption(getText("ContextMenu_MailOrderCatalogs_Computer_AccessComputer"), obj, function()
                    local frontSquare = MailOrderCatalogs_Utils.getFrontSquareOfComputer(obj)

                    if frontSquare and frontSquare:isFree(false) then
                        ISTimedActionQueue.add(ISWalkToTimedAction:new(player, frontSquare))
                        ISTimedActionQueue.add(MailOrderCatalogs_AccessComputerAction:new(player, obj))
                    else
                        local square = obj:getSquare()
                        local fallback = AdjacentFreeTileFinder.Find(square, player)
                        if fallback then
                            ISTimedActionQueue.add(ISWalkToTimedAction:new(player, fallback))
                            ISTimedActionQueue.add(MailOrderCatalogs_AccessComputerAction:new(player, obj))
                        else
                            player:Say(getText("IGUI_MailOrderCatalogs_PlayerText_CantReachComputer"))
                        end
                    end
                end)
                break
            end
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)