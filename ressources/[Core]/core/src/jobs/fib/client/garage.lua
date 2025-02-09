FibJob.GarageMenu = RageUI.CreateMenu("FIB", "~p~FIB~s~: Garage", 8, 200)
FibJob.VehiculesMenu = RageUI.CreateSubMenu(FibJob.GarageMenu, "FIB", "~p~FIB~s~: Véhicules Disponible", 8, 200)

local open = false

FibJob.GarageMenu.Closed = function()
    open = false
end

FibJob.OpenGarageMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(FibJob.GarageMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(FibJob.GarageMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(FibJob.GarageMenu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_fib'].Garage.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected = v.name
                                end
                            end, FibJob.VehiculesMenu)
                        end
                    end
                end)

                RageUI.IsVisible(FibJob.VehiculesMenu, true, true, true, function()
                    for k,v in pairs(Config['job_fib'].Garage.Vehicules) do
                        if v.categorie == categorySelected then
                            if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                                RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if Framework.Game.IsSpawnPointClear(Config['job_fib'].Garage.SpawnPos, 5.0) then
                                            Framework.Game.SpawnVehicle(v.model, Config['job_fib'].Garage.SpawnPos, Config['job_fib'].Garage.SpawnHeading, function(vehicle) 
                                                local props = {
                                                    modEngine = 3,
                                                    modBrakes = 3,
                                                    modTransmission = 3,
                                                    modSuspension = 3,
                                                    modTurbo = true
                                                }
                                            
                                                Framework.Game.SetVehicleProperties(vehicle, props)
    
                                                local newPlate = Concess:GenerateSocietyPlate('FIB0')
                                                SetVehicleNumberPlateText(vehicle, newPlate)
                                                exports["ac"]:ExecuteServerEvent('keys:givekey', 'no', newPlate)
    
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
                    end
                end)
                
            end
        end)
    end
end