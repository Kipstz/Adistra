bossManagement = {}

SharedSocietes = {}

bossManagement.Jobs = {}

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function(result)
		for i = 1, #result, 1 do
			bossManagement.Jobs[result[i].name] = result[i]
			bossManagement.Jobs[result[i].name].grades = {}
		end
	
		MySQL.Async.fetchAll('SELECT * FROM job_grades', {}, function(result2)
			for i = 1, #result2, 1 do
				bossManagement.Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
			end
		end)
	end)
end)

local function InitSocietes()
    MySQL.Async.fetchAll('SELECT * FROM societes', {}, function(data)
        for k,v in pairs(data) do
            if not SharedSocietes[v.name] then 
                SharedSocietes[v.name] = {}
                SharedSocietes[v.name].name = v.name 
                SharedSocietes[v.name].label = v.label 
                SharedSocietes[v.name].data = json.decode(v.data)
            end
        end

        SocietesLoaded = true
    end)
end

CreateThread(function()
    InitSocietes()
end)

function SaveSociety(name, data, vehicle) 
    MySQL.Sync.execute("UPDATE societes SET `data` = @data WHERE `name` = @name", {
        ["@name"] = name,
        ["@data"] = json.encode(data)
    })  
end

CreateThread(function()
    while true do 
        for k,v in pairs(SharedSocietes) do 
            SaveSociety(v.name, v.data)
        end

        print("[^6SocietyManagement^0] Les sociétés ont été sauvegarder !")

        Wait(60000 * 10)
    end
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 60 then
		CreateThread(function()
			Wait(50000)
            for k,v in pairs(SharedSocietes) do 
                SaveSociety(v.name, v.data)
            end
		end)
	end
end)

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Wait(5000)
        local xPlayers = Framework.GetExtendedPlayers()

        for _, xPlayer in pairs(xPlayers) do
            TriggerClientEvent('bossManagement:updateSocietes', xPlayer.source)
        end
    end
end)

Framework.RegisterServerCallback("bossManagement:getSocietes", function(src, cb)
    cb(SharedSocietes)
end)

Framework.RegisterCommand('society_add', { 'owner' }, function(xPlayer, args, showError)
    if xPlayer then
        xPlayer.showNotification("~r~Cette commande ne peut pas être utiliser en jeu !")
    end

    local defaultData = {
        accounts = {money = 0},
        items = {},
        weapons = {}
    }

    MySQL.query("INSERT INTO societes (name, label, data) VALUES (?, ?, ?)", {
        args.name, args.label, json.encode(defaultData)
    })

end, true, {help = "Créer une société", validate = true, arguments = {
	{name = 'name', help = "Nom de la société", type = 'string'},
    {name = 'label', help = "Label de la société", type = 'string'},
}})