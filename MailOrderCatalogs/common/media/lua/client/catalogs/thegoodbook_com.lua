-- thegoodbook_com

return {
    siteName = "thegoodbook.com",
    description = getText("UI_MailOrderCatalogs_SiteDescription_TheGoodBookCom"),
    items = {
        {
            name = "Base.Book",
            price = 10,
            description = getText("UI_MailOrderCatalogs_ItemDescription_Book"),
        },
        {
            name = "Base.Magazine",
            price = 6,
            description = getText("UI_MailOrderCatalogs_ItemDescription_Magazine"),
        },
        {
            name = "Base.ComicBook",
            price = 7,
            description = getText("UI_MailOrderCatalogs_ItemDescription_ComicBook"),
        }
    }
}