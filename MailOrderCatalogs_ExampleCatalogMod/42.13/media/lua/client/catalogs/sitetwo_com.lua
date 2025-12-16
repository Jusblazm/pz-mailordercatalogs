-- sitetwo_com

--[[
    this site is set up without translation in mind.
    siteone_net is set up with translation in mind.
]]

return {
    siteName = "sitetwo.com", -- url users can enter to visit site
    description = "Example Site #2", -- site description (for lore)
    items = {
        {
            name = "Base.Pen", -- item ID
            price = 1, -- price in 1 Base.Money
            description = "Smooth writing for everyday notes.", -- description (for lore)
        },
        {
            name = "Base.PenFancy", -- item ID
            price = 10, -- price in 1 Base.Money
            description = "Old-school elegance with modern ink.", -- description (for lore)
        }
    }
}