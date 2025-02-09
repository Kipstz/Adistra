
CayoAutoJob.PlayersHarvesting = {}

CayoAutoJob.priceToPay = 0;

RegisterServerEvent('CayoAutoJob:startHarvest')
AddEventHandler('CayoAutoJob:startHarvest', function(item, price)
    local xPlayer = Framework.GetPlayerFromId(source)

    CayoAutoJob.PlayersHarvesting[source] = true
    CayoAutoJob.startHarvest(source, item, price)
end)

RegisterServerEvent('CayoAutoJob:stopHarvest')
AddEventHandler('CayoAutoJob:stopHarvest', function()
    local xPlayer = Framework.GetPlayerFromId(source)

    CayoAutoJob.PlayersHarvesting[source] = false;
    if CayoAutoJob.priceToPay > 0 then
        TriggerEvent('bossManagement:removeMoneybyOther', 'cayoauto', tonumber(CayoAutoJob.priceToPay))
        CayoAutoJob.priceToPay = 0;
    end
end)

CayoAutoJob.startHarvest = function(src, item, price)
    local xPlayer = Framework.GetPlayerFromId(src)

    SetTimeout(10000, function()
        Wait(500)
		if CayoAutoJob.PlayersHarvesting[src] then
            local itemLabel = Framework.ITEMS:GetItemLabel(item)
            local itemCount = math.random(1, 2)
        
            if xPlayer['inventory'].canCarryItem(item, itemCount) then
                xPlayer['inventory'].addInventoryItem(item, itemCount)
        
                xPlayer.showNotification("~g~Vous avez récupérer ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                CayoAutoJob.priceToPay = tonumber(CayoAutoJob.priceToPay) + tonumber(price); 
                CayoAutoJob.startHarvest(src, item, price)
            else
                xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")

                TriggerClientEvent('CayoAutoJob:stopHarvest', src)
            end
        end
    end)
end