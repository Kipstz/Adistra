
Property.garageMenu = RageUI.CreateMenu("Garage", "~p~Garage~s~: Actions", 8, 200)

local open = false

Property.garageMenu.Closed = function()
    open = false
end

function Property:openGarageMenu(propertyId)
    Framework.TriggerServerCallback('property:getGarage', function(vehicles) 
        SharedProperty[propertyId].data["vehicles"] = vehicles
    end, propertyId)

    if open then
        RageUI.CloseAll()
        RageUI.Visible(Property.garageMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Property.garageMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Property.garageMenu, true, true, true, function()

                    for k,v in pairs(SharedProperty[propertyId].data["vehicles"]) do
                        RageUI.ButtonWithStyle("[~b~"..v.props.plate.."~s~] - "..v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local coords = Property:getPropertybyId(propertyId).points['vehSpawn']
                                local heading = Property:getPropertybyId(propertyId).points['vehHeading']

                                if Framework.Game.IsSpawnPointClear(vector3(coords.x, coords.y, coords.z), 5.0) then
                                    Framework.TriggerServerCallback('property:canSpawnVehicle', function(canSpawn) 
                                        if canSpawn then
                                            TriggerServerEvent('property:removeVehicle', propertyId, v.props.plate)
                                            Framework.Game.SpawnVehicle(v.props.model, vector3(coords.x, coords.y, coords.z), heading, function(vehicle) 
                                                Framework.Game.SetVehicleProperties(vehicle, v.props)
            
                                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                                RageUI.CloseAll()
                                            end)
                                        else
                                            Framework.ShowNotification("~r~Le véhicule n'est plus disponnible !~s~")
                                        end
                                    end, propertyId, v.props.plate)
                                else
                                    Framework.ShowNotification("~r~Il n'y a pas asser de place !")
                                end
                            end
                        end)
                    end

                end)
            end
        end)
    end
end