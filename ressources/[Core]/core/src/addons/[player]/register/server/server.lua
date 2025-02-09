
local registrationCount = {}

RegisterNetEvent("core:registerSpawn")
AddEventHandler("core:registerSpawn", function()
    local _source = source
    local xPlayer = Framework.GetPlayerFromId(_source)
    local coords = GetEntityCoords(GetPlayerPed(_source))
    local startZone = vector3(-413.2, 1168.3, 325.9)

    if not xPlayer then return end

    if not registrationCount[xPlayer.identifier] then
        registrationCount[xPlayer.identifier] = 0
    end

    if registrationCount[xPlayer.identifier] < 2 then
        if #(coords - startZone) < 10.0 then
            registrationCount[xPlayer.identifier] = registrationCount[xPlayer.identifier] + 1
            TriggerClientEvent("core:openMenuRegister", _source)
        else
            xPlayer.showNotification("~r~Vous devez être dans la zone de spawn pour vous enregistrer !")
        end
    else
        xPlayer.showNotification("~r~Vous avez atteint la limite d'enregistrement !")
    end
end)