CreateThread(function()
    for k,v in pairs(Config['karting'].positions) do 
        local blip = AddBlipForCoord(v)
        SetBlipSprite(blip, 315)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 5)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Karting")
        EndTextCommandSetBlipName(blip)

        ZoneManager:createZoneWithMarker(v, 10, 10.5, {
            onPress = {control = 38, action = function(zone)
                OpenMainMenuKarting()
            end}
        })
    end
end)