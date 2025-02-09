
Drugs.inSell = false;

Drugs.startSell = function(drug)
    if not Drugs.inSell then
        Drugs.inSell = true;

        exports["ac"]:ExecuteServerEvent('drugs:startSell', Config['drugs'][drug]['sell'])
        Drugs:progress(Config['drugs'][drug]['sell'].progressMsg)
    end
end

--RegisterNetEvent('drugs:stopSell')
--AddEventHandler('drugs:stopSell', function()
--    Drugs.inSell = false;
--    FreezeEntityPosition(PlayerPedId(), false)
--end)