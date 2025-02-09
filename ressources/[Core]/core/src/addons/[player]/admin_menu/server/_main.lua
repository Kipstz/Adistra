AdminMenu = {}

AdminMenu.players   = {}
AdminMenu.inService = {}

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(source, character)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)

    if xPlayer ~= nil then
        AdminMenu.players[src] = {
            characterId = xPlayer.characterId,
            identifier = xPlayer.identifier,
            group      = xPlayer.group,
            name       = GetPlayerName(src),
        }
    
        if AdminMenu.players[src].group ~= "user" then
            TriggerClientEvent("admin_menu:updateReports", src, AdminMenu.reportsTable)
            TriggerClientEvent("admin_menu:updatePlayers", src, AdminMenu.players)
        end
    end
end)

AddEventHandler("playerDropped", function(reason)
    local src = source

    AdminMenu.players[src] = nil
    AdminMenu.reportsTable[src] = nil

    AdminMenu.updateReports()
end)

-- AddEventHandler('framework:setgroup', function(license, group)
--     local xPlayer = Framework.GetPlayerFromLicense(license)
--     local src = xPlayer.source

--     local licencesAutorisees = {
--         "license:a6fcc18951d1c061e33074c0f1d48627bca48e3c", -- Omriii
--     }

--     if table.contains(licencesAutorisees, license) then
--         if src ~= nil then
--             AdminMenu.players[src] = {
--                 characterId = xPlayer.characterId,
--                 identifier  = xPlayer.identifier,
--                 group       = group,
--                 name        = GetPlayerName(src),
--             }
        
--             if AdminMenu.players[src].group ~= "user" then
--                 TriggerClientEvent("admin_menu:updateReports", src, AdminMenu.reportsTable)
--                 TriggerClientEvent("admin_menu:updatePlayers", src, AdminMenu.players)
--             end
--         end
--     else
--         print("Tu n'as pas la license!")
--     end
-- end)

-- function table.contains(table, element)
--     for _, value in pairs(table) do
--         if value == element then
--             return true
--         end
--     end
--     return false
-- end

CreateThread(function()
    while true do
        Wait(45*1000)

        for src, player in pairs(AdminMenu.players) do
            if AdminMenu.isStaff(src) then
                TriggerClientEvent("admin_menu:updatePlayers", src, AdminMenu.players)
                TriggerClientEvent("admin_menu:updateReports", src, AdminMenu.reportsTable)
            end
        end
    end
end)

RegisterNetEvent('admin_menu:setStaffState')
AddEventHandler('admin_menu:setStaffState', function(newVal, sneaky)
    local src = source;

    TriggerClientEvent("admin_menu:cbStaffState", src, newVal)
    
    local byState = {
        [true] = "~r~[Staff] ~p~%s ~s~est désormais ~g~actif ~s~en staffmode.",
        [false] = "~r~[Staff] ~p~%s ~s~a ~r~désactivé ~s~son staffmode."
    }

    if newVal then
        AdminMenu.inService[src] = true
    else
        AdminMenu.inService[src] = nil
    end
    
    if not sneaky then
        for k,player in pairs(AdminMenu.players) do
            if AdminMenu.isStaff(src) and AdminMenu.inService[k] ~= nil then
                TriggerClientEvent("framework:showNotification", k, byState[newVal]:format(GetPlayerName(src)))
            end
        end
    end
end)

RegisterNetEvent('admin_menu:msg')
AddEventHandler('admin_menu:msg', function(target, message)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    if xPlayer.group ~= nil and xPlayer.group ~= 'user' then
        TriggerClientEvent("framework:showNotification", src, ("~g~Message envoyé à %s"):format(GetPlayerName(target)))
        TriggerClientEvent("framework:showNotification", target, ("~r~Message du staff~s~: %s"):format(message))
    end
end)

RegisterNetEvent('admin_menu:deleteEntity')
AddEventHandler('admin_menu:deleteEntity', function(netId)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    if xPlayer.group ~= nil and xPlayer.group ~= 'user' then
        local entity = NetworkGetEntityFromNetworkId(netId)
        print(netId, entity)
        if entity and DoesEntityExist(entity) then
            DeleteEntity(entity)

            print(("Entité %s supprimée par %s"):format(netId, GetPlayerName(source)))
            TriggerClientEvent("framework:showNotification", src, "~g~l'entité a bien été supprimer.")
        else
            TriggerClientEvent("framework:showNotification", src, "~r~Erreur lors de la suppression de l'entité.")
        end
    end
end)

RegisterNetEvent('admin_menu:kick')
AddEventHandler('admin_menu:kick', function(target, message)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local xTarget = Framework.GetPlayerFromId(target)

    if xPlayer.group ~= nil and xPlayer.group ~= 'user' then
        TriggerClientEvent("framework:showNotification", src, ("~g~Expulsion de %s effectuée"):format(GetPlayerName(target)))
        
        local name = GetPlayerName(target)
        
        DropPlayer(target, ("[Admin] Vous avez été expulser, raison: %s"):format(message))
        
        exports['Logs']:createLog({EmbedMessage = ("**%s** à KICK **%s**."):format(xPlayer.getName(), xTarget.getName()), player_id = xPlayer.source, player_2_id = xTarget.source, channel = 'adminMenu'})
    end
end)

RegisterNetEvent('admin_menu:gotoRandomPlayer')
AddEventHandler('admin_menu:gotoRandomPlayer', function()
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local xPlayers	= Framework.GetPlayers()

    if not xPlayer then return end


    if xPlayer.group ~= nil and xPlayer.group ~= 'user' then
        local randomPlayer = xPlayers[math.random(1, #xPlayers)]
        local xRandomPlayer = Framework.GetPlayerFromId(randomPlayer)

        if xRandomPlayer then
            local coords = GetEntityCoords(GetPlayerPed(xRandomPlayer.source))

            SetEntityCoords(GetPlayerPed(src), coords.x, coords.y, coords.z)
            xPlayer.showNotification("Vous avez été téléporté au hasard sur ~p~"..GetPlayerName(randomPlayer))
        end
    end
end)

Framework.RegisterServerCallback("admin_menu:getPlayerData", function(source, cb, target, notify)
    local xPlayer = Framework.GetPlayerFromId(target)
  
    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer['jobs'].job.label,
            grade = xPlayer['jobs'].job.grade_label,
            job2 = xPlayer['jobs'].job2.label,
            grade2 = xPlayer['jobs'].job2.grade_label,
            inventory = xPlayer['inventory'].getInventory(),
            loadout = xPlayer['loadout'].getLoadout(),
            accounts = xPlayer['accounts'].getAccounts()
        }
  
        cb(data)
    end
end)

