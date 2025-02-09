
Factions.GarageMenu = RageUI.CreateMenu("Garage", "~p~Garage~s~: Actions", 8, 200)

local open = false

Factions.GarageMenu.Closed = function()
    open = false
end

Factions.OpenGarageMenu = function(coords, faction)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Factions.GarageMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Factions.GarageMenu, true)
        open = true

        Framework.TriggerServerCallback('factions:getVehicules', function(vehicles) 
            SharedFactions[faction].vehicle = vehicles
        end, faction)

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Factions.GarageMenu, true, true, true, function()

                    for k,v in pairs(SharedFactions[faction].vehicle) do
                        RageUI.ButtonWithStyle("[~b~"..v.plate.."~s~] - "..GetDisplayNameFromVehicleModel(v.model), nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                Wait(500)
                                if Framework.Game.IsSpawnPointClear(coords.posSpawn, 5.0) then
                                    Framework.TriggerServerCallback('factions:canSpawnVehicle', function(canSpawn) 
                                        if canSpawn then
                                            TriggerServerEvent('factions:removeVehicle', faction, v.plate)
                                            Framework.Game.SpawnVehicle(v.model, coords.posSpawn, coords.heading, function(vehicle)
                                                Framework.Game.SetVehicleProperties(vehicle, v)
            
                                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            
                                                RageUI.CloseAll()
                                            end)
                                        else
                                            Framework.ShowNotification("~r~Le véhicule n'est plus disponnible !~s~")
                                        end
                                    end, faction, v.plate)
                                else
                                    Framework.ShowNotification("~r~Aucune place disponnible ! ~s~")
                                end
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

RegisterNetEvent("factions:updateVehicles")
AddEventHandler("factions:updateVehicles", function(faction, vehicles)
    SharedFactions[faction].vehicle = vehicles
end)