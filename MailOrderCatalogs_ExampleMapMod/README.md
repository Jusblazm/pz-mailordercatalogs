# Adding delivery points to your maps
This guide will show you how to use the `MailOrderCatalogs_ExampleMapMod` as a template to create your own delivery points for Mail Order Catalogs. This is particularly useful for map makers.

## Delivery Points
All file names must be **unique**. If two files share the same name, even from different mods, one will overwrite the other.

### Naming Recommendations
To avoid conflicts, it’s recommended to prefix your files with the name you use under `author=` or `id=` in your `mod.info`.  

**Example:** 
- Recommended custom file: `MyMapMod_DeliveryLocationsLoader.lua`  

This makes it easy to organize your files and ensures your loader file (e.g., `Jusblazm_CatalogsLoader.lua`) can reference them consistently.  

### Adding Your Websites
The example file (`MyMapMod_DeliveryLocationsLoader.lua`) already contain the code structure you need. To add your own delivery locations:

1. Copy one of the example site files and rename it for your website.  
2. In your loader file (e.g., `MyMapMod_DeliveryLocationsLoader.lua`), set your locations:
```lua
    MailOrderCatalogs.RegisterDeliveryLocation(1111, 2222, 0) -- Replace with your x, y, z
```

### Provided Example Files
The example mod includes the following file to guide you:
- `MyMapMod_DeliveryLocationsLoader.lua` - Loader file

This file is a fully functional example and shows exactly what you need to do to add your own delivery points for Mail Order Catalogs. Simply replace or extend it with your custom locations.