PoliceJob.Garage3Menu = RageUI.CreateMenu("LSPD", "~p~LSPD~s~: Garage", 8, 200)
PoliceJob.Vehicules3Menu = RageUI.CreateSubMenu(PoliceJob.Garage3Menu, "LSPD", "~p~LSPD~s~: Véhicules Disponible", 8, 200)

local open = false

PoliceJob.Garage3Menu.Closed = function()
    open = false
end

PoliceJob.OpenGarage3Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(PoliceJob.Garage3Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(PoliceJob.Garage3Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(PoliceJob.Garage3Menu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_police'].Garage3.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected = v.name
                                end
                            end, PoliceJob.Vehicules3Menu)
                        end
                    end
                end)

                RageUI.IsVisible(PoliceJob.Vehicules3Menu, true, true, true, function()
                    for k,v in pairs(Config['job_police'].Garage3.Vehicules) do
                        if v.categorie == categorySelected then
                            if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                                RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if Framework.Game.IsSpawnPointClear(Config['job_police'].Garage3.SpawnPos, 5.0) then
                                            Framework.Game.SpawnVehicle(v.model, Config['job_police'].Garage3.SpawnPos, Config['job_police'].Garage3.SpawnHeading, function(vehicle) 
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