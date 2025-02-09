

VigneronJob = {}
VigneronJob.inTimeout = false

VigneronJob.PlayersHarvesting = {}
VigneronJob.PlayersCrafting = {}
VigneronJob.PlayersSelling = {}

RegisterServerEvent('VigneronJob:startHarvest')
AddEventHandler('VigneronJob:startHarvest', function(item)
    local xPlayer = Framework.GetPlayerFromId(source)

    VigneronJob.PlayersHarvesting[source] = true
    VigneronJob.startHarvest(source, item)
end)

RegisterServerEvent('VigneronJob:stopHarvest')
AddEventHandler('VigneronJob:stopHarvest', function()
    local xPlayer = Framework.GetPlayerFromId(source)

    VigneronJob.PlayersHarvesting[source] = false
end)

VigneronJob.startHarvest = function(src, item)
    local xPlayer = Framework.GetPlayerFromId(src)

    SetTimeout(5000, function()
        Wait(500)
		if VigneronJob.PlayersHarvesting[src] then
            local itemLabel = Framework.ITEMS:GetItemLabel(item)
            local itemCount = math.random(1, 2)
        
            if xPlayer['inventory'].canCarryItem(item, itemCount) then
                xPlayer['inventory'].addInventoryItem(item, itemCount)
        
                xPlayer.showNotification("~g~Vous avez récupérer ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                VigneronJob.startHarvest(src, item)
            else
                xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")

                TriggerClientEvent('VigneronJob:stopHarvest', src)
            end
        end
    end)
end

RegisterServerEvent('VigneronJob:startCraft')
AddEventHandler('VigneronJob:startCraft', function(lastItem, item)
    local xPlayer = Framework.GetPlayerFromId(source)

    VigneronJob.PlayersCrafting[source] = true
    VigneronJob.startCraft(source, lastItem, item)
end)

RegisterServerEvent('VigneronJob:stopCraft')
AddEventHandler('VigneronJob:stopCraft', function()
    local xPlayer = Framework.GetPlayerFromId(source)

    VigneronJob.PlayersCrafting[source] = false
end)

VigneronJob.startCraft = function(src, lastItem, item)
    local xPlayer = Framework.GetPlayerFromId(src)

    if xPlayer['inventory'].getInventoryItem(lastItem).count > 0 then
        SetTimeout(5000, function()
            Wait(500)
            if VigneronJob.PlayersCrafting[src] then
                local itemLabel = Framework.ITEMS:GetItemLabel(item)
                local itemCount = math.random(1, 2)
            
                if xPlayer['inventory'].canSwapItem(lastItem, 1, item, itemCount) then
                    xPlayer['inventory'].removeInventoryItem(lastItem, 1)
                    xPlayer['inventory'].addInventoryItem(item, itemCount)
            
                    xPlayer.showNotification("~g~Vous avez récupérer ~b~"..itemCount.."x ~o~"..itemLabel.." ~s~!")
                    VigneronJob.startCraft(src, lastItem, item)
                else
                    xPlayer.showNotification("~r~Vous n'avez pas assez de place dans votre Inventaire !")

                    TriggerClientEvent('VigneronJob:stopCraft', src)
                end
            end
        end)
    else
        xPlayer.showNotification("~r~Vous n'avez pas les outils nécessaire !")

        TriggerClientEvent('VigneronJob:stopCraft', src)
    end
end

RegisterServerEvent('VigneronJob:startSell')
AddEventHandler('VigneronJob:startSell', function(needItem)
    local xPlayer = Framework.GetPlayerFromId(source)

    VigneronJob.PlayersSelling[source] = true
    VigneronJob.startSell(source, needItem)
end)

VigneronJob.addSocietyAmount = 0

RegisterServerEvent('VigneronJob:stopSell')
AddEventHandler('VigneronJob:stopSell', function()
    local xPlayer = Framework.GetPlayerFromId(source)

    VigneronJob.PlayersSelling[source] = false

    if VigneronJob.addSocietyAmount ~= 0 then
        TriggerEvent('bossManagement:depositMoneybyOther', 'vigneron', VigneronJob.addSocietyAmount)
        VigneronJob.addSocietyAmount = 0
    end
end)

VigneronJob.startSell = function(src, needItem)
    local xPlayer = Framework.GetPlayerFromId(src)

    if xPlayer['inventory'].getInventoryItem(needItem).count > 0 then
        SetTimeout(5000, function()
            Wait(500)
            if VigneronJob.PlayersSelling[src] then
                local itemLabel = Framework.ITEMS:GetItemLabel(needItem)

                if xPlayer['inventory'].getInventoryItem(needItem).count > 0 then
                    xPlayer['inventory'].removeInventoryItem(needItem, 1)
                    xPlayer['accounts'].addAccountMoney('money', Config['job_vigneron'].sellPrice)

                    VigneronJob.addSocietyAmount = VigneronJob.addSocietyAmount + Config['job_vigneron'].sellPrice
    
                    xPlayer.showNotification("Vous avez vendu ~b~1x ~r~"..itemLabel.." ~s~pour ~g~"..Config['job_vigneron'].sellPrice.."$ ~s~!")
                    VigneronJob.startSell(src, needItem)
                else
                    xPlayer.showNotification("~r~Vous n'avez rien a vendre !")

                    if VigneronJob.addSocietyAmount ~= 0 then
                        TriggerEvent('bossManagement:depositMoneybyOther', 'vigneron', VigneronJob.addSocietyAmount)
                        VigneronJob.addSocietyAmount = 0
                    end

                    TriggerClientEvent('VigneronJob:stopSell', src)
                end
            end
        end)
    else
        xPlayer.showNotification("~r~Vous n'avez rien a vendre !")

        if VigneronJob.addSocietyAmount ~= 0 then
            TriggerEvent('bossManagement:depositMoneybyOther', 'vigneron', VigneronJob.addSocietyAmount)
            VigneronJob.addSocietyAmount = 0
        end

        TriggerClientEvent('VigneronJob:stopSell', src)
    end
end

VigneronJob.startTimeout = function(time)
    VigneronJob.inTimeout = true
    
    SetTimeout(time, function()
        VigneronJob.inTimeout = false
    end)
end

RegisterServerEvent('VigneronJob:annonce')
AddEventHandler('VigneronJob:annonce', function(annonce)
    local xPlayer = Framework.GetPlayerFromId(source)

    if not VigneronJob.inTimeout then
        local xPlayers	= Framework.GetPlayers()
        for i=1, #xPlayers, 1 do
            TriggerClientEvent('framework:showAdvancedNotification', xPlayers[i], "Vigneron", '~b~Annonce', annonce)
        end

        VigneronJob.startTimeout(60000 * 5)
    else
        xPlayer.showNotification("~r~Veuillez patienter avant de faire une autre annonce (5 min entre chaque annonce) !")
    end
end)