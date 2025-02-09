CayoEmsJob.Garage2Menu = RageUI.CreateMenu("Ambulance", "~p~Ambulance~s~: Garage Hélicoptère", 8, 200)
CayoEmsJob.HelicosMenu = RageUI.CreateSubMenu(CayoEmsJob.Garage2Menu, "Ambulance", "~p~Ambulance~s~: Hélicoptères Disponible", 8, 200)

local open = false

CayoEmsJob.Garage2Menu.Closed = function()
    open = false
end

CayoEmsJob.OpenGarage2Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(CayoEmsJob.Garage2Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(CayoEmsJob.Garage2Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)
                
                RageUI.IsVisible(CayoEmsJob.Garage2Menu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_cayoems'].Garage2.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected2 = v.name
                                end
                            end, CayoEmsJob.HelicosMenu)
                        end
                    end

                end)

                RageUI.IsVisible(CayoEmsJob.HelicosMenu, true, true, true, function()
                    for k,v in pairs(Config['job_cayoems'].Garage2.Helicos) do
                        if v.categorie == categorySelected2 then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    if Framework.Game.IsSpawnPointClear(Config['job_cayoems'].Garage2.SpawnPos, 5.0) then
                                        Framework.Game.SpawnVehicle(v.model, Config['job_cayoems'].Garage2.SpawnPos, Config['job_cayoems'].Garage2.SpawnHeading, function(vehicle) 
                                            local newPlate = Concess:GenerateSocietyPlate('AMB')
                                            SetVehicleNumberPlateText(vehicle, newPlate)
                                            exports["ac"]:ExecuteServerEvent('keys:givekey', 'no', newPlate)
                                            
                                            SetVehicleLivery(vehicle, 1)
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