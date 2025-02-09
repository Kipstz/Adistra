
Drugs.PlayersHarvesting = {}

RegisterNetEvent('drugs:startHarvest')
AddEventHandler('drugs:startHarvest', function(drug)
    local src = source;
    if not Drugs.PlayersHarvesting[src] then
        Drugs.PlayersHarvesting[src] = true
        Drugs.startHarvest(src, drug)
    end
end)

RegisterNetEvent('drugs:stopHarvest')
AddEventHandler('drugs:stopHarvest', function()
    local src = source;
    if Drugs.PlayersHarvesting[src] then
        Drugs.PlayersHarvesting[src] = false
    end
end)

Drugs.startHarvest = function(src, drug)
    local xPlayer = Framework.GetPlayerFromId(src)

    SetTimeout(10000, function()
        Wait(500)

		if Drugs.PlayersHarvesting[src] then
            local itemLabel = Framework.ITEMS:GetItemLabel(drug.item)
            local itemCount = math.random(1, 2)
        
            if itemLabel ~= nil then
                if xPlayer['inventory'].canCarryItem(drug.item, itemCount) then
                    xPlayer['inventory'].addInventoryItem(drug.item, itemCount)
            
                    xPlayer.showNotification("~g~Vous avez récupérer ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                    Drugs.startHarvest(src, drug)
                else
                    xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")
                    TriggerClientEvent('drugs:stopHarvest', src)
                end
            else
                print("^1Erreur DRUGS: Item Invalide^0")
                TriggerClientEvent('drugs:stopHarvest', src)
            end
        end
    end)
end