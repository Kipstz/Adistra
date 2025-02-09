
BurgerShotJob.PlayersHarvesting = {}

BurgerShotJob.priceToPay = 0;

RegisterServerEvent('BurgerShotJob:startHarvest')
AddEventHandler('BurgerShotJob:startHarvest', function(item, price)
    local xPlayer = Framework.GetPlayerFromId(source)

    BurgerShotJob.PlayersHarvesting[source] = true
    BurgerShotJob.startHarvest(source, item, price)
end)

RegisterServerEvent('BurgerShotJob:stopHarvest')
AddEventHandler('BurgerShotJob:stopHarvest', function()
    local xPlayer = Framework.GetPlayerFromId(source)

    BurgerShotJob.PlayersHarvesting[source] = false;
    if BurgerShotJob.priceToPay > 0 then
        TriggerEvent('bossManagement:removeMoneybyOther', 'burger', tonumber(BurgerShotJob.priceToPay))
        BurgerShotJob.priceToPay = 0;
    end
end)

BurgerShotJob.startHarvest = function(src, item, price)
    local xPlayer = Framework.GetPlayerFromId(src)

    SetTimeout(10000, function()
        Wait(500)
		if BurgerShotJob.PlayersHarvesting[src] then
            local itemLabel = Framework.ITEMS:GetItemLabel(item)
            local itemCount = math.random(1, 2)
        
            if xPlayer['inventory'].canCarryItem(item, itemCount) then
                xPlayer['inventory'].addInventoryItem(item, itemCount)
        
                xPlayer.showNotification("~g~Vous avez récupérer ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                BurgerShotJob.priceToPay = tonumber(BurgerShotJob.priceToPay) + tonumber(price); 
                BurgerShotJob.startHarvest(src, item, price)
            else
                xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")

                TriggerClientEvent('BurgerShotJob:stopHarvest', src)
            end
        end
    end)
end