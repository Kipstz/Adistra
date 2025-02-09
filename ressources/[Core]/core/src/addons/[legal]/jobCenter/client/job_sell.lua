
JobCenter.inSell = false;

CreateThread(function()
    for k,v in pairs(Config['jobcenter']['points']) do
        for k2, v2 in pairs(v['sell'].localisations) do
            ZoneManager:createZoneWithMarker(v2, 15, 2, {
                onPress = {control = 38, action = function(zone)
                        if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == v.jobRequired then
                            if JobCenter.ServiceCheck then
                                JobCenter:startSell(v.jobRequired, v['sell'].msg, v['sell'].anim)
                            else
                                Framework.ShowNotification("~r~Vous devez être en service !~s~")
                            end
                        else
                            Framework.ShowNotification("~r~Vous ne pouvez pas effectuer cela !~s~")
                        end
                end}
            })
        end
    end
end)

function JobCenter:startSell(job, msg, anim)
    if not JobCenter.inSell then
        JobCenter.inSell = true;
        exports["ac"]:ExecuteServerEvent('jobcenter:startSell', job)
        JobCenter:progress(msg, anim)
    end
end

RegisterNetEvent('jobcenter:stopSell')
AddEventHandler('jobcenter:stopSell', function()
    JobCenter.inSell = false;
    FreezeEntityPosition(PlayerPedId(), false)
end)