-- MailOrderCatalogs_Utils
local MailOrderCatalogs_Utils = {}

MailOrderCatalogs_Utils.validComputerSprites = {
    ["appliances_com_01_72"] = true, -- off
    ["appliances_com_01_73"] = true, -- off
    ["appliances_com_01_74"] = true, -- off
    ["appliances_com_01_75"] = true, -- off
    ["appliances_com_01_76"] = true, -- on
    ["appliances_com_01_77"] = true, -- on
    ["appliances_com_01_78"] = true, -- on
    ["appliances_com_01_79"] = true, -- on
}

MailOrderCatalogs_Utils.ComputerFacingDirections = {
    ["appliances_com_01_72"] = 2, -- South
    ["appliances_com_01_73"] = 1, -- East
    ["appliances_com_01_74"] = 0, -- North
    ["appliances_com_01_75"] = 3, -- West
    ["appliances_com_01_76"] = 2, -- South
    ["appliances_com_01_77"] = 1, -- East
    ["appliances_com_01_78"] = 0, -- North
    ["appliances_com_01_79"] = 3, -- West
}

function MailOrderCatalogs_Utils.isValidComputerSprite(spriteName)
    return MailOrderCatalogs_Utils.validComputerSprites[spriteName] == true
end

function MailOrderCatalogs_Utils.getFrontSquareOfComputer(obj)
    return MailOrderCatalogs_Utils.getFrontSquareFromDirectionTable(obj, MailOrderCatalogs_Utils.ComputerFacingDirections)
end

MailOrderCatalogs_Utils.validATMSprites = {
    ["location_business_bank_01_64"] = true, -- standalone
    ["location_business_bank_01_65"] = true, -- standalone
    ["location_business_bank_01_66"] = true, -- in wall
    ["location_business_bank_01_67"] = true, -- in wall
}

MailOrderCatalogs_Utils.ATMFacingDirections = {
    ["location_business_bank_01_64"] = 1, -- East
    ["location_business_bank_01_65"] = 2, -- South
    ["location_business_bank_01_66"] = 1, -- East
    ["location_business_bank_01_67"] = 2, -- South
}

function MailOrderCatalogs_Utils.isValidATMSprite(spriteName)
    return MailOrderCatalogs_Utils.validATMSprites[spriteName] == true
end

function MailOrderCatalogs_Utils.getFrontSquareOfATM(obj)
    return MailOrderCatalogs_Utils.getFrontSquareFromDirectionTable(obj, MailOrderCatalogs_Utils.ATMFacingDirections)
end

function MailOrderCatalogs_Utils.getFrontSquareFromDirectionTable(obj, directionTable)
    local sprite = obj:getSprite()
    if not sprite then return nil end

    local spriteName = sprite:getName()
    local dir = directionTable[spriteName]
    if not dir then return nil end

    local dx, dy = 0, 0
    if dir == 0 then dy = -1
    elseif dir == 1 then dx = 1
    elseif dir == 2 then dy = 1
    elseif dir == 3 then dx = -1
    end

    local square = obj:getSquare()
    return getCell():getGridSquare(square:getX() + dx, square:getY() + dy, square:getZ())
end

function MailOrderCatalogs_Utils.setSprite(obj, newSpriteName)
    obj:setSprite(getSprite(newSpriteName))
    obj:transmitUpdatedSpriteToServer()
end

function MailOrderCatalogs_Utils.getSpriteIDFromName(name)
    local base, id = string.match(name, "^(appliances_com_01_)(%d+)$")
    return base, tonumber(id)
end

function MailOrderCatalogs_Utils.setSpriteOffset(obj, spriteName, offset)
    if spriteName then
        local base, id = MailOrderCatalogs_Utils.getSpriteIDFromName(spriteName)
        if base and id then
            local newID = id + offset
            local newSprite = base .. tostring(newID)
            MailOrderCatalogs_Utils.setSprite(obj, newSprite)
        end
    end
end

function MailOrderCatalogs_Utils.checkAndSetApplianceOffset(obj, spriteName)
    if spriteName and spriteName:match("^appliances_com_01_7[6-9]$") then
        MailOrderCatalogs_Utils.setSpriteOffset(obj, spriteName, -4)
        return true
    end
    return false
end

function MailOrderCatalogs_Utils.setPowerState(object, isOn)
    if not object then return end

    -- save the power state
    local modData = object:getModData()
    modData.ComputerIsOn = isOn

    --[[
        patch for S4_Economy
        due to the mod automatically disabling 
        "turned on" computer sprite if S4_Economy doesn't
        believe it should be turned on.
    ]]
    if getActivatedMods():contains("\\S4_Economy") then
        return
    end

    -- update the sprite offset
    local sprite = object:getSprite()
    local spriteName = sprite and sprite:getName()
    if spriteName then
        local offset = isOn and 4 or -4
        MailOrderCatalogs_Utils.setSpriteOffset(object, spriteName, offset)
    end
end

function MailOrderCatalogs_Utils.ensureComputerIsOff(object)
    if not object then return end

    local modData = object:getModData()
    modData.ComputerIsOn = false

    local sprite = object:getSprite()
    local spriteName = sprite and sprite:getName()

    MailOrderCatalogs_Utils.checkAndSetApplianceOffset(object, spriteName)
end

function MailOrderCatalogs_Utils.getItemIcon(itemName)
    if not itemName then return nil end
    print("[MailOrderCatalogs] Debug: Item name -> " .. tostring(itemName))

    local scriptItem = getScriptManager():FindItem(itemName)
    print("[MailOrderCatalogs] Debug: Script item -> " .. tostring(scriptItem))
    if not scriptItem then
        print("[MailOrderCatalogs] Error: Item not found -> " .. tostring(itemName))
        return nil
    end

    -- check for multiple icons
    local icons = scriptItem:getIconsForTexture()
    if icons and not icons:isEmpty() then
        local iconName = icons:get(0)  -- default to first one for now, in future display all
        local iconTexture = getTexture(iconName) or getTexture("Item_" .. iconName)
        if not iconTexture then
            iconTexture = getTexture("media/textures/Item_" .. iconName .. ".png")
        end
        return iconTexture
    end

    -- use single icon
    local iconName = scriptItem:getIcon()
    local iconTexture = getTexture(iconName) or getTexture("Item_" .. iconName)
    if not iconTexture then
        iconTexture = getTexture("media/textures/Item_" .. iconName .. ".png")
    end
    if not iconTexture then
        print("[MailOrderCatalogs] Error: Texture file missing or failed to load -> Item_" .. tostring(iconName) .. ".png")
    end
    return iconTexture
end

function MailOrderCatalogs_Utils.getItemDisplayName(itemName)
    if not itemName then return nil end
    -- print("[MailOrderCatalogs] Debug: Item name -> " .. tostring(itemName))

    local scriptItem = ScriptManager.instance:getItem(itemName)
    -- print("[MailOrderCatalogs] Debug: Script item -> " .. tostring(scriptItem))
    if not scriptItem then
        print("[MailOrderCatalogs] Error: Item not found -> " .. tostring(itemName))
        return nil
    end

    local displayName = scriptItem:getDisplayName()
    -- print("[MailOrderCatalogs] Debug: Display name -> " .. tostring(displayName))
    if not displayName then
        print("[MailOrderCatalogs] Error: No display name found for item -> " .. tostring(itemName))
        return nil
    end
    return displayName
end

local function isSquarePowered(square)
    return (
        (SandboxVars.AllowExteriorGenerator and square:haveElectricity()) or
        (SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier and not square:isOutside())
    )
end

-- required for ATM outside of post office in Ekron
-- it's part of the building, but not defined as part of the building
local function isNearbySquarePowered(square, radius)
    if not square then return false end
    radius = radius or 1

    for dx = -radius, radius do
        for dy = -radius, radius do
            local checkSquare = getCell():getGridSquare(square:getX() + dx, square:getY() + dy, square:getZ())
            if checkSquare and isSquarePowered(checkSquare) then
                return true
            end
        end
    end
    return false
end

function MailOrderCatalogs_Utils.checkPower(square)
    if not square then return false end
    return isSquarePowered(square)
end

function MailOrderCatalogs_Utils.isATMPowered(obj)
    if not obj then return false end
    local square = obj:getSquare()
    if not square then return false end
    -- return isSquarePowered(square)
    return isNearbySquarePowered(square, 3)
end

function MailOrderCatalogs_Utils.getAllCreditCards(player)
    local cards = {}
    local inv = player:getInventory():getItems()
    for i=0, inv:size()-1 do
        local item = inv:get(i)
        if item:getType() == "CreditCard" then
            table.insert(cards, item)
        end
    end
    return cards
end

function MailOrderCatalogs_Utils.getPlayerCard(player)
    local descriptor = player:getDescriptor()
    local fullName = descriptor:getForename() .. " " .. descriptor:getSurname()

    local inv = player:getInventory():getItems()
    for i = 0, inv:size() - 1 do
        local item = inv:get(i)
        if item:getType() == "CreditCard" then
            local modData = item:getModData()
            if modData and modData.owner == fullName then
                return item
            end
        end
    end
    return nil
end

function MailOrderCatalogs_Utils.generateRandomPIN()
    local num = ZombRand(0, 100)
    return string.format("%02d", num)
end

function MailOrderCatalogs_Utils.ensureCardHasData(card)
    local modData = card:getModData()
    if not modData.pin then
        modData.pin = MailOrderCatalogs_Utils.generateRandomPIN()
    end
    if not modData.attempts then
        modData.attempts = 0
    end
    if not modData.last4 then
        modData.last4 = tostring(ZombRand(1000, 9999))
    end
    if not modData.owner then
        local name = card:getName() or ""
        local found = name:match("Credit Card[:%s]*(.+)")
        modData.owner = found or "Unknown"
    end
    if not modData.accountID then
        modData.accountID = "FAKE_" .. tostring(ZombRand(100000, 999999)) .. "_" .. modData.owner
    end
    if not modData.isStolen then
        modData.isStolen = false
    end
end

function MailOrderCatalogs_Utils.isAutomaticOwnerPINEnabled()
    return SandboxVars.MailOrderCatalogs and SandboxVars.MailOrderCatalogs.OwnerPIN == true
end

function MailOrderCatalogs_Utils.getItemPrice(item)
    if not item or not item.price then
        return 1
    end

    local multiplier = 2
    local sandboxOptions = getSandboxOptions()
    if sandboxOptions then
        local opt = sandboxOptions:getOptionByName("MailOrderCatalogs.PriceMultiplier")
        if opt then
            multiplier = opt:getValue()
        end
    end

    local priceMult = 1.0
    if multiplier == 1 then
        priceMult = 0.5
    elseif multiplier == 2 then
        priceMult = 1.0
    elseif multiplier == 3 then
        priceMult = 2.0
    end

    local finalPrice = math.floor(item.price * priceMult + 0.5)
    if finalPrice < 1 then
        finalPrice = 1
    end

    return finalPrice
end

return MailOrderCatalogs_Utils
