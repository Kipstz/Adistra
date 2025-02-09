AmbulanceJob.GarageMenu = RageUI.CreateMenu("Ambulance", "~p~Ambulance~s~: Garage", 8, 200)
AmbulanceJob.VehiculesMenu = RageUI.CreateSubMenu(AmbulanceJob.GarageMenu, "Ambulance", "~p~Ambulance~s~: Vehicules Disponible", 8, 200)

local open = false

AmbulanceJob.GarageMenu.Closed = function()
    open = false
end

AmbulanceJob.OpenGarageMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(AmbulanceJob.GarageMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(AmbulanceJob.GarageMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)
                
                RageUI.IsVisible(AmbulanceJob.GarageMenu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_ambulance'].Garage.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected = v.name
                                end
                            end, AmbulanceJob.VehiculesMenu)
                        end
                    end
                end)

                RageUI.IsVisible(AmbulanceJob.VehiculesMenu, true, true, true, function()
                    for k,v in pairs(Config['job_ambulance'].Garage.Vehicules) do
                        if v.categorie == categorySelected then
                            if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                                RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if Framework.Game.IsSpawnPointClear(Config['job_ambulance'].Garage.SpawnPos, 5.0) then
                                            Framework.Game.SpawnVehicle(v.model, Config['job_ambulance'].Garage.SpawnPos, Config['job_ambulance'].Garage.SpawnHeading, function(vehicle) 
                                                local props = {
                                                    modEngine = 3,
                                                    modBrakes = 3,
                                                    modTransmission = 3,
                                                    modSuspension = 3,
                                                    modTurbo = true
                                                }
                                            
                                                Framework.Game.SetVehicleProperties(vehicle, props)
    
                                                local newPlate = Concess:GenerateSocietyPlate('AMB')
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