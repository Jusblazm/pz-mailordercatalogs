require "MailOrderCatalogs_ComputerUI"
require "MailOrderCatalogs_ATMUI"
require "MailOrderCatalogs_CardSelectorUI"

local MailOrderCatalogs_Delivery = require("MailOrderCatalogs_Delivery")
local MailOrderCatalogs_DeliveryLocations = require("MailOrderCatalogs_DeliveryLocations")

-- unified ESC key handler
local function onGlobalKeyPressed(key)
    if key == Keyboard.KEY_ESCAPE then
        -- close ComputerUI
        if MailOrderCatalogs_ComputerUI.instance and MailOrderCatalogs_ComputerUI.instance:isVisible() then
            MailOrderCatalogs_ComputerUI.instance:close()
            MailOrderCatalogs_ComputerUI.instance = nil
        end

        -- close ATMUI
        if MailOrderCatalogs_ATMUI.instance and MailOrderCatalogs_ATMUI.instance:isVisible() then
            MailOrderCatalogs_ATMUI.instance:setVisible(false)
            MailOrderCatalogs_ATMUI.instance:removeFromUIManager()
            MailOrderCatalogs_ATMUI.instance = nil
        end

        -- close CardSelectorUI
        if MailOrderCatalogs_CardSelectorUI.instance and MailOrderCatalogs_CardSelectorUI.instance:isVisible() then
            MailOrderCatalogs_CardSelectorUI.instance:setVisible(false)
            MailOrderCatalogs_CardSelectorUI.instance:removeFromUIManager()
            MailOrderCatalogs_CardSelectorUI.instance = nil
        end
    end
end

Events.OnKeyPressed.Add(onGlobalKeyPressed)

-- run delivery point setup on game start 
-- debug
-- Events.OnGameStart.Add(function()
--     MailOrderCatalogs_Delivery.spawnDeliveryPoint()
-- end)
