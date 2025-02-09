NightClub.GarageMenu = RageUI.CreateMenu("77-Club", "~p~77-Club~s~: Garage", 8, 200)
NightClub.VehiculesMenu = RageUI.CreateSubMenu(NightClub.GarageMenu, "77-Club", "~p~77-Club~s~: Véhicules Disponible", 8, 200)

local open = false

NightClub.GarageMenu.Closed = function()
    open = false
end

NightClub.OpenGarageMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(NightClub.GarageMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(NightClub.GarageMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)
                
                RageUI.IsVisible(NightClub.GarageMenu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_77club'].Garage.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected = v.name
                                end
                            end, NightClub.VehiculesMenu)
                        end
                    end
                end)

                RageUI.IsVisible(NightClub.VehiculesMenu, true, true, true, function()
                    for k,v in pairs(Config['job_77club'].Garage.Vehicules) do
                        if v.categorie == categorySelected then
                            if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                                RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if Framework.Game.IsSpawnPointClear(Config['job_77club'].Garage.SpawnPos, 5.0) then
                                            Framework.Game.SpawnVehicle(v.model, Config['job_77club'].Garage.SpawnPos, Config['job_77club'].Garage.SpawnHeading, function(vehicle) 
                                                local props = {
                                                    modEngine = 3,
                                                    modBrakes = 3,
                                                    modTransmission = 3,
                                                    modSuspension = 3,
                                                    modTurbo = true
                                                }
                                            
                                                Framework.Game.SetVehicleProperties(vehicle, props)
    
                                                local newPlate = Concess:GenerateSocietyPlate('77CL')
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