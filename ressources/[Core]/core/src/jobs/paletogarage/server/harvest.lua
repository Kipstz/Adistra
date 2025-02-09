
PaletoGarageJob.PlayersHarvesting = {}

PaletoGarageJob.priceToPay = 0;

RegisterServerEvent('PaletoGarageJob:startHarvest')
AddEventHandler('PaletoGarageJob:startHarvest', function(item, price)
    local xPlayer = Framework.GetPlayerFromId(source)

    PaletoGarageJob.PlayersHarvesting[source] = true
    PaletoGarageJob.startHarvest(source, item, price)
end)

RegisterServerEvent('PaletoGarageJob:stopHarvest')
AddEventHandler('PaletoGarageJob:stopHarvest', function()
    local xPlayer = Framework.GetPlayerFromId(source)

    PaletoGarageJob.PlayersHarvesting[source] = false;
    if PaletoGarageJob.priceToPay > 0 then
        TriggerEvent('bossManagement:removeMoneybyOther', 'paletogarage', tonumber(PaletoGarageJob.priceToPay))
        PaletoGarageJob.priceToPay = 0;
    end
end)

PaletoGarageJob.startHarvest = function(src, item, price)
    local xPlayer = Framework.GetPlayerFromId(src)

    SetTimeout(10000, function()
        Wait(500)
		if PaletoGarageJob.PlayersHarvesting[src] then
            local itemLabel = Framework.ITEMS:GetItemLabel(item)
            local itemCount = math.random(1, 2)
        
            if xPlayer['inventory'].canCarryItem(item, itemCount) then
                xPlayer['inventory'].addInventoryItem(item, itemCount)
        
                xPlayer.showNotification("~g~Vous avez récupérer ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                PaletoGarageJob.priceToPay = tonumber(PaletoGarageJob.priceToPay) + tonumber(price); 
                PaletoGarageJob.startHarvest(src, item, price)
            else
                xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")

                TriggerClientEvent('PaletoGarageJob:stopHarvest', src)
            end
        end
    end)
end