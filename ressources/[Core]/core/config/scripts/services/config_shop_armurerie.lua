
Config['shop_armurerie'] = {
    MenuTitle = {
        MainMenu = "Armurerie",
        CategoryMenu = "Armurerie"
    },
    MenuSubTitle = {
        MainMenu = "Choissisez une catégorie",
        CategoryMenu = "Choissisez un article"
    },

    localisations = {},

    categories = {
        { name = 'wblanches', label = "Armes blanches", needPPA = false },
        { name = 'wfeu', label = "Armes à Feu", needPPA = true},
        { name = 'others', label = "Autres", needPPA = false }
    },
    items = {
        { cat = 'wblanches', name = 'WEAPON_KNIFE', label = "Couteau", price = 8000 },
        { cat = 'wblanches', name = 'WEAPON_BAT', label = "Batte de baseball", price = 8000 },
        { cat = 'wblanches', name = 'WEAPON_HATCHET', label = "Hachette", price = 8000 },
        { cat = 'wblanches', name = 'WEAPON_SWITCHBLADE', label = "Couteau à cran d arrêt", price = 8000 },
        { cat = 'wblanches', name = 'WEAPON_FLASHLIGHT', label = "Lampe torche", price = 8000 },
        { cat = 'wblanches', name = 'WEAPON_MACHETE', label = "Machette", price = 8000 },
        { cat = 'wblanches', name = 'WEAPON_DAGGER', label = "Poignard", price = 8000 },

        { cat = 'wfeu', name = 'WEAPON_SNSPISTOL', label = "Pétoire", price = 70000 },

        { cat = 'others', name = 'clip', label = "Chargeur", price = 500, action = function()
            local qte = VisualManager:KeyboardOutput("Quantité", "", 5)

            if qte ~= nil and tonumber(qte) and tonumber(qte) > 0 then
                exports["ac"]:ExecuteServerEvent('shop_armurerie:buyChargeur', 400, qte)
            else
                Framework.ShowNotification("~r~Quantité Invalide !")
            end
        end},
        { cat = 'others', name = 'GADGET_PARACHUTE', label = "Parachute", price = 5000, action = function()
            exports["ac"]:ExecuteServerEvent('shop_armurerie:buy', {name = 'GADGET_PARACHUTE', price = 5000}, 1)
        end},
        { cat = 'others', name = 'gpb', label = "Gilet par balle", price = 10000, action = function()
            local qte = VisualManager:KeyboardOutput("Quantité", "", 5)

            if qte ~= nil and tonumber(qte) and tonumber(qte) > 0 then
                exports["ac"]:ExecuteServerEvent('shop_armurerie:buyGpb', 10000, qte)
            else
                Framework.ShowNotification("~r~Quantité Invalide !")
            end
        end}
    },

    pricePPA = 200000,
    chargeurItem = 'clip',
    gbpItem = "gpb"
}

if Config:gabz() then
    Config['shop_armurerie'].localisations = {
        { pos = vector3(-1309.0, -391.9, 36.7) },
        { pos = vector3(249.1, -49.3, 69.9) },
        { pos = vector3(843.5, -1030.0, 28.2) },
        { pos = vector3(16.4, -1109.5, 29.8) },
        { pos = vector3(814.7, -2152.9, 29.6) },
        { pos = vector3(-3169.0, 1085.3, 20.8) },
        { pos = vector3(-1115.1, 2696.5, 18.5) },
        { pos = vector3(1695.3, 3756.6, 34.7) },
        { pos = vector3(-328.8, 6080.3, 31.5) },
        { pos = vector3(2567.6, 297.6, 108.7) },
        { pos = vector3(5009.2, -5164.0, 3.1) } -- Cayo
    }
else
    Config['shop_armurerie'].localisations = {
        { pos = vector3(-1309.0, -391.9, 36.7) },
        { pos = vector3(249.1, -49.3, 69.9) },
        { pos = vector3(843.5, -1030.0, 28.2) },
        { pos = vector3(21.6, -1107.6, 29.8) },
        { pos = vector3(814.7, -2152.9, 29.6) },
        { pos = vector3(-3169.0, 1085.3, 20.8) },
        { pos = vector3(-1115.1, 2696.5, 18.5) },
        { pos = vector3(1695.3, 3756.6, 34.7) },
        { pos = vector3(-328.8, 6080.3, 31.5) },
        { pos = vector3(2567.6, 297.6, 108.7) },
        { pos = vector3(5009.2, -5164.0, 3.1) } -- Cayo
    }
end