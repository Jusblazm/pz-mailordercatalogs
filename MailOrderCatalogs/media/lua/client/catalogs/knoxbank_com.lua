-- knoxbank_com

return {
    siteName = "knoxbank.com",
    description = getText("UI_MailOrderCatalogs_SiteDescription_KnoxBankCom"),
    customRender = function(self, siteID, player, card)
        
        local padding = 20
        local labelSpacing = 4
        local btnW, btnH = 200, 25
        local y = padding

        local function addLabel(text)
            local label = ISLabel:new(padding, y, 20, text, 1, 1, 1, 1, UIFont.Small, true)
            label:initialise()
            self.rightPanel:addChild(label)
            y = y + label:getHeight() + labelSpacing
        end

        addLabel(getText("UI_MailOrderCatalogs_KnoxBank_Welcome"))
        addLabel("-----------------------------")

        local btnSignup = ISButton:new(padding, y, btnW, btnH, getText("UI_MailOrderCatalogs_KnoxBank_SignUp"), self, function()
            -- placeholder for creating a new account
        end)
        btnSignup:initialise()
        btnSignup.enable = false
        self.rightPanel:addChild(btnSignup)
        y = y + btnH + 10

        local btnAccess = ISButton:new(padding, y, btnW, btnH, getText("UI_MailOrderCatalogs_KnoxBank_AccessAccount"), self, function()
            self:loadWebsite("knoxbank.com/account")
        end)
        btnAccess:initialise()
        btnAccess.enable = (card ~= nil)
        btnAccess:setTooltip(getText("Tooltip_MailOrderCatalogs_KnoxBank_AccessAccount"))
        self.rightPanel:addChild(btnAccess)
        y = y + btnH + 10

        local btnOrderCard = ISButton:new(padding, y, btnW, btnH, getText("UI_MailOrderCatalogs_KnoxBank_OrderCard"), self, function()
            print("[MailOrderCatalogs] General: New credit card ordered for " .. tostring(player))
            if not player or player:isDead() then return end
            sendClientCommand("EZPZBanking", "OrderCreditCard", {})
            self:loadWebsite("knoxbank.com")
        end)
        btnOrderCard:initialise()
        btnOrderCard:setTooltip(getText("Tooltip_MailOrderCatalogs_KnoxBank_OrderCard"))
        self.rightPanel:addChild(btnOrderCard)
        y = y + btnH + 10
    end
}