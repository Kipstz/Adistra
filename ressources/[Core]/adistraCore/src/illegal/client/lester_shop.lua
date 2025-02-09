local lester_coords = {
    vector3(707.8, -965.2, 30.4)
}
local buy_items <const> = {
    { name = 'cardaccesfleeca', label = "Carte d'accès malveillant Fleeca Bank", desc = "", price = 10000 },
    { name = 'cardsecurefleeca', label = "Carte de Sécurité Fleeca Bank", desc = "", price = 10000 },

    { name = 'id_card', label = "Carte d'Identification", desc = "", price = 25000 },
    { name = 'thermal_charge', label = "Charge Thermique", desc = "", price = 30000 },
    { name = 'lockpick', label = "Outils de Crochetage (LockPick)", desc = "", price = 5000 },
    { name = 'laptop_h', label = "Ordinateur de Hacker", desc = "", price = 25000 },
}
local sell_items <const> = {
    { name = 'collier', label = "Collier", desc = "", price = 3000 },
    { name = 'bague', label = "Bague", desc = "", price = 6000 },
    { name = 'bijoux', label = "Bijoux", desc = "", price = 12000 },

    { name = 'livres', label = "Livres", desc = "", price = 200 },
    { name = 'dvd', label = "DVD", desc = "", price = 250 },
    { name = 'horloge', label = "Horloge", desc = "", price = 280 },
    { name = 'montre', label = "Montre", desc = "", price = 650 },
    { name = 'tablette', label = "Tablette", desc = "", price = 660 },
    { name = 'ps4', label = "PS4", desc = "", price = 550 },
    { name = 'xbox', label = "XBOX", desc = "", price = 550 },
    { name = 'laptop', label = "Ordinateur", desc = "", price = 1250 },
    { name = 'airpod', label = "Airpod", desc = "", price = 400 },
    { name = 'smartphone', label = "Smartphone", desc = "", price = 2800 },
    { name = 'ecranplat', label = "Ecran plat", desc = "", price = 5000 },
    { name = 'ps5', label = "PS5", desc = "", price = 1250 },
    { name = 'iphone15', label = "Iphone 15", desc = "", price = 6000 },
    { name = 'rolex', label = "Rolex", desc = "", price = 15000 },

    { name = 'gold_bar', label = "Lingot d'or", desc = "", price = 25000 },
    { name = 'dia_box', label = "Barre de Diamants", desc = "", price = 50000 },
}

local function open_menu()
    MainMenu = RageUI.CreateMenu("Lester", "Que veux-tu l'ami ?", 8, 200)
    RageUI.Visible(MainMenu, not RageUI.Visible(MainMenu))

    while MainMenu do 
        RageUI.IsVisible(MainMenu, true, true, true, function()
            RageUI.Separator("↓ Achats ↓ ")
            for _, v in pairs(buy_items) do
                RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~g~"..v.price.."$" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local input = lib.inputDialog('Achat Lester', {'Quantité'})
                        if not input then return end
                        local quantity = tonumber(input[1])
                        if quantity and quantity > 0 then
                            TriggerServerEvent("adistraCore.actionMenu", v, quantity, "buy")
                        end
                    end
                end)
            end
            RageUI.Separator("↓ Revente ↓")
            for _,v in pairs(sell_items) do
                RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~g~"..v.price.."$" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local input = lib.inputDialog('Achat Lester', {'Quantité'})
                        if not input then return end
                        local quantity = tonumber(input[1])
                        if quantity and quantity > 0 then
                            TriggerServerEvent("adistraCore.actionMenu", v, quantity, "sell")
                        end
                    end
                end)
            end
        end, function()
        end)
        if not RageUI.Visible(MainMenu) then 
            MainMenu = RMenu:DeleteType(MainMenu, true)
        end
        Wait(1)
    end
end

local function create_marker(self)
    DrawMarker(27, self.coords.x, self.coords.y, self.coords.z - 0.90, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, 0, 1, 0, 1)
    Framework.Game.Utils.DrawText3D((vector3(707.8, -965.2, 30.4)), "Appuyez sur [~p~E~s~] pour intéragir.",0.9, 4)	
    if self.currentDistance < 3 then
        if IsControlJustPressed(1, 51) then 
            open_menu()
        end
    end
end 

local function loading_marker()
    for i = 1, #lester_coords do
        lib.points.new({
            coords = lester_coords[i],
            distance = 10,
            nearby = create_marker
        })
    end
end

Citizen.CreateThread(function()
    loading_marker()
end)