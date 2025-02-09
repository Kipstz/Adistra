
RegisterNetEvent("personalmenu:boss_recrute")
AddEventHandler("personalmenu:boss_recrute", function(target, job, grade)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local tPlayer = Framework.GetPlayerFromId(target)

    if xPlayer and tPlayer then
        if(tPlayer['jobs'].getJob().name == 'unemployed' or tPlayer['jobs'].getJob().name == 'tabac' or tPlayer['jobs'].getJob().name == 'mineur') then
            if xPlayer['jobs'].getJob().name == job then
                tPlayer['jobs'].setJob(job, grade)

                tPlayer.showNotification("Vous avez été recruter dans une entreprise !")
                xPlayer.showNotification("Vous avez recruté une personne !")
            end
        else
            xPlayer.showNotification("Impossible de recruter cette personne, elle est déjà dans une entreprise")
        end
    else
        print("^ERREUR PERSONAL MENU BOSS RECRUTE")
    end
end)

RegisterNetEvent("personalmenu:boss_recrute2")
AddEventHandler("personalmenu:boss_recrute2", function(target, job, grade)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local tPlayer = Framework.GetPlayerFromId(target)

    if xPlayer and tPlayer then
        if(tPlayer['jobs'].getJob2().name == 'unemployed2') then
            if xPlayer['jobs'].getJob2().name == job then
                tPlayer['jobs'].setJob2(job, grade)

                tPlayer.showNotification("Vous avez été recruter dans une faction !")
                xPlayer.showNotification("Vous avez recruté une personne !")
            end
        else
            xPlayer.showNotification("Impossible de recruter cette personne, elle est déjà dans un groupe")
        end
    else
        print("^ERREUR PERSONAL MENU BOSS RECRUTE 2")
    end
end)

RegisterNetEvent('personalmenu:Inventory')
AddEventHandler('personalmenu:Inventory', function(target, type, itemName, itemCount)
    local src = source;
    print('personalmenu:Inventory:'..source)
    TriggerEvent('framework:giveInventoryItem', target, type, itemName, itemCount, src)
end)

RegisterNetEvent('personalmenu:Inventory2')
AddEventHandler('personalmenu:Inventory2', function(type, itemName, itemCount)
    local src = source;
    TriggerEvent('framework:removeInventoryItem', type, itemName, itemCount, src)
end)

RegisterNetEvent('personalmenu:use')
AddEventHandler('personalmenu:use', function(itemName)
    local src = source;
    TriggerEvent('framework:useItem', itemName, src)
end)
