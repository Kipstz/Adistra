UsArmyJob.GarageMenu = RageUI.CreateMenu("US Army", "~p~US Army~s~: Garage", 8, 200)
UsArmyJob.VehiculesMenu = RageUI.CreateSubMenu(UsArmyJob.GarageMenu, "US Army", "~p~US Army~s~: Véhicules Disponible", 8, 200)

local open = false

UsArmyJob.GarageMenu.Closed = function()
    open = false
end

UsArmyJob.OpenGarageMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(UsArmyJob.GarageMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(UsArmyJob.GarageMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(UsArmyJob.GarageMenu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_usarmy'].Garage.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected = v.name
                                end
                            end, UsArmyJob.VehiculesMenu)
                        end
                    end
                end)

                RageUI.IsVisible(UsArmyJob.VehiculesMenu, true, true, true, function()
                    for k,v in pairs(Config['job_usarmy'].Garage.Vehicules) do
                        if v.categorie == categorySelected then
                            if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                                RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if Framework.Game.IsSpawnPointClear(Config['job_usarmy'].Garage.SpawnPos, 5.0) then
                                            Framework.Game.SpawnVehicle(v.model, Config['job_usarmy'].Garage.SpawnPos, Config['job_usarmy'].Garage.SpawnHeading, function(vehicle) 
                                                local props = {
                                                    modEngine = 3,
                                                    modBrakes = 3,
                                                    modTransmission = 3,
                                                    modSuspension = 3,
                                                    modTurbo = true
                                                }
                                            
                                                Framework.Game.SetVehicleProperties(vehicle, props)
    
                                                local newPlate = Concess:GenerateSocietyPlate('ARMY')
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