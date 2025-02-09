
SautsParachutes = {}

CreateThread(function()
    for k,v in pairs(Config['sautsparachutes'].localisations) do
        BlipManager:addBlip('sp_'..k, v.pos, 94, 57, "Activités | Sauts en Parachutes", 0.6, true)
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                SautsParachutes:OpenMenu()
            end}
        })
    end
end)
