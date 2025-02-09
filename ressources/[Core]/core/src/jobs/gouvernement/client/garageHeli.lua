GouvernementJob.Garage2Menu = RageUI.CreateMenu("Gouvernement", "~p~Gouvernement~s~: Garage Hélicoptère", 8, 200)
GouvernementJob.HelicosMenu = RageUI.CreateSubMenu(GouvernementJob.Garage2Menu, "Gouvernement", "~p~Gouvernement~s~: Hélicoptères Disponible", 8, 200)

local open = false

GouvernementJob.Garage2Menu.Closed = function()
    open = false
end

GouvernementJob.OpenGarage2Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(GouvernementJob.Garage2Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(GouvernementJob.Garage2Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)
                
                RageUI.IsVisible(GouvernementJob.Garage2Menu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_gouvernement'].Garage2.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected2 = v.name
                                end
                            end, GouvernementJob.HelicosMenu)
                        end
                    end

                end)

                RageUI.IsVisible(GouvernementJob.HelicosMenu, true, true, true, function()
                    for k,v in pairs(Config['job_gouvernement'].Garage2.Helicos) do
                        if v.categorie == categorySelected2 then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    if Framework.Game.IsSpawnPointClear(Config['job_gouvernement'].Garage2.SpawnPos, 5.0) then
                                        Framework.Game.SpawnVehicle(v.model, Config['job_gouvernement'].Garage2.SpawnPos, Config['job_gouvernement'].Garage2.SpawnHeading, function(vehicle) 
                                            local newPlate = Concess:GenerateSocietyPlate('GOUV')
                                            SetVehicleNumberPlateText(vehicle, newPlate)
                                            exports["ac"]:ExecuteServerEvent('keys:givekey', 'no', newPlate)
                                            
                                            SetVehicleLivery(vehicle, 0)
                                            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                            RageUI.CloseAll()
                                        end)

                                        Framework.ShowNotification("Véhicule Spawn !")
                                    else
                                        Framework.ShowNotification("Aucune place disponible !")
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