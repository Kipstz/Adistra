PoliceJob.GarageMenu = RageUI.CreateMenu("LSPD", "~p~LSPD~s~: Garage", 8, 200)
PoliceJob.VehiculesMenu = RageUI.CreateSubMenu(PoliceJob.GarageMenu, "LSPD", "~p~LSPD~s~: Véhicules Disponible", 8, 200)

local open = false

PoliceJob.GarageMenu.Closed = function()
    open = false
end

PoliceJob.OpenGarageMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(PoliceJob.GarageMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(PoliceJob.GarageMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(PoliceJob.GarageMenu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_police'].Garage.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected = v.name
                                end
                            end, PoliceJob.VehiculesMenu)
                        end
                    end
                end)

                RageUI.IsVisible(PoliceJob.VehiculesMenu, true, true, true, function()
                    for k,v in pairs(Config['job_police'].Garage.Vehicules) do
                        if v.categorie == categorySelected then
                            if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                                RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if Framework.Game.IsSpawnPointClear(Config['job_police'].Garage.SpawnPos, 5.0) then
                                            Framework.Game.SpawnVehicle(v.model, Config['job_police'].Garage.SpawnPos, Config['job_police'].Garage.SpawnHeading, function(vehicle) 
                                                local props = {
                                                    modEngine = 3,
                                                    modBrakes = 3,
                                                    modTransmission = 3,
                                                    modSuspension = 3,
                                                    modTurbo = true
                                                }
                                            
                                                Framework.Game.SetVehicleProperties(vehicle, props)
    
                                                local newPlate = Concess:GenerateSocietyPlate('LSPD')
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