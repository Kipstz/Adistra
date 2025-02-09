Config['shop_barber'] = {
    MenuTitle = {
        MainMenu = "BarberShop",
        CategoryMenu = "BarberShop"
    },
    MenuSubTitle = {
        MainMenu = "Choissisez une catégorie",
        CategoryMenu = "Faites votre choix"
    },

    price = 100,

    localisations = {}
}

if Config:gabz() then
    Config['shop_barber'].localisations = {
        { pos = vector3(-32.7, -152.2, 57.1) },
        { pos = vector3(-815.6, -184.4, 37.6) },
        { pos = vector3(-1283.8, -1116.9, 7.0) },
        { pos = vector3(136.2, -1708.5, 29.3) },
        { pos = vector3(1211.6, -472.8, 66.2) },
        { pos = vector3(1931.9, 3729.4, 32.8) },
        { pos = vector3(5124.5, -5135.3, 2.2) }, -- Cayo
    }
else
    Config['shop_barber'].localisations = {
        { pos = vector3(-32.7, -152.2, 57.1) },
        { pos = vector3(-815.6, -184.4, 37.6) },
        { pos = vector3(-1283.8, -1116.9, 7.0) },
        { pos = vector3(136.2, -1708.5, 29.3) },
        { pos = vector3(1211.6, -472.8, 66.2) },
        { pos = vector3(1931.9, 3729.4, 32.8) },
        { pos = vector3(5124.5, -5135.3, 2.2) }, -- Cayo
    }
end