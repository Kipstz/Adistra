
BarberShop = {}

CreateThread(function()
    for k,v in pairs(Config['shop_barber'].localisations) do
        BlipManager:addBlip('barber_'..k, v.pos, 71, 47, "Coiffeur/Barber", 0.7, true)
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                BarberShop:OpenMenu(k)
            end}
        })
    end
end)