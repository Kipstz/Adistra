
Framework.RegisterServerCallback("factions:getFactionMoney", function(src, cb, faction)
    cb(SharedFactions[faction].data.accounts['black_money'])
end)

Framework.RegisterServerCallback("factions:getMembres", function(source, cb, faction)
	if source == 0 then
		MySQL.Async.fetchAll("SELECT characterId, identity, identifier, jobs FROM characters WHERE json_value(jobs,'$.job2.name')=@job2", {
			['@job2'] = faction
		}, function(results)
			local membres = {}

			for i = 1, #results, 1 do
				local identity = json.decode(results[i].identity)
				local jobs = json.decode(results[i].jobs)
				table.insert(membres, {
					name = (identity.firstname or 'Inconnu') .. ' ' .. (identity.lastname or 'Inconnu'),
					characterId = results[i].characterId,
					identifier = results[i].identifier,
					job2 = {
						name = jobs['job2'].name,
						label = Factions.Jobs2[jobs['job2'].name].label,
						grade =jobs['job2'].grade,
						grade_name = Factions.Jobs2[jobs['job2'].name].grades[tostring(jobs['job2'].grade)].name,
						grade_label = Factions.Jobs2[jobs['job2'].name].grades[tostring(jobs['job2'].grade)].label
					}
				})
			end

			cb(membres)
		end)
	else
		local xPlayer = Framework.GetPlayerFromId(source)

		if xPlayer['jobs'].job2.name == faction then
			MySQL.Async.fetchAll("SELECT characterId, identity, identifier, jobs FROM characters WHERE json_value(jobs,'$.job2.name')=@job2", {
				['@job2'] = faction
			}, function(results)
				local membres = {}

				for i = 1, #results, 1 do
					local identity = json.decode(results[i].identity)
					local jobs = json.decode(results[i].jobs)
					table.insert(membres, {
						name = (identity.firstname or 'Inconnu') .. ' ' .. (identity.lastname or 'Inconnu'),
						identifier = results[i].identifier,
						characterId = results[i].characterId,
						job2 = {
							name = jobs['job2'].name,
							label = Factions.Jobs2[jobs['job2'].name].label,
							grade =jobs['job2'].grade,
							grade_name = Factions.Jobs2[jobs['job2'].name].grades[tostring(jobs['job2'].grade)].name or "Inconnu",
							grade_label = Factions.Jobs2[jobs['job2'].name].grades[tostring(jobs['job2'].grade)].label or "Inconnu"
						}
					})
				end

				cb(membres)
			end)
		else
			cb({})
		end
	end
end)

Framework.RegisterServerCallback("factions:getJob2", function(source, cb, faction)
	local job2 = json.decode(json.encode(Factions.Jobs2[faction]))
	local grades = {}

	for k, v in pairs(job2.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job2.grades = grades
	cb(job2)
end)

RegisterServerEvent('factions:promote2')
AddEventHandler('factions:promote2', function(characterId, identifier, job2, grade2)
    local xTarget = Framework.GetPlayerFromIdentifier(identifier)

    if xTarget then
        xTarget['jobs'].setJob2(job2, grade2)

       xTarget.showNotification("~r~Vous avez été promu !")
    else
		MySQL.Async.fetchAll("SELECT jobs FROM characters WHERE characterId = ?", {characterId}, function(results)
			local jobs = json.decode(results[1].jobs)

			jobs['job2'].name = job2
			jobs['job2'].grade = grade2

			MySQL.Async.execute("UPDATE characters SET jobs = @jobs WHERE characterId = @characterId", {
				['@jobs'] = json.encode(jobs),
				['@characterId'] = characterId
			})
		end)
    end
end)

RegisterServerEvent('factions:virer2')
AddEventHandler('factions:virer2', function(characterId, identifier)
    local xTarget = Framework.GetPlayerFromIdentifier(identifier)

    if xTarget then
        xTarget['jobs'].setJob2('unemployed2', 0)

       xTarget.showNotification("~r~Vous avez été virer de votre Faction !")
    else
		MySQL.Async.fetchAll("SELECT jobs FROM characters WHERE characterId = ?", {characterId}, function(results)
			local jobs = json.decode(results[1].jobs)

			jobs['job2'].name = 'unemployed2'
			jobs['job2'].grade = 0

			MySQL.Async.execute("UPDATE characters SET jobs = @jobs WHERE characterId = @characterId", {
				['@jobs'] = json.encode(jobs),
				['@characterId'] = characterId
			})
		end)
    end
end)

RegisterServerEvent('factions:washMoney')
AddEventHandler('factions:washMoney', function(faction, amount)
	local src = source;
    local xPlayer = Framework.GetPlayerFromId(src)
	local myMoney = xPlayer['accounts'].getAccount('black_money').money

    if tonumber(myMoney) >= amount then
		xPlayer['accounts'].removeAccountMoney('black_money', amount)
		xPlayer['accounts'].addAccountMoney('money', amount)
		exports['Logs']:createLog({EmbedMessage = ("(Coffre Factions) **%s** à blanchi **%s**$, faction: **%s**"):format(GetPlayerName(source), amount, faction), player_id = source, channel = 'interactions'})
	else
        xPlayer.showNotification("~r~Montant Invalide !")
	end
end)
