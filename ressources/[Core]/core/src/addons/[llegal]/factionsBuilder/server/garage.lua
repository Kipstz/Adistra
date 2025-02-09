
Framework.RegisterServerCallback('factions:getVehicules', function(src, cb, faction)
    cb(SharedFactions[faction].vehicle)
end)

Framework.RegisterServerCallback('factions:canSpawnVehicle', function(src, cb, faction, plate)
    if SharedFactions[faction].vehicle[plate] then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('factions:storeVehicle')
AddEventHandler('factions:storeVehicle', function(faction, props)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    if SharedFactions[faction].vehicle[props.plate] == nil then
        local found = false;
        MySQL.query("SELECT * FROM character_vehicles WHERE plate = ?", { plate }, function(result)
            if next(result) then found = true else found = false end
        end)
        if not found then
            xPlayer.showNotification("~r~ATTENTION~s~: La contenance du coffre du véhicule sera supprimé en cas de redémarrage du serveur !")
        end

        SharedFactions[faction].vehicle[props.plate] = props
    end
end)

RegisterServerEvent('factions:removeVehicle')
AddEventHandler('factions:removeVehicle', function(faction, plate)
    if SharedFactions[faction].vehicle[plate] then 
        SharedFactions[faction].vehicle[plate] = nil
    end
end)