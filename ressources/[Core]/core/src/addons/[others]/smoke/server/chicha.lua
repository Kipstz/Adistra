
Smoke.Chicha = {}

Smoke.Chicha.players = {}

Framework.ITEMS:RegisterUsableItem('chicha', function(src)
    local xPlayer = Framework.GetPlayerFromId(src)
    if not Smoke.Chicha.players[src] then
        xPlayer['inventory'].removeInventoryItem('chicha', 1)
        Smoke.Chicha.players[src] = true;
        TriggerClientEvent('smoke:startChicha', src)
        Smoke.Chicha:startTimeout(src, (60000 * 15))
    else
        xPlayer.showNotification("~r~Vous êtes déjà entrain de fumée une chicha !~s~")
    end
end)

function Smoke.Chicha:startTimeout(src, time)
    SetTimeout(time, function()
        TriggerClientEvent('smoke:stopChicha', src)
        Smoke.Chicha.players[src] = false;
    end)
end

RegisterServerEvent("smoke:chicha_smokes")
AddEventHandler("smoke:chicha_smokes", function(entity)
	TriggerClientEvent("smoke:chicha_smokes", -1, entity)
end)