-- MailOrderCatalogs_Traits
require "NPCs/MainCreationMethods"

local mailOrderCatalogsTraits = function()
    local creditCardThief = TraitFactory.addTrait(
        "CreditCardThief", -- type
        getText("UI_trait_CreditCardThief"), -- name
        3, -- cost
        getText("UI_trait_CreditCardThief_Description"), -- description
        false, -- is profession?
        false -- remove in MP?
    )
    BaseGameCharacterDetails.SetTraitDescription(creditCardThief)

    TraitFactory.sortList()
end

Events.OnGameBoot.Add(mailOrderCatalogsTraits)