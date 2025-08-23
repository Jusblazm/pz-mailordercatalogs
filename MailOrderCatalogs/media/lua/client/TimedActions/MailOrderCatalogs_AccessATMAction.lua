-- MailOrderCatalogs_AccessATMAction
require "TimedActions/ISBaseTimedAction"

MailOrderCatalogs_AccessATMAction = ISBaseTimedAction:derive("MailOrderCatalogs_AccessATMAction")

function MailOrderCatalogs_AccessATMAction:isValid()
    return true
end

function MailOrderCatalogs_AccessATMAction:waitToStart()
    self.character:faceThisObject(self.object)
    return self.character:shouldBeTurning()
end

function MailOrderCatalogs_AccessATMAction:update()
    self.character:faceThisObject(self.object)
end

function MailOrderCatalogs_AccessATMAction:start()
    self:setActionAnim("Loot")
    self.character:SetVariable("LootPosition", "Mid")
end

function MailOrderCatalogs_AccessATMAction:stop()
    ISBaseTimedAction.stop(self)
end

function MailOrderCatalogs_AccessATMAction:perform()
    if #self.cards > 1 then
        MailOrderCatalogs_CardSelectorUI.openSelectorUI(self.character)
    elseif #self.cards == 1 then
        MailOrderCatalogs_ATMUI.openATMUI(self.character, self.cards[1])
    end
    ISBaseTimedAction.perform(self)
end

function MailOrderCatalogs_AccessATMAction:new(character, object, cards)
    local o = ISBaseTimedAction.new(self, character)
    setmetatable(o, self)
    self.__index = self

    o.character = character
    o.object = object
    o.cards = cards or {}
    o.maxTime = 30

    return o
end