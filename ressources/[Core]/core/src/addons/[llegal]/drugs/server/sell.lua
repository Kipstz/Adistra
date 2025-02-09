
Drugs.PlayersSelling = {}

RegisterNetEvent('drugs:startSell')
AddEventHandler('drugs:startSell', function(drug)
    local src = source;
    if not Drugs.PlayersSelling[src] then
        Drugs.PlayersSelling[src] = true
        Drugs.startSell(src, drug)
    end
end)

RegisterNetEvent('drugs:stopSell')
AddEventHandler('drugs:stopSell', function()
    local src = source;
    if Drugs.PlayersSelling[src] then
        Drugs.PlayersSelling[src] = false
    end
end)

Drugs.startSell = function(src, drug)
    local xPlayer = Framework.GetPlayerFromId(src)
    local itemLabel = Framework.ITEMS:GetItemLabel(drug.need)

    if not itemLabel then
        print("^1Erreur DRUGS: Item Invalide^0")
        Drugs.PlayersSelling[src] = false
        FreezeEntityPosition(src, false)
        return
    end
    local function sellDrugs()
        if not Drugs.PlayersSelling[src] then
            return
        end
        if xPlayer['inventory'].getInventoryItem(drug.need).count > 0 then
            xPlayer['inventory'].removeInventoryItem(drug.need, 1)
            xPlayer['accounts'].addAccountMoney('black_money', drug.price)
            xPlayer.showNotification("Vous avez vendu ~b~1x ~r~"..itemLabel.." ~s~pour ~g~"..drug.price.."$ ~s~!")
            SetTimeout(10000, sellDrugs)
        else
            xPlayer.showNotification("~r~Vous n'avez pas de pochons a vendre !")
        end
    end
    SetTimeout(10000, sellDrugs)
end