-- MailOrderCatalogs_AccessComputerAction
require "TimedActions/ISBaseTimedAction"

MailOrderCatalogs_AccessComputerAction = ISBaseTimedAction:derive("MailOrderCatalogs_AccessComputerAction")

function MailOrderCatalogs_AccessComputerAction:isValid()
    return true
end

function MailOrderCatalogs_AccessComputerAction:waitToStart()
    self.character:faceThisObject(self.object)
    return self.character:shouldBeTurning()
end

function MailOrderCatalogs_AccessComputerAction:update()
    self.character:faceThisObject(self.object)
end

function MailOrderCatalogs_AccessComputerAction:start()
    self:setActionAnim("Loot")
    self.character:SetVariable("LootPosition", "Mid")
end

function MailOrderCatalogs_AccessComputerAction:stop()
    ISBaseTimedAction.stop(self)
end

function MailOrderCatalogs_AccessComputerAction:perform()
    MailOrderCatalogs_ComputerUI.openComputerUI(self.object, self.character)
    ISBaseTimedAction.perform(self)
end

function MailOrderCatalogs_AccessComputerAction:new(character, object)
    local o = ISBaseTimedAction.new(self, character)
    setmetatable(o, self)
    self.__index = self

    o.character = character
    o.object = object
    o.maxTime = 30

    return o
end