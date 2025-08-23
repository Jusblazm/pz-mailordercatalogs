local MailOrderCatalogs_DeliveryQueue = require("MailOrderCatalogs_DeliveryQueue")

-- Events.OnClientCommand.Add(function(module, command, player, args)
--     if module == "MailOrderCatalogs" and command == "QueueDelivery" then
--         if args and args.item then
--             MailOrderCatalogs_DeliveryQueue.addDelivery(args.x, args.y, args.z, args.item)
--         end
--     end
-- end)

Events.OnClientCommand.Add(function(module, command, player, args)
    if module == "MailOrderCatalogs" and command == "QueueDelivery" then
        if args and args.item then
            if args.r and args.g and args.b then
                -- fluid item with color
                MailOrderCatalogs_DeliveryQueue.addFluidDelivery(args.x, args.y, args.z, {
                    item = args.item,
                    r = args.r,
                    g = args.g,
                    b = args.b
                })
            else
                -- regular item
                MailOrderCatalogs_DeliveryQueue.addDelivery(args.x, args.y, args.z, args.item)
            end
        end
    end
end)
