-- MailOrderCatalogs_Main
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
    end
end

Events.OnKeyPressed.Add(onGlobalKeyPressed)