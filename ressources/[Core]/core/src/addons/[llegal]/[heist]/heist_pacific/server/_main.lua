PacificHeist = {}

Framework.RegisterServerCallback("heist_pacific:GetData", function(source, cb)
    cb(Config['heist_pacific'].info)
end)

Framework.RegisterServerCallback("heist_pacific:GetDoors", function(source, cb)
    cb(Config['heist_pacific'].PoliceDoors)
end)

Framework.RegisterServerCallback("heist_pacific:startevent", function(source, cb, method)
    local xPlayers = Framework.GetPlayers()
    local cops = Service:GetInServiceCount('police')
    local cops2 = Service:GetInServiceCount('sheriff')
    if cops ~= nil and cops2 ~= nil then copcount = tonumber(cops+cops2)
    elseif cops ~= nil then copcount = tonumber(cops)
    elseif cops2 ~= nil then copcount = tonumber(cops2)
    elseif cops == nil and cops2 == nil then copcount = 0
    end
    local xPlayer = Framework.GetPlayerFromId(source)

    if not Config['heist_pacific'].info.locked then
        if (os.time() - Config['heist_pacific'].cooldown) > Config['heist_pacific'].lastrobbed then
            if copcount >= Config['heist_pacific'].mincops then
                if method == 1 then
                    local item = xPlayer['inventory'].getInventoryItem("thermal_charge")["count"]

                    if item >= 1 then
                        xPlayer['inventory'].removeInventoryItem("thermal_charge", 1)
                        cb(true)
                        Config['heist_pacific'].info.stage = 1
                        Config['heist_pacific'].info.style = 1
                        Config['heist_pacific'].info.locked = true
                    else
                        cb("Vous n'avez aucune charge thermique.")
                    end
                elseif method == 2 then
                    local item = xPlayer['inventory'].getInventoryItem("lockpick")["count"]

                    if item >= 1 then
                        xPlayer['inventory'].removeInventoryItem("lockpick", 1)
                        Config['heist_pacific'].info.stage = 1
                        Config['heist_pacific'].info.style = 2
                        Config['heist_pacific'].info.locked = true
                        cb(true)
                    else
                        cb("Vous n'avez pas de lockpick.")
                    end
                end
            else
                cb("Il faut minimum "..Config['heist_pacific'].mincops.." policiers en ville.")
            end
        else
            cb(math.floor((Config['heist_pacific'].cooldown - (os.time() - Config['heist_pacific'].lastrobbed)) / 60)..":"..math.fmod((Config['heist_pacific'].cooldown - (os.time() - Config['heist_pacific'].lastrobbed)), 60).." avant de faire un nouveau braquage.")
        end
    else
        cb("La banque vien d'être braquée.")
    end
end)

Framework.RegisterServerCallback("heist_pacific:checkItem", function(source, cb, itemname)
    local xPlayer = Framework.GetPlayerFromId(source)
    local item = xPlayer['inventory'].getInventoryItem(itemname)["count"]

    if item >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

Framework.RegisterServerCallback("heist_pacific:gettotalcash", function(source, cb)
    cb(Config['heist_pacific'].totalcash)
end)

RegisterServerEvent("heist_pacific:removeitem")
AddEventHandler("heist_pacific:removeitem", function(itemname)
    local xPlayer = Framework.GetPlayerFromId(source)

    xPlayer['inventory'].removeInventoryItem(itemname, 1)
end)

RegisterServerEvent("heist_pacific:updatecheck")
AddEventHandler("heist_pacific:updatecheck", function(var, status)
    TriggerClientEvent("heist_pacific:updatecheck_c", -1, var, status)
end)

--[[RegisterServerEvent("heist_pacific:toggleDoor")
AddEventHandler("heist_pacific:toggleDoor", function(door, coords, status)
    TriggerClientEvent("heist_pacific:toggleDoor_c", -1, door, coords, status)
end)]]

RegisterServerEvent("heist_pacific:policeDoor")
AddEventHandler("heist_pacific:policeDoor", function(doornum, status)
    Config['heist_pacific'].PoliceDoors[doornum].locked = status
    TriggerClientEvent("heist_pacific:policeDoor_c", -1, doornum, status)
end)

RegisterServerEvent("heist_pacific:moltgate")
AddEventHandler("heist_pacific:moltgate", function(x, y, z, oldmodel, newmodel, method)
    TriggerClientEvent("heist_pacific:moltgate_c", -1, x, y, z, oldmodel, newmodel, method)
end)

RegisterServerEvent("heist_pacific:fixdoor")
AddEventHandler("heist_pacific:fixdoor", function(hash, coords, heading)
    TriggerClientEvent("heist_pacific:fixdoor_c", -1, hash, coords, heading)
end)

RegisterServerEvent("heist_pacific:openvault")
AddEventHandler("heist_pacific:openvault", function(method)
    TriggerClientEvent("heist_pacific:openvault_c", -1, method)
end)

RegisterServerEvent("heist_pacific:startloot")
AddEventHandler("heist_pacific:startloot", function()
    TriggerClientEvent("heist_pacific:startloot_c", -1)
end)

RegisterServerEvent("heist_pacific:rewardCash")
AddEventHandler("heist_pacific:rewardCash", function()
    local xPlayer = Framework.GetPlayerFromId(source)
    local reward = math.random(Config['heist_pacific'].mincash, Config['heist_pacific'].maxcash)

    if Config['heist_pacific'].black then
        xPlayer['accounts'].addAccountMoney("black_money", reward)
        Config['heist_pacific'].totalcash = Config['heist_pacific'].totalcash + reward
    else
        xPlayer['accounts'].addMoney(reward)
        Config['heist_pacific'].totalcash = Config['heist_pacific'].totalcash + reward
    end
end)

RegisterServerEvent("heist_pacific:rewardGold")
AddEventHandler("heist_pacific:rewardGold", function()
    local xPlayer = Framework.GetPlayerFromId(source)

    xPlayer.addInventoryItem("gold_bar", 1)
end)

RegisterServerEvent("heist_pacific:rewardDia")
AddEventHandler("heist_pacific:rewardDia", function()
    local xPlayer = Framework.GetPlayerFromId(source)

    xPlayer['inventory'].addInventoryItem("dia_box", 1)
end)

RegisterServerEvent("heist_pacific:giveidcard")
AddEventHandler("heist_pacific:giveidcard", function()
    local _source = source
    local xPlayer = Framework.GetPlayerFromId(_source)

    xPlayer['inventory'].addInventoryItem("id_card", 1)
end)

RegisterServerEvent("heist_pacific:ostimer")
AddEventHandler("heist_pacific:ostimer", function()
    Config['heist_pacific'].lastrobbed = os.time()
    Config['heist_pacific'].info.stage, Config['heist_pacific'].info.style, Config['heist_pacific'].info.locked = 0, nil, false
    Citizen.Wait(300000)
    for i = 1, #Config['heist_pacific'].PoliceDoors, 1 do
        Config['heist_pacific'].PoliceDoors[i].locked = true
        TriggerClientEvent("heist_pacific:policeDoor_c", -1, i, true)
    end
    Config['heist_pacific'].totalcash = 0;
    TriggerClientEvent("heist_pacific:reset", -1)
end)

RegisterServerEvent("heist_pacific:gas")
AddEventHandler("heist_pacific:gas", function()
    TriggerClientEvent("heist_pacific:gas_c", -1)
end)

RegisterServerEvent("heist_pacific:ptfx")
AddEventHandler("heist_pacific:ptfx", function(method)
    TriggerClientEvent("heist_pacific:ptfx_c", -1, method)
end)

RegisterServerEvent("heist_pacific:alarm_s")
AddEventHandler("heist_pacific:alarm_s", function(toggle)
    if Config['heist_pacific'].enablesound then
        TriggerClientEvent("heist_pacific:alarm", -1, toggle)
    end
    TriggerClientEvent("heist_pacific:policenotify", -1, toggle)
end)
