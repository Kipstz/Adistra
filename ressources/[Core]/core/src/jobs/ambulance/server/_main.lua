
TriggerEvent("service:activateService", 'ambulance', 15)

RegisterNetEvent("AmbulanceJob:MettreSortirVeh")
AddEventHandler("AmbulanceJob:MettreSortirVeh", function(player)
    if player ~= nil then
        TriggerClientEvent("AmbulanceJob:MettreSortirVeh", player)
    else
        print("^1 Erreur AMBULANCEJOB: player is nil")
    end
end)

RegisterServerEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(source)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/pharmacie.json") 

	Pharmacie = json.decode(loadFile)

    if xPlayer ~= nil then
        if xPlayer['jobs'] and xPlayer['jobs'].job.name == 'ambulance' then
            xPlayer.triggerEvent("AmbulanceJob:updateStock", Pharmacie)
        end
    end
end)

RegisterNetEvent("AmbulanceJob:add")
AddEventHandler("AmbulanceJob:add", function(item, qte)
	local xPlayer = Framework.GetPlayerFromId(source)

    if xPlayer['jobs'] and xPlayer['jobs'].job.name == 'ambulance' then
        local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/pharmacie.json") 

        local found = false 
            
        Pharmacie = json.decode(loadFile)
    
        if not next(Pharmacie) then
            Pharmacie.items = {
                {
                    item = item,
                    label = Framework.ITEMS:GetItemLabel(item),
                    count = qte
                }
            }
    
            found = true
        else
            for k,v in pairs(Pharmacie.items) do
                if v.item == item then 
                    if xPlayer['inventory'].getInventoryItem(item).count >= qte then
                        local TotalCount = qte + v.count 
    
                        v.count  = TotalCount
        
                        xPlayer['inventory'].removeInventoryItem(item, qte)
                        xPlayer.showNotification("Vous avez déposé ~b~x"..qte.." ~g~"..Framework.ITEMS:GetItemLabel(item))
    
                        found = true
                    else
                        xPlayer.showNotification("Quantité Invalide !")
                    end
                end
            end
        end
    
        if not found and next(Pharmacie) then 
            table.insert(Pharmacie.items, {
                item = item,
                label = Framework.ITEMS:GetItemLabel(item),
                count = qte
            })
        end
    
        SaveResourceFile(GetCurrentResourceName(), "./data/pharmacie.json", json.encode(Pharmacie, {indent=true}), -1) 
        
        for _,xPlayer in pairs(Framework.GetExtendedPlayers()) do
            if xPlayer and xPlayer['jobs'] and xPlayer['jobs'].job.name == 'ambulance' then
                xPlayer.triggerEvent("AmbulanceJob:updateStock", Pharmacie)
            end
        end
    else
        print("CHEATER DEPOT EMS "..source)
    end
end)


RegisterNetEvent("AmbulanceJob:remove")
AddEventHandler("AmbulanceJob:remove", function(item, qte)
	local xPlayer = Framework.GetPlayerFromId(source)

    if xPlayer['jobs'] and xPlayer['jobs'].job.name == 'ambulance' then
        local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/pharmacie.json") 

        local found = false 
            
        Pharmacie = json.decode(loadFile)
    
        for k,v in pairs(Pharmacie.items) do
            if v.item == item then
                if xPlayer['inventory'].canCarryItem(item, qte) then
                    if v.count >= qte then
                        local TotalCount = v.count - qte 
        
                        v.count  = TotalCount
        
                        xPlayer['inventory'].addInventoryItem(item, qte)
                        xPlayer.showNotification("Vous avez retiré ~b~x"..qte.." ~g~"..Framework.ITEMS:GetItemLabel(item))
        
                        found = true
                    else
                        xPlayer.showNotification("Quantité Invalide !")
                    end
                else
                    xPlayer.showNotification("~r~Vous n'avez pas asser de place !~s~")
                end
            end
        end
    
        SaveResourceFile(GetCurrentResourceName(), "./data/pharmacie.json", json.encode(Pharmacie, {indent=true}), -1) 
        
        for _,xPlayer in pairs(Framework.GetExtendedPlayers()) do
            if xPlayer['jobs'] and xPlayer['jobs'].job.name == 'ambulance' then
                xPlayer.triggerEvent("AmbulanceJob:updateStock", Pharmacie)
            end
        end
    else
        print("CHEATER RETRAIT EMS "..source)
    end
end)

RegisterNetEvent("AmbulanceJob:buy")
AddEventHandler("AmbulanceJob:buy", function(item, qte, price)
	local xPlayer = Framework.GetPlayerFromId(source)

    if xPlayer['jobs'] and xPlayer['jobs'].job.name == 'ambulance' then
        TriggerEvent('bossManagement:getSocietyAccount', 'ambulance', function(accountMoney)
            if accountMoney >= price then
                TriggerEvent('bossManagement:removeMoneybyOther', 'ambulance', price)
    
                local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/pharmacie.json") 
    
                local found = false 
            
                Pharmacie = json.decode(loadFile)
            
                if not next(Pharmacie) then
                    Pharmacie.items = {
                        {
                            item = item,
                            label = Framework.ITEMS:GetItemLabel(item),
                            count = qte
                        }
                    }
            
                    found = true
                else
                    for k,v in pairs(Pharmacie.items) do
                        if v.item == item then
                            local TotalCount = qte + v.count 
            
                            v.count  = TotalCount
            
                            found = true
                        end
                    end
                end
            
                if not found and next(Pharmacie) then 
                    table.insert(Pharmacie.items, {
                        item = item,
                        label = Framework.ITEMS:GetItemLabel(item),
                        count = qte
                    })
                end
        
                SaveResourceFile(GetCurrentResourceName(), "./data/pharmacie.json", json.encode(Pharmacie, {indent=true}), -1) 
                
                for _,xPlayer in pairs(Framework.GetExtendedPlayers()) do
                    if xPlayer['jobs'] and xPlayer['jobs'].job.name == 'ambulance' then
                        xPlayer.triggerEvent("AmbulanceJob:updateStock", Pharmacie)
                    end
                end
    
                xPlayer.showNotification("Vous avez acheté ~b~x"..qte.." ~g~"..Framework.ITEMS:GetItemLabel(item))
            else
                xPlayer.showNotification("~r~La société n'a pas assez d'argent !")
            end
        end)
    else
        print("CHEATER ACHAT EMS "..source)
    end
end)

comaCalls = {}

RegisterNetEvent('playerDied:comaCall')
AddEventHandler('playerDied:comaCall', function()
    local _source = source
    local playerPed = GetPlayerPed(_source)
    local _position = GetEntityCoords(playerPed)
    
    comaCalls[_source] = _position
    newComa = true
end)