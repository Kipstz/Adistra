Config['shop_superettes'] = {
    MenuTitle = {
        MainMenu = "Supérettes",
        CategoryMenu = "Supérettes"
    },
    MenuSubTitle = {
        MainMenu = "Choissisez une catégorie",
        CategoryMenu = "Choissisez un article"
    },

    localisations = {},

    categories = {
        { name = 'nourritures', label = "Nourritures" },
        { name = 'boissons', label = "Boissons" },
        { name = 'others', label = "Autres" }
    },
    items = {
        { cat = 'nourritures', name = 'bread', label = "Pain", price = 60 },

        { cat = 'boissons', name = 'water', label = "Eau", price = 50 },

        { cat = 'others', name = 'chest', label = "Coffre Fort", price = 200000 },
    }
}

if Config:gabz() then
    Config['shop_superettes'].localisations = {
        { pos = vector3(-48.1, -1756.9, 29.4) },
        { pos = vector3(26.1, -1346.9, 29.5) },
        { pos = vector3(-707.8, -913.8, 19.2) },
        { pos = vector3(-1222.9, -906.9, 12.3) },
        { pos = vector3(-1487.9, -379.2, 40.1) },
        { pos = vector3(-2968.2, 391.3, 15.0) },
        { pos = vector3(-3039.7, 585.9, 7.9) },
        { pos = vector3(-3242.1, 1001.5, 12.8) },
        { pos = vector3(1729.3, 6414.8, 35.0) },
        { pos = vector3(1698.9, 4924.1, 42.1) },
        { pos = vector3(1961.2, 3741.1, 32.3) },
        { pos = vector3(1392.5, 3604.5, 35.0) },
        { pos = vector3(2678.5, 3280.9, 55.2) },
        { pos = vector3(1165.8, 2708.9, 38.1) },
        { pos = vector3(547.6, 2671.1, 42.2) },
        { pos = vector3(-1821.4, 793.3, 138.1) },
        { pos = vector3(1136.0, -982.3, 46.4) },
        { pos = vector3(374.1, 326.1, 103.6) },
        { pos = vector3(1163.3, -323.0, 69.2) },
        { pos = vector3(2556.9, 382.5, 108.6) },
        { pos = vector3(4986.0, -5202.7, 2.5) } -- Cayo
    }
else
    Config['shop_superettes'].localisations = {
        { pos = vector3(-48.1, -1756.9, 29.4) },
        { pos = vector3(26.1, -1346.9, 29.5) },
        { pos = vector3(-707.8, -913.8, 19.2) },
        { pos = vector3(-1222.9, -906.9, 12.3) },
        { pos = vector3(-1487.9, -379.2, 40.1) },
        { pos = vector3(-2968.2, 391.3, 15.0) },
        { pos = vector3(-3039.7, 585.9, 7.9) },
        { pos = vector3(-3242.1, 1001.5, 12.8) },
        { pos = vector3(1729.3, 6414.8, 35.0) },
        { pos = vector3(1698.9, 4924.1, 42.1) },
        { pos = vector3(1961.2, 3741.1, 32.3) },
        { pos = vector3(1392.5, 3604.5, 35.0) },
        { pos = vector3(2678.5, 3280.9, 55.2) },
        { pos = vector3(1165.8, 2708.9, 38.1) },
        { pos = vector3(547.6, 2671.1, 42.2) },
        { pos = vector3(-1821.4, 793.3, 138.1) },
        { pos = vector3(1136.0, -982.3, 46.4) },
        { pos = vector3(374.1, 326.1, 103.6) },
        { pos = vector3(1163.3, -323.0, 69.2) },
        { pos = vector3(2556.9, 382.5, 108.6) },
        { pos = vector3(4986.0, -5202.7, 2.5) } -- Cayo
    }
end