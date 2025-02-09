CayoAutoJob.GarageMenu = RageUI.CreateMenu("Cayo Perico Automobile", "~p~Cayo Perico Automobile~s~: Garage", 8, 200)
CayoAutoJob.VehiculesMenu = RageUI.CreateSubMenu(CayoAutoJob.GarageMenu, "Cayo Perico Automobile", "~p~Cayo Perico Automobile~s~: Véhicules Disponible", 8, 200)

local open = false

CayoAutoJob.GarageMenu.Closed = function()
    open = false
end

CayoAutoJob.OpenGarageMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(CayoAutoJob.GarageMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(CayoAutoJob.GarageMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(CayoAutoJob.GarageMenu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_cayoauto'].Garage.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected = v.name
                                end
                            end, CayoAutoJob.VehiculesMenu)
                        end
                    end
                end)

                RageUI.IsVisible(CayoAutoJob.VehiculesMenu, true, true, true, function()
                    for k,v in pairs(Config['job_cayoauto'].Garage.Vehicules) do
                        if v.categorie == categorySelected then
                            if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                                RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if Framework.Game.IsSpawnPointClear(Config['job_cayoauto'].Garage.SpawnPos, 5.0) then
                                            Framework.Game.SpawnVehicle(v.model, Config['job_cayoauto'].Garage.SpawnPos, Config['job_cayoauto'].Garage.SpawnHeading, function(vehicle) 
                                                local props = {
                                                    modEngine = 3,
                                                    modBrakes = 3,
                                                    modTransmission = 3,
                                                    modSuspension = 3,
                                                    modTurbo = true
                                                }
                                            
                                                Framework.Game.SetVehicleProperties(vehicle, props)
    
                                                local newPlate = Concess:GenerateSocietyPlate('BENN')
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