SheriffPaletoJob.Garage2Menu = RageUI.CreateMenu("Sheriff", "~p~Sheriff~s~: Garage Hélicoptère", 8, 200)
SheriffPaletoJob.HelicosMenu = RageUI.CreateSubMenu(SheriffPaletoJob.Garage2Menu, "Sheriff", "~p~Sheriff~s~: Hélicoptères Disponible", 8, 200)

local open = false

SheriffPaletoJob.Garage2Menu.Closed = function()
    open = false
end

SheriffPaletoJob.OpenGarage2Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(SheriffPaletoJob.Garage2Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(SheriffPaletoJob.Garage2Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)
                
                RageUI.IsVisible(SheriffPaletoJob.Garage2Menu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_sheriffpaleto'].Garage2.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected2 = v.name
                                end
                            end, SheriffPaletoJob.HelicosMenu)
                        end
                    end

                end)

                RageUI.IsVisible(SheriffPaletoJob.HelicosMenu, true, true, true, function()
                    for k,v in pairs(Config['job_sheriffpaleto'].Garage2.Helicos) do
                        if v.categorie == categorySelected2 then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    if Framework.Game.IsSpawnPointClear(Config['job_sheriffpaleto'].Garage2.SpawnPos, 5.0) then
                                        Framework.Game.SpawnVehicle(v.model, Config['job_sheriffpaleto'].Garage2.SpawnPos, Config['job_sheriffpaleto'].Garage2.SpawnHeading, function(vehicle) 
                                            local newPlate = Concess:GenerateSocietyPlate('SHER')
                                            SetVehicleNumberPlateText(vehicle, newPlate)
                                            exports["ac"]:ExecuteServerEvent('keys:givekey', 'no', newPlate)
                                            
                                            SetVehicleLivery(vehicle, 2)
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
                end)
                
            end
        end)
    end
end