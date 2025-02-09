
Armurerie = {}

CreateThread(function()
    for k,v in pairs(Config['shop_armurerie'].localisations) do
        BlipManager:addBlip('armurerie_'..k, v.pos, 110, 1, "Armurerie", 0.7, true)
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                Armurerie:OpenMenu(k)
            end}
        })
    end
end)