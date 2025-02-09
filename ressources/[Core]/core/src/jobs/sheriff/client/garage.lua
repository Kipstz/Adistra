SheriffJob.GarageMenu = RageUI.CreateMenu("Sheriff", "~p~Sheriff~s~: Garage", 8, 200)
SheriffJob.VehiculesMenu = RageUI.CreateSubMenu(SheriffJob.GarageMenu, "Sheriff", "~p~Sheriff~s~: Véhicules Disponible", 8, 200)

local open = false

SheriffJob.GarageMenu.Closed = function()
    open = false
end

SheriffJob.OpenGarageMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(SheriffJob.GarageMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(SheriffJob.GarageMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(SheriffJob.GarageMenu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_sheriff'].Garage.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected = v.name
                                end
                            end, SheriffJob.VehiculesMenu)
                        end
                    end
                end)

                RageUI.IsVisible(SheriffJob.VehiculesMenu, true, true, true, function()
                    for k,v in pairs(Config['job_sheriff'].Garage.Vehicules) do
                        if v.categorie == categorySelected then
                            if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                                RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if Framework.Game.IsSpawnPointClear(Config['job_sheriff'].Garage.SpawnPos, 5.0) then
                                            Framework.Game.SpawnVehicle(v.model, Config['job_sheriff'].Garage.SpawnPos, Config['job_sheriff'].Garage.SpawnHeading, function(vehicle) 
                                                local props = {
                                                    modEngine = 3,
                                                    modBrakes = 3,
                                                    modTransmission = 3,
                                                    modSuspension = 3,
                                                    modTurbo = true
                                                }
                                            
                                                Framework.Game.SetVehicleProperties(vehicle, props)
    
                                                local newPlate = Concess:GenerateSocietyPlate('SHER')
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