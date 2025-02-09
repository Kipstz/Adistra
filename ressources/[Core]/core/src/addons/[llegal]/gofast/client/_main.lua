
GoFast = {}

GoFast.inGoFast = false;
GoFast.canDoGoFast = true;

CreateThread(function()
    EntityManager:createPed(Config['gofast'].base.pedModel, Config['gofast'].base.pos, Config['gofast'].base.pedHeading)
    ZoneManager:createZoneWithMarker(Config['gofast'].base.pos, 10, 1.5, {
        onPress = {control = 38, action = function(zone)
            if GoFast.canDoGoFast then
                GoFast:OpenMainMenu()
            else
                Framework.ShowNotification("~r~Vous devez patienter avant de pouvoir refaire un GoFast !~s~")
            end
        end}
    })
end)

RegisterNetEvent("gofast:alert")
AddEventHandler("gofast:alert", function(job)
    if Framework.PlayerData.jobs['job'].name == job then
        Framework.ShowNotification("~r~GOFAST EN COURS PARTANT DE ROCKFORD HILLS~s~")
    end
end)