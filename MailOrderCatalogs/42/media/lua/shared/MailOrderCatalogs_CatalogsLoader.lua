-- MailOrderCatalogs_CatalogsLoader
local registrar = require("MailOrderCatalogs_CatalogRegistrar")

local function registerCatalogs()
    local site = require("catalogs/fork_com")
    registrar.registerWebsite(site)
    local site = require("catalogs/projectzomboid_com")
    registrar.registerWebsite(site)
    -- Sky Blue Banking
    -- competitor eventually?
    local site = require("catalogs/knoxbank_com")
    registrar.registerWebsite(site)

    -- 5 Bux or Less
    -- probably not

    -- A.A.Ron Hunting Supply Catalogs

    -- Al's Auto Shop Catalogs
    -- doesn't sell stuff

    -- American Tire Catalogs

    -- Army Surplus Store Catalogs
    -- surplus stores wouldn't deliver goods

    -- Awl Work and Sew Play Catalogs
    local site = require("catalogs/awlworknsewplay_beginner_com")
    local catalog = "Base.AwlWorkAndSewPlayCatalog1"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/awlworknsewplay_knitting_com")
    local catalog = "Base.AwlWorkAndSewPlayCatalog2"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/awlworknsewplay_leather_com")
    local catalog = "Base.AwlWorkAndSewPlayCatalog3"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/awlworknsewplay_tools_com")
    local catalog = "Base.AwlWorkAndSewPlayCatalog4"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/awlworknsewplay_professional_com")
    local catalog = "Base.AwlWorkAndSewPlayCatalog5"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/awlworknsewplay_dyes_com")
    -- local catalog = "Base.AwlWorkAndSewPlayCatalog6"
    registrar.registerWebsite(site)

    -- Bait & Tackle Catalogs

    -- Barg-N-Clothes Catalogs

    -- BBBQ Catalogs

    -- Bernard's Book Emporium Catalogs

    -- Better Bed Than Dead Catalogs

    -- Better Furnishings Catalogs

    -- Book Naked Catalogs
    local site = require("catalogs/booknaked_firstaid_com")
    local catalog = "Base.BookNakedCatalog1"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/booknaked_welding_com")
    local catalog = "Base.BookNakedCatalog2"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/booknaked_tailoring_com")
    local catalog = "Base.BookNakedCatalog3"
    registrar.registerWebsite(site, catalog)

    -- Brooks Public Library of Louisville Catalogs
    -- doesn't sell stuff

    -- Cally's Gifts Catalogs

    -- Car Fix-Ation Catalogs

    -- Dressed to the 90s Catalogs
    local site = require("catalogs/dressedtothe90s_shellsuits_com")
    local catalog = "Base.DressedToThe90sCatalog1"
    registrar.registerWebsite(site, catalog)

    -- E.P. Tools Catalogs
    local site = require("catalogs/eptools_gardening_com")
    local catalog = "Base.EPToolsCatalog1"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/eptools_lumber_com")
    local catalog = "Base.EPToolsCatalog2"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/eptools_vehicle_com")
    local catalog = "Base.EPToolsCatalog3"
    registrar.registerWebsite(site, catalog)

    -- Electron House Catalogs

    -- Enigma Books Catalogs
    local site = require("catalogs/enigmabooks_survival_com")
    local catalog = "Base.EnigmaBooksCatalog1"
    registrar.registerWebsite(site, catalog)

    -- Family Fashion Catalogs
    local site = require("catalogs/familyfashion_sportswear_com")
    local catalog = "Base.FamilyFashionCatalog1"
    registrar.registerWebsite(site, catalog)

    -- Farming & Rural Supply Catalogs
    local site = require("catalogs/farmingnruralsupply_beginner_com")
    local catalog = "Base.FarmingAndRuralSupplyCatalog1"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/farmingnruralsupply_ruggedwear_com")
    local catalog = "Base.FarmingAndRuralSupplyCatalog2"
    registrar.registerWebsite(site, catalog)

    -- FashionaBelle Catalogs

    -- Filigree Fashions Catalogs
    local site = require("catalogs/filigreefashions_intimates_com")
    local catalog = "Base.FiligreeFashionsCatalog1"
    registrar.registerWebsite(site, catalog)

    -- From the Dugout Catalogs

    -- Genteel-y Used Catalogs
    -- used clothes store wouldn't deliver goods

    -- Go Flash Catalogs
    -- photography, probably not

    -- Hit Vids! Catalogs

    -- Hugo Plush Catalogs

    -- Jim's Autoshop Catalogs
    -- doesn't sell stuff

    -- Jimmy's Pre-owned Cars Catalogs

    -- Knox Pack Kitchens Catalogs
    -- kitchen factory

    -- Laces Catalogs
    
    -- Lenny's Car Repair Catalogs
    -- doesn't sell stuff

    -- Lola Limon Catalogs

    -- Louisville Bruiser Catalogs
    local site = require("catalogs/louisvillebruiser_com")
    local catalog = "Base.LouisvilleBruiserCatalog"
    registrar.registerWebsite(site, catalog)

    -- Maps Unlimited Catalogs
    -- map store, probably not
    -- useful for map makers maybe

    -- Mashie Signs & Paintings Catalogs
    -- not useful

    -- Med U Well Catalogs
    local site = require("catalogs/meduwell_com")
    local catalog = "Base.MedUWellCatalog1"
    registrar.registerWebsite(site, catalog)

    -- Morris' Bait Shop Catalogs

    -- Nails & Nuts Tool Store Catalogs

    -- Nolan's Used Cars Catalogs

    -- Noteworthy Catalogs

    -- Olympia Department Store Catalogs

    -- Optima Eyes Catalogs

    -- Palette Pop Art Supplies Catalogs

    -- Perfick Potato Co. Catalogs
    -- potato factory

    -- Pharmahug Catalogs
    local site = require("catalogs/pharmahug_com")
    local catalog = "Base.PharmahugCatalog1"
    registrar.registerWebsite(site, catalog)

    -- Posh Box Catalogs

    -- Purple + Black Catalogs

    -- Purrfect Barkner Pet Supplies Catalogs

    -- Seat Yourself Furniture Catalogs

    -- Scenic Mile Car Dealership Catalogs

    -- Sammie's Catalogs

    -- Sasha Sashay Catalogs

    -- Saucy Catalogs
    local site = require("catalogs/saucy_intimates_com")
    local catalog = "Base.SaucyCatalog1"
    registrar.registerWebsite(site, catalog)

    -- Sheba Jewellers Catalogs

    -- Shoed for the Stars Catalogs

    -- Spitfire Fashion Catalogs

    -- Stars & Stripes Catalogs

    -- Stendo's Firearms Emporium Catalogs

    -- The Exquisite Pearl Catalogs
    local site = require("catalogs/theexquisitepearl_gems_com")
    local catalog = "Base.TheExquisitePearlCatalog1"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/theexquisitepearl_luthex_com")
    local catalog = "Base.TheExquisitePearlCatalog2"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/theexquisitepearl_earrings_com")
    local catalog = "Base.TheExquisitePearlCatalog3"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/theexquisitepearl_necklaces_com")
    local catalog = "Base.TheExquisitePearlCatalog4"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/theexquisitepearl_rings_com")
    local catalog = "Base.TheExquisitePearlCatalog5"
    registrar.registerWebsite(site, catalog)

    -- The Good Book Catalogs

    -- The Top Hanger Catalogs

    -- Time 4 Sport Catalogs

    -- Toyz Catalogs

    -- Thumbs of Green Catalogs
    local site = require("catalogs/thumbsofgreen_beginner_com")
    local catalog = "Base.ThumbsOfGreenCatalog1"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/thumbsofgreen_alliums_com")
    local catalog = "Base.ThumbsOfGreenCatalog2"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/thumbsofgreen_flowers_com")
    local catalog = "Base.ThumbsOfGreenCatalog3"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/thumbsofgreen_cucurbits_com")
    local catalog = "Base.ThumbsOfGreenCatalog4"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/thumbsofgreen_cruciferous_com")
    local catalog = "Base.ThumbsOfGreenCatalog5"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/thumbsofgreen_brewing_com")
    local catalog = "Base.ThumbsOfGreenCatalog6"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/thumbsofgreen_fruits_com")
    local catalog = "Base.ThumbsOfGreenCatalog7"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/thumbsofgreen_grains_com")
    local catalog = "Base.ThumbsOfGreenCatalog8"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/thumbsofgreen_herbs_com")
    local catalog = "Base.ThumbsOfGreenCatalog9"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/thumbsofgreen_leafygreens_com")
    local catalog = "Base.ThumbsOfGreenCatalog10"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/thumbsofgreen_medicinal_com")
    local catalog = "Base.ThumbsOfGreenCatalog11"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/thumbsofgreen_oilseed_com")
    local catalog = "Base.ThumbsOfGreenCatalog12"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/thumbsofgreen_nightshades_com")
    local catalog = "Base.ThumbsOfGreenCatalog13"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/thumbsofgreen_roots_com")
    local catalog = "Base.ThumbsOfGreenCatalog14"
    registrar.registerWebsite(site, catalog)

    -- United Shipping Logistics
    -- sells delivery boxes?

    -- Upscale Mobility Auto Dealership Catalogs

    -- ValuTech Catalogs

    -- West Point DIY Catalogs

    -- Window Catalogs

    -- Worm of Books Catalogs
    local site = require("catalogs/wormofbooks_learn_com")
    local catalog = "Base.WormOfBooksCatalog1"
    registrar.registerWebsite(site, catalog)

    -- Your Closet Catalogs
    local site = require("catalogs/yourcloset_intimates_com")
    local catalog = "Base.YourClosetCatalog1"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/yourcloset_sportswear_com")
    local catalog = "Base.YourClosetCatalog2"
    registrar.registerWebsite(site, catalog)

    -- Yuri Design Catalogs

    -- Zac's Hardware Catalogs
    local site = require("catalogs/zacshardware_tools_com")
    local catalog = "Base.ZacsHardwareCatalog1"
    registrar.registerWebsite(site, catalog)
    local site = require("catalogs/zacshardware_protective_com")
    local catalog = "Base.ZacsHardwareCatalog2"
    registrar.registerWebsite(site, catalog)
end

Events.OnInitGlobalModData.Add(registerCatalogs)
Events.OnGameStart.Add(registerCatalogs)