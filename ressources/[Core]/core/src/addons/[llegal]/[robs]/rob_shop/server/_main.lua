
RegisterServerEvent('rob_shop:pickUp')
AddEventHandler('rob_shop:pickUp', function(store)
    local xPlayer = Framework.GetPlayerFromId(source)
    local randomAmount = math.random(Config['rob_shops'].Shops[store].money[1], Config['rob_shops'].Shops[store].money[2])

    xPlayer['accounts'].addAccountMoney('black_money', randomAmount)
    xPlayer.showNotification("Vous avez reçu ~g~"..randomAmount.."$~s~ !")
    TriggerClientEvent('rob_shop:removePickup', -1, store) 
end)

Framework.RegisterServerCallback('rob_shop:canRob', function(source, cb, store)
    local cops = Service:GetInServiceCount('police')
    local cops2 = Service:GetInServiceCount('sheriff')
    if cops ~= nil and cops2 ~= nil then copcount = tonumber(cops+cops2)
    elseif cops ~= nil then copcount = tonumber(cops)
    elseif cops2 ~= nil then copcount = tonumber(cops2)
    elseif cops == nil and cops2 == nil then copcount = 0
    end

    if copcount >= Config['rob_shops'].Shops[store].cops then
        if not Config['rob_shops'].Shops[store].robbed then
            cb(true)
        else
            cb(false)
        end
    else
        cb('no_cops')
    end
end)

RegisterServerEvent('rob_shop:rob')
AddEventHandler('rob_shop:rob', function(store)
    local src = source
    Config['rob_shops'].Shops[store].robbed = true

    TriggerClientEvent('rob_shop:msgPolice', -1, store, src)

    TriggerClientEvent('rob_shop:rob', -1, store)
    Wait(30000)
    TriggerClientEvent('rob_shop:robberyOver', src)

    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute
    local cooldown = Config['rob_shops'].Shops[store].cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second

    Wait(wait)
    Config['rob_shops'].Shops[store].robbed = false

    TriggerClientEvent('rob_shop:resetStore', -1, store)
end)