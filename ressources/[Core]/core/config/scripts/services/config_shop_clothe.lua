Config['shop_clothe'] = {
    MenuTitle = {
        MainMenu = "Magasin de Vêtements",
        ShopMenu = "Magasin de Vêtements",
        ClotheGestion = "Magasin de Vêtements"
    },
    MenuSubTitle = {
        MainMenu = "Bienvenue",
        ShopMenu = "Faites votre tenue",
        ClotheGestion = "Gérer vos tenues"
    },

    price = 1000,

    limitOutfitsVip = {
        [0] = 15,
        [1] = 30,
        [2] = 60,
        [3] = 1000
    },

    localisations = {}
}

if Config:gabz() then
    Config['shop_clothe'].localisations = {
        { pos = vector3(-1450.2, -237.5, 49.8) },
        { pos = vector3(-1195.0, -772.6, 17.3) },
        { pos = vector3(-826.5, -1077.7, 11.3) },
        { pos = vector3(77.5, -1397.9, 29.4) },
        { pos = vector3(423.0, -801.7, 29.5) },
        { pos = vector3(-710.8, -153.1, 37.4) },
        { pos = vector3(-163.5, -303.5, 39.7) },
        { pos = vector3(124.2, -219.3, 54.6) },
        { pos = vector3(-3171.2, 1048.5, 20.9) },
        { pos = vector3(-1104.3, 2705.6, 19.1) },
        { pos = vector3(616.9, 2758.6, 42.1) },
        { pos = vector3(1191.8, 2708.0, 38.2) },
        { pos = vector3(1690.7, 4826.9, 42.1) },
        { pos = vector3(6.1, 6517.2, 31.9) },
        { pos = vector3(4483.8, -4450.9, 4.5) }, -- CAYO
    }
else
    Config['shop_clothe'].localisations = {
        { pos = vector3(-1450.2, -237.5, 49.8) },
        { pos = vector3(-1195.0, -772.6, 17.3) },
        { pos = vector3(-826.5, -1077.7, 11.3) },
        { pos = vector3(77.5, -1397.9, 29.4) },
        { pos = vector3(423.0, -801.7, 29.5) },
        { pos = vector3(-710.8, -153.1, 37.4) },
        { pos = vector3(-163.5, -303.5, 39.7) },
        { pos = vector3(124.2, -219.3, 54.6) },
        { pos = vector3(-3171.2, 1048.5, 20.9) },
        { pos = vector3(-1104.3, 2705.6, 19.1) },
        { pos = vector3(616.9, 2758.6, 42.1) },
        { pos = vector3(1191.8, 2708.0, 38.2) },
        { pos = vector3(1690.7, 4826.9, 42.1) },
        { pos = vector3(6.1, 6517.2, 31.9) },
        { pos = vector3(4483.8, -4450.9, 4.5) }, -- CAYO
    }
end