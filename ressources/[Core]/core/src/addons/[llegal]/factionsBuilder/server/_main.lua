
Factions = {}
SharedFactions = {}

function SaveFact(name, data, vehicle) 
    MySQL.Sync.execute("UPDATE factions SET `data` = @data, `vehicle` = @vehicle WHERE `name` = @name", {
        ["@name"] = name,
        ["@data"] = json.encode(data),
        ["@vehicle"] = json.encode(vehicle)
    })  
end

CreateThread(function()
    local SaveCount = 0

    while true do 
        for k,v in pairs(SharedFactions) do 
            SaveFact(v.name, v.data, v.vehicle)
        end
        
        print("[^6FactionsBuilder^0] Les factions ont été sauvegarder !")

        Wait(60000 * 10)
    end
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 60 then
		CreateThread(function()
			Wait(50000)
            for k,v in pairs(SharedFactions) do 
                SaveFact(v.name, v.data, v.vehicle)
            end
		end)
	end
end)

Factions.Jobs2 = {}

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM jobs2', {}, function(result)
		for i = 1, #result, 1 do
			Factions.Jobs2[result[i].name] = result[i]
			Factions.Jobs2[result[i].name].grades = {}
		end
	
		MySQL.Async.fetchAll('SELECT * FROM job2_grades', {}, function(result2)
			for i = 1, #result2, 1 do
                --print(result2[i].job2_name)
				Factions.Jobs2[result2[i].job2_name].grades[tostring(result2[i].grade)] = result2[i]
			end
		end)
	end)
end)