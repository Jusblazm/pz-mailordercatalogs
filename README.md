# Mail Order Catalogs
Shop like it's 1995!\
Only on Steam's Workshop at: https://steamcommunity.com/sharedfiles/filedetails/?id=3555453653 \
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
- customRender passes `self`, `siteID`, `player`, and `card`.
  - `self` is the `rightPanel`, everything needs to be attached to it.
  - `siteID` is your `siteName` it's used in the internals, so it's passed back, you likely won't need it.
  - `player` is the `IsoPlayer` of the player who opened the UI.
  - `card` is the raw card owned by `player`. You still need to access it's mod data via `card:getModData()`:
    - `owner`
    - `accountID`
    - `last4`
    - `pin`
    - `attempts`
    - `isStolen`

- There are no other variables in the core code, you must get them yourself.

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
**NOTE:** Only the player's card is accessible in the Computer UI. This is so players can't bypass the ATM PIN cracking minigame and spend money from stolen cards.

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
| 🇩🇪 German               | ██░░░░░░░░ 24% | 119/501     | 🔃 In Progress |
| 🇪🇸 Spanish              | ██░░░░░░░░ 24% | 119/501     | 🔃 In Progress |
| 🇫🇮 Finnish              | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇫🇷 French               | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇭🇺 Hungarian            | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇮🇩 Indonesian           | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇮🇹 Italian              | ██░░░░░░░░ 24% | 119/501     | 🔃 In Progress |
| 🇯🇵 Japanese             | ██░░░░░░░░ 24% | 119/501     | 🔃 In Progress |
| 🇰🇷 Korean               | ████░░░░░░ 43% | 217/501     | 🔃 In Progress |
| 🇳🇱 Dutch                | ██░░░░░░░░ 24% | 119/501     | 🔃 In Progress |
| 🇳🇴 Norwegian            | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇵🇭 Filipino             | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇵🇱 Polish               | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇵🇹 Portuguese           | ██░░░░░░░░ 24% | 119/501     | 🔃 In Progress |
| 🇧🇷 Brazilian Portuguese | ██░░░░░░░░ 24% | 119/501     | 🔃 In Progress |
| 🇷🇴 Romanian             | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇷🇺 Russian              | ██████████ 100% | 501/501     | ✅ Done      |
| 🇹🇭 Thai                 | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇹🇷 Turkish              | ░░░░░░░░░░ 0% | 0/501     | ❌ Not Started |
| 🇺🇦 Ukrainian            | ██████████ 100% | 501/501     | ✅ Done      |
<!-- AUTO-GENERATED-TABLE:END -->

### Translation Notice
Translations are done via ChatGPT and checked with Google Translate. I do my best, but I'm sure there are some errors. If you would like to contribute please get in touch.

## Support
Come find me on discord! Be sure to grab the Project Zomboid Modding Role once you arrive.
[![Discord](https://raw.githubusercontent.com/Jusblazm/pz-archive/refs/heads/main/_imgs/discordinvite.png)](https://discord.gg/yqstRpuGXy)

A simple like and a favorite is more than enough, but if you would like to do more:
[![Ko-fi](https://i.imgur.com/vs8dr3R.png)](https://ko-fi.com/jusblazm)
