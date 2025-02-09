AdminMenu = {}

RegisterKeyMapping('adminmenu', "(staff) Ouvrir le Menu Staff", 'keyboard', 'F10')

RegisterCommand("adminmenu", function()
    local myId = GetPlayerServerId(PlayerId())

    if Framework ~= nil and GetEntityHealth(PlayerPedId()) > 0 then
        if AdminMenu.isStaff(myId) and Framework.PlayerData.group ~= 'user' then
            AdminMenu.OpenAdminMenu()
        end
    end
end)

RegisterKeyMapping('noclip', "(staff) Activer/Désactiver le NoClip", 'keyboard', 'F9')

RegisterCommand("noclip", function()
    local myId = GetPlayerServerId(PlayerId())

    if Framework ~= nil and GetEntityHealth(PlayerPedId()) > 0 then
        if AdminMenu.isStaff(myId) and Framework.PlayerData.group ~= 'user' then
            AdminMenu.NoClip()
        end
    end
end)

RegisterKeyMapping('freecam', "(staff) Activer/Désactiver la freecam", 'keyboard', 'F7')
RegisterCommand("freecam", function()
    local myId = GetPlayerServerId(PlayerId())
    
    if Framework ~= nil and GetEntityHealth(PlayerPedId()) > 0 then
        if AdminMenu.isStaff(myId) and Framework.PlayerData.group ~= 'user' then
            AdminMenu.freecam()
        end
    end
end)

AdminMenu.players = {}
AdminMenu.connecteds, AdminMenu.staff = 0,0

RegisterNetEvent("admin_menu:updatePlayers")
AddEventHandler("admin_menu:updatePlayers", function(table)
    AdminMenu.players = table
    
    local count, sCount = 0, 0

    for src, player in pairs(table) do
        count = count + 1
        
        if AdminMenu.isStaff(src) then
            sCount = sCount + 1
        end
    end

    AdminMenu.connecteds, AdminMenu.staff = count,sCount
end)

RegisterNetEvent('admin_menu:fixVehicle')
AddEventHandler('admin_menu:fixVehicle', function()
    local plyPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(plyPed)

    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true)
end)