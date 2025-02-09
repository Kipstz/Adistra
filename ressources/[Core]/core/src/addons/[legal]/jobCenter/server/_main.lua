
JobCenter = {}

RegisterNetEvent('jobcenter:newJob')
AddEventHandler('jobcenter:newJob', function(job)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src);

    if Framework.JOBS:DoesJobExist(job, 0) then
        xPlayer['jobs'].setJob(job, 0)
        xPlayer.showNotification("~g~Vous avez un nouveau métier !~s~")
    else
        print("^1Erreur JOBCENTER: Le métier "..job.." n'existe pas !^0")
        xPlayer.showNotification("~r~Une erreur s'est produite.~s~")
    end
end)