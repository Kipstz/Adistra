
Cayo_Locations.MainMenu = RageUI.CreateMenu(Config["cayo_loc"].MenuTitle.MainMenu, Config["cayo_loc"].MenuSubTitle.MainMenu, 8, 200)

Cayo_Locations.CategoriesMenu = RageUI.CreateSubMenu(Cayo_Locations.MainMenu, Config["cayo_loc"].MenuTitle.CategoryMenu, Config["cayo_loc"].MenuSubTitle.CategoryMenu, 8, 200)

local open = false

Cayo_Locations.MainMenu.Closed = function()
    open = false
end

function Cayo_Locations:OpenMenu(categories)
    Cayo_Locations.catSelected = {}

    if open then
        RageUI.CloseAll()
        RageUI.Visible(Cayo_Locations.MainMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Cayo_Locations.MainMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Cayo_Locations.MainMenu, true, true, true, function()
                    for k,v in pairs(categories) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                Cayo_Locations.catSelected = v
                            end
                        end, Cayo_Locations.CategoriesMenu)
                    end
                end)

                RageUI.IsVisible(Cayo_Locations.CategoriesMenu, true, true, true, function()
                    for k,v in pairs(Config["cayo_loc"].vehicles) do
                        if v.cat == Cayo_Locations.catSelected.name then
                            RageUI.ButtonWithStyle("[PRIX: ~g~"..v.price.."$ ~s~] - "..v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    RageUI.CloseAll()
                                    Framework.PaymentMethod(tonumber(v.price), function(price, method)
                                        if price and method ~= nil then
                                            if Framework.Game.IsSpawnPointClear(Cayo_Locations.catSelected.spawn, 5.0) then 
                                                Framework.TriggerServerCallback("cayo_locations:haveMoney", function(hasMoney)
                                                    if hasMoney then
                                                        Cayo_Locations:spawnVehicle(v.name, Cayo_Locations.catSelected.spawn, Cayo_Locations.catSelected.heading)
                                                    end
                                                end, {price = tonumber(v.price), method = method})
                                            else
                                                Framework.ShowNotification("~r~Il n'y a pas asser de place dans la zone !")
                                            end
                                        end
                                    end)
                                end
                            end)
                        end
                    end
                end)
            end
        end)
    end
end