Config['shop_accessories'] = {
    MenuTitle = {
        MainMenu = "Magasin d'Accessoires",
    },
    MenuSubTitle = {
        MainMenu = "Bienvenue",
        MasquesMenu = "Masques",
        ChapeauxMenu = "Chapeaux",
        LunettesMenu = "Lunettes",
        MontresMenu = "Montres",
        BraceletsMenu = "Bracelets",
    },

    localisations = {}
}

if Config:gabz() then
    Config['shop_accessories'].localisations = {
        { pos = vector3(-1124.0, -1442.2, 5.2) }, -- Sud
        { pos = vector3(4503.7, -4513.0, 4.0) }, -- Cayo
    }
else
    Config['shop_accessories'].localisations = {
        { pos = vector3(-1337.4, -1278.1, 4.9) }, -- Sud
        { pos = vector3(4503.7, -4513.0, 4.0) }, -- Cayo
    }
end