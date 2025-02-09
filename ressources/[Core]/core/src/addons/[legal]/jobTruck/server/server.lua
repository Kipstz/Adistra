local activeMissions = {} 

RegisterNetEvent("core:jobTruck:startMissionServer")
AddEventHandler("core:jobTruck:startMissionServer", function()
    local _source = source
    local xPlayer = Framework.GetPlayerFromId(_source)

    if not xPlayer then return end


    local playerCoords = GetEntityCoords(GetPlayerPed(_source))
    local distance = #(playerCoords - Config['jobTruck'].PositionPNJ)
    if distance > 45.0 then
        return print("ID: ".._source.." | Tentative de triche détectée (distance trop élevée)")
    end


    activeMissions[xPlayer.identifier] = true
end)

RegisterNetEvent("core:jobTruck:stopMission")
AddEventHandler("core:jobTruck:stopMission", function()
    local _source = source
    local xPlayer = Framework.GetPlayerFromId(_source)

    if not xPlayer then return end

    if not activeMissions[xPlayer.identifier] then
        return DropPlayer(_source, "GG BG fallait te cover (by kabyleeee le plus beau de la terre)")
    end

    activeMissions[xPlayer.identifier] = false

end)

RegisterNetEvent("core:jobTruck:finishMission")
AddEventHandler("core:jobTruck:finishMission", function(imGayDataFDP, price)
    local _source = source
    local xPlayer = Framework.GetPlayerFromId(_source)

    if not xPlayer then return end

    if not imGayDataFDP then 
        print("ID: ".._source.." | Tentative de triche détectée (imGayDataFDP)")
        return DropPlayer(_source, "GG BG fallait te cover (by kabyleeee le plus beau de la terre)")
    end

    if not activeMissions[xPlayer.identifier] then
        print("ID: ".._source.." | Tentative de triche détectée (activeMissions)")
        return DropPlayer(_source, "GG BG fallait te cover (by kabyleeee le plus beau de la terre)")
    end

    if price > 90000 then
        print("ID: ".._source.." | Tentative de triche détectée (price)")
        return DropPlayer(_source, "GG BG fallait te cover (by kabyleeee le plus beau de la terre)")
    end


    xPlayer['accounts'].addAccountMoney('bank', price)
    xPlayer.showNotification("Vous avez reçu votre salaire pour avoir livré la marchandise : ~g~"..price.."$")

    activeMissions[xPlayer.identifier] = false

end)