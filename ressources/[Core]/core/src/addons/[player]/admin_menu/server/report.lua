AdminMenu.reportsTable = {}
AdminMenu.reportsCount = 0

RegisterNetEvent('admin_menu:takeReport')
AddEventHandler('admin_menu:takeReport', function(reportId)
    local src = source
    local reportId = reportId
    local xPlayer = Framework.GetPlayerFromId(src)

    if not AdminMenu.isStaff(src) then
        DropPlayer(src, "Vous n'avez pas la permission de faire cela")
        return
    end

    if not AdminMenu.reportsTable[reportId] then
        TriggerClientEvent("framework:showNotification", src, "~r~[Report] \n\n~s~Ce report n'est plus en attente de prise en charge")
        
        return
    end

    AdminMenu.reportsTable[reportId].takenBy = GetPlayerName(src)
    AdminMenu.reportsTable[reportId].taken = true

    if AdminMenu.players[reportId] ~= nil then
        TriggerClientEvent("framework:showNotification", reportId, "~r~[Report] \n\n~s~Votre report a été pris en charge.")
    end

    AdminMenu.notifyStaffs("~r~[Report] \n\n~s~Le staff ~r~"..GetPlayerName(src).."~s~ a pris en charge le report ~y~n°"..AdminMenu.reportsTable[reportId].uniqueId)
    
    local coords = GetEntityCoords(GetPlayerPed(reportId))
    SetEntityCoords(GetPlayerPed(src), coords)

    AdminMenu.updateReports()
end)

RegisterNetEvent('admin_menu:closeReport')
AddEventHandler('admin_menu:closeReport', function(reportId)
    local src = source
    local reportId = reportId
    local xPlayer = Framework.GetPlayerFromId(src)

    if not AdminMenu.isStaff(src) then
        DropPlayer(src, "Vous n'avez pas la permission de faire cela")
        return
    end

    if not AdminMenu.reportsTable[reportId] then
        TriggerClientEvent("framework:showNotification", src, "~r~[Report] \n\n~s~Ce report n'est plus valide")
        return
    end

    if AdminMenu.players[reportId] ~= nil then
        TriggerClientEvent("framework:showNotification", reportId, "~r~[Report] \n\n~s~Votre report a été cloturé. N'hésitez pas à nous recontacter en cas de besoin.")
    end

    AdminMenu.notifyStaffs("~r~[Report] \n\n~s~Le staff ~r~"..GetPlayerName(src).."~s~ a ~g~cloturé ~s~le report ~y~n°"..AdminMenu.reportsTable[reportId].uniqueId)
    AdminMenu.reportsTable[reportId] = nil

    AdminMenu.updateReports()
end)

AdminMenu.updateReports = function()
    for src, player in pairs(AdminMenu.players) do
        if AdminMenu.isStaff(src) then
            TriggerClientEvent("admin_menu:updateReports", src, AdminMenu.reportsTable)
        end
    end
end

AdminMenu.notifyStaffs = function(message)
    for src, player in pairs(AdminMenu.players) do
        if AdminMenu.isStaff(src) then
            if AdminMenu.inService[src] ~= nil then
                TriggerClientEvent("framework:showNotification", src, message)
            end
        end
    end
end

RegisterCommand("report", function(source, args)
    if source == 0 then
        return
    end

    if AdminMenu.reportsTable[source] ~= nil then
        TriggerClientEvent("framework:showNotification", source, "~r~[Report] \n\n~s~Vous avez déjà un report actif.")

        return
    end

    local currentTime = os.time()
    if AdminMenu.lastReportTime == nil then
        AdminMenu.lastReportTime = {}
    end

    if AdminMenu.lastReportTime[source] and (currentTime - AdminMenu.lastReportTime[source]) < 600 then
        local remainingTime = 600 - (currentTime - AdminMenu.lastReportTime[source])
        TriggerClientEvent("framework:showNotification", source, string.format("~r~[Report] \n\n~s~Vous devez attendre encore %d secondes avant de pouvoir envoyer un nouveau report.", remainingTime))
        return
    end

    AdminMenu.reportsCount = AdminMenu.reportsCount + 1
    AdminMenu.reportsTable[source] = { timeElapsed = {0,0}, uniqueId = AdminMenu.reportsCount, id = source, name = GetPlayerName(source), reason = table.concat(args, " "), taken = false, createdAt = os.date('%c'), takenBy = nil }
    
    AdminMenu.lastReportTime[source] = currentTime
    
    AdminMenu.notifyStaffs("~r~[Report] \n\n~s~Un nouveau report a été reçu. ID Unique: ~y~" .. AdminMenu.reportsCount)
    TriggerClientEvent("framework:showNotification", source, "~r~[Report] \n\n~s~Votre report a été envoyé ! \nVous serez informé quand \nil sera pris en charge et / ou cloturé.")
    
    AdminMenu.updateReports()
end, false)

CreateThread(function()
    while true do
        Wait(1000 * 60)

        for k, v in pairs(AdminMenu.reportsTable) do
            AdminMenu.reportsTable[k].timeElapsed[1] = AdminMenu.reportsTable[k].timeElapsed[1] + 1

            if AdminMenu.reportsTable[k].timeElapsed[1] > 60 then
                AdminMenu.reportsTable[k].timeElapsed[1] = 0
                AdminMenu.reportsTable[k].timeElapsed[2] = AdminMenu.reportsTable[k].timeElapsed[2] + 1
            end
        end
    end
end)