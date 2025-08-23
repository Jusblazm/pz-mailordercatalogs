-- require "ISUI/ISPanel"
-- require "ISUI/ISScrollBar"

-- ISScrollContainer = ISPanel:derive("ISScrollContainer")

-- function ISScrollContainer:new(x, y, width, height)
--     local o = ISPanel.new(self, x, y, width, height)
--     o:noBackground()
--     o.contentPanel = ISPanel:new(0, 0, width, height)
--     o.scrollbar = ISScrollBar:new(o, true)
--     return o
-- end

-- function ISScrollContainer:initialise()
--     ISPanel.initialise(self)

--     -- Content panel (scrollable)
--     self.contentPanel:initialise()
--     self.contentPanel:instantiate()
--     self.contentPanel:noBackground()
--     self:addChild(self.contentPanel)

--     -- Scrollbar
--     self.scrollbar:initialise()
--     self.scrollbar:instantiate()
--     self.scrollbar:setHeight(self:getHeight())
--     self.scrollbar:setVisible(true)
--     self.scrollbar.target = self
--     self:addChild(self.scrollbar)
-- end

-- function ISScrollContainer:prerender()
--     ISPanel.prerender(self)

--     self.scrollbar:setHeight(self:getHeight())
--     self.scrollbar:setScrollHeight(self.contentPanel:getScrollHeight())
-- end

-- function ISScrollContainer:render()
--     ISPanel.render(self)
--     -- Optional: Draw border or background
-- end

-- -- Scroll interface required by ISScrollBar
-- function ISScrollContainer:getScrollHeight()
--     return self.contentPanel:getHeight()
-- end

-- function ISScrollContainer:getScrollAreaHeight()
--     return self:getHeight()
-- end

-- function ISScrollContainer:getYScroll()
--     return -self.contentPanel:getY()
-- end

-- function ISScrollContainer:setYScroll(y)
--     self.contentPanel:setY(-y)
-- end

-- -- Helper function to add a child to the content panel
-- function ISScrollContainer:addScrollChild(child)
--     self.contentPanel:addChild(child)
-- end

-- -- Set inner content height manually if needed
-- function ISScrollContainer:setContentHeight(h)
--     self.contentPanel:setHeight(h)
--     self.scrollbar:setScrollHeight(h)
-- end
