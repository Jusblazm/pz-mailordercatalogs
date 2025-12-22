-- MailOrderCatalogs_ContextMenu
local MailOrderCatalogs_Utils = require("MailOrderCatalogs_Utils")

local function onFillWorldObjectContextMenu(playerIndex, context, worldObjects, test)
    local player = getSpecificPlayer(playerIndex)

    for _, obj in ipairs(worldObjects) do
        local sprite = obj:getSprite()
        if sprite then
            local spriteName = sprite:getName()

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