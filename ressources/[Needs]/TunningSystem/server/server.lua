
Framework = nil

TriggerEvent('framework:init', function(obj) Framework = obj end)

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Wait(5000)
        local xPlayers = Framework.GetExtendedPlayers()

        for _, xPlayer in pairs(xPlayers) do
			if xPlayer ~= nil then
                xPlayer.triggerEvent('TunningSytem:update', xPlayer)
			end
        end
    end
end)

Framework.RegisterServerCallback('TunningSystem:used', function(src,cb, id, netid)
	local found = false;

	if not Config['tunningsystem'].localisations[id].used then
		found = true;

		if SendUsed then
			SendUsed(id, src)
		else
			print("TunningSystem: READ README, YOUR TRANSID IS INVALID, SCRIPT WON'T WORK")
		end
	end

    cb(found)

	while Config['tunningsystem'].localisations[id].used do
		Wait(10000)
		if GetPlayerPing(src) <= 0 then
			DeleteEntity(NetworkGetEntityFromNetworkId(netid))
			if SendUsed then
				SendUsed(id, false)
			else
				print("TunningSystem: READ README, YOUR TRANSID IS INVALID, SCRIPT WON'T WORK")
			end
		end
	end
end)

RegisterServerEvent('TunningSystem:used')
AddEventHandler('TunningSystem:used', function(id)
	local src = source;
	if Config['tunningsystem'].localisations[id].used == src then
		if SendUsed then
			SendUsed(id,false)
		else
			print("TunningSystem: READ README, YOUR TRANSID IS INVALID, SCRIPT WON'T WORK")
		end
	else
		--cheateeer
	end
end)

Framework.RegisterServerCallback('TunningSystem:canPay', function(source, cb, info)
    local config = Config['tunningsystem'].localisations[info.nomidaberto]
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)

    if config.society and config.job then
        TriggerEvent('bossManagement:getSocietyAccount', config.job, function(accountMoney)
            if tonumber(accountMoney) >= tonumber(info.price) then
                cb(true)
            else
                xPlayer.showNotification("~r~La Societé n'a pas assez d'argent !")
                cb(false)
            end
        end)
    else
        if xPlayer['accounts'].getAccount("bank").money >= tonumber(info.price) then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent('TunningSystem:payModifications')
AddEventHandler('TunningSystem:payModifications', function(price, id, vehprops)
    local config = Config['tunningsystem'].localisations[id]
    local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
    local async = false;
    local payed = false;

    if config.used == src then
        local permission = true;
        if config.job then
            permission = false;
            if xPlayer['jobs'].getJob().name == config.job then permission = true; end
        end

        if permission then
            if config.society and config.job then
                TriggerEvent('bossManagement:getSocietyAccount', config.job, function(accountMoney)
                    if tonumber(accountMoney) >= tonumber(price) then
                        TriggerEvent('bossManagement:removeMoneybyOther', config.job, tonumber(price))
                        payed = true;
						async = true;
                    else
						xPlayer.showNotification("~r~La Societé n'a pas assez d'argent !")
						async = true;
                    end
                end)
            else
                if xPlayer['accounts'].getAccount("bank").money >= tonumber(price) then
                    payed = true;
                    xPlayer['accounts'].removeAccountMoney("bank", tonumber(price))
					async = true;
                else
					async = true;
                end
                
            end
        else
            async = true;
        end
    else
        async = true;
    end

    while not async do
        Wait(100)
	end

    if payed then
        SaveVehicle(vehprops)
        TriggerClientEvent("TunningSystem:payAfter", src, id, payed)
        -- if Config.WebHook and Config.WebHook ~= "" then
        --     sendToDiscord('Mechanic Upgrade/Tuning Logs', "[Upgrade/Tuning Logs]\n\nTotal: ".. price .."\n\nVehicle Plate Number: [".. vehprops.plate .."]\nMechanic that worked on the vehicle: " .. xPlayer.name, 11750815)
        -- end
    end
end)

function SaveVehicle(vehprops)	
	MySQL.Async.fetchAll('SELECT vehicle FROM character_vehicles WHERE plate = @plate', {
		['@plate'] = vehprops.plate
	}, function(result)
		if result[1] then
			local vehicle = json.decode(result[1].vehicle)

			if vehprops.model == vehicle.model then
				MySQL.Async.execute('UPDATE character_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
					['@plate'] = vehprops.plate,
					['@vehicle'] = json.encode(vehprops)
				})
			end
		end
	end)
end

function SendUsed(id, type)
	Config['tunningsystem'].localisations[id].used = type
	TriggerClientEvent("TunningSystem:used", -1, id, type)
end