
function GoFast:spawnVeh(vehModel, coords, heading)
    local plyPed = PlayerPedId()
    Framework.Game.SpawnVehicle(vehModel, coords, heading, function(veh)
        local props = Framework.Game.GetVehicleProperties(veh)
        TaskWarpPedIntoVehicle(plyPed, veh, -1)
        GoFast.vehicle = veh;
        GoFast.vehiclePlate = props.plate;
    end)
end

function GoFast:setDestination(coords)
    GoFast.blip = AddBlipForCoord(coords)
    SetBlipSprite(GoFast.blip, 1)
    SetBlipDisplay(GoFast.blip, 4)
    SetBlipColour(GoFast.blip, 5)
    SetBlipScale(GoFast.blip, 0.5)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("Destination")
    EndTextCommandSetBlipName(GoFast.blip)

    SetBlipRoute(GoFast.blip, true)
    SetBlipRouteColour(GoFast.blip, 5)

    ZoneManager:createZoneWithMarker(coords, 10, 3.5, {
        onPress = {control = 38, action = function(zone)
            if GoFast.inGoFast then
                local plyPed = PlayerPedId()
                local inVeh = IsPedInAnyVehicle(plyPed)
                if inVeh then
                    local vehicle = GetVehiclePedIsIn(plyPed)
                    if GoFast.vehiclePlate ~= nil and GoFast.vehiclePlate == GetVehicleNumberPlateText(vehicle) then
                        GoFast:delivery(vehicle)
                    else
                        GoFast.inGoFast = false;
                        RemoveBlip(GoFast.blip)
    
                        Framework.ShowNotification("~r~Ta crus pouvoir m'arnaqué enfoiré !~s~")
                    end
                else
                    GoFast.inGoFast = false;
                    RemoveBlip(GoFast.blip)
    
                    Framework.ShowNotification("~r~Ta crus pouvoir m'arnaqué enfoiré !~s~")
                end
            end
        end}
    })
end

function GoFast:start()
    GoFast.inGoFast = true;
    GoFast.canDoGoFast = false;
    GoFast.configId = math.random(1, #Config['gofast'].missions)
    GoFast.config = Config['gofast'].missions[GoFast.configId]

    if Framework.Game.IsSpawnPointClear(GoFast.config.vehPos, 5.0) then
        GoFast:spawnVeh(GoFast.config.veh, GoFast.config.vehPos, GoFast.config.vehHead)
        GoFast:setDestination(GoFast.config.toCoords)
        GoFast:timer()
        GoFast:cooldown()
        
        exports["ac"]:ExecuteServerEvent('gofast:start', GoFast.configId)
        Framework.ShowNotification("Un point à été mis sur votre GPS ! Vous avez ~b~15 Minutes~s~ pour livrer le véhicule.")
    else
        Framework.ShowNotification("~r~Impossible de lancer un GoFast, un véhicule gène.~s~")
    end
end

function GoFast:delivery(veh)
	local vehiclehealth = GetEntityHealth(veh) - 100
	local maxhealth = GetEntityMaxHealth(veh) - 100
	local percent = (vehiclehealth / maxhealth) * 100

    if percent > 80 then
        GoFast.inGoFast = false;
        RemoveBlip(GoFast.blip)
        if GoFast.vehicle ~= nil and DoesEntityExist(GoFast.vehicle) then
            Framework.Game.DeleteVehicle(GoFast.vehicle)
            GoFast.vehicle = nil;
        end

        exports["ac"]:ExecuteServerEvent('gofast:reward', GoFast.configId)
    else
        Framework.ShowNotification("~r~Tu te fous de moi ! Ton véhicule est une épave roulante !~s~")

        GoFast.inGoFast = false;
        RemoveBlip(GoFast.blip)
        if GoFast.vehicle ~= nil and DoesEntityExist(GoFast.vehicle) then
            Framework.Game.DeleteVehicle(GoFast.vehicle)
            GoFast.vehicle = nil;
        end
    end
end

function GoFast:stop()
    GoFast.inGoFast = false;
    RemoveBlip(GoFast.blip)
    if GoFast.vehicle ~= nil and DoesEntityExist(GoFast.vehicle) then
        Framework.Game.DeleteVehicle(GoFast.vehicle)
        GoFast.vehicle = nil;
    end
end

function GoFast:timer()
    SetTimeout(60000*15, function()
        Framework.ShowNotification("~r~Vous avez dépasser le temps !~s~")
        GoFast:stop()
    end)
end

function GoFast:cooldown()
    SetTimeout(60000*20, function()
        GoFast.canDoGoFast = true;
    end)
end