
RegisterNetEvent('framework:setJob')
AddEventHandler('framework:setJob', function(job)
	Framework.PlayerData.jobs['job'] = job
end)

RegisterNetEvent('framework:setJob2')
AddEventHandler('framework:setJob2', function(job2)
	Framework.PlayerData.jobs['job2'] = job2
end)