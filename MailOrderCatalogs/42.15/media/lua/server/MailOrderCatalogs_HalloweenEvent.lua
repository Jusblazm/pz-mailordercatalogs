-- MailOrderCatalogs_HalloweenEvent.lua
local function spawnHalloweenZombiesAt(x, y, z)
    if SandboxVars.MailOrderCatalogs and SandboxVars.MailOrderCatalogs.EnableHalloweenEvent == false then
        return
    end

    if SandboxVars.MailOrderCatalogs and SandboxVars.MailOrderCatalogs.OnlyOctober then
        local gameTime = getGameTime()
        local month = gameTime:getMonth()
        if month ~= 9 then return end
    end

    if ZombRand(0, 2) == 0 then
        print("[MailOrderCatalogs] General -> Halloween zombies were not spawned this time, lucky you!")
        return
    end

    local count = ZombRand(1, 6)
    print(string.format("[MailOrderCatalogs] General -> Spawning %d zombies near delivery at (%d, %d, %d)", count, x, y, z))

    for i=1, count do
        local offsetX = ZombRand(-2, 3)
        local offsetY = ZombRand(-2, 3)
        local spawnX = x + offsetX
        local spawnY = y + offsetY
        local spawnZ = z or 0

        -- local outfits = { "MOCHalloweenEventPumpkin" }
        -- local outfit = outfits[ZombRand(#outfits) + 1]

        addZombiesInOutfit(
            spawnX, -- x 
            spawnY, -- y
            spawnZ, -- z
            1,      -- # of zombies
            nil,    -- outfit (currently random)
            0.5     -- female chance
        )
    end
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module == "MailOrderCatalogs" and command == "SpawnHalloweenZombies" then
        if args and args.x and args.y and args.z then
            spawnHalloweenZombiesAt(args.x, args.y, args.z)
        end
    end
end)