
Framework.RegisterServerCallback("cayo_locations:haveMoney", function(src, cb, info)
    local xPlayer = Framework.GetPlayerFromId(src);
    local price, method = info.price, info.method;
    if xPlayer['accounts'].accounts[method].money >= tonumber(price) then 
        xPlayer['accounts'].removeAccountMoney(method, tonumber(price)) 
        xPlayer.showNotification("Vous avez payé ~g~"..price.."$~s~.")
        cb(true) 
    else 
        xPlayer.showNotification("~r~Vous n'avez pas asser d'argent !")
        cb(false)
    end
end)