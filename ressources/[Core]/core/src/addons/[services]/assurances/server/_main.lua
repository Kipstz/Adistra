Assurances = {}

Assurances.delays = {}

Framework.RegisterServerCallback('assurances:getOwneds', function(src, cb, typeG)
    local xPlayer = Framework.GetPlayerFromId(src)

    if typeG == 'car' then
        Assurances.ownedCars = {}

        MySQL.Async.fetchAll('SELECT * FROM character_vehicles WHERE characterId = @characterId AND type = @type OR characterId = @characterId AND type = @type2', {
            ['@characterId'] = xPlayer.characterId,
            ['@type'] = 'car',
            ['@type2'] = 'boutique'
        }, function(data)
            for k, v in pairs(data) do
                if xPlayer.characterId == v.characterId then
                    local vehicle = json.decode(v.vehicle)
        
                    table.insert(Assurances.ownedCars, {
                        characterId = xPlayer.characterId,
                        vehicle = vehicle, 
                        state = v.state, 
                        label = v.label or "Ma Voiture",
                        plate = v.plate, 
                        type = v.type,
                        assurance = v.assurance
                    })

                end
            end

            cb(Assurances.ownedCars)
        end)
    elseif typeG == 'boat' then
        Assurances.ownedBoats = {}

        MySQL.Async.fetchAll('SELECT * FROM character_vehicles WHERE characterId = @characterId AND type = @type', {
            ['@characterId'] = xPlayer.characterId,
            ['@type'] = 'boat'
        }, function(data)
            for k, v in pairs(data) do
                local vehicle = json.decode(v.vehicle)
    
                table.insert(Assurances.ownedBoats, {
                    characterId = xPlayer.characterId,
                    vehicle = vehicle, 
                    state = v.state, 
                    label = v.label,
                    plate = v.plate, 
                    type = v.type,
                    assurance = v.assurance
                })
            end

            cb(Assurances.ownedBoats)
        end)
    elseif typeG == 'aircraft' then
        Assurances.ownedAircrafts = {}

        MySQL.Async.fetchAll('SELECT * FROM character_vehicles WHERE characterId = @characterId AND type = @type', {
            ['@characterId'] = xPlayer.characterId,
            ['@type'] = 'aircraft'
        }, function(data)
            for k, v in pairs(data) do
                local vehicle = json.decode(v.vehicle)
    
                table.insert(Assurances.ownedAircrafts, {
                    characterId = xPlayer.characterId,
                    vehicle = vehicle, 
                    state = v.state, 
                    label = v.label,
                    plate = v.plate, 
                    type = v.type,
                    assurance = v.assurance
                })
            end

            cb(Assurances.ownedAircrafts)
        end)
    end
end)

RegisterNetEvent('assurances:newContrat')
AddEventHandler('assurances:newContrat', function(args)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);
    local myMoney = tonumber(xPlayer['accounts'].getAccount('bank').money);
    local price = tonumber(args.price);

    if myMoney < price then
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent en Banque !~s~")
    else
        MySQL.Async.execute('UPDATE character_vehicles SET assurance = ? WHERE plate = ?', {args.id, args.plate}, function()
            xPlayer['accounts'].removeAccountMoney('bank', price)
            xPlayer.showNotification("~g~Vous avez un nouveau contrat pour la somme de "..args.price.."$ !")
        end)
    end
end)

Framework.RegisterServerCallback('assurances:check', function(src, cb, assuranceId)
    local src = src;
    local xPlayer = Framework.GetPlayerFromId(src);
    local can = true;
    local myMoney = tonumber(xPlayer['accounts'].getAccount('bank').money);
    for k,v in pairs(Config['assurances'].contrats) do if k == assuranceId then price = tonumber(v.franchise); end end

    if myMoney < price then can = false; xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !") end
    if Assurances.delays[src] ~= nil then
        can = false;
        xPlayer.showNotification("~r~Vous devez encore patienter quelques instants avant de redemander un véhicule.")
    end

    cb(can)
end)

RegisterNetEvent('assurances:vehicleSpawn')
AddEventHandler('assurances:vehicleSpawn', function(assuranceId)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);
    for k,v in pairs(Config['assurances'].contrats) do 
        if k == assuranceId then 
            price = tonumber(v.franchise);
            delay = v.delay
        end 
    end

    xPlayer['accounts'].removeAccountMoney('bank', price)
    Assurances.delays[src] = delay
end)

CreateThread(function()
    while true do
        wait = 10000;

        if next(Assurances.delays) then
            wait = 1000;
            for k,v in pairs(Assurances.delays) do
                if v <= 0 then Assurances.delays[k] = nil else Assurances.delays[k] = v - 1000 end
            end
        end
        
        Wait(wait)
    end
end)