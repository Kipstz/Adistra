
Framework.RegisterServerCallback('property:getGarage', function(src, cb, propertyId)
    cb(SharedProperty[propertyId].data["vehicles"])
end)

Framework.RegisterServerCallback('property:canSpawnVehicle', function(src, cb, propertyId, plate)
    if SharedProperty[propertyId].data["vehicles"][plate] then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('property:depositVeh')
AddEventHandler('property:depositVeh', function(propertyId, veh)
    local xPlayer = Framework.GetPlayerFromId(source)

    if SharedProperty[propertyId].data["vehicles"] and not SharedProperty[propertyId].data["vehicles"][veh.props.plate] then
        SharedProperty[propertyId].data["vehicles"][veh.props.plate] = veh
    else
        xPlayer.showNotification("~r~Véhicule déjà dans le garage !")
    end
end)

RegisterServerEvent('property:removeVeh')
AddEventHandler('property:removeVeh', function(propertyId, veh)
    local xPlayer = Framework.GetPlayerFromId(source)

    if SharedProperty[propertyId].data["vehicles"] and SharedProperty[propertyId].data["vehicles"][veh.props.plate] then
        SharedProperty[propertyId].data["vehicles"][veh.props.plate] = nil
    else
        xPlayer.showNotification("~r~Véhicule Invalide !")
    end
end)