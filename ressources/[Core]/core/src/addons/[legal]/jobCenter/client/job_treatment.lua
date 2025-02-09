
JobCenter.inTreatment = false;

CreateThread(function()
    for k,v in pairs(Config['jobcenter']['points']) do
        for k2, v2 in pairs(v['treatment'].localisations) do
            ZoneManager:createZoneWithMarker(v2, 15, 5, {
                onPress = {control = 38, action = function(zone)
                        if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == v.jobRequired then
                            if JobCenter.ServiceCheck then
                                JobCenter:startTreatment(v.jobRequired, v['treatment'].msg, v['treatment'].anim)
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

function JobCenter:startTreatment(job, msg, anim)
    if not JobCenter.inTreatment then
        JobCenter.inTreatment = true;
        exports["ac"]:ExecuteServerEvent('jobcenter:startTreatment', job)
        JobCenter:progress(msg, anim)
    end
end

RegisterNetEvent('jobcenter:stopTreatment')
AddEventHandler('jobcenter:stopTreatment', function()
    JobCenter.inTreatment = false;
    FreezeEntityPosition(PlayerPedId(), false)
end)