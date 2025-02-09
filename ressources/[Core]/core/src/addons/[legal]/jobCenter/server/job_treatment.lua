
JobCenter.PlayersTreatment = {}

RegisterServerEvent('jobcenter:startTreatment')
AddEventHandler('jobcenter:startTreatment', function(job)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);
    local item = Config['jobcenter']['points'][job]['treatment'].item
    local itemRequired = Config['jobcenter']['points'][job]['treatment'].itemRequired

    if not JobCenter.PlayersTreatment[src] then
        JobCenter.PlayersTreatment[src] = true;
        JobCenter:startTreatment(src, item, itemRequired)
    end
end)

RegisterServerEvent('jobcenter:stopTreatment')
AddEventHandler('jobcenter:stopTreatment', function()
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);

    if JobCenter.PlayersTreatment[src] then
        JobCenter.PlayersTreatment[src] = false;
    end
end)

function JobCenter:startTreatment(src, item, itemRequired)
    local xPlayer = Framework.GetPlayerFromId(src);

    SetTimeout(10000, function()
        Wait(500)
		if JobCenter.PlayersTreatment[src] then
            local itemLabel = Framework.ITEMS:GetItemLabel(item);
            local itemRequiredLabel = Framework.ITEMS:GetItemLabel(itemRequired);

            if item ~= nil and itemRequired ~= nil and itemLabel ~= nil and itemRequiredLabel ~= nil then
                if xPlayer['inventory'].getInventoryItem(itemRequired).count > 1 then
                    itemCount = math.random(1, 3);
                else
                    itemCount = 1
                end

                if xPlayer['inventory'].getInventoryItem(itemRequired).count > 0 then
                    if xPlayer['inventory'].canSwapItem(itemRequired, itemCount, item, itemCount) then
                        xPlayer['inventory'].removeInventoryItem(itemRequired, itemCount)
                        xPlayer['inventory'].addInventoryItem(item, itemCount)

                        xPlayer.showNotification("~g~Vous avez traiter ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                        JobCenter:startTreatment(src, item, itemRequired)
                    else
                        xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")
        
                        TriggerClientEvent('jobcenter:stopTreatment', src)
                        JobCenter.PlayersTreatment[src] = false;
                    end
                else
                    xPlayer.showNotification("~r~Vous n'avez rien a traiter !~s~")
                    TriggerClientEvent('jobcenter:stopTreatment', src)
                    JobCenter.PlayersTreatment[src] = false;
                end
            else
                print("^1Erreur JOBCENTER: Item Invalide^0")
                TriggerClientEvent('jobcenter:stopTreatment', src)
                JobCenter.PlayersTreatment[src] = false;
            end
        end
    end)
end
