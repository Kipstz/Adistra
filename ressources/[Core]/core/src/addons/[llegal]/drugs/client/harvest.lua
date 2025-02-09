
Drugs.inHarvest = false;

Drugs.startHarvest = function(drug)
    if not Drugs.inHarvest then
        Drugs.inHarvest = true;

        exports["ac"]:ExecuteServerEvent('drugs:startHarvest', Config['drugs'][drug]['harvest'])
        Drugs:progress(Config['drugs'][drug]['harvest'].progressMsg)
    end
end

RegisterNetEvent('drugs:stopHarvest')
AddEventHandler('drugs:stopHarvest', function()
    Drugs.inHarvest = false;
    FreezeEntityPosition(PlayerPedId(), false)
end)