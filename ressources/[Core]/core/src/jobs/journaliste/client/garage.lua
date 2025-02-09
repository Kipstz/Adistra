JournalisteJob.GarageMenu = RageUI.CreateMenu("Weazel-News", "~p~Journaliste~s~: Garage", 8, 200)
JournalisteJob.VehiculesMenu = RageUI.CreateSubMenu(JournalisteJob.GarageMenu, "Weazel-News", "~p~Journaliste~s~: Véhicules Disponible", 8, 200)

local open = false

JournalisteJob.GarageMenu.Closed = function()
    open = false
end

JournalisteJob.OpenGarageMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(JournalisteJob.GarageMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(JournalisteJob.GarageMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)
                
                RageUI.IsVisible(JournalisteJob.GarageMenu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_journalist'].Garage.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected = v.name
                                end
                            end, JournalisteJob.VehiculesMenu)
                        end
                    end
                end)

                RageUI.IsVisible(JournalisteJob.VehiculesMenu, true, true, true, function()
                    for k,v in pairs(Config['job_journalist'].Garage.Vehicules) do
                        if v.categorie == categorySelected then
                            if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                                RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if Framework.Game.IsSpawnPointClear(Config['job_journalist'].Garage.SpawnPos, 5.0) then
                                            Framework.Game.SpawnVehicle(v.model, Config['job_journalist'].Garage.SpawnPos, Config['job_journalist'].Garage.SpawnHeading, function(vehicle) 
                                                local props = {
                                                    modEngine = 3,
                                                    modBrakes = 3,
                                                    modTransmission = 3,
                                                    modSuspension = 3,
                                                    modTurbo = true
                                                }
                                            
                                                Framework.Game.SetVehicleProperties(vehicle, props)
    
                                                local newPlate = Concess:GenerateSocietyPlate('WEAZ')
                                                SetVehicleNumberPlateText(vehicle, newPlate)
                                                SetVehicleLivery(vehicle, 0)
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