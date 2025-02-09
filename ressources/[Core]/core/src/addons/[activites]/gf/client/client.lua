CreateThread(function()
    local coords = vector3(237.51565551758,-881.83441162109,30.492111206055)
    
    BlipManager:addBlip('gotogfzone', coords, 150, 1, "~r~Zone GunFight", 0.7, true)
    ZoneManager:createZoneWithMarker(coords, 10, 10.5, {
        onPress = {control = 38, action = function(zone)
            SetEntityCoords(PlayerPedId(), vector3(1471.7595214844,6343.3979492188,22.37380027771))
        end}
    })
end)