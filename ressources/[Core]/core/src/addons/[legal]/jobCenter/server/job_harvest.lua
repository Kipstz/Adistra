
JobCenter.PlayersHarvesting = {}

RegisterServerEvent('jobcenter:startHarvest')
AddEventHandler('jobcenter:startHarvest', function(job)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);
    local item = Config['jobcenter']['points'][job]['harvest'].item

    if not JobCenter.PlayersHarvesting[src] then
        JobCenter.PlayersHarvesting[src] = true;
        JobCenter:startHarvest(src, item)
    end
end)

RegisterServerEvent('jobcenter:stopHarvest')
AddEventHandler('jobcenter:stopHarvest', function()
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);

    if JobCenter.PlayersHarvesting[src] then
        JobCenter.PlayersHarvesting[src] = false;
    end
end)

function JobCenter:startHarvest(src, item)
    local xPlayer = Framework.GetPlayerFromId(src);

    SetTimeout(10000, function()
        Wait(500)
		if JobCenter.PlayersHarvesting[src] then
            local itemLabel = Framework.ITEMS:GetItemLabel(item);
            local itemCount = math.random(1, 3);

            if item ~= nil and itemLabel ~= nil then
                if xPlayer['inventory'].canCarryItem(item, itemCount) then
                    xPlayer['inventory'].addInventoryItem(item, itemCount)
            
                    xPlayer.showNotification("~g~Vous avez récolter ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                    JobCenter:startHarvest(src, item)
                else
                    xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")
    
                    TriggerClientEvent('jobcenter:stopHarvest', src)
                    JobCenter.PlayersHarvesting[src] = false;
                end
            else
                print("^1Erreur JOBCENTER: Item Invalide^0")
                TriggerClientEvent('jobcenter:stopHarvest', src)
                JobCenter.PlayersHarvesting[src] = false;
            end
        end
    end)
end
