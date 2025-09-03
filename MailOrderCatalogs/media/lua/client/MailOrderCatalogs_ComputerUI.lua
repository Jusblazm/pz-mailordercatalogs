-- MailOrderCatalogs_ComputerUI
MailOrderCatalogs_ComputerUI = {}

-- require "ISUI/ISScrollContainer"

local ISCollapsableWindow = ISCollapsableWindow

local MailOrderCatalogs_Utils = require("MailOrderCatalogs_Utils")
local MailOrderCatalogs_CatalogRegistrar = require("MailOrderCatalogs_CatalogRegistrar")
local MailOrderCatalogs_Delivery = require("MailOrderCatalogs_Delivery")

MailOrderCatalogs_ComputerUI.ComputerWindow = ISCollapsableWindow:derive("ComputerWindow")

function MailOrderCatalogs_ComputerUI.ComputerWindow:new(x, y, width, height)
    local o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.minimumWidth = 600
    o.minimumHeight = 600
    return o
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:updateCartLabel()
    local seen = {}
    local lines = {}

    for _, entry in ipairs(self.cartOrder) do
        local name = entry.name
        if not seen[name] then
            local data = self.shoppingCart[name]
            if data then
                local displayName = MailOrderCatalogs_Utils.getItemDisplayName(name) or name
                table.insert(lines, string.format("%dx %s", data.count, displayName))
                seen[name] = true
            end
        end
    end

    if #lines == 0 then
        self.cartLabel:setText(getText("UI_MailOrderCatalogs_ComputerUI_CartEmpty"))
        self.cartLabel:paginate()
    else
        self.cartLabel:setText(getText("UI_MailOrderCatalogs_ComputerUI_CartItems") .. "\n" .. table.concat(lines, ", "))
        self.cartLabel:paginate()
    end
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:updateTotalPriceLabel()
    local total = 0
    for _, entry in ipairs(self.cartOrder) do
        total = total + (entry.price or 0)
    end
    self.totalPriceLabel:setName(string.format(getText("UI_MailOrderCatalogs_ComputerUI_TotalPrice") .. "$%.2f", total))
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:populateAvailableWebsites()
    self.leftScrollPanel:clear()

    local player = self:getPlayer()
    local inventory = player and player:getInventory()

    local unlockedSites = {}

    if inventory then
        local items = inventory:getItems()
        for i = 0, items:size()-1 do
            local item = items:get(i)
            if item then
                -- option 1: check modData
                local modData = item:getModData()
                local siteID = modData and modData.websiteURL
                if siteID and siteID ~= "" then
                    print("[MailOrderCatalogs] Debug: Item modData -> site: " .. tostring(item:getDisplayName()) .. " -> " .. tostring(siteID))
                    unlockedSites[siteID] = true
                end

                -- option 2: check item mapping
                local fullType = item:getFullType()
                local mappedSite = MailOrderCatalogs_CatalogRegistrar.ItemToSiteMap[fullType]
                if mappedSite and not unlockedSites[mappedSite] then
                    print("[MailOrderCatalogs] Debug: Item mapping -> site: " .. tostring(item:getDisplayName()) .. " -> " .. tostring(mappedSite))
                    unlockedSites[mappedSite] = true
                end
            end
        end
    end

    -- now populate the quick access panel with sites the player has access to
    for siteID, siteData in pairs(MailOrderCatalogs_CatalogRegistrar.Websites) do
        if unlockedSites[siteID] then
            print("[MailOrderCatalogs] Debug: Showing site: " .. tostring(siteID))
            self.leftScrollPanel:addItem(siteData.siteName, {siteID = siteID})
        end
    end
    self.leftScrollPanel:addScrollBars()
end

-- required for a proper power pc feeling
function MailOrderCatalogs_ComputerUI.ComputerWindow:populatePanels()
    self:populateAvailableWebsites()

    self.labelWelcome = ISLabel:new(10, 10, 20, "Welcome, user!", 1, 1, 1, 1, UIFont.Small, true)
    self.labelWelcome:initialise()
    self.rightPanel:addChild(self.labelWelcome)

    self.cartLabel:setText(getText("UI_MailOrderCatalogs_ComputerUI_CartEmpty"))
    self.cartLabel:paginate()
    self.insufficientFundsLabel:setName("")
    self:updateCartLabel()
    self:updateTotalPriceLabel()
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:renderWebsite(siteID)
    self.rightPanel:clearChildren()
    self.itemsPerPage = self.itemsPerPage or {}
    if not self.currentPage then self.currentPage = {} end
    if not self.currentPage[siteID] then self.currentPage[siteID] = 1 end

    local fromQuickAccess = self.fromQuickAccess
    local currentPage = self.currentPage[siteID]
    local player = self:getPlayer()
    local card = self:getCard()
    -- local modData = card:getModData()
    -- local account = MailOrderCatalogs_BankServer.getOrCreateAccountByID(modData)

    local padding = 20
    local columnSpacing = 20
    local btnW, btnH = 160, 25
    local labelSpacing = 4
    local itemSpacing = 10
    local iconSize = 32

    local function measureWebsiteItem(item)
        local height = 0
        if fromQuickAccess then height = height + iconSize + labelSpacing end
        height = height + 20 + labelSpacing -- name
        height = height + 20 + labelSpacing -- price

        -- description height
        local desc = item.description or ""
        local tempRichText = ISRichTextPanel:new(0, 0, btnW, 1)
        tempRichText:initialise()
        tempRichText.autosetheight = true
        tempRichText:setMargins(0, 0, 0, 0)
        tempRichText:setText(desc)
        tempRichText:paginate()
        local descHeight = tempRichText:getHeight()
        height = height + math.max(descHeight, 60) + labelSpacing

        height = height + btnH + itemSpacing
        return height
    end

    local function renderWebsiteItem(x, y, item, forcedHeight)
        local currentY = y

        if fromQuickAccess then
            local itemTexture = MailOrderCatalogs_Utils.getItemIcon(item.name)
            if itemTexture then
                local iconImage = ISImage:new(x, currentY, iconSize, iconSize, itemTexture)
                iconImage:initialise()
                self.rightPanel:addChild(iconImage)
            end
            currentY = currentY + iconSize + labelSpacing
        end

        local rawDisplayName = MailOrderCatalogs_Utils.getItemDisplayName(item.name)
        local labelDisplayName = rawDisplayName or getText("UI_MailOrderCatalogs_ComputerUI_DoesNotExist")

        local itemNameLabel = ISRichTextPanel:new(x, currentY, btnW, 1)
        itemNameLabel:initialise()
        itemNameLabel.autosetheight = true
        itemNameLabel:noBackground()
        itemNameLabel:setMargins(0, 0, 0, 0)
        itemNameLabel:setText(getText("UI_MailOrderCatalogs_ComputerUI_ItemLabel") .. labelDisplayName)
        itemNameLabel:paginate()
        self.rightPanel:addChild(itemNameLabel)
        currentY = currentY + itemNameLabel:getHeight() + labelSpacing

        local price = MailOrderCatalogs_Utils.getItemPrice(item)

        local itemPriceLabel = ISLabel:new(x, currentY, 20,
            getText("UI_MailOrderCatalogs_ComputerUI_PriceLabel") .. string.format("%.2f", price),
            1, 1, 1, 1, UIFont.Small, true)
        itemPriceLabel:initialise()
        self.rightPanel:addChild(itemPriceLabel)
        currentY = currentY + itemPriceLabel:getHeight() + labelSpacing

        local descText = item.description or ""
        local descPanel = ISRichTextPanel:new(x, currentY, btnW, 1)
        descPanel:initialise()
        descPanel.autosetheight = true
        descPanel:noBackground()
        descPanel:setMargins(0, 0, 0, 0)
        descPanel:setText(descText)
        descPanel:paginate()
        self.rightPanel:addChild(descPanel)
        currentY = currentY + descPanel:getHeight() + labelSpacing

        local contentHeightSoFar = currentY - y
        local minNeededHeight = forcedHeight - (btnH + itemSpacing)
        local paddingNeeded = math.max(0, minNeededHeight - contentHeightSoFar)
        if paddingNeeded > 0 then
            local pad = ISPanel:new(x, currentY, btnW, paddingNeeded)
            pad:initialise()
            pad.background = false
            self.rightPanel:addChild(pad)
            currentY = currentY + paddingNeeded
        end

        local addToCartButton = ISButton:new(x, currentY, btnW, btnH,
            getText("UI_MailOrderCatalogs_ComputerUI_ButtonText"),
            self,
            function()
                local itemScript = getScriptManager():FindItem(item.name)
                if not itemScript then
                    print("[MailOrderCatalogs] Error: Item doesn't exist -> " .. tostring(item.name))
                    return
                end
                if not self.shoppingCart[item.name] then
                    self.shoppingCart[item.name] = { count = 1, item = item }
                else
                    self.shoppingCart[item.name].count = self.shoppingCart[item.name].count + 1
                end
                local price = MailOrderCatalogs_Utils.getItemPrice(item)
                table.insert(self.cartOrder, { name = item.name, price = price })
                self:updateCartLabel()
                self:updateTotalPriceLabel()
                self:updateLayout()
            end)
        addToCartButton:initialise()
        addToCartButton:instantiate()
        if rawDisplayName == nil then addToCartButton.enable = false end
        self.rightPanel:addChild(addToCartButton)

        currentY = currentY + btnH + itemSpacing
        return currentY
    end

    local siteData = MailOrderCatalogs_CatalogRegistrar.Websites[siteID]
    if not siteData then
        local label = ISLabel:new(padding, padding, 20,
            getText("UI_MailOrderCatalogs_ComputerUI_UnknownWebsite") .. tostring(siteID),
            1, 1, 1, 1, UIFont.Small, true)
        label:initialise()
        self.rightPanel:addChild(label)
        return
    end

    -- customRender sites (banking only) 
    if siteData.customRender then 
        siteData.customRender(self, siteID, player, card) 
        return 
    end

    -- welcome
    local introY = padding
    local function addIntroLabel(text)
        local label = ISLabel:new(padding, introY, 20, text, 1, 1, 1, 1, UIFont.Small, true)
        label:initialise()
        self.rightPanel:addChild(label)
        introY = introY + label:getHeight() + labelSpacing
    end
    addIntroLabel(getText("UI_MailOrderCatalogs_ComputerUI_WelcomeMessage") .. siteData.siteName)
    addIntroLabel(siteData.description or "")
    addIntroLabel("-----------------------------")

    local panelW = self.rightPanel:getWidth()
    local panelH = self.rightPanel:getHeight()
    local cardWidth = btnW + padding
    local numColumns = math.max(1, math.floor((panelW - padding) / (cardWidth + columnSpacing)))
    local columnXs, columnYs = {}, {}
    for i=1, numColumns do
        columnXs[i] = padding + (i - 1) * (cardWidth + columnSpacing)
        columnYs[i] = introY
    end

    local allItems = siteData.items or {}

    -- 1st pass: figure out how many fit
    local simYs = {}
    for i=1, numColumns do simYs[i] = introY end
    local itemsPerPageEstimate = {}
    local idx = 1
    while idx <= #allItems do
        local rowHeights, row = {}, {}
        for col = 1, numColumns do
            if idx > #allItems then break end
            local item = allItems[idx]
            rowHeights[col] = measureWebsiteItem(item)
            table.insert(row, {col=col, item=item})
            idx = idx + 1
        end
        local maxRowHeight = 0
        for _, h in ipairs(rowHeights) do maxRowHeight = math.max(maxRowHeight, h) end
        for _, ri in ipairs(row) do
            if simYs[ri.col] + maxRowHeight > panelH - 40 then
                idx = #allItems + 1
                break
            end
            simYs[ri.col] = simYs[ri.col] + maxRowHeight
            table.insert(itemsPerPageEstimate, ri.item)
        end
    end

    local perPageCount = #itemsPerPageEstimate
    local startIndex = (currentPage - 1) * perPageCount + 1
    local endIndex = math.min(#allItems, startIndex + perPageCount - 1)

    -- 2nd pass: render items that fit
    local columnYsReal = {}
    for i=1, numColumns do columnYsReal[i] = introY end

    local i = startIndex
    while i <= endIndex do
        local rowHeights, rowItems = {}, {}
        for col = 1, numColumns do
            if i > endIndex then break end
            local item = allItems[i]
            rowHeights[col] = measureWebsiteItem(item)
            table.insert(rowItems, { col = col, item = item })
            i = i + 1
        end
        local maxRowHeight = 0
        for _, h in ipairs(rowHeights) do maxRowHeight = math.max(maxRowHeight, h) end
        for _, ri in ipairs(rowItems) do
            columnYsReal[ri.col] = renderWebsiteItem(columnXs[ri.col], columnYsReal[ri.col], ri.item, maxRowHeight)
        end
    end

    -- pagination
    local rightPanelW, rightPanelH = self.rightPanel:getWidth(), self.rightPanel:getHeight()
    local navBtnW, navBtnH = 80, 25
    local navPadding = 10
    if endIndex < #allItems then
        self.nextButton = ISButton:new(rightPanelW - navBtnW - navPadding,
            rightPanelH - navBtnH - navPadding, navBtnW, navBtnH,
            getText("UI_MailOrderCatalogs_ComputerUI_NextButton"),
            self,
            function()
                self.currentPage[siteID] = self.currentPage[siteID] + 1
                self:renderWebsite(siteID)
            end)
        self.nextButton:initialise()
        self.nextButton:instantiate()
        self.rightPanel:addChild(self.nextButton)
    end
    if currentPage > 1 then
        self.prevButton = ISButton:new(rightPanelW - (navBtnW * 2) - (navPadding * 2),
            rightPanelH - navBtnH - navPadding, navBtnW, navBtnH,
            getText("UI_MailOrderCatalogs_ComputerUI_PreviousButton"),
            self,
            function()
                self.currentPage[siteID] = math.max(1, currentPage - 1)
                self:renderWebsite(siteID)
            end)
        self.prevButton:initialise()
        self.prevButton:instantiate()
        self.rightPanel:addChild(self.prevButton)
    end
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:loadWebsite(siteID, fromQuickAccess)
    self.currentWebsiteID = siteID
    self.fromQuickAccess = fromQuickAccess or false
    self:renderWebsite(siteID)
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:setObject(object)
    self.object = object
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:getObject()
    return self.object
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:setPlayer(player)
    self.player = player
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:getPlayer()
    return self.player
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:setCard(card)
    self.card = card
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:getCard()
    return self.card
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:initialise()
    ISCollapsableWindow.initialise(self)
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:onKeyPress(key)
    ISCollapsableWindow.onKeyPress(self, key)

    if key == Keyboard.KEY_ESCAPE then
        self:close()
        self:setVisible(false)
        MailOrderCatalogs_ComputerUI.instance = nil
    end
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:createChildren()
    ISCollapsableWindow.createChildren(self)

    local obj = self:getObject()
    local square = obj and obj:getSquare()
    self.hasPower = MailOrderCatalogs_Utils.checkPower(square)
    if isDebugEnabled() then
        print("[MailOrderCatalogs] Debug: local obj = " .. tostring(obj))
        print("[MailOrderCatalogs] Debug: local square = " .. tostring(square))
        print("[MailOrderCatalogs] Debug: Square has power: " .. tostring(square:haveElectricity()))
        print("[MailOrderCatalogs] Debug: Computer has power: " .. tostring(self.hasPower))
        print("[MailOrderCatalogs] Debug: Sprite: " .. tostring(obj:getSprite() and obj:getSprite():getName()))
        print("[MailOrderCatalogs] Debug: ElecShutModifier: " .. tostring(SandboxVars.ElecShutModifier))
        print("[MailOrderCatalogs] Debug: Nights Survived: " .. tostring(GameTime:getInstance():getNightsSurvived()))
        print("[MailOrderCatalogs] Debug: Is Outside: " .. tostring(square:isOutside()))
        print("[MailOrderCatalogs] Debug: Condition: " .. tostring(SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier and not square:isOutside()))
    end

    local modData = obj and obj:getModData()
    self.isOn = modData and modData.ComputerIsOn or false

    local padding = 10
    local resizeBarHeight = 12

    local powerButtonX, powerButtonY, powerButtonW, powerButtonH = 40, 30, 60, 25

    local ledW, ledH = 20, 20
    local ledX = powerButtonX - ledW - padding
    local ledY = powerButtonY + (powerButtonH - ledH) / 2

    local powerLabelH = 20
    local powerLabelX = powerButtonX + powerButtonW + padding
    local powerLabelY = powerButtonY + (powerButtonH - powerLabelH) / 2

    -- add led
    self.led = ISLedLight:new(ledX, ledY, ledW, ledH)
    self.led:initialise()
    self.led:setLedColor(1, 0, 1, 0)
    self.led:setLedColorOff(1, 0, 0.3, 0)
    self:addChild(self.led)

    -- add power button
    local powerButtonText = getText(self.isOn and "ContextMenu_Turn_Off" or "ContextMenu_Turn_On")
    self.powerButton = ISButton:new(powerButtonX, powerButtonY, powerButtonW, powerButtonH, powerButtonText, self, function()
        self:togglePower()
    end)    
    self.powerButton:initialise()
    self.powerButton:instantiate()
    self.powerButton:setEnable(self.hasPower)
    self:addChild(self.powerButton)

    -- add power label
    local powerLabelText = getText(self.isOn and "IGUI_RadioRequiresPowerNearby" or "IGUI_RadioPowerNearby")
    local color
    if self.hasPower then
        color = self.isOn and getCore():getBadHighlitedColor() or getCore():getGoodHighlitedColor()
    else
        color = getCore():getBadHighlitedColor()
    end
    self.powerStateLabel = ISLabel:new(powerLabelX, powerLabelY, powerLabelH, powerLabelText, 1, 1, 1, 1, UIFont.Small, true)
    self.powerStateLabel:setColor(color:getR(), color:getG(), color:getB())
    self:addChild(self.powerStateLabel)

    -- debug
    if isDebugEnabled() then
        local debugButtonW, debugButtonH = 150, 25
        local debugButtonY = powerButtonY
        local debugButtonX = self.width - debugButtonW - padding
        self.debugTogglePowerButton = ISButton:new(
            debugButtonX, debugButtonY, debugButtonW, debugButtonH, 
            getText("UI_MailOrderCatalogs_ComputerUI_DebugButton"), 
            self, 
            function()
                self.hasPower = not self.hasPower
                print("[MailOrderCatalogs] Debug: Power toggled to: ", self.hasPower)
                self:refreshPowerState()
            end)
        self.debugTogglePowerButton:initialise()
        self.debugTogglePowerButton:instantiate()
        self:addChild(self.debugTogglePowerButton)
    end

    -- add reset ui button
    local resetButtonW, resetButtonH = 80, 25
    local resetButtonX, resetButtonY
    if isDebugEnabled() then
        resetButtonX = self.width - 150 - resetButtonW - (padding * 2)
        resetButtonY = powerButtonY
    else
        resetButtonX = self.width - resetButtonW - padding
        resetButtonY = powerButtonY
    end
    self.resetUISizeButton = ISButton:new(
        resetButtonX, resetButtonY, resetButtonW, resetButtonH, 
        getText("UI_MailOrderCatalogs_ComputerUI_ResetUIButton"), 
        self, 
        function()
            local globalModData = ModData.getOrCreate("MailOrderCatalogs_ComputerUI_Settings")
            globalModData.savedWidth = nil
            globalModData.savedHeight = nil
            ModData.transmit("MailOrderCatalogs_ComputerUI_Settings")
            self:setWidth(1200)
            self:setHeight(800)
            self:updateLayout()
            self.leftScrollPanel:addScrollBars()
            print("[MailOrderCatalogs] General: Reverting Computer Terminal back to default size.")
        end)
    self.resetUISizeButton:initialise()
    self.resetUISizeButton:instantiate()
    self:addChild(self.resetUISizeButton)

    -- url bar
    local urlTitle = ""
    local urlX = padding
    local urlY = 70
    local urlW = self.width - padding * 2
    local urlH = 20
    self.urlBar = ISTextEntryBox:new(urlTitle, urlX, urlY, urlW, urlH)
    self.urlBar:initialise()
    self.urlBar:instantiate()
    self.urlBar:setTooltip(getText("Tooltip_MailOrderCatalogs_ComputerUI_URLBar"))
    self:addChild(self.urlBar)

    -- url go button
    local urlGoBtnW, urlGoBtnH = 60, 20
    local urlGoBtnX = self.width - 60 - padding
    local urlGoBtnY = 70
    self.urlGoButton = ISButton:new(
        urlGoBtnX, urlGoBtnY, urlGoBtnW, urlGoBtnH, 
        getText("UI_MailOrderCatalogs_ComputerUI_Visit"), 
        self, 
        function()
            local url = self.urlBar:getText()
            if self.isOn then
                self:loadWebsite(url)
            end
        end)
    self.urlGoButton:initialise()
    self.urlGoButton:instantiate()
    self:addChild(self.urlGoButton)

    -- ********************************
    -- *
    -- * panels for browsing websites
    -- *
    -- ********************************

    -- left box
    local leftBoxX = padding
    local leftBoxY = 100
    local leftBoxW = self.width / 8 - padding
    local leftBoxH = self.height - leftBoxY - padding - resizeBarHeight

    -- dynamic bottom height
    local totalUsableHeight = self.height - leftBoxY - padding * 2
    local bottomBoxH = math.max(100, totalUsableHeight * 0.25)

    -- bottom box
    local bottomBoxX = leftBoxX + leftBoxW + padding
    local bottomBoxY = self.height - bottomBoxH - padding - resizeBarHeight
    local bottomBoxW = self.width - bottomBoxX - padding

    -- right box
    local rightBoxX = bottomBoxX
    local rightBoxY = leftBoxY
    local rightBoxW = bottomBoxW
    local rightBoxH = bottomBoxY - rightBoxY - padding

    self.leftScrollPanel = ISScrollingListBox:new(leftBoxX, leftBoxY, leftBoxW, leftBoxH)
    self.leftScrollPanel:initialise()
    self:addChild(self.leftScrollPanel)

    -- **********************************************
    -- please figure me out :( I need to be adjusted
    -- **********************************************

    -- self.leftScrollPanel.font = UIFont.Small
    -- self.leftScrollPanel.itemheight = 24

    local windowSelf = self
    self.leftScrollPanel.onMouseDown = function(listBox, x, y)
        local index = listBox:rowAt(x, y)
        if index ~= -1 then
            listBox.selected = index
            local siteData = listBox.items[index].item
            windowSelf:loadWebsite(siteData.siteID, true)
        end
    end

    self.rightPanel = ISPanel:new(rightBoxX, rightBoxY, rightBoxW, rightBoxH)
    self.rightPanel:initialise()
    self:addChild(self.rightPanel)

    self.bottomPanel = ISPanel:new(bottomBoxX, bottomBoxY, bottomBoxW, bottomBoxH)
    self.bottomPanel:initialise()
    self:addChild(self.bottomPanel)

    -- add shopping cart buttons to bottomPanel
    local btnW, btnH = 100, 25
    local spacing = 10
    local btnTotalWidth = btnW * 3 + spacing * 2

    local btnY = self.bottomPanel.height - btnH - padding
    local btnX = self.bottomPanel.width - btnTotalWidth - padding

    self.removeLastItemButton = ISButton:new(btnX, btnY, btnW, btnH, getText("UI_MailOrderCatalogs_ComputerUI_RemoveLast"), self, function()
        if #self.cartOrder == 0 then return end

        -- remove last item
        local lastEntry = table.remove(self.cartOrder)

        -- update shoppingCart count
        if lastEntry and self.shoppingCart[lastEntry.name] then
            self.shoppingCart[lastEntry.name].count = self.shoppingCart[lastEntry.name].count - 1
            if self.shoppingCart[lastEntry.name].count <= 0 then
                self.shoppingCart[lastEntry.name] = nil
            end
        end
        self.insufficientFundsLabel:setName("")
        self:updateCartLabel()
        self:updateTotalPriceLabel()
        self:updateLayout()
    end)
    self.removeLastItemButton:initialise()
    self.removeLastItemButton:instantiate()
    self.bottomPanel:addChild(self.removeLastItemButton)

    self.emptyCartButton = ISButton:new(btnX + btnW + spacing, btnY, btnW, btnH, getText("UI_MailOrderCatalogs_ComputerUI_EmptyCart"), self, function()
        self.shoppingCart = {}
        self.cartOrder = {}
        self.insufficientFundsLabel:setName("")
        self:updateCartLabel()
        self:updateTotalPriceLabel()
        self:updateLayout()
    end)
    self.emptyCartButton:initialise()
    self.emptyCartButton:instantiate()
    self.bottomPanel:addChild(self.emptyCartButton)

    self.totalPriceLabel = ISLabel:new(btnX + (btnW + spacing) * 2, btnY - 20, 20, getText("UI_MailOrderCatalogs_ComputerUI_TotalPrice") .. "$0.00", 1, 1, 1, 1, UIFont.Small, true)
    self.totalPriceLabel:initialise()
    self.bottomPanel:addChild(self.totalPriceLabel)

    self.checkoutButton = ISButton:new(btnX + (btnW + spacing) * 2, btnY, btnW, btnH, getText("UI_MailOrderCatalogs_ComputerUI_Checkout"), self, function()
        local isEmpty = true
        for _, data in pairs(self.shoppingCart) do
            if data.count and data.count > 0 then
                isEmpty = false
                break
            end
        end
        if isEmpty then return end

        -- get total cost
        local totalCost = 0
        for _, entry in ipairs(self.cartOrder) do
            totalCost = totalCost + (entry.price or 0)
        end

        -- get account and validate funds
        local card = self:getCard()
        if not card then
            self.insufficientFundsLabel:setName(getText("UI_MailOrderCatalogs_ComputerUI_NoCard"))
            return
        end

        local modData = card:getModData()
        local account = MailOrderCatalogs_BankServer.getOrCreateAccountByID(modData)
        if not account then
            self.insufficientFundsLabel:setName(getText("UI_MailOrderCatalogs_ComputerUI_NoBank"))
            return
        end

        local balance = MailOrderCatalogs_BankServer.getBalance(modData)
        if balance < totalCost then
            self.insufficientFundsLabel:setName(getText("UI_MailOrderCatalogs_ComputerUI_NoMoney"))
            return
        end

        MailOrderCatalogs_BankServer.setBalance(modData, balance - totalCost)

        -- clear warning
        self.insufficientFundsLabel:setName("")

        -- deliver items
        local player = self:getPlayer()
        for name, data in pairs(self.shoppingCart) do
            for i=1, data.count do
                MailOrderCatalogs_Delivery.deliverItem(name, player)
                -- PREP FOR FLUID CONTAINERS

                -- if data.rgb then
                --     MailOrderCatalogs_Delivery.deliverColoredFluidItem(name, data.rgb, player)
                -- else
                --     MailOrderCatalogs_Delivery.deliverItem(name, player)
                -- end
            end
        end
        self.shoppingCart = {}
        self.cartOrder = {}
        self:updateCartLabel()
        self:updateTotalPriceLabel()
        self:close()
    end)
    self.checkoutButton:initialise()
    self.checkoutButton:instantiate()
    self.bottomPanel:addChild(self.checkoutButton)

    self.shoppingCart = {}
    self.cartOrder = {}

    self.cartLabel = ISRichTextPanel:new(10, 10, self.bottomPanel.width, 1)
    self.cartLabel:initialise()
    self.cartLabel.autosetheight = true
    self.cartLabel:noBackground()
    self.cartLabel:setMargins(0, 0, 0, 0)
    self.cartLabel:setText(getText("UI_MailOrderCatalogs_ComputerUI_CartEmpty"))
    self.cartLabel:paginate()
    self.bottomPanel:addChild(self.cartLabel)

    local labelPadding = 5
    local labelH = 20
    local labelY = ((self.bottomPanel.height / 2) - labelH - labelPadding)

    self.insufficientFundsLabel = ISLabel:new(10, labelH, labelY, "", 1, 0.2, 0.2, 1, UIFont.Small, true)
    self.insufficientFundsLabel:initialise()
    self.bottomPanel:addChild(self.insufficientFundsLabel)

    if self.IsOn then
        self:populatePanels()
    end

    self.bottomUIElements = {
        self.removeLastItemButton,
        self.emptyCartButton,
        self.checkoutButton,
        self.totalPriceLabel,
        self.cartLabel,
        self.insufficientFundsLabel,
    }

    if not self.isOn then
        for _, element in ipairs(self.bottomUIElements) do
            element:setVisible(false)
        end
    end
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:updateLayout()
    local padding = 10
    local resizeBarHeight = 12

    -- left box
    local leftBoxX = padding
    local leftBoxY = 100
    local leftBoxW = self.width / 8 - padding
    local leftBoxH = self.height - leftBoxY - padding - resizeBarHeight

    -- dynamic bottom height
    local totalUsableHeight = self.height - leftBoxY - padding * 2
    local bottomBoxH = math.max(100, totalUsableHeight * 0.25)

    -- bottom box
    local bottomBoxX = leftBoxX + leftBoxW + padding
    local bottomBoxY = self.height - bottomBoxH - padding - resizeBarHeight
    local bottomBoxW = self.width - bottomBoxX - padding

    -- right box
    local rightBoxX = bottomBoxX
    local rightBoxY = leftBoxY
    local rightBoxW = bottomBoxW
    local rightBoxH = bottomBoxY - rightBoxY - padding

    -- update panels
    if self.leftScrollPanel then
        self.leftScrollPanel:setX(leftBoxX)
        self.leftScrollPanel:setY(leftBoxY)
        self.leftScrollPanel:setWidth(leftBoxW)
        self.leftScrollPanel:setHeight(leftBoxH)
    end

    if self.rightPanel then
        self.rightPanel:setX(rightBoxX)
        self.rightPanel:setY(rightBoxY)
        self.rightPanel:setWidth(rightBoxW)
        self.rightPanel:setHeight(rightBoxH)
    end

    if self.bottomPanel then
        self.bottomPanel:setX(bottomBoxX)
        self.bottomPanel:setY(bottomBoxY)
        self.bottomPanel:setWidth(bottomBoxW)
        self.bottomPanel:setHeight(bottomBoxH)
    end

    -- update debug button position if it exists
    if self.debugTogglePowerButton then
        local debugButtonW, debugButtonH = 150, 25
        local debugButtonX = self.width - debugButtonW - 10
        local debugButtonY = 30
        self.debugTogglePowerButton:setX(debugButtonX)
        self.debugTogglePowerButton:setY(debugButtonY)

        -- update reset button position relative to debug button
        if self.resetUISizeButton then
            local resetButtonW, resetButtonH = 80, 25
            local resetButtonX = debugButtonX - resetButtonW - 10
            local resetButtonY = debugButtonY
            self.resetUISizeButton:setX(resetButtonX)
            self.resetUISizeButton:setY(resetButtonY)
        end
    else
        -- update reset button position if no debug button
        if self.resetUISizeButton then
            local resetButtonW, resetButtonH = 80, 25
            local resetButtonX = self.width - resetButtonW - 10
            local resetButtonY = 30
            self.resetUISizeButton:setX(resetButtonX)
            self.resetUISizeButton:setY(resetButtonY)
        end
    end

    -- update url bar
    if self.urlBar then
        self.urlBar:setX(padding)
        self.urlBar:setY(70)
        self.urlBar:setWidth(self.width - padding * 2)
        self.urlBar:setHeight(20)
    end

    -- update url go button
    if self.urlGoButton then
        self.urlGoButton:setX(self.width - 60 - padding)
        self.urlGoButton:setY(70)
    end

    -- update navigation buttons inside rightPanel
    if self.rightPanel and self.nextButton and self.prevButton then
        local navBtnW, navBtnH = 80, 25
        local padding = 10

        local rightPanelW = self.rightPanel:getWidth()
        local rightPanelH = self.rightPanel:getHeight()

        self.nextButton:setX(rightPanelW - navBtnW - padding)
        self.nextButton:setY(rightPanelH - navBtnH - padding)

        self.prevButton:setX(rightPanelW - (navBtnW * 2) - (padding * 2))
        self.prevButton:setY(rightPanelH - navBtnH - padding)
    end
    
    -- update shopping cart buttons in bottomPanel
    if self.bottomPanel and self.removeLastItemButton and self.emptyCartButton and self.checkoutButton then
        local btnW, btnH = 100, 25
        local spacing = 10
        local padding = 10

        local panelW = self.bottomPanel:getWidth()
        local panelH = self.bottomPanel:getHeight()

        local btnTotalWidth = btnW * 3 + spacing * 2
        local btnY = panelH - btnH - padding
        local btnX = panelW - btnTotalWidth - padding

        self.removeLastItemButton:setX(btnX)
        self.removeLastItemButton:setY(btnY)

        self.emptyCartButton:setX(btnX + btnW + spacing)
        self.emptyCartButton:setY(btnY)

        self.checkoutButton:setX(btnX + (btnW + spacing) * 2)
        self.checkoutButton:setY(btnY)

        if self.totalPriceLabel then
            self.totalPriceLabel:setX(btnX + (btnW + spacing) * 2)
            self.totalPriceLabel:setY(btnY - 20)
        end

        if self.bottomPanel and self.insufficientFundsLabel then
            local labelPadding = 5
            local labelH = self.insufficientFundsLabel.height
            self.insufficientFundsLabel:setX(10)
            self.insufficientFundsLabel:setY(self.bottomPanel:getHeight() - labelH - labelPadding)
        end
    end

    -- re-render website if one is loaded
    if self.currentWebsiteID then
        self:renderWebsite(self.currentWebsiteID)
    end
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:onResize()
    ISCollapsableWindow.onResize(self)
    self:updateLayout()
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:close()
    ISCollapsableWindow.close(self)
    print("[MailOrderCatalogs] General: Saving Computer Terminal size")

    -- save window size in mod data
    local modData = ModData.getOrCreate("MailOrderCatalogs_ComputerUI_Settings")
    modData.savedWidth = self:getWidth()
    modData.savedHeight = self:getHeight()
    ModData.transmit("MailOrderCatalogs_ComputerUI_Settings")

    -- turn computer off when closed
    MailOrderCatalogs_Utils.ensureComputerIsOff(self:getObject())
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:refreshPowerState()

    if not self.hasPower then
        self.isOn = false

        -- save power state to the worldobject
        MailOrderCatalogs_Utils.ensureComputerIsOff(self:getObject())

        local color = getCore():getBadHighlitedColor()
        self.powerStateLabel:setName(getText("IGUI_RadioRequiresPowerNearby"))
        self.powerStateLabel:setColor(color:getR(), color:getG(), color:getB())
        self.powerButton:setTitle(getText("ContextMenu_Turn_On"))
        self.powerButton:setEnable(false)

        if self.led then
            self.led:setLedIsOn(true)
            self.led:setLedColor(1, 1, 0, 0)
        end
    else
        self.powerButton:setEnable(true)

        local powerLabelText = getText(self.isOn and "IGUI_RadioRequiresPowerNearby" or "IGUI_RadioPowerNearby")
        local color = self.isOn and getCore():getBadHighlitedColor() or getCore():getGoodHighlitedColor()
        self.powerStateLabel:setName(powerLabelText)
        self.powerStateLabel:setColor(color:getR(), color:getG(), color:getB())

        if self.led then 
            self.led:setLedIsOn(self.isOn)
            self.led:setLedColor(1, 0, 1, 0)
        end
    end
end

function MailOrderCatalogs_ComputerUI.ComputerWindow:togglePower()
    local obj = self:getObject()
    local square = obj and obj:getSquare()
    local hasPower = MailOrderCatalogs_Utils.checkPower(square)

    if not hasPower then
        local color = getCore():getBadHighlitedColor()
        self.powerStateLabel:setName(getText("IGUI_RadioRequiresPowerNearby"))
        self.powerStateLabel:setColor(color:getR(), color:getG(), color:getB())
        self.powerButton:setEnable(false)
        if self.led then self.led:setLedIsOn(false) end
        return
    end

    self.isOn = not self.isOn

    self.powerButton:setTitle(getText(self.isOn and "ContextMenu_Turn_Off" or "ContextMenu_Turn_On"))

    if self.led then
        self.led:setLedIsOn(self.isOn)
    end

    MailOrderCatalogs_Utils.setPowerState(obj, self.isOn)

    -- show or clear panel contents
    if self.isOn then
        self:populatePanels()
    else
        self.leftScrollPanel:clear()
        self.rightPanel:clearChildren()

        if self.cartLabel then 
            self.cartLabel:setText("")
            self.cartLabel:paginate() 
        end
        if self.insufficientFundsLabel then self.insufficientFundsLabel:setName("") end
        if self.totalPriceLabel then self.totalPriceLabel:setName(getText("UI_MailOrderCatalogs_ComputerUI_TotalPrice") .. "$0.00") end

        self.urlBar:setText("")
        self.currentWebsiteID = nil

        self.shoppingCart = {}
        self.cartOrder = {}

        self:updateCartLabel()
        self:updateTotalPriceLabel()
    end

    -- toggle visibility of bottom panel UI elements
    if self.bottomUIElements then
        for _, element in ipairs(self.bottomUIElements) do
            element:setVisible(self.isOn)
        end
    end
end


function MailOrderCatalogs_ComputerUI.openComputerUI(object, player)
    if MailOrderCatalogs_ComputerUI.instance and MailOrderCatalogs_ComputerUI.instance:isVisible() then
        return
    end
    local card = MailOrderCatalogs_Utils.getPlayerCard(player)
    if not card then
        print("[MailOrderCatalogs] General: No Credit Card found.")
        -- return

    end

    local defaultWidth, defaultHeight = 1200, 800
    local modData = ModData.getOrCreate("MailOrderCatalogs_ComputerUI_Settings")
    local width = modData.savedWidth or defaultWidth
    local height = modData.savedHeight or defaultHeight

    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2

    local panel = MailOrderCatalogs_ComputerUI.ComputerWindow:new(x, y, width, height)
    panel:setObject(object)
    panel:setPlayer(player)
    panel:setCard(card)
    panel:initialise()
    panel:addToUIManager()
    panel:setVisible(true)
    panel:setResizable(true)
    panel:setTitle(getText("UI_MailOrderCatalogs_ComputerUI_ComputerTitle"))

    MailOrderCatalogs_ComputerUI.instance = panel

    if card then
        local modData = card:getModData()
        MailOrderCatalogs_Utils.ensureCardHasData(card)
        local account = MailOrderCatalogs_BankServer.getOrCreateAccountByID(modData)

        if isDebugEnabled() then
            print("[MailOrderCatalogs] Debug: Player: " .. tostring(player))
            print("[MailOrderCatalogs] Debug: Credit Card Owner: " .. tostring(modData.owner))
            print("[MailOrderCatalogs] Debug: Credit Card Account ID: " .. tostring(modData.accountID))
            print("[MailOrderCatalogs] Debug: Credit Card Number: **** **** **** " .. tostring(modData.last4))
            print("[MailOrderCatalogs] Debug: Credit Card PIN: " .. tostring(modData.pin))
            print("[MailOrderCatalogs] Debug: Credit Card Attempts: " .. tostring(modData.attempts) .. "/3")
            local descriptor = player:getDescriptor()
            print("[MailOrderCatalogs] Debug: I own this Credit Card: " .. tostring(modData.owner == descriptor:getForename() .. " " .. descriptor:getSurname()))
            print("[MailOrderCatalogs] Debug: This Credit Card is stolen: " .. tostring(modData.isStolen))
            print("[MailOrderCatalogs] Debug: My account balance is: " .. tostring(account.balance))
        end
    end
end

return MailOrderCatalogs_ComputerUI