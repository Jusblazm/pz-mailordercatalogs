-- knoxbank_com

return {
    siteName = "knoxbank.com",
    description = getText("UI_MailOrderCatalogs_SiteDescription_KnoxBankCom"),
    customRender = function(self, siteID, player, card)
        local padding = 20
        local labelSpacing = 4
        local y = padding

        local modData = card:getModData()
        local account = MailOrderCatalogs_BankServer.getOrCreateAccountByID(modData)

        local function addLabel(text)
            local label = ISLabel:new(padding, y, 20, text, 1, 1, 1, 1, UIFont.Small, true)
            label:initialise()
            self.rightPanel:addChild(label)
            y = y + label:getHeight() + labelSpacing
        end

        addLabel(getText("UI_MailOrderCatalogs_KnoxBank_Welcome"))
        addLabel("-----------------------------")
        addLabel(getText("UI_MailOrderCatalogs_KnoxBank_YourCard") .. " **** **** **** " .. tostring(modData.last4))
        addLabel(getText("UI_MailOrderCatalogs_KnoxBank_Balance") .. tostring(account.balance))
        local currentPinLabel = ISLabel:new(padding, y, 20, getText("UI_MailOrderCatalogs_KnoxBank_CurrentPIN") .. tostring(account.pin), 1, 1, 1, 1, UIFont.Small, true)
        currentPinLabel:initialise()
        self.rightPanel:addChild(currentPinLabel)
        y = y + currentPinLabel:getHeight() + labelSpacing
        addLabel(getText("UI_MailOrderCatalogs_KnoxBank_SetPIN"))

        local pinEntry = ISTextEntryBox:new("", padding, y, 100, 25)
        pinEntry:initialise()
        self.rightPanel:addChild(pinEntry)
        y = y + 30

        local pinErrorLabel = ISLabel:new(padding, y, 20, getText("UI_MailOrderCatalogs_KnoxBank_PINError"), 1, 0.2, 0.2, 1, UIFont.Small, true)
        pinErrorLabel:initialise()
        pinErrorLabel:setVisible(false)
        self.rightPanel:addChild(pinErrorLabel)
        y = y + pinErrorLabel:getHeight() + labelSpacing

        local submitButton = ISButton:new(padding, y, 100, 25, getText("UI_MailOrderCatalogs_KnoxBank_UpdatePIN"), self, function()
            local newPin = pinEntry:getInternalText()
            if #newPin ~= 2 or not tonumber(newPin) then
                pinErrorLabel:setVisible(true)
                return
            end
            pinErrorLabel:setVisible(false)
            modData.pin = newPin
            MailOrderCatalogs_BankServer.setPIN(modData, newPin)
            currentPinLabel:setName(getText("UI_MailOrderCatalogs_KnoxBank_CurrentPIN") .. tostring(MailOrderCatalogs_BankServer.getPIN(modData)))
        end)
        submitButton:initialise()
        self.rightPanel:addChild(submitButton)
        y = y + 30

        local reportButton = ISButton:new(padding, y, 150, 25, getText("UI_MailOrderCatalogs_KnoxBank_ReportStolen"), self, function()
            -- placeholder for card stolen logic
            print("[MailOrderCatalogs] Debug: Card has been reported stolen!")
        end)
        reportButton:initialise()
        reportButton.enable = false
        self.rightPanel:addChild(reportButton)
    end
}
