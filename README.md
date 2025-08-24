# Mail Order Catalogs
Shop like it's 1995!\
Only on Steam's Workshop at: NOT RELEASED YET\
If found elsewhere, please report.

## What This Mod Does
* Adds working computers with limited functionality.
* Adds functional ATMs.
* Adds an ATM hacking minigame.
* Adds new traits.
* Adds new items: Shopping Catalogs. All prefixed with `Catalog:`.
* Adds delivery points to each Post Office in game.
* Integrates with [Hacking Skill](https://steamcommunity.com/sharedfiles/filedetails/?id=3539339798).

Please check the Steam Workshop page for full details.

This is built as a **framework**. You can easily add new websites, new catalogs, and new ATMs, that will gain automatic functionality for Mail Order Catalogs. Computers are handled different due to having an on and off state. After a rewrite of how they are handled, you will be able to extend Mail Order Catalogs to your custom computers.

## Modders
If you're a map maker, please check out the Example Map Mod for how to register a custom delivery location in your town (All of my predefined locations are inside Post Offices).\
If you release mods with clothing, items, or just want to add websites for users who are using Mail Order Catalogs, checkout the Example Catalog Mod for how to include a website.

### API for Modders
These are the **official functions** your mod can call to interact with Mail Order Catalogs.
You do **not** need to repack or include this mod to use them.

### Available Functions
``` lua
MailOrderCatalogs.RegisterATM(spriteName, facingDir)
-- Registers an ATM in the world.
-- facingDir: 0 = North, 1 = East, 2 = South, 3 = West.

MailOrderCatalogs.RegisterDeliveryLocation(x, y, z)
-- Registers a delivery location at the given coordinates.
-- Useful for map makers who want to define new drop-off points.
```

### Advanced Websites
You can overwrite the standard website with your own design.
To do so, define a `siteName`, `description`, and a `customRender` function.
- `self` and `siteID` are **required** arguments.
- You may also pass `player` and `card` into the anonymous function if needed.
- There are no other variables in the core code, you must get them yourself.
The display renders on `rightPanel`, so you must add your UI elements there.
``` lua
return {
    siteName = "examplesite.com",
    description = "Example Site Description",
    customRender = function(self, siteID, player, card)
        -- example custom website code
        local label = ISLabel:new(padding, y, 20, "Example", 1, 1, 1, 1, UIFont.Small, true)
        label:initialise()
        self.rightPanel:addChild(label)
    end
}
```

## 🌐 Translation Progress
<!-- AUTO-GENERATED-TABLE:START -->
| Language                | Progress      | Completed | Status        |
|-------------------------|---------------|-----------|---------------|
| 🇺🇸 English              | ██████████ 100% | 501/501     | ✅ Done      |
| 🇦🇷 Argentina            | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🏴 Catalan             | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇹🇼 Traditional Chinese  | ██░░░░░░░░ 24% | 119/501     | 🔃 In Progress |
| 🇨🇳 Simplified Chinese   | ██░░░░░░░░ 24% | 119/501     | 🔃 In Progress |
| 🇨🇿 Czech                | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇩🇰 Danish               | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇩🇪 German               | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇪🇸 Spanish              | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇫🇮 Finnish              | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇫🇷 French               | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇭🇺 Hungarian            | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇮🇩 Indonesian           | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇮🇹 Italian              | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇯🇵 Japanese             | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇰🇷 Korean               | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇳🇱 Dutch                | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇳🇴 Norwegian            | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇵🇭 Filipino             | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇵🇱 Polish               | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇵🇹 Portuguese           | ██░░░░░░░░ 24% | 119/501     | 🔃 In Progress |
| 🇧🇷 Brazilian Portuguese | ██░░░░░░░░ 24% | 119/501     | 🔃 In Progress |
| 🇷🇴 Romanian             | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇷🇺 Russian              | ██░░░░░░░░ 24% | 119/501     | 🔃 In Progress |
| 🇹🇭 Thai                 | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇹🇷 Turkish              | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇺🇦 Ukrainian            | ██░░░░░░░░ 24% | 119/501     | 🔃 In Progress |
<!-- AUTO-GENERATED-TABLE:END -->

### Translation Notice
Translations are done via ChatGPT and checked with Google Translate. I do my best, but I'm sure there are some errors. If you would like to contribute please get in touch.

## Support
Come find me on discord! Be sure to grab the Project Zomboid Modding Role once you arrive.\
[![Discord](https://raw.githubusercontent.com/Jusblazm/pz-archive/refs/heads/main/_imgs/discordinvite.png)](https://discord.gg/yqstRpuGXy)





[h1]Mail Order Catalogs[/h1]
A semi-honest mail order system that uses computers instead of phones for a QoL UI.
[list]
[*] Guess URLs to discover websites (text-only).
[*] Find catalogs in the world to unlock sites in your quick access list (with images).
[*] Images represent your character matching catalog item IDs with in-game items.
[/list]

[h2]Important[/h2]
Default Card PIN: [b]11[/b] (changeable at any computer via knoxbank.com).
[list]
[*] Future Features
[*] FAQ
[/list]

[h2]Features[/h2]
[list]
[*] Semi-Functional Computers
[*] Functional ATMs
[*] Functional Credit Cards
[*] Hacking "Minigame"
[*] Delivery Locations in Post Offices
[*] New Item: Catalogs
[*] New Trait
[/list]

[h3]Hacking "Minigame"[/h3]
A new "minigame" at ATMs when you have stolen credit cards. You can guess the PIN (2 digits) and attempt to steal money from the accounts. [i]Be careful though, you only have 3 attempts before the card is revoked.[/i]
[list]
[*] Without [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3539339798]Hacking Skill[/url] you must guess the exact PIN.
[*] With Hacking Skill you gain hacking XP and higher levels give you a wider margin for successful guesses.
[/list]

[table]
[tr][td][b]Hacking Level[/b][/td][td][b]Pin Range[/b][/td][td][b]Explanation[/b][/td][/tr]
[tr][td]0[/td][td]0[/td][td]You must guess the exact 2-digit PIN.[/td][/tr]
[tr][td]5[/td][td]10[/td][td]Your guess can be up to ±10 digits away from the actual PIN.[/td][/tr]
[tr][td]10[/td][td]20[/td][td]Your guess can be up to ±20 digits away from the actual PIN.[/td][/tr]
[/table]

[h3]Trait[/h3]
[img]https://raw.githubusercontent.com/Jusblazm/pz-mailordercatalogs/refs/heads/main/MailOrderCatalogs/42/media/ui/Traits/trait_creditcardthief.png[/img] Credit Card Thief | 3 Points | +5 spread when trying stolen credit card PINs

[h2]Current Issues[/h2]
Delivery Points respawn if picked up. Fallback safety rule due to how delivery is currently handled. Only triggers when delivered to a delivery point that isn't loaded. You can technically duplicate the storage containers.
Delivery is instant, meaning in multiplayer another player could steal what you purchase.

[h2]Upcoming Features[/h2]
[list]
[*] More websites.
[*] Furniture websites.
[*] FluidContainer support.
[*] Clothing variants.
[*] Delayed delivery.
[*] Player specific delivery.
[*] Redesigned delivery system.
[*] Vehicle delivery.
[*] Report your card as stolen.
[*] More unique catalog images.
[*] A unique model for the delivery box.
[/list]
Check out the Future Features discussion for more information.

[h2]Compatibility[/h2]
Hopefully there are no issues, but I'm sure there are some. I purposefully touched as little base game code as possible and prefixed everything in an attempt not to clash.
[list]
[*] Adds a new Context Menu option for Computers and ATMs -> shouldn't cause issues.
[*] Adds power to Computers & ATMs -> most likely culprit for compatibility issues.
[*] Attaches data to Base.CreditCard -> may clash with other mods that do the same.
[/list]

[h3]Build 41 Multiplayer[/h3]
Initial internal tests show almost everything works in multiplayer. However, some things will require me to load the mod properly, which means I can't test until official release. If you're reading this, I'm either testing multiplayer functionality now, or going to be very soon.

[h2]GitHub[/h2]
Check the internals, modder resources, and translation info here: [url=https://github.com/Jusblazm/pz-mailordercatalogs]Mail Order Catalogs GitHub[/url]

[h3]Modders[/h3]
Mail Order Catalogs includes:
[list]
[*] An API
[*] Example mod for adding new catalogs and websites
[*] Example mod for adding new delivery points
[/list]
See GitHub for details.

[h3]Translation[/h3]
Translation is ongoing. Project Zomboid has ~4900 items, each needing descriptions and translations. See GitHub for current progress.

[h2]Permissions[/h2]
[code]This mod is in active development, please suggest features instead of reuploading modified versions. My Discord and GitHub both have information on helping with translations. Do not reupload a translated version of this mod.
[url=http://theindiestone.com/forums/index.php/topic/2530-mod-permissions/?p=36478][img]https://raw.githubusercontent.com/Jusblazm/pz-archive/refs/heads/main/_imgs/MODS_03.png[/img][/url][/code]

[h2]Credits[/h2]
The Indie Stone for Project Zomboid

[url=https://discord.gg/yqstRpuGXy][img]https://raw.githubusercontent.com/Jusblazm/pz_archive/refs/heads/main/_imgs/discordinvite.png[/img][/url]

A simple like and a favorite is more than enough, but if you would like to do more:
[url=https://ko-fi.com/jusblazm][img]https://storage.ko-fi.com/cdn/kofi3.png[/img][/url]





Future Features Discussion

[h3]More websites[/h3]
I'll continue to add websites.
[h3]Furniture websites[/h3]
Once I have furniture down, I will begin adding websites that sell it.

[h3]FluidContainer support[/h3]
Mail Order Catalogs treats all items the same currently. Fluid items like Industrial Dyes can be purchased, but the color is currently randomized. I'm in the middle of updating scripts to take into account items with rgb fluids. Once completed, you will be able to purchase Industrial Dyes with specific colors.

[h3]Clothing variants[/h3]
Current systems ignore variants and deliver a random variant. i.e. Lumberjack shirts have multiple colors under a single item ID. I'm working on a way to purchase a specific version.

[h3]Delayed delivery[/h3]
Currently delivery is instant. I plan to introduce randomized delivery so that it takes time for items to be delivered. Sandbox Variables will be added for this -> instant delivery all the way up to 7 days.

[h3]Player specific delivery[/h3]
I'm not sure if this one is actually possible. This would require the mod to check which player loaded the grid and only complete the delivery if the player who purchased the item is in the grid. I will exhaust ways to do this once Build 42 releases with multiplayer, as Build 42 is my focus.

[h3]Redesigned delivery system[/h3]
The current delivery system was built early in the concept of this mod. Once vehicles are figured out, a new delivery system will be needed. This new version will be more specific about where your delivery was sent and potentially include localized deliveries.

[h3]Vehicle delivery[/h3]
I have to figure out localized spawning for this, so a vehicle doesn't just appear in the middle of a building. Possibly means designated spawn locations in vehicle lots somewhere.

[h3]Report your card as stolen[/h3]
This really only matters in multiplayer. It will make your credit card unusable, which means unhackable at an ATM and unable to be used for purchasing items on a website. You will have to request a new card from the bank.

[h3]A unique model for the delivery box[/h3]
I hope to eventually hire someone to create a unique delivery point instead of the cardboard box.

[h3]More unique catalog images[/h3]
Art isn't my strong suit. Catalogs for each company are being produced, but its a slow process. Catalogs without a unique image use the magazine image.





FAQ Discussion

[h3]How many items have descriptions?[/h3]
There are currently 359 descriptions, however some items like Skill Books, Skill Magazines, and Seed Packets currently share the same description, so there are significantly more items.

[h3]Is it safe to add midsave?[/h3]
Yes.

[h3]Is it safe to remove midsave?[/h3]
Very likely, however, the cardboard boxes spawned by the mod will persist as they are base game items.

[h3]Where was my item delivered?[/h3]
After you purchase an item, your character will say one of two things: "I think my package was delivered nearby" or "I think my package was delivered to a nearby Post Office". If it was delivered nearby, that means you have a delivery point within 50 squares of your character. If it was delivered to a nearby Post Office, your item was delivered to the nearest post office. Post Offices are located in: Brandenberg, Ekron, Irvington, Louisville, March Ridge, Riverside, and West Point.

[h3]Can I move the delivery boxes?[/h3]
Yes, the code is attached to the delivery box, not the location, so you can freely pick it up and put it down anywhere you want.

[h3]How are translations going?[/h3]
Check out the GitHub.

[h3]Will you create websites for modded items?[/h3]
No. I'm leaving this up to the mod creators themselves.
