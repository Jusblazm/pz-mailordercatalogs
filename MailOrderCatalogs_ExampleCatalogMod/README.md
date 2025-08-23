# Creating your own catalogs and websites
This guide will show you how to use the `MailOrderCatalogs_ExampleCatalogMod` as a template to create your own custom catalogs and websites for Mail Order Catalogs.  

## Websites
Each website should be defined in its own Lua file. The file name itself does **not** need to match the website’s name, but all file names must be **unique**. If two files share the same name, even from different mods, one will overwrite the other. Likewise, if two websites share the same URL, they will overwrite each other as well.

### Naming Recommendations
To avoid conflicts, it’s recommended to prefix your files with the name you use under `author=` or `id=` in your `mod.info`.  

**Example:**  
- Original example file: `siteone_net.lua`  
- Recommended custom file: `Jusblazm_siteone_net.lua`  

This makes it easy to organize your files and ensures your loader file (e.g., `Jusblazm_CatalogsLoader.lua`) can reference them consistently.  

### Adding Your Websites & Ensuring They Spawn
All example files (`siteone_net.lua`, `sitetwo_com.lua`, and `ExampleCatalogMod_CatalogsLoader.lua`) already contain the code structure you need. To add your own websites:  

1. Copy one of the example site files and rename it for your website.  
2. In your loader file (e.g., `ExampleCatalogMod_CatalogsLoader.lua`), require your new site file:
```lua
    local site = require("catalogs/YourWebsiteFileName") -- Replace with your file name
```
3. In your distributions file (e.g. `ExampleCatalogMod_Distributions.lua`), populate the catalog table:
```lua
    local catalogs = { "Base.ExampleCatalog" } -- Enter each catalog, comma separated
```
Make sure the file name matches exactly.

### Provided Example Files
The example mod includes the following files to guide you:
- `siteone_net.lua` - Example website 1
- `sitetwo_com.lua` - Example website 2
- `ExampleCatalogMod_CatalogsLoader.lua` - Loader file
- `ItemName_EN.txt` - Example item name localization
- `UI_EN.txt` - Example UI text localization
- `items_examplemodcatalogs.txt` - Example catalog items
- `ExampleCatalogMod_Distributions.lua` - Template distributions file

These files are fully functional examples and show exactly what you need to do to add your own catalogs to Mail Order Catalogs. Simply replace or extend them with your own content.