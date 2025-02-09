
CartelCayo_VDA = {}

CreateThread(function()
    for k,v in pairs(Config['cartelcayo_vda'].localisations) do
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                print("enculer vaaaa")
                if CartelCayo_VDA:isJob() then
                    CartelCayo_VDA:OpenMenu(Config['cartelcayo_vda'].list)
                end
            end}
        })
    end
end)

