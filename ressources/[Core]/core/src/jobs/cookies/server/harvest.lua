
CookiesJob.PlayersHarvesting = {}

CookiesJob.priceToPay = 0;

RegisterServerEvent('CookiesJob:startHarvest')
AddEventHandler('CookiesJob:startHarvest', function(item, price)
    local xPlayer = Framework.GetPlayerFromId(source)

    CookiesJob.PlayersHarvesting[source] = true
    CookiesJob.startHarvest(source, item, price)
end)

RegisterServerEvent('CookiesJob:stopHarvest')
AddEventHandler('CookiesJob:stopHarvest', function()
    local xPlayer = Framework.GetPlayerFromId(source)

    CookiesJob.PlayersHarvesting[source] = false;
    if CookiesJob.priceToPay > 0 then
        TriggerEvent('bossManagement:removeMoneybyOther', 'cookies', tonumber(CookiesJob.priceToPay))
        CookiesJob.priceToPay = 0;
    end
end)

CookiesJob.startHarvest = function(src, item, price)
    local xPlayer = Framework.GetPlayerFromId(src)

    SetTimeout(10000, function()
        Wait(500)
		if CookiesJob.PlayersHarvesting[src] then
            local itemLabel = Framework.ITEMS:GetItemLabel(item)
            local itemCount = math.random(1, 2)
        
            if xPlayer['inventory'].canCarryItem(item, itemCount) then
                xPlayer['inventory'].addInventoryItem(item, itemCount)
        
                xPlayer.showNotification("~g~Vous avez récupérer ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                CookiesJob.priceToPay = tonumber(CookiesJob.priceToPay) + tonumber(price); 
                CookiesJob.startHarvest(src, item, price)
            else
                xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")

                TriggerClientEvent('CookiesJob:stopHarvest', src)
            end
        end
    end)
end