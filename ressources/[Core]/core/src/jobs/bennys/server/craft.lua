
BennysJob.PlayersCrafting = {}

RegisterServerEvent('BennysJob:startCraft')
AddEventHandler('BennysJob:startCraft', function(lastItem, item)
    local xPlayer = Framework.GetPlayerFromId(source)

    BennysJob.PlayersCrafting[source] = true
    BennysJob.startCraft(source, lastItem, item)
end)

RegisterServerEvent('BennysJob:stopCraft')
AddEventHandler('BennysJob:stopCraft', function()
    local xPlayer = Framework.GetPlayerFromId(source)

    BennysJob.PlayersCrafting[source] = false;
end)

BennysJob.startCraft = function(src, lastItem, item)
    local xPlayer = Framework.GetPlayerFromId(src)

    if xPlayer['inventory'].getInventoryItem(lastItem).count > 0 then
        SetTimeout(10000, function()
            Wait(500)
            if BennysJob.PlayersCrafting[src] then
                local itemLabel = Framework.ITEMS:GetItemLabel(item)
                local itemCount = math.random(1, 2)
            
                if xPlayer['inventory'].canSwapItem(lastItem, 1, item, itemCount) then
                    xPlayer['inventory'].removeInventoryItem(lastItem, 1)
                    xPlayer['inventory'].addInventoryItem(item, itemCount)
            
                    xPlayer.showNotification("~g~Vous avez récupérer ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                    BennysJob.startCraft(src, lastItem, item)
                else
                    xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")

                    TriggerClientEvent('BennysJob:stopCraft', src)
                end
            end
        end)
    else
        xPlayer.showNotification("~r~Vous n'avez pas les outils nécessaire !")

        TriggerClientEvent('BennysJob:stopCraft', src)
    end
end