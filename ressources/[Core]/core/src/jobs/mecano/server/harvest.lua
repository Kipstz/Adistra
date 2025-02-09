
MecanoJob.PlayersHarvesting = {}

MecanoJob.priceToPay = 0;

RegisterServerEvent('MecanoJob:startHarvest')
AddEventHandler('MecanoJob:startHarvest', function(item, price)
    local xPlayer = Framework.GetPlayerFromId(source)

    MecanoJob.PlayersHarvesting[source] = true
    MecanoJob.startHarvest(source, item, price)
end)

RegisterServerEvent('MecanoJob:stopHarvest')
AddEventHandler('MecanoJob:stopHarvest', function()
    local xPlayer = Framework.GetPlayerFromId(source)

    MecanoJob.PlayersHarvesting[source] = false;
    if MecanoJob.priceToPay > 0 then
        TriggerEvent('bossManagement:removeMoneybyOther', 'mecano', tonumber(MecanoJob.priceToPay))
        MecanoJob.priceToPay = 0;
    end
end)

MecanoJob.startHarvest = function(src, item, price)
    local xPlayer = Framework.GetPlayerFromId(src)

    SetTimeout(10000, function()
        Wait(500)
		if MecanoJob.PlayersHarvesting[src] then
            local itemLabel = Framework.ITEMS:GetItemLabel(item)
            local itemCount = math.random(1, 2)
        
            if xPlayer['inventory'].canCarryItem(item, itemCount) then
                xPlayer['inventory'].addInventoryItem(item, itemCount)
        
                xPlayer.showNotification("~g~Vous avez récupérer ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                MecanoJob.priceToPay = tonumber(MecanoJob.priceToPay) + tonumber(price); 
                MecanoJob.startHarvest(src, item, price)
            else
                xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")

                TriggerClientEvent('MecanoJob:stopHarvest', src)
            end
        end
    end)
end