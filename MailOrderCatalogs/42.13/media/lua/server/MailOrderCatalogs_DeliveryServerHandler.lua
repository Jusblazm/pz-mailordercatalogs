-- MailOrderCatalogs_DeliveryServerHandler
local MailOrderCatalogs_DeliveryQueue = require("MailOrderCatalogs_DeliveryQueue")

Events.OnClientCommand.Add(function(module, command, player, args)
    if module == "MailOrderCatalogs" and command == "QueueDelivery" then
        local deliverAt = args.deliverAt or 0

        if args and args.item then
            if args.r and args.g and args.b then
                -- fluid item with color
                MailOrderCatalogs_DeliveryQueue.addFluidDelivery(args.x, args.y, args.z, 
                    { item = args.item, r = args.r, g = args.g, b = args.b, },
                    deliverAt
                )
            else
                -- regular item
                MailOrderCatalogs_DeliveryQueue.addDelivery(args.x, args.y, args.z, args.item, deliverAt)
            end
            if args.loc and not args.suppressEvents then
                MailOrderCatalogs_DeliveryQueue.addZombieDelivery(args.x, args.y, args.z, deliverAt)
            end
        end
    end

    if module == "MailOrderCatalogs" and command == "InstantDelivery" then
        if args and args.item then
            local x, y, z = args.x, args.y, args.z

            local square = getCell():getGridSquare(x, y, z)
            if square then
                local containerObj = MailOrderCatalogs_DeliveryQueue.getOrCreateDropbox(square)
                if containerObj then
                    local container = containerObj:getContainer()
                    -- local item = container:AddItem(args.item)
                    local item = instanceItem(args.item)
                    container:AddItem(item)
                    sendAddItemToContainer(container, item)

                    -- sendAddItemToContainer(container, item)
                    print(string.format("[MailOrderCatalogs] General: Delivered '%s' to %d, %d, %d", args.item, x, y, z))

                    if not args.suppressEvents then
                        MailOrderCatalogs_DeliveryQueue.addZombieDelivery(args.x, args.y, args.z, 0)
                    end
                end
            end
        end
    end
end)