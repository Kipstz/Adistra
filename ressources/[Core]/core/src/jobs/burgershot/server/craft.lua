
BurgerShotJob.PlayersCrafting = {}

RegisterServerEvent('BurgerShotJob:startCraft')
AddEventHandler('BurgerShotJob:startCraft', function(lastItem, item)
    local xPlayer = Framework.GetPlayerFromId(source)

    BurgerShotJob.PlayersCrafting[source] = true
    BurgerShotJob.startCraft(source, lastItem, item)
end)

RegisterServerEvent('BurgerShotJob:stopCraft')
AddEventHandler('BurgerShotJob:stopCraft', function()
    local xPlayer = Framework.GetPlayerFromId(source)

    BurgerShotJob.PlayersCrafting[source] = false;
end)

BurgerShotJob.startCraft = function(src, lastItem, item)
    local xPlayer = Framework.GetPlayerFromId(src)

    if xPlayer['inventory'].getInventoryItem(lastItem).count > 0 then
        SetTimeout(10000, function()
            Wait(500)
            if BurgerShotJob.PlayersCrafting[src] then
                local itemLabel = Framework.ITEMS:GetItemLabel(item)
                local itemCount = math.random(1, 2)
            
                if xPlayer['inventory'].canSwapItem(lastItem, 1, item, itemCount) then
                    xPlayer['inventory'].removeInventoryItem(lastItem, 1)
                    xPlayer['inventory'].addInventoryItem(item, itemCount)
            
                    xPlayer.showNotification("~g~Vous avez récupérer ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                    BurgerShotJob.startCraft(src, lastItem, item)
                else
                    xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")

                    TriggerClientEvent('BurgerShotJob:stopCraft', src)
                end
            end
        end)
    else
        xPlayer.showNotification("~r~Vous n'avez pas les outils nécessaire !")

        TriggerClientEvent('BurgerShotJob:stopCraft', src)
    end
end