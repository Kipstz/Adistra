
Cayo_VDA = {}

CreateThread(function()
    for k,v in pairs(Config['cayo_vda'].localisations) do
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                if Cayo_VDA:isJob() then
                    Cayo_VDA:OpenMenu(Config['cayo_vda'].list)
                end
            end}
        })
    end
end)

