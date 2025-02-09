Ascenseurs = {}

CreateThread(function()
    for k,v in pairs(Config['ascenseurs']) do
        for k2,v2 in pairs(v.canTakesPos) do
            ZoneManager:createZoneWithMarker(v2, 4, 1.5, {
                onPress = {control = 38, action = function(zone)
                    Ascenseurs:OpenMenu(v.etages)
                end}
            })
        end
    end
end)
