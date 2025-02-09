Garages = {}

Garages.ownedCars = {}
Garages.ownedBoats = {}
Garages.ownedAircrafts = {}

CreateThread(function()
    for k,v in pairs(Config['garages'].localisations) do
        BlipManager:addBlip('garage_'..k, v.pos, v.sprite, v.color, v.name, 0.6, true)
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                if v.type == 'car' then
                    Garages.OpenCarMenu(v.spawn, v.heading)
                elseif v.type == 'boat' then
                    Garages.OpenBoatMenu(v.spawn, v.heading)
                elseif v.type == 'aircraft' then
                    Garages.OpenAircraftMenu(v.spawn, v.heading)
                end
            end}
        })
        ZoneManager:createZoneWithMarker(v.deleter, 20, 3.5, {
            onPress = {control = 38, action = function(zone)
                local plyPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(plyPed)

                if IsPedInAnyVehicle(plyPed) then 
                    if GetPedInVehicleSeat(vehicle, -1) == plyPed then
                        Garages.CheckOwned(vehicle, v.type)
                    end
                else
                    Framework.ShowNotification("~r~Vous devez être dans un véhicule !~s~")
                end
            end}
        })
    end
end)

Garages.CheckOwned = function(vehicle, typeVeh)
    local isOwned = false
    local vehicleProps = Framework.Game.GetVehicleProperties(vehicle)
    
    if typeVeh == 'car' then
        Framework.TriggerServerCallback('garages:getOwneds', function(myCars) 
            Garages.ownedCars = myCars
        end, 'car')

        Wait(1500)

        for k,v in pairs(Garages.ownedCars) do
            if v.plate == vehicleProps.plate then
                isOwned = true
            end
        end
    elseif typeVeh == 'boat' then
        Framework.TriggerServerCallback('garages:getOwneds', function(myBoats) 
            Garages.ownedBoats = myBoats
        end, 'boat')

        Wait(1500)
        
        for k,v in pairs(Garages.ownedBoats) do
            if v.plate == vehicleProps.plate then
                isOwned = true
            end
        end
    elseif typeVeh == 'aircraft' then
        Framework.TriggerServerCallback('garages:getOwneds', function(myAircrafts) 
            Garages.ownedAircrafts = myAircrafts
        end, 'aircrafts')

        Wait(1500)
        
        for k,v in pairs(Garages.ownedAircrafts) do
            if v.plate == vehicleProps.plate then
                isOwned = true
            end
        end
    end

    if isOwned then
        exports["ac"]:ExecuteServerEvent('garages:storeVehicle', vehicleProps)

        if typeVeh == 'car' then
            for k,v in pairs(Garages.ownedCars) do
                if v.plate == vehicleProps.plate then
                    v.state = true
                end
            end
        elseif typeVeh == 'boat' then
            for k,v in pairs(Garages.ownedBoats) do
                if v.plate == vehicleProps.plate then
                    v.state = true
                end
            end
        elseif typeVeh == 'aircraft' then
            for k,v in pairs(Garages.ownedAircrafts) do
                if v.plate == vehicleProps.plate then
                    v.state = true
                end
            end
        end
        
        Framework.Game.DeleteVehicle(vehicle)
    else
        Framework.ShowNotification("~r~Ce n'est pas votre véhicule !")
    end
end