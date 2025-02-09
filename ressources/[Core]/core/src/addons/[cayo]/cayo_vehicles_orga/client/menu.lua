
Cayo_Vehicles_Orga.MainMenu = RageUI.CreateMenu(Config["cayo_vehicles_orga"].MenuTitle.MainMenu, Config["cayo_vehicles_orga"].MenuSubTitle.MainMenu, 8, 200)

Cayo_Vehicles_Orga.CategoriesMenu = RageUI.CreateSubMenu(Cayo_Vehicles_Orga.MainMenu, Config["cayo_vehicles_orga"].MenuTitle.CategoryMenu, Config["cayo_vehicles_orga"].MenuSubTitle.CategoryMenu, 8, 200)

local open = false

Cayo_Vehicles_Orga.MainMenu.Closed = function()
    open = false
end

function Cayo_Vehicles_Orga:OpenMenu(categories)
    Cayo_Vehicles_Orga.catSelected = {}

    if open then
        RageUI.CloseAll()
        RageUI.Visible(Cayo_Vehicles_Orga.MainMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Cayo_Vehicles_Orga.MainMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Cayo_Vehicles_Orga.MainMenu, true, true, true, function()
                    for k,v in pairs(categories) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                Cayo_Vehicles_Orga.catSelected = v
                            end
                        end, Cayo_Vehicles_Orga.CategoriesMenu)
                    end
                end)

                RageUI.IsVisible(Cayo_Vehicles_Orga.CategoriesMenu, true, true, true, function()
                    for k,v in pairs(Config["cayo_vehicles_orga"].vehicles) do
                        if v.cat == Cayo_Vehicles_Orga.catSelected.name then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    if Framework.Game.IsSpawnPointClear(Cayo_Vehicles_Orga.catSelected.spawn, 5.0) then
                                        RageUI.CloseAll()
                                        Cayo_Vehicles_Orga:spawnVehicle(v.name, Cayo_Vehicles_Orga.catSelected.spawn, Cayo_Vehicles_Orga.catSelected.heading)
                                    else
                                        Framework.ShowNotification("~r~Il n'y a pas asser de place dans la zone !")
                                    end
                                end
                            end)
                        end
                    end
                end)
            end
        end)
    end
end