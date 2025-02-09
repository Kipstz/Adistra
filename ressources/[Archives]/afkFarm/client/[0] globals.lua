Framework = nil
TriggerEvent('framework:init', function(obj) Framework = obj end)
Framework.PlayerData = Framework.GetPlayerData()

vg_AFKFarm = {
    ped = nil,
    isInAFKMode = false,
    coords = vector3(-781.34912109375, 336.51940917969, 207.62086486816),
    returnCoords = nil,
    lastCheckinTime = 0,
    securityToken = nil
}

local function RequestSecurityToken()
    TriggerServerEvent("afkFarm:RequestToken")
end

RegisterNetEvent("afkFarm:ReceiveToken")
AddEventHandler("afkFarm:ReceiveToken", function(token)
    vg_AFKFarm.securityToken = token
    print("Received security token: " .. token)
end)

function AFKMode(mode)
    if mode == "enter" and not vg_AFKFarm.isInAFKMode then
        vg_AFKFarm.returnCoords = GetEntityCoords(PlayerPedId())
        RequestSecurityToken()
        Wait(100)
        if vg_AFKFarm.securityToken then
            vg_AFKFarm.isInAFKMode = true
            SetEntityCoords(PlayerPedId(), vg_AFKFarm.coords)
            TriggerServerEvent("afkFarm:AFKMode", "enter", vg_AFKFarm.securityToken, vg_AFKFarm.returnCoords)
        else
            print("Failed to enter AFK mode: Security token not received")
        end
    elseif mode == "exit" and vg_AFKFarm.isInAFKMode then
        vg_AFKFarm.isInAFKMode = false
        TriggerServerEvent("afkFarm:AFKMode", "exit", vg_AFKFarm.securityToken)
        Wait(100)
        if vg_AFKFarm.returnCoords then
            SetEntityCoords(PlayerPedId(), vg_AFKFarm.returnCoords)
        end
        vg_AFKFarm.securityToken = nil
        vg_AFKFarm.returnCoords = nil
    end
end

CreateThread(function()
    while true do
        Wait(5000)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - vg_AFKFarm.coords)
        if vg_AFKFarm.isInAFKMode then
            if distance > 5.0 then
                print("Détecté hors de la zone AFK, sortie du mode AFK")
                AFKMode("exit")
            else
                TriggerServerEvent("afkFarm:Checkin", vg_AFKFarm.securityToken)
            end
        else
            if distance < 5.0 then
                SetEntityCoords(PlayerPedId(), vector3(237.11508178711,-761.58013916016,30.846464157104))
            end
        end
    end
end)

RegisterNetEvent("afkFarm:ForceEndAFK")
AddEventHandler("afkFarm:ForceEndAFK", function()
    vg_AFKFarm.isInAFKMode = false
    if vg_AFKFarm.returnCoords then
        SetEntityCoords(PlayerPedId(), vg_AFKFarm.returnCoords)
    end
    vg_AFKFarm.securityToken = nil
    vg_AFKFarm.returnCoords = nil
end)