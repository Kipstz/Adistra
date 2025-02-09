
Cayo_Locations = {}

CreateThread(function()
    for k,v in pairs(Config['cayo_loc'].localisations) do
        BlipManager:addBlip('loccayo_'..k, v.pos, 473, 1, "Locations", 0.7, true)
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                Cayo_Locations:OpenMenu(v.categories)
            end}
        })
    end

    for k,v in pairs(Config['cayo_loc'].deleters.pos) do
        ZoneManager:createZoneWithoutMarker(v, 10, 10, {
            onPress = {control = 38, action = function(zone)
                Config['cayo_loc'].deleters.action()
            end}
        })
    end
end)