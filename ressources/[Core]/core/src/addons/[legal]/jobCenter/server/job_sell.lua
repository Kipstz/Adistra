
JobCenter.PlayersSelling = {}

RegisterServerEvent('jobcenter:startSell')
AddEventHandler('jobcenter:startSell', function(job)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);
    local itemsRequireds = Config['jobcenter']['points'][job]['sell'].itemsRequireds
    local prices = Config['jobcenter']['points'][job]['sell'].prices

    if not JobCenter.PlayersSelling[src] then
        JobCenter.PlayersSelling[src] = true;
        JobCenter:startSell(src, itemsRequireds, prices)
    end
end)

RegisterServerEvent('jobcenter:stopSell')
AddEventHandler('jobcenter:stopSell', function()
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);

    if JobCenter.PlayersSelling[src] then
        JobCenter.PlayersSelling[src] = false;
    end
end)

function JobCenter:startSell(src, itemsRequireds, prices)
    local xPlayer = Framework.GetPlayerFromId(src);
    local itemRequired = nil;

    for k,v in pairs(itemsRequireds) do
        if xPlayer['inventory'].getInventoryItem(v) ~= nil then
            if xPlayer['inventory'].getInventoryItem(v).count > 0 then
                itemRequired = v
                break
            end
        elseif xPlayer['inventory'].getInventoryItem(v) == nil then
            print("^1Erreur JOBCENTER: Item Invalide^0")
            TriggerClientEvent('jobcenter:stopSell', src)
        end
    end

    SetTimeout(10000, function()
        Wait(500)
		if JobCenter.PlayersSelling[src] then
            if itemRequired ~= nil then
                local itemLabel = Framework.ITEMS:GetItemLabel(itemRequired);

                if itemLabel ~= nil then
                    local itemCount = xPlayer['inventory'].getInventoryItem(itemRequired).count;
    
                    if itemCount > 0 then
                        xPlayer['inventory'].removeInventoryItem(itemRequired, itemCount)
                        xPlayer['accounts'].addAccountMoney('money', tonumber(prices[itemRequired]*itemCount))
                    
                        xPlayer.showNotification("~g~Vous avez vendu ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                        JobCenter:startSell(src, itemsRequireds, prices)
                    else
                        xPlayer.showNotification("~r~Vous n'avez rien a vendre !~s~")
                        TriggerClientEvent('jobcenter:stopSell', src)
                        JobCenter.PlayersSelling[src] = false;
                    end
                else
                    print("^1Erreur JOBCENTER: Item Invalide^0")
                    TriggerClientEvent('jobcenter:stopSell', src)
                    JobCenter.PlayersSelling[src] = false;
                end
            else
                xPlayer.showNotification("~r~Vous n'avez rien a vendre !~s~")
                TriggerClientEvent('jobcenter:stopSell', src)
                JobCenter.PlayersSelling[src] = false;
            end
        end
    end)
end
