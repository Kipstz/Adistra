
Drugs.PlayersCrafting = {}

RegisterNetEvent('drugs:startCraft')
AddEventHandler('drugs:startCraft', function(drug)
    local src = source;
    if not Drugs.PlayersCrafting[src] then
        Drugs.PlayersCrafting[src] = true
        Drugs.startCraft(src, drug)
    end
end)

RegisterNetEvent('drugs:stopCraft')
AddEventHandler('drugs:stopCraft', function()
    local src = source;
    if Drugs.PlayersCrafting[src] then
        Drugs.PlayersCrafting[src] = false
    end
end)

Drugs.startCraft = function(src, drug)
    local xPlayer = Framework.GetPlayerFromId(src)

    if xPlayer['inventory'].getInventoryItem(drug.need).count > 0 then
        SetTimeout(10000, function()
            Wait(500)
            if Drugs.PlayersCrafting[src] then
                local itemLabel = Framework.ITEMS:GetItemLabel(drug.item)
                if xPlayer['inventory'].getInventoryItem(drug.need).count > 1 then
                    itemCount = math.random(1, 2)
                else
                    itemCount = 1
                end
            
                if itemLabel ~= nil then
                    if xPlayer['inventory'].canSwapItem(drug.need, 1, drug.item, itemCount) then
                        xPlayer['inventory'].removeInventoryItem(drug.need, 1)
                        xPlayer['inventory'].addInventoryItem(drug.item, itemCount)
                
                        xPlayer.showNotification("~g~Vous avez récupérer ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                        Drugs.startCraft(src, drug)
                    else
                        xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")
    
                        TriggerClientEvent('drugs::stopCraft', src)
                    end
                else
                    print("^1Erreur DRUGS: Item Invalide^0")
                    TriggerClientEvent('drugs:stopCraft', src)
                end
            end
        end)
    else
        xPlayer.showNotification("~r~Vous n'avez pas les matières premières !")

        TriggerClientEvent('drugs::stopCraft', src)
    end
end