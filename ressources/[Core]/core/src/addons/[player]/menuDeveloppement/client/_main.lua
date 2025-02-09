MenuDev = {}

RegisterCommand("devmenu", function()
    local myId = GetPlayerServerId(PlayerId())

    if Framework ~= nil and GetEntityHealth(PlayerPedId()) > 0 then
        if MenuDev:isWlAccess(myId) then
            MenuDev.OpenDevMenu()
        else
            print("[DEVMENU] No access")
        end
    end
end)