
RegisterNetEvent('shop_barber:pay')
AddEventHandler('shop_barber:pay', function()
    local xPlayer = Framework.GetPlayerFromId(source)

    if xPlayer['accounts'].getMoney() >= 100 then
        xPlayer['accounts'].removeMoney(100)
    else
        xPlayer.triggerEvent('skinchanger:reloadSkinPlayer')
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
    end
end)