CookiesJob.GarageMenu = RageUI.CreateMenu("BurgerShot", "~p~BurgerShot~s~: Garage", 8, 200)
CookiesJob.VehiculesMenu = RageUI.CreateSubMenu(CookiesJob.GarageMenu, "BurgerShot", "~p~BurgerShot~s~: Véhicules Disponible", 8, 200)

local open = false

CookiesJob.GarageMenu.Closed = function()
    open = false
end

CookiesJob.OpenGarageMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(CookiesJob.GarageMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(CookiesJob.GarageMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)
                
                RageUI.IsVisible(CookiesJob.GarageMenu, true, true, true, function()
                    
                    for k,v in pairs(Config['job_cookies'].Garage.Categories) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    categorySelected = v.name
                                end
                            end, CookiesJob.VehiculesMenu)
                        end
                    end
                end)

                RageUI.IsVisible(CookiesJob.VehiculesMenu, true, true, true, function()
                    for k,v in pairs(Config['job_cookies'].Garage.Vehicules) do
                        if v.categorie == categorySelected then
                            if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                                RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        if Framework.Game.IsSpawnPointClear(Config['job_cookies'].Garage.SpawnPos, 5.0) then
                                            Framework.Game.SpawnVehicle(v.model, Config['job_cookies'].Garage.SpawnPos, Config['job_cookies'].Garage.SpawnHeading, function(vehicle) 
                                                local props = {
                                                    modEngine = 3,
                                                    modBrakes = 3,
                                                    modTransmission = 3,
                                                    modSuspension = 3,
                                                    modTurbo = true
                                                }
                                            
                                                Framework.Game.SetVehicleProperties(vehicle, props)
    
                                                local newPlate = Concess:GenerateSocietyPlate('LSCU')
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