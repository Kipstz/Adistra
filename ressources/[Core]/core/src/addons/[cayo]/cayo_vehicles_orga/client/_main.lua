
Cayo_Vehicles_Orga = {}

CreateThread(function()
    for k,v in pairs(Config['cayo_vehicles_orga'].localisation)  do
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                if Cayo_Vehicles_Orga:isJob() then
                    Cayo_Vehicles_Orga:OpenMenu(v.categories)
                else
                    Framework.ShowNotification("~r~Vous ne pouvez pas accéder au garage.~s~")
                end
            end}
        })
    end

    for k,v in pairs(Config['cayo_vehicles_orga'].localisations)  do
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                if Cayo_Vehicles_Orga:isJob() then
                    Cayo_Vehicles_Orga:OpenMenu(v.categories)
                else
                    Framework.ShowNotification("~r~Vous ne pouvez pas accéder au garage.~s~")
                end
            end}
        })
    end

    for k,v in pairs(Config['cayo_vehicles_orga'].deleters.pos) do
        ZoneManager:createZoneWithoutMarker(v, 10, 10, {
            onPress = {control = 38, action = function(zone)
                Config['cayo_vehicles_orga'].deleters.action()
            end}
        })
    end
end)