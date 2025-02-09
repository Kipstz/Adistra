
TruckJob.destBlip = nil
TruckJob.vehicle = nil
TruckJob.imGayDataFDP = false



function TruckJob.getAvailableOutPoint()
    for _, coords in ipairs(Config['jobTruck'].AvailablesSpawnCoords) do
        if Framework.Game.IsSpawnPointClear(coords.xyz, 3.0) then
            return coords
        end
    end
end

function TruckJob.setDestinationBlip(coords)
    if TruckJob.destBlip and DoesBlipExist(TruckJob.destBlip) then
        SetBlipCoords(TruckJob.destBlip, coords.xyz)
        SetBlipRoute(TruckJob.destBlip, true)
        return
    end
    local blip = AddBlipForCoord(coords.xyz)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Destination")
    EndTextCommandSetBlipName(blip)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, true)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 1)
    TruckJob.destBlip = blip
end

function TruckJob.startMission(missionData)

    if not missionData.label or not missionData.car or not missionData.price or not missionData.destinationFinal or not missionData.removeCar then
        return Framework.ShowNotification("~r~Une erreur est survenue !")
    end

    local spawnPoint = TruckJob.getAvailableOutPoint()

    if not spawnPoint then 
        return Framework.ShowNotification("~r~Aucun point de spawn de véhicule disponible veuillez réessayer dans quelques instants !")
    end

    local model = missionData.car
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local vehicle = CreateVehicle(model, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.w, true, true)
    while not DoesEntityExist(vehicle) or not NetworkGetEntityIsNetworked(vehicle) do
        Wait(0)
    end
    SetEntityAsMissionEntity(vehicle, true, true)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetModelAsNoLongerNeeded(model)

    TruckJob.vehicle = vehicle

    Framework.ShowNotification("Livre moi cette marchandise rapidement au point indiqué sur le GPS !")
    TruckJob.setDestinationBlip(missionData.destinationFinal)

    TruckJob.imGayDataFDP = true

    while TruckJob.imGayDataFDP do 
        Wait(0)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if veh == vehicle then
                local coords = GetEntityCoords(veh)
                local distance = #(coords - missionData.destinationFinal.xyz)
                if distance < 10.0 then
                    RemoveBlip(TruckJob.destBlip)
                    Framework.ShowNotification("Vous avez livré la marchandise veuillez retourner au point de départ pour déposer le véhicule de livraison !")
                    TruckJob.setDestinationBlip(missionData.removeCar)
                    while true do 
                        Wait(0)
                        local newCoords = GetEntityCoords(veh)
                        local newDistance = #(newCoords - missionData.removeCar.xyz)    
                        if newDistance < 10.0 then
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                                if veh == vehicle then
                                    DeleteVehicle(veh)
                                    RemoveBlip(TruckJob.destBlip)
                                    TriggerServerEvent("core:jobTruck:finishMission", TruckJob.imGayDataFDP, missionData.price)
                                    TruckJob.imGayDataFDP = false
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end     
end
