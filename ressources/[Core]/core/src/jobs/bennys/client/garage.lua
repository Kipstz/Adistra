BennysJob.GarageMenu = RageUI.CreateMenu("Benny's", "~p~Benny's~s~: Garage", 8, 200)
BennysJob.VehiculesMenu = RageUI.CreateSubMenu(BennysJob.GarageMenu, "Benny's", "~p~Benny's~s~: Véhicules Disponible", 8, 200)

local open = false

BennysJob.GarageMenu.Closed = function()
    open = false
end

BennysJob.OpenGarageMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(BennysJob.GarageMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(BennysJob.GarageMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(BennysJob.GarageMenu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_bennys'].Garage.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected = v.name
                                end
                            end, BennysJob.VehiculesMenu)
                        end
                    end
                end)

                RageUI.IsVisible(BennysJob.VehiculesMenu, true, true, true, function()
                    for k,v in pairs(Config['job_bennys'].Garage.Vehicules) do
                        if v.categorie == categorySelected then
                            if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                                RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if Framework.Game.IsSpawnPointClear(Config['job_bennys'].Garage.SpawnPos, 5.0) then
                                            Framework.Game.SpawnVehicle(v.model, Config['job_bennys'].Garage.SpawnPos, Config['job_bennys'].Garage.SpawnHeading, function(vehicle) 
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