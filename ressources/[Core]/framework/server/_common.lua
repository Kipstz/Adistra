

------------------------------------------------------------------------------------------------------------------------------------
Framework.Players = {}
------------------------------------------------------------------------------------------------------------------------------------
Framework.ServerCallbacks = {}
Framework.RegisteredCommands = {}

AddEventHandler('framework:init', function(cb)
	cb(Framework)
end)

local function StartDBSync()
	CreateThread(function()
		while true do
			Wait(10 * 60 * 1000)
			Framework.SavePlayers()
		end
	end)
end

MySQL.ready(function()
	local items = MySQL.query.await('SELECT * FROM items')
	for k, v in ipairs(items) do
		Framework.ITEMS.List[v.name] = {
			label = v.label,
			weight = v.weight,
			canRemove = v.can_remove
		}
	end

	local Jobs = {}
	local jobs = MySQL.query.await('SELECT * FROM jobs')

	for _, v in ipairs(jobs) do
		Jobs[v.name] = v
		Jobs[v.name].grades = {}
	end

	local jobGrades = MySQL.query.await('SELECT * FROM job_grades')

	for _, v in ipairs(jobGrades) do
		if Jobs[v.job_name] then
			Jobs[v.job_name].grades[tostring(v.grade)] = v
		else
			print(('[^3WARNING^7] Ignoring job grades for ^5"%s"^0 due to missing job'):format(v.job_name))
		end
	end

	for _, v in pairs(Jobs) do
		if Framework.Table.SizeOf(v.grades) == 0 then
			Jobs[v.name] = nil
			print(('[^3WARNING^7] Ignoring job ^5"%s"^0due to no job grades found'):format(v.name))
		end
	end

	if not Jobs then
		Framework.JobsList['unemployed'] = {
			label = 'Unemployed',
			grades = {
				['0'] = {
					grade = 0,
					name = 'unemployed',
					label = 'Unemployed',
				}
			}
		}
	else
		Framework.JobsList = Jobs
	end

	local Jobs2 = {}
	local jobs2 = MySQL.query.await('SELECT * FROM jobs2')

	for _, v in ipairs(jobs2) do
		Jobs2[v.name] = v
		Jobs2[v.name].grades = {}
	end

	local job2Grades = MySQL.query.await('SELECT * FROM job2_grades')

	for _, v in ipairs(job2Grades) do
		if Jobs2[v.job2_name] then
			Jobs2[v.job2_name].grades[tostring(v.grade)] = v
		else
			print(('[^3WARNING^7] Ignoring job2 grades for ^5"%s"^0 due to missing job2'):format(v.job2_name))
		end
	end

	for _, v in pairs(Jobs2) do
		if Framework.Table.SizeOf(v.grades) == 0 then
			Jobs2[v.name] = nil
			print(('[^3WARNING^7] Ignoring job2 ^5"%s"^0due to no job2 grades found'):format(v.name))
		end
	end

	if not Jobs2 then
		Framework.Jobs2List['unemployed2'] = {
			label = 'Unemployed2',
			grades = {
				['0'] = {
					grade = 0,
					name = 'unemployed2',
					label = 'Unemployed2',
				}
			}
		}
	else
		Framework.Jobs2List = Jobs2
	end

	print('[^2INFO^7] ^1Framework ^0initialisé')
	StartDBSync()
	Framework.StartPositionSync()
	Wait(15000)
	Framework.StartAideCheck()
end)

RegisterServerEvent('framework:triggerServerCallback')
AddEventHandler('framework:triggerServerCallback', function(name, requestId, ...)
	local playerId = source

	Framework.TriggerServerCallback(name, requestId, playerId, function(...)
		TriggerClientEvent('framework:serverCallback', playerId, requestId, ...)
	end, ...)
end)

local allEvents = {
	-- FRAMEWORK --
	['framework:giveInventoryItem'] = false,
	['framework:removeInventoryItem'] = false,
	['framework:useItem'] = false,
	--['framework:updateWeaponAmmo'] = false,
	['framework:onPickup'] = false,
}

local fiveguard_resource = "ac"
AddEventHandler("fg:ExportsLoaded", function(fiveguard_res, res)
    if res == "*" or res == GetCurrentResourceName() then
        fiveguard_resource = fiveguard_res
        for event,cross_scripts in pairs(allEvents) do
            local retval, errorText = exports[fiveguard_res]:RegisterSafeEvent(event, {
                ban = true,
                log = true
            }, cross_scripts)
            if not retval then
                print("[fiveguard safe-events] "..errorText)
            end
        end
    end
end)