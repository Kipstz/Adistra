
Framework.RegisterServerCallback('shop_superettes:haveMoney', function(src, cb, info)
    local xPlayer = Framework.GetPlayerFromId(src);
    local price, method = tonumber(info.price*info.count), info.method;

    if(info.name ~= 'bread' and info.name ~= 'water' and info.name ~= 'chest') then
        exports['ac']:fg_BanPlayer(src, 'Utilisation inappropriée du callback shop_superettes:haveMoney', true)
        return
    end

    if xPlayer['accounts'].accounts[method].money >= tonumber(price) then 
        xPlayer['accounts'].removeAccountMoney(method, tonumber(price)) 
        xPlayer['inventory'].addInventoryItem(info.name, info.count)
        xPlayer.showNotification("Vous avez payé ~g~"..price.."$~s~.")
        cb(true) 
    else 
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
        cb(false)
    end
end)