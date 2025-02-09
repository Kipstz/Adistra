
ClotheShop = {}

CreateThread(function()
    for k,v in pairs(Config['shop_clothe'].localisations) do
        BlipManager:addBlip('clothe_'..k, v.pos, 73, 47, "Magasin de Vêtements", 0.7, true)
        ZoneManager:createZoneWithMarker(v.pos, 10, 1.5, {
            onPress = {control = 38, action = function(zone)
                ClotheShop:OpenMenu(k)
            end}
        })
    end
end)

ClotheShop.myOutfits = {}

RegisterNetEvent('shop_clothe:updateOutfits')
AddEventHandler('shop_clothe:updateOutfits', function(outfits)
    ClotheShop.myOutfits = outfits
end)