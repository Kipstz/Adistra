
Keys = {}
Serrurier = {}

CreateThread(function()
    for k,v in pairs(Config['keys'].localisations) do
        -- BlipManager:addBlip('serrurier_'..k, v.pos, 811, 3, "Serrurier", 0.7, true)
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                Serrurier:OpenMenu()
            end}
        })
    end
end)
