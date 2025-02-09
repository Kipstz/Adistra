
Banques = {}

CreateThread(function()
    for k,v in pairs(Config['banques'].localisations) do
        BlipManager:addBlip('bank_'..k, v.pos, 500, 43, "Banque", 0.7, true)
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                Banques:OpenMenu()
            end}
        })
    end
end)