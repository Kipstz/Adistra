
Drugs.inCraft = false;

Drugs.startCraft = function(drug)
    if not Drugs.inCraft then
        Drugs.inCraft = true;

        exports["ac"]:ExecuteServerEvent('drugs:startCraft', Config['drugs'][drug]['craft'])
        Drugs:progress(Config['drugs'][drug]['craft'].progressMsg)
    end
end

RegisterNetEvent('drugs:stopCraft')
AddEventHandler('drugs:stopCraft', function()
    Drugs.inCraft = false;
    FreezeEntityPosition(PlayerPedId(), false)
end)