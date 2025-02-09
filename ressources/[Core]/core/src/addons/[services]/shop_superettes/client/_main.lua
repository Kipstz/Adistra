
Superettes = {}

CreateThread(function()
    for k,v in pairs(Config['shop_superettes'].localisations) do
        BlipManager:addBlip('shop_'..k, v.pos, 52, 2, "Superettes", 0.7, true)
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                Superettes:OpenMenu(k)
            end}
        })
    end
end)