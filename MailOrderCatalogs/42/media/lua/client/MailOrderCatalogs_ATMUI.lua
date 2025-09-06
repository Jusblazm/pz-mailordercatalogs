-- MailOrderCatalogs_ATMUI
MailOrderCatalogs_ATMUI = {}

local MailOrderCatalogs_BankServer = require("MailOrderCatalogs_BankServer")
local MailOrderCatalogs_Utils = require("MailOrderCatalogs_Utils")

local ISCollapsableWindow = ISCollapsableWindow

MailOrderCatalogs_ATMUI.ATMWindow = ISCollapsableWindow:derive("ATMWindow")

function MailOrderCatalogs_ATMUI.ATMWindow:new(x, y, width, height)
    local o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    return o
end

function MailOrderCatalogs_ATMUI.ATMWindow:setPlayer(player)
    self.player = player
end

function MailOrderCatalogs_ATMUI.ATMWindow:getPlayer()
    return self.player
end

function MailOrderCatalogs_ATMUI.ATMWindow:setCard(card)
    self.card = card
end

function MailOrderCatalogs_ATMUI.ATMWindow:getCard()
    return self.card
end

function MailOrderCatalogs_ATMUI.ATMWindow:createChildren()
    ISCollapsableWindow.createChildren(self)

    -- PIN entry box
    local entryWidth = 100
    self.pinEntry = ISTextEntryBox:new("", 10, 30, entryWidth, 25)
    self.pinEntry:initialise()
    self.pinEntry:instantiate()
    self.pinEntry:setOnlyNumbers(true)
    self.pinEntry:setMaxTextLength(2)
    self.pinEntry:setTooltip(getText("Tooltip_MailOrderCatalogs_ATMUI_PinEntry_Normal"))
    self:addChild(self.pinEntry)

    -- submit button
    self.submitButton = ISButton:new(10 + entryWidth + 10, 30, 80, 25, getText("UI_MailOrderCatalogs_ATMUI_SubmitButton"), self, function()
        self:onSubmitPIN()
    end)
    self.submitButton:initialise()
    self.submitButton:instantiate()
    self:addChild(self.submitButton)

    -- placeholder
    -- self.unlockedLabel = ISLabel:new(10, 70, 20, "Access Granted", 1, 1, 1, 1, UIFont.Medium, true)
    -- self.unlockedLabel:setVisible(false)
    -- self:addChild(self.unlockedLabel)
end

function MailOrderCatalogs_ATMUI.ATMWindow:onSubmitPIN()
    local player = self:getPlayer()
    local enteredPinStr = self.pinEntry:getText()

    if not enteredPinStr or not enteredPinStr:match("^%d%d$") then
        self.pinEntry:setText("")
        self.pinEntry:setTooltip(getText("Tooltip_MailOrderCatalogs_ATMUI_PinEntry_Error"))
        return
    end

    local enteredPin = tonumber(enteredPinStr)

    local card = self:getCard()
    if not card then
        self.pinEntry:setVisible(false)
        self.submitButton:setVisible(false)
        self:addChild(ISLabel:new(10, 70, 20, getText("UI_MailOrderCatalogs_ATMUI_NoCardFound"), 1, 1, 1, 1, UIFont.Medium, true))
        return
    end

    local modData = card:getModData()
    MailOrderCatalogs_Utils.ensureCardHasData(card)

    local actualPinStr = modData.pin
    local actualPin = tonumber(actualPinStr)
    local descriptor = player:getDescriptor()
    local playerFullName = descriptor:getForename() .. " " .. descriptor:getSurname()
    local isOwner = (modData.owner == playerFullName)
    local pinCorrect = false

    if isOwner then
        if MailOrderCatalogs_Utils.isAutomaticOwnerPINEnabled() then
            pinCorrect = true
        else
            if enteredPinStr == actualPinStr then
                pinCorrect = true
            end
        end
    else
        local hackingLevel = 0
        local pinRange = 0
        if HackingSkill and Perks.Hacking then
            hackingLevel = HackingSkill.getLevel(player)
            pinRange = math.floor(hackingLevel * 2)
        end

        if player:HasTrait("CreditCardThief") then
            pinRange = pinRange + 5
        end

        if math.abs(enteredPin - actualPin) <= pinRange then
            pinCorrect = true
        end
    end

    if pinCorrect then
        self.pin = true
        self.pinEntry:setVisible(false)
        self.submitButton:setVisible(false)
        if isOwner then
            modData.attempts = 0
        end
        self:createBankUI()
    else
        modData.attempts = (modData.attempts or 0) + 1
        self.pinEntry:setText("")
        self.pinEntry:setTooltip(getText("Tooltip_MailOrderCatalogs_ATMUI_PinEntry_Incorrect") .. tostring(modData.attempts) .. "/3")

        if HackingSkill and Perks.Hacking then
            HackingSkill.addXP(player, 2)
        end

        if modData.attempts >= 3 then
            player:getInventory():Remove(card)
            self.pinEntry:setVisible(false)
            self.submitButton:setVisible(false)
            self:addChild(ISLabel:new(10, 70, 20, getText("UI_MailOrderCatalogs_ATMUI_CardDestroyed"), 1, 0, 0, 1, UIFont.Medium, true))
            print("[MailOrderCatalogs] General: Credit Card destroyed due to 3 failed PIN attempts.")
        end
    end
    if isDebugEnabled() then
        MailOrderCatalogs_BankServer.printAllAccounts()
    end
end

function MailOrderCatalogs_ATMUI.ATMWindow:createBankUI()
    local x = 10
    local y = 100

    -- bank balance
    self.balanceLabel = ISLabel:new(x, y, 20, getText("UI_MailOrderCatalogs_ATMUI_Balance" .. "0"), 1, 1, 1, 1, UIFont.Medium, true)
    self:addChild(self.balanceLabel)

    -- transaction entry
    self.amountEntry = ISTextEntryBox:new("", x, y + 30, 100, 25)
    self.amountEntry:initialise()
    self.amountEntry:instantiate()
    self.amountEntry:setOnlyNumbers(true)
    self.amountEntry:setTooltip(getText("Tooltip_MailOrderCatalogs_ATMUI_AmountEntry_Normal"))
    self:addChild(self.amountEntry)

    -- deposit button
    self.depositButton = ISButton:new(x + 110, y + 30, 80, 25, getText("UI_MailOrderCatalogs_ATMUI_DepositButton"), self, function()
        self:onDeposit()
    end)
    self.depositButton:initialise()
    self.depositButton:instantiate()
    self:addChild(self.depositButton)

    -- withdraw button
    self.withdrawButton = ISButton:new(x + 200, y + 30, 80, 25, getText("UI_MailOrderCatalogs_ATMUI_WithdrawButton"), self, function()
        self:onWithdraw()
    end)
    self.withdrawButton:initialise()
    self.withdrawButton:instantiate()
    self:addChild(self.withdrawButton)

    self:updateBalanceLabel()
end

function MailOrderCatalogs_ATMUI.ATMWindow:updateBalanceLabel()
    local player = self:getPlayer()
    local card = self:getCard()
    local account = MailOrderCatalogs_BankServer.getAccountByID(card:getModData().accountID)
    local balance = account and tonumber(account.balance or 0) or 0
    local formatBalance = string.format("%.2f", balance)
    self.balanceLabel:setName(getText("UI_MailOrderCatalogs_ATMUI_Balance") .. formatBalance)
end

function MailOrderCatalogs_ATMUI.ATMWindow:onDeposit()
    local amount = tonumber(self.amountEntry:getText())
    if not amount or amount <= 0 then return end

    local player = self:getPlayer()
    local inv = player:getInventory()
    local card = self:getCard()
    if not card then return end

    local modData = card:getModData()
    local account = MailOrderCatalogs_BankServer.getAccountByID(modData.accountID)
    if not account then return end

    local moneySingles = inv:getAllType("Money")
    local moneyBundles = inv:getAllType("MoneyBundle")

    local totalAvailable = moneySingles:size() + (moneyBundles:size() * 100)
    if totalAvailable < 1 then
        self.amountEntry:setTooltip(getText("Tooltip_MailOrderCatalogs_ATMUI_AmountEntry_NoMoney"))
        return
    end

    local remaining = amount
    local deposited = 0

    for i=0, moneyBundles:size()-1 do
        if remaining <= 0 then break end

        local bundle = moneyBundles:get(i)
        if bundle then
            if remaining >= 100 then
                inv:Remove(bundle)
                deposited = deposited + 100
                remaining = remaining - 100
            else
                inv:Remove(bundle)
                deposited = deposited + remaining

                local leftover = 100 - remaining
                for j=1, leftover do
                    inv:AddItem("Base.Money")
                end
                remaining = 0
            end
        end
    end

    for i=0, moneySingles:size()-1 do
        if remaining <= 0 then break end

        local single = moneySingles:get(i)
        if single then
            inv:Remove(single)
            deposited = deposited + 1
            remaining = remaining - 1
        end
    end

    MailOrderCatalogs_BankServer.deposit(modData.accountID, deposited)
    self:updateBalanceLabel()
end

function MailOrderCatalogs_ATMUI.ATMWindow:onWithdraw()
    local amount = tonumber(self.amountEntry:getText())
    if not amount or amount <= 0 then return end

    local player = self:getPlayer()
    local card = self:getCard()
    if not card then return end

    local modData = card:getModData()
    local account = MailOrderCatalogs_BankServer.getAccountByID(modData.accountID)
    if not account then return end

    if account.balance < amount then
        self.amountEntry:setTooltip(getText("Tooltip_MailOrderCatalogs_ATMUI_AmountEntry_Insufficient"))
        return
    end

    local remaining = amount

    while remaining >= 100 do
        player:getInventory():AddItem("Base.MoneyBundle")
        remaining = remaining - 100
    end

    while remaining > 0 do
        player:getInventory():AddItem("Base.Money")
        remaining = remaining - 1
    end

    MailOrderCatalogs_BankServer.withdraw(modData.accountID, amount)
    self:updateBalanceLabel()
end

function MailOrderCatalogs_ATMUI.openATMUI(player, card)
    if MailOrderCatalogs_ATMUI.instance and MailOrderCatalogs_ATMUI.instance:isVisible() then
        return
    end

    card = card or MailOrderCatalogs_Utils.getCard(player)
    if not card then
        print("[MailOrderCatalogs] General: No Credit Card found.")

        if panel.pinEntry then panel.pinEntry:setVisible(false) end
        if panel.submitButton then panel.submitButton:setVisible(false) end
        local noCardLabel = ISLabel:new(10, 70, 20, getText("UI_MailOrderCatalogs_ATMUI_NoCardFound"), 1, 1, 1, 1, UIFont.Medium, true)
        panel:addChild(noCardLabel)
        return
    end

    local width = 300
    local height = 200
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2

    local panel = MailOrderCatalogs_ATMUI.ATMWindow:new(x, y, width, height)
    panel:setPlayer(player)
    panel:setCard(card)
    panel:initialise()
    panel:addToUIManager()
    panel:setVisible(true)
    panel:setResizable(false)
    panel:setTitle(getText("UI_MailOrderCatalogs_ATMUI_ATMTitle"))

    MailOrderCatalogs_ATMUI.instance = panel

    local modData = card:getModData()
    MailOrderCatalogs_Utils.ensureCardHasData(card)
    local account = MailOrderCatalogs_BankServer.getOrCreateAccountByID(modData)

    if isDebugEnabled() then
        print("[MailOrderCatalogs] Debug: Credit Card Owner: " .. tostring(modData.owner))
        print("[MailOrderCatalogs] Debug: Credit Card Account ID: " .. tostring(modData.accountID))
        print("[MailOrderCatalogs] Debug: Credit Card Number: **** **** **** " .. tostring(modData.last4))
        print("[MailOrderCatalogs] Debug: Credit Card PIN: " .. tostring(modData.pin))
        print("[MailOrderCatalogs] Debug: Credit Card Attempts: " .. tostring(modData.attempts) .. "/3")
        local descriptor = player:getDescriptor()
        print("[MailOrderCatalogs] Debug: I own this Credit Card: " .. tostring(modData.owner == descriptor:getForename() .. " " .. descriptor:getSurname()))
        print("[MailOrderCatalogs] Debug: This Credit Card is stolen: " .. tostring(modData.isStolen))
    end
end

return MailOrderCatalogs_ATMUI