
Assurances = {}

CreateThread(function()
    for k,v in pairs(Config['assurances'].localisations) do
        BlipManager:addBlip('assurance_'..k, v.pos, 280, 3, "Assurance (Fourrières)", 0.7, true)
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                Assurances:OpenMenu(v.type, v.spawn)
            end}
        })
    end
end)
