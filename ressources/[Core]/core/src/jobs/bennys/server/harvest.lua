
BennysJob.PlayersHarvesting = {}

BennysJob.priceToPay = 0;

RegisterServerEvent('BennysJob:startHarvest')
AddEventHandler('BennysJob:startHarvest', function(item, price)
    local xPlayer = Framework.GetPlayerFromId(source)

    BennysJob.PlayersHarvesting[source] = true
    BennysJob.startHarvest(source, item, price)
end)

RegisterServerEvent('BennysJob:stopHarvest')
AddEventHandler('BennysJob:stopHarvest', function()
    local xPlayer = Framework.GetPlayerFromId(source)

    BennysJob.PlayersHarvesting[source] = false;
    if BennysJob.priceToPay > 0 then
        TriggerEvent('bossManagement:removeMoneybyOther', 'bennys', tonumber(BennysJob.priceToPay))
        BennysJob.priceToPay = 0;
    end
end)

BennysJob.startHarvest = function(src, item, price)
    local xPlayer = Framework.GetPlayerFromId(src)

    SetTimeout(10000, function()
        Wait(500)
		if BennysJob.PlayersHarvesting[src] then
            local itemLabel = Framework.ITEMS:GetItemLabel(item)
            local itemCount = math.random(1, 2)
        
            if xPlayer['inventory'].canCarryItem(item, itemCount) then
                xPlayer['inventory'].addInventoryItem(item, itemCount)
        
                xPlayer.showNotification("~g~Vous avez récupérer ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                BennysJob.priceToPay = tonumber(BennysJob.priceToPay) + tonumber(price); 
                BennysJob.startHarvest(src, item, price)
            else
                xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")

                TriggerClientEvent('BennysJob:stopHarvest', src)
            end
        end
    end)
end