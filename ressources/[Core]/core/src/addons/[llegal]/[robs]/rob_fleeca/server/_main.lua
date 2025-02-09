FleecaRob = {}

Doors = {
    ["F1"] = {{loc = vector3(312.93, -284.45, 54.16), h = 160.91, txtloc = vector3(312.93, -284.45, 54.16), obj = nil, locked = true}, {loc = vector3(310.93, -284.44, 54.16), txtloc = vector3(310.93, -284.44, 54.16), state = nil, locked = true}},
    ["F2"] = {{loc = vector3(148.76, -1045.89, 29.37), h = 158.54, txtloc = vector3(148.76, -1045.89, 29.37), obj = nil, locked = true}, {loc = vector3(146.61, -1046.02, 29.37), txtloc = vector3(146.61, -1046.02, 29.37), state = nil, locked = true}},
    ["F3"] = {{loc = vector3(-1209.66, -335.15, 37.78), h = 213.67, txtloc = vector3(-1209.66, -335.15, 37.78), obj = nil, locked = true}, {loc = vector3(-1211.07, -336.68, 37.78), txtloc = vector3(-1211.07, -336.68, 37.78), state = nil, locked = true}},
    ["F4"] = {{loc = vector3(-2957.26, 483.53, 15.70), h = 267.73, txtloc = vector3(-2957.26, 483.53, 15.70), obj = nil, locked = true}, {loc = vector3(-2956.68, 481.34, 15.70), txtloc = vector3(-2956.68, 481.34, 15.7), state = nil, locked = true}},
    ["F5"] = {{loc = vector3(-351.97, -55.18, 49.04), h = 159.79, txtloc = vector3(-351.97, -55.18, 49.04), obj = nil, locked = true}, {loc = vector3(-354.15, -55.11, 49.04), txtloc = vector3(-354.15, -55.11, 49.04), state = nil, locked = true}},
    ["F6"] = {{loc = vector3(1174.24, 2712.47, 38.09), h = 160.91, txtloc = vector3(1174.24, 2712.47, 38.09), obj = nil, locked = true}, {loc = vector3(1176.40, 2712.75, 38.09), txtloc = vector3(1176.40, 2712.75, 38.09), state = nil, locked = true}},
}

RegisterServerEvent("rob_fleeca:startcheck")
AddEventHandler("rob_fleeca:startcheck", function(bank)
    local _source = source;
    local copscount = 0;
    for k,v in pairs(Config['rob_fleeca'].PoliceJobs) do
        local count = Service:GetInServiceCount(v)
        if count ~= nil then
            copscount = tonumber(copscount + count)
        end
    end
    
    local Players = Framework.GetPlayers()

    local xPlayer = Framework.GetPlayerFromId(_source)
    local item = xPlayer['inventory'].getInventoryItem("cardaccesfleeca").count

    if copscount >= Config['rob_fleeca'].mincops then
        if item >= 1 then
            if not Config['rob_fleeca'].Banks[bank].onaction == true then
                if (os.time() - Config['rob_fleeca'].cooldown) > Config['rob_fleeca'].Banks[bank].lastrobbed then
                    Config['rob_fleeca'].Banks[bank].onaction = true
                    xPlayer['inventory'].removeInventoryItem("cardaccesfleeca", 1)
                    TriggerClientEvent("rob_fleeca:outcome", _source, true, bank)
                    TriggerClientEvent("rob_fleeca:policenotify", -1, bank)
                else
                    TriggerClientEvent("rob_fleeca:outcome", _source, false, "Cette banque a récemment volé. Vous devez attendre ~b~"..math.floor((Config['rob_fleeca'].cooldown - (os.time() - Config['rob_fleeca'].Banks[bank].lastrobbed)) / 60)..":"..math.fmod((Config['rob_fleeca'].cooldown - (os.time() - Config['rob_fleeca'].Banks[bank].lastrobbed)), 60))
                end
            else
                TriggerClientEvent("rob_fleeca:outcome", _source, false, "~r~Cette banque est actuellement cambriolée !")
            end
        else
            TriggerClientEvent("rob_fleeca:outcome", _source, false, "~r~Vous n'avez pas de ~r~Carte d'accès malveillante, aller voir Lester !")
        end
    else
        TriggerClientEvent("rob_fleeca:outcome", _source, false, "~r~Il n'y a pas assez de policiers dans la ville.")
    end
end)

RegisterServerEvent("rob_fleeca:lootup")
AddEventHandler("rob_fleeca:lootup", function(var, var2)
    TriggerClientEvent("rob_fleeca:lootup_c", -1, var, var2)
end)

RegisterServerEvent("rob_fleeca:openDoor")
AddEventHandler("rob_fleeca:openDoor", function(coords, method)
    TriggerClientEvent("rob_fleeca:openDoor_c", -1, coords, method)
end)

RegisterServerEvent("rob_fleeca:toggleDoor")
AddEventHandler("rob_fleeca:toggleDoor", function(key, state)
    Doors[key][1].locked = state
    TriggerClientEvent("rob_fleeca:toggleDoor", -1, key, state)
end)

RegisterServerEvent("rob_fleeca:toggleVault")
AddEventHandler("rob_fleeca:toggleVault", function(key, state)
    Doors[key][2].locked = state
    TriggerClientEvent("rob_fleeca:toggleVault", -1, key, state)
end)

RegisterServerEvent("rob_fleeca:updateVaultState")
AddEventHandler("rob_fleeca:updateVaultState", function(key, state)
    Doors[key][2].state = state
end)

RegisterServerEvent("rob_fleeca:startLoot")
AddEventHandler("rob_fleeca:startLoot", function(data, name, players)
    local _source = source

    for i = 1, #players, 1 do
        TriggerClientEvent("rob_fleeca:startLoot_c", players[i], data, name)
    end
    TriggerClientEvent("rob_fleeca:startLoot_c", _source, data, name)
end)

RegisterServerEvent("rob_fleeca:stopHeist")
AddEventHandler("rob_fleeca:stopHeist", function(name)
    TriggerClientEvent("rob_fleeca:stopHeist_c", -1, name)
end)

RegisterServerEvent('rob_fleeca:rewardCash')
AddEventHandler('rob_fleeca:rewardCash', function()
    local xPlayer = Framework.GetPlayerFromId(source)
    local reward = math.random(Config['rob_fleeca'].mincash, Config['rob_fleeca'].maxcash)

    if Config['rob_fleeca'].black then
        xPlayer['accounts'].addAccountMoney("black_money", reward)
    else
        xPlayer['accounts'].addMoney(reward)
    end
end)

RegisterServerEvent("rob_fleeca:setCooldown")
AddEventHandler("rob_fleeca:setCooldown", function(name)
    Config['rob_fleeca'].Banks[name].lastrobbed = os.time()
    Config['rob_fleeca'].Banks[name].onaction = false
    TriggerClientEvent("rob_fleeca:resetDoorState", -1, name)
end)

Framework.RegisterServerCallback("rob_fleeca:getBanks", function(source, cb)
    cb(Config['rob_fleeca'].Banks, Doors)
end)

Framework.RegisterServerCallback("rob_fleeca:checkSecond", function(source, cb)
    local xPlayer = Framework.GetPlayerFromId(source)
    local item = xPlayer['inventory'].getInventoryItem("cardsecurefleeca").count

    if item >= 1 then
        xPlayer['inventory'].removeInventoryItem("cardsecurefleeca", 1)
        cb(true)
    else
        cb(false)
    end
end)