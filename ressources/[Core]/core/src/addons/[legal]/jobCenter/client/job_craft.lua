
JobCenter.inCraft = false;

CreateThread(function()
    for k,v in pairs(Config['jobcenter']['points']) do
        for k2, v2 in pairs(v['craft'].localisations) do
            ZoneManager:createZoneWithMarker(v2, 10, 5, {
                onPress = {control = 38, action = function(zone)
                        if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == v.jobRequired then
                            if JobCenter.ServiceCheck then
                                JobCenter:startCraft(v.jobRequired, v['craft'].msg, v['craft'].anim)
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

function JobCenter:startCraft(job, msg, anim)
    if not JobCenter.inCraft then
        JobCenter.inCraft = true;
        exports["ac"]:ExecuteServerEvent('jobcenter:startCraft', job)
        JobCenter:progress(msg, anim)
    end
end

RegisterNetEvent('jobcenter:stopCraft')
AddEventHandler('jobcenter:stopCraft', function()
    JobCenter.inCraft = false;
    FreezeEntityPosition(PlayerPedId(), false)
end)