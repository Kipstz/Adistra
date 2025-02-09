
AccessoriesShop = {}

CreateThread(function()
    for k,v in pairs(Config['shop_accessories'].localisations) do
        BlipManager:addBlip('acc_'..k, v.pos, 362, 1, "Magasin d'Accessoires", 0.7, true)
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                AccessoriesShop:OpenMenu(k)
            end}
        })
    end
end)

AccessoriesShop.myAccessories = {}

RegisterNetEvent('shop_accessories:updateAccessories')
AddEventHandler('shop_accessories:updateAccessories', function(accessories)
    AccessoriesShop.myAccessories = accessories
end)