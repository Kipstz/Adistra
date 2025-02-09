
FactionsBuilder = {}

local function InitGangs()
    MySQL.Async.fetchAll('SELECT * FROM factions', {}, function(data)
        for k,v in pairs(data) do
            if not SharedFactions[v.name] then 
                SharedFactions[v.name] = {}
                SharedFactions[v.name].name = v.name 
                SharedFactions[v.name].label = v.label 
                SharedFactions[v.name].params = json.decode(v.params)
                SharedFactions[v.name].coords = json.decode(v.coords)
                SharedFactions[v.name].data = json.decode(v.data)
                SharedFactions[v.name].vehicle = json.decode(v.vehicle)
            end
        end

        FactionsLoaded = true
    end)
end

CreateThread(function()
    while SharedFactions == nil do
        Wait(5)
    end
    InitGangs()
end)

Framework.RegisterServerCallback("factionsBuilder:getFactions", function(src, cb)
    cb(SharedFactions)
end)

-- FACTIONS BUILDER --

RegisterServerEvent('factionsBuilder:addFaction')
AddEventHandler('factionsBuilder:addFaction', function(faction)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    if not Framework.JOBS2:DoesJob2Exist(faction.name, 0) then
        MySQL.Async.execute('INSERT INTO jobs2 (name, label) VALUES (@name, @label)', {
            ['@name'] = faction.name,
            ['@label'] = faction.label
        }, function(rowsChanged)

        end)
    else
        print("[FACTIONSBUILDER] CANCELED, existe déjà")
    end

    for k,v in pairs(faction.grades) do
        if not Framework.JOBS2:DoesJob2Exist(faction.name, v.id) then
            MySQL.Async.execute('INSERT INTO job2_grades (job2_name, grade, name, label) VALUES (@job2_name, @grade, @name, @label)', {
                ['@job2_name'] = faction.name,
                ['@grade'] = v.id,
                ['@name'] = v.name,
                ['@label'] = v.label
            })
        else
            print("[FACTIONSBUILDER] CANCELED, existe déjà")
        end
    end
    
    MySQL.query("INSERT INTO factions (`name`, `label`, `params`, `coords`, `data`, `vehicle`) VALUES (?, ?, ?, ?, ?, ?)", {
        faction.name, faction.label, json.encode(faction.params), json.encode(faction.coords), json.encode(faction.data), json.encode(faction.vehicle)
    })

    xPlayer.showNotification("Vous avez créer une faction !")
    TriggerClientEvent('factionsBuilder:updateFaction', -1, faction)
    exports['framework']:ReloadJobs()
end)

RegisterServerEvent('factionsBuilder:editFaction')
AddEventHandler('factionsBuilder:editFaction', function(faction)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    MySQL.query("UPDATE factions SET `name` = ?, `label` = ?, `params` = ?, `coords` = ?, `data` = ?, `vehicle` = ? WHERE name = ?", {
        faction.name, faction.label, json.encode(faction.params), json.encode(faction.coords), json.encode(faction.data), json.encode(faction.vehicle), faction.name
    })

    xPlayer.showNotification("Vous avez modifier la faction !")
    TriggerClientEvent('factionsBuilder:updateFaction', -1, faction)
    exports['framework']:ReloadJobs()
end)

RegisterServerEvent('factionsBuilder:deleteFaction')
AddEventHandler('factionsBuilder:deleteFaction', function(factionName)
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)

    MySQL.query("DELETE FROM factions WHERE name = ?", {factionName})
    MySQL.query('DELETE FROM jobs2 WHERE name = ?', {factionName})
    MySQL.query('DELETE FROM job2_grades WHERE job2_name = ?', {factionName})

    xPlayer.showNotification("Vous avez supprimer la faction !")
    TriggerClientEvent('factionsBuilder:deleteFaction', -1, factionName)
    exports['framework']:ReloadJobs()
end)

Framework.RegisterCommand('fa_builder', { 'superadmin', 'owner' }, function(xPlayer, args, showError)
    xPlayer.triggerEvent('factionsBuilder:openBuilder')
end, true, {help = "Gangs Builder", validate = true})