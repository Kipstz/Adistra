
Madrazo_VDA = {}

CreateThread(function()
    for k,v in pairs(Config['madrazo_vda'].localisations) do
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                if Madrazo_VDA:isJob() then
                    Madrazo_VDA:OpenMenu(Config['madrazo_vda'].list)
                end
            end}
        })
    end
end)