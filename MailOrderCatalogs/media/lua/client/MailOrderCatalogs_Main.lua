-- MailOrderCatalogs_Main
require "MailOrderCatalogs_ComputerUI"

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

local function updateWarning(playerIndex, playerObj)
    print("[MailOrderCatalogs] Warning: This version of Mail Order Catalogs is no longer supported. Please update to the newest version to get new features and continued support.")
end

Events.OnCreatePlayer.Add(updateWarning)