
VDA = {}

CreateThread(function()
    for k,v in pairs(Config['vda'].localisations) do
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                VDA:OpenMenu(Config['vda'].list)
            end}
        })
    end
end)