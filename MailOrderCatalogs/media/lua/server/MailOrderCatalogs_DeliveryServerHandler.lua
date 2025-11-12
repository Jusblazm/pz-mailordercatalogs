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
            if args.loc then
                MailOrderCatalogs_DeliveryQueue.addZombieDelivery(args.x, args.y, args.z, deliverAt)
            end
        end
    end
end)
