SwatJob.Garage2Menu = RageUI.CreateMenu("SWAT", "~p~SWAT~s~: Garage Hélicoptère", 8, 200)
SwatJob.HelicosMenu = RageUI.CreateSubMenu(SwatJob.Garage2Menu, "SWAT", "~p~SWAT~s~: Hélicoptères Disponible", 8, 200)

local open = false

SwatJob.Garage2Menu.Closed = function()
    open = false
end

SwatJob.OpenGarage2Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(SwatJob.Garage2Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(SwatJob.Garage2Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)
                
                RageUI.IsVisible(SwatJob.Garage2Menu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_swat'].Garage2.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected2 = v.name
                                end
                            end, SwatJob.HelicosMenu)
                        end
                    end

                end)

                RageUI.IsVisible(SwatJob.HelicosMenu, true, true, true, function()
                    for k,v in pairs(Config['job_swat'].Garage2.Helicos) do
                        if v.categorie == categorySelected2 then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    if Framework.Game.IsSpawnPointClear(Config['job_swat'].Garage2.SpawnPos, 5.0) then
                                        Framework.Game.SpawnVehicle(v.model, Config['job_swat'].Garage2.SpawnPos, Config['job_swat'].Garage2.SpawnHeading, function(vehicle) 
                                            local newPlate = Concess:GenerateSocietyPlate('SWAT')
                                            SetVehicleNumberPlateText(vehicle, newPlate)
                                            exports["ac"]:ExecuteServerEvent('keys:givekey', 'no', newPlate)
                                            
                                            SetVehicleLivery(vehicle, 0)
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