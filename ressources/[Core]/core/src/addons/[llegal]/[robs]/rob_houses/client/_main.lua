
RobHouses = {}

RobHouses.inRobbing = false;
RobHouses.zoneLootId = nil;

CreateThread(function()
    -- OUTSIDE + BLIP --
    for k,v in pairs(Config['rob_houses'].localisations) do
        BlipManager:addBlip('robhouse_'..k, v.pos, 500, 6, "Cambriolages", 0.3, true)
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                if not RobHouses.inRobbing then
                    RobHouses:start(k, v)
                else
                    Framework.ShowNotification("~r~Vous êtes déjà entrain de cambrioler cette maison !~s~")
                end
            end}
        })
    end
end)

RegisterNetEvent('rob_houses:notify')
AddEventHandler('rob_houses:notify', function(robId, robber)
    while Framework.PlayerData.jobs == nil do Wait(100) end
    if Framework.PlayerData.jobs['job'].name == Config['rob_houses'].localisations[robId].job then
        local mugshot, mugshotStr = Framework.Game.GetPedMugshot(GetPlayerPed(GetPlayerFromServerId(robber)))
        Framework.ShowAdvancedNotification("Citoyen", "Cambriolage en Cours", "Nous avons envoyé une photo du voleur prise par la caméra CCTV!", mugshotStr, 4)
        UnregisterPedheadshot(mugshot)
        while true do
            local name = GetCurrentResourceName() .. math.random(999)
            AddTextEntry(name, "~INPUT_CONTEXT~ Définir un point de cheminement vers le magasin \n~INPUT_FRONTEND_RRIGHT~ Fermer cette case")
            DisplayHelpTextThisFrame(name, false)
            if IsControlPressed(0, 38) then
                SetNewWaypoint(Config['rob_houses'].localisations[robId].pos)
                return
            elseif IsControlPressed(0, 194) then return end
            Wait(1)
        end
    end
end)