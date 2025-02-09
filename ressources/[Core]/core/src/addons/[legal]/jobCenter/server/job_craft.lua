
JobCenter.PlayersCraft = {}

RegisterServerEvent('jobcenter:startCraft')
AddEventHandler('jobcenter:startCraft', function(job)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);
    local item = Config['jobcenter']['points'][job]['craft'].items
    local itemRequired = Config['jobcenter']['points'][job]['craft'].itemRequired

    if not JobCenter.PlayersCraft[src] then
        JobCenter.PlayersCraft[src] = true;
        JobCenter:startCraft(src, item, itemRequired)
    end
end)

RegisterServerEvent('jobcenter:stopCraft')
AddEventHandler('jobcenter:stopCraft', function()
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);

    if JobCenter.PlayersCraft[src] then
        JobCenter.PlayersCraft[src] = false;
    end
end)

function JobCenter:randomItem(items)
    local rand = math.random(1, 100)
    local cumulatif = 0;

    for k, v in pairs(items) do
        cumulatif = cumulatif + v
        if rand <= cumulatif then
            return k
        end
    end
end

function JobCenter:startCraft(src, items, itemRequired)
    local xPlayer = Framework.GetPlayerFromId(src);

    SetTimeout(10000, function()
        Wait(500)
		if JobCenter.PlayersCraft[src] then
            local item = JobCenter:randomItem(items)
            local itemLabel = Framework.ITEMS:GetItemLabel(item);
            local itemRequiredLabel = Framework.ITEMS:GetItemLabel(itemRequired);

            if item ~= nil and itemRequired ~= nil and itemLabel ~= nil and itemRequiredLabel ~= nil then
                if xPlayer['inventory'].getInventoryItem(itemRequired).count > 1 then
                    itemCount = math.random(1, 3);

                    if xPlayer['inventory'].getInventoryItem(itemRequired).count < itemCount then
                        itemCount = 1
                    end
                else
                    itemCount = 1
                end
                
                if xPlayer['inventory'].getInventoryItem(itemRequired).count > 0 then
                    if xPlayer['inventory'].canSwapItem(itemRequired, itemCount, item, itemCount) then
                        xPlayer['inventory'].removeInventoryItem(itemRequired, itemCount)
                        xPlayer['inventory'].addInventoryItem(item, itemCount)
                
                        xPlayer.showNotification("~g~Vous avez reçu ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                        JobCenter:startCraft(src, items, itemRequired)
                    else
                        xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")
        
                        TriggerClientEvent('jobcenter:stopCraft', src)
                        JobCenter.PlayersCraft[src] = false;
                    end
                else
                    xPlayer.showNotification("~r~Vous n'avez rien a transformer !~s~")
                    TriggerClientEvent('jobcenter:stopCraft', src)
                    JobCenter.PlayersCraft[src] = false;
                end
            else
                print("^1Erreur JOBCENTER: Item Invalide^0")
                TriggerClientEvent('jobcenter:stopCraft', src)
                JobCenter.PlayersCraft[src] = false;
            end
        end
    end)
end
