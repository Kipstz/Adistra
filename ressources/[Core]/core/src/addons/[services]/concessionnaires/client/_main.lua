Concess = {}

CreateThread(function()
    for k,v in pairs(Config['concess'].localisations) do
        BlipManager:addBlip('concess_'..k, v.pos, v.sprite, v.color, v.label, 0.7, true)
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                Concess:OpenMenu(v.type)
            end}
        })
    end
end)