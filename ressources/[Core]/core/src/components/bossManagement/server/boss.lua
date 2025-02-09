
Framework.RegisterServerCallback("bossManagement:getSocietyAccount", function(src, cb, societeName)
    cb(SharedSocietes[societeName].data.accounts['money'])
end)

RegisterServerEvent('bossManagement:getSocietyAccount')
AddEventHandler('bossManagement:getSocietyAccount', function(societeName, cb)
	if SharedSocietes[societeName] ~= nil then
		cb(SharedSocietes[societeName].data["accounts"]['money'])
	else
		print("[^6SocietyManagement^0] Tentative de get l'argent d'une société inconnu par un script, société: "..societeName)

		cb(0)
	end
end)

RegisterServerEvent('bossManagement:depositMoneybyOther')
AddEventHandler('bossManagement:depositMoneybyOther', function(societeName, amount)
	if SharedSocietes[societeName] ~= nil then
		SharedSocietes[societeName].data["accounts"]['money'] = SharedSocietes[societeName].data["accounts"]['money'] + amount
	else
		print("[^6SocietyManagement^0] Tentative de dépot d'argent dans une société inconnu par un script, société: "..societeName)
	end
end)

RegisterServerEvent('bossManagement:removeMoneybyOther')
AddEventHandler('bossManagement:removeMoneybyOther', function(societeName, amount)
	if SharedSocietes[societeName] ~= nil then
		SharedSocietes[societeName].data["accounts"]['money'] = SharedSocietes[societeName].data["accounts"]['money'] - amount
	else
		print("[^6SocietyManagement^0] Tentative de retrait d'argent dans une société inconnu par un script, société: "..societeName)
	end
end)

RegisterServerEvent('bossManagement:depositMoney')
AddEventHandler('bossManagement:depositMoney', function(societeName, amount)
    local xPlayer = Framework.GetPlayerFromId(source)
    local myMoney = xPlayer['accounts'].getAccount('money').money

    if tonumber(myMoney) >= amount then
        xPlayer['accounts'].removeAccountMoney('money', amount)
        SharedSocietes[societeName].data["accounts"]['money'] = SharedSocietes[societeName].data["accounts"]['money'] + amount
		exports['Logs']:createLog({EmbedMessage = ("(Coffre Société) **%s** à déposer **%s**$, société: **%s**"):format(GetPlayerName(source), amount, societeName), player_id = source, channel = 'interactions'})
    else
        xPlayer.showNotification("~r~Montant Invalide !")
    end
end)

RegisterServerEvent('bossManagement:removeMoney')
AddEventHandler('bossManagement:removeMoney', function(societeName, amount)
    local xPlayer = Framework.GetPlayerFromId(source)

	if(xPlayer['jobs'].getJob().name ~= societeName) then
        exports['ac']:fg_BanPlayer(source, 'Tentative bossManagement:removeMoney ('..societeName..') (Noob)', true)
		return
    end

    if SharedSocietes[societeName].data["accounts"]['money'] >= amount then
        SharedSocietes[societeName].data["accounts"]['money'] = SharedSocietes[societeName].data["accounts"]['money'] - amount
        xPlayer['accounts'].addAccountMoney('money', amount)
		exports['Logs']:createLog({EmbedMessage = ("(Coffre Société) **%s** à retirer **%s**$, société: **%s**"):format(GetPlayerName(source), amount, societeName), player_id = source, channel = 'interactions'})
    else 
        xPlayer.showNotification("~r~Montant Invalide !")
    end
end)

Framework.RegisterServerCallback("bossManagement:getEmployees", function(source, cb, societyName)
	if source == 0 then
		MySQL.Async.fetchAll("SELECT characterId, identity, identifier, jobs FROM characters WHERE json_value(jobs,'$.job.name')=@job", {
			['@job'] = societyName
		}, function(results)
			local employees = {}

			for i = 1, #results, 1 do
				local identity = json.decode(results[i].identity)
				local jobs = json.decode(results[i].jobs)

				table.insert(employees, {
					name = (identity.firstname or 'Inconnu') .. ' ' .. (identity.lastname or 'Inconnu'),
					characterId = results[i].characterId,
					identifier = results[i].identifier,
					job = {
						name = jobs['job'].name,
						label = bossManagement.Jobs[jobs['job'].name].label,
						grade =jobs['job'].grade,
						grade_name = bossManagement.Jobs[jobs['job'].name].grades[tostring(jobs['job'].grade)].name,
						grade_label = bossManagement.Jobs[jobs['job'].name].grades[tostring(jobs['job'].grade)].label
					}
				})
			end

			cb(employees)
		end)
	else
		local xPlayer = Framework.GetPlayerFromId(source)

		if xPlayer['jobs'].job.name == societyName then
			MySQL.Async.fetchAll("SELECT characterId, identity, identifier, jobs FROM characters WHERE json_value(jobs,'$.job.name')=@job", {
				['@job'] = societyName
			}, function(results)
				local employees = {}

				for i = 1, #results, 1 do
					local identity = json.decode(results[i].identity)
					local jobs = json.decode(results[i].jobs)
					
					if identity ~= nil then 
						table.insert(employees, {
							name = (identity.firstname or 'Inconnu') .. ' ' .. (identity.lastname or 'Inconnu'),
							characterId = results[i].characterId,
							identifier = results[i].identifier,
							job = {
								name = jobs['job'].name,
								label = bossManagement.Jobs[jobs['job'].name].label,
								grade =jobs['job'].grade,
								grade_name = bossManagement.Jobs[jobs['job'].name].grades[tostring(jobs['job'].grade)].name,
								grade_label = bossManagement.Jobs[jobs['job'].name].grades[tostring(jobs['job'].grade)].label
							}
						})
					else
						table.insert(employees, {
							name = ('Inconnu') .. ' ' .. ('Inconnu'),
							characterId = results[i].characterId,
							identifier = results[i].identifier,
							job = {
								name = jobs['job'].name,
								label = bossManagement.Jobs[jobs['job'].name].label,
								grade = jobs['job'].grade,
								grade_name = bossManagement.Jobs[jobs['job'].name].grades[tostring(jobs['job'].grade)].name,
								grade_label = bossManagement.Jobs[jobs['job'].name].grades[tostring(jobs['job'].grade)].label
							}
						})
					end
				end

				cb(employees)
			end)
		else
			cb({})
		end
	end
end)

Framework.RegisterServerCallback("bossManagement:getJob", function(source, cb, society)
	local job = json.decode(json.encode(bossManagement.Jobs[society]))
	local grades = {}

	for k, v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades
	cb(job)
end)

RegisterServerEvent('bossManagement:promote')
AddEventHandler('bossManagement:promote', function(characterId, identifier, job, grade)
	local xPlayer = Framework.GetPlayerFromId(source)
    local xTarget = Framework.GetPlayerFromIdentifier(identifier)

	if(xPlayer) then
		if(xPlayer['jobs'].getJob().name == job) then
			if xTarget then
				xTarget['jobs'].setJob(job, grade)

			xTarget.showNotification("~r~Vous avez été promu !")
			else
				MySQL.Async.fetchAll("SELECT jobs FROM characters WHERE characterId = ?", {characterId}, function(results)
					local jobs = json.decode(results[1].jobs)

					jobs['job'].name = job
					jobs['job'].grade = grade

					MySQL.Async.execute("UPDATE characters SET jobs = @jobs WHERE characterId = @characterId", {
						['@jobs'] = json.encode(jobs),
						['@characterId'] = characterId
					})
				end)
			end
		else
			exports['ac']:fg_BanPlayer(src, 'Tenative de setJob par bossPromote (Noob)', true)
		end
	end
end)

RegisterServerEvent('bossManagement:virer')
AddEventHandler('bossManagement:virer', function(characterId, identifier)
    local xTarget = Framework.GetPlayerFromIdentifier(identifier)

    if xTarget then
        xTarget['jobs'].setJob('unemployed', 0)

       xTarget.showNotification("~r~Vous avez été virer de votre Travail !")
    else
		MySQL.Async.fetchAll("SELECT jobs FROM characters WHERE characterId = ?", {characterId}, function(results)
			local jobs = json.decode(results[1].jobs)

			jobs['job'].name = 'unemployed'
			jobs['job'].grade = 0

			MySQL.Async.execute("UPDATE characters SET jobs = @jobs WHERE characterId = @characterId", {
				['@jobs'] = json.encode(jobs),
				['@characterId'] = characterId
			})
		end)
    end
end)

