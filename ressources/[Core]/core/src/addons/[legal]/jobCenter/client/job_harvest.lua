
JobCenter.inHarvest = false;

CreateThread(function()
    for k,v in pairs(Config['jobcenter']['points']) do
        for k2, v2 in pairs(v['harvest'].localisations) do
            ZoneManager:createZoneWithMarker(v2, 15, 5, {
                onPress = {control = 38, action = function(zone)
                        if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == v.jobRequired then
                            if JobCenter.ServiceCheck then
                                JobCenter:startHarvest(v.jobRequired, v['harvest'].msg, v['harvest'].anim)
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

function JobCenter:startHarvest(job, msg, anim)
    if not JobCenter.inHarvest then
        JobCenter.inHarvest = true;
        exports["ac"]:ExecuteServerEvent('jobcenter:startHarvest', job)

        JobCenter:progress(msg, anim)
    end
end

RegisterNetEvent('jobcenter:stopHarvest')
AddEventHandler('jobcenter:stopHarvest', function()
    JobCenter.inHarvest = false;
    FreezeEntityPosition(PlayerPedId(), false)
end)