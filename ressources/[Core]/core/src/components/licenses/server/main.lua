function AddLicense(target, type, cb)
	local xPlayer = Framework.GetPlayerFromId(target)

	if xPlayer then
		MySQL.insert('INSERT INTO character_licenses (type, characterId) VALUES (?, ?)', {type, xPlayer.characterId},
		function(rowsChanged)
			if cb then
				cb()
			end
		end)
	else
		if cb then
			cb()
		end
	end
end

function RemoveLicense(target, type, cb)
	local xPlayer = Framework.GetPlayerFromId(target)

	if xPlayer then
		MySQL.update('DELETE FROM character_licenses WHERE type = ? AND characterId = ?', {type, xPlayer.characterId},
		function(rowsChanged)
			if cb then
				cb()
			end
		end)
	else
		if cb then
			cb()
		end
	end
end

function GetLicense(type, cb)
	MySQL.scalar('SELECT label FROM licenses WHERE type = ?', {type},function(result)
		cb({type = type, label = result})
	end)
end

function GetLicenses(target, cb)
	local xPlayer = Framework.GetPlayerFromId(target)
	MySQL.query('SELECT character_licenses.type, licenses.label FROM character_licenses LEFT JOIN licenses ON character_licenses.type = licenses.type WHERE characterId = ?', {xPlayer.characterId},
	function(result)
		cb(result)
	end)
end

function CheckLicense(target, type, cb)
	local xPlayer = Framework.GetPlayerFromId(target)

	if xPlayer then
		MySQL.scalar('SELECT type FROM character_licenses WHERE type = ? AND characterId = ?', {type, xPlayer.characterId},
		function(result)
			if result then
				cb(true)
			else
				cb(false)
			end
		end)
	else
		cb(false)
	end
end

function GetLicensesList(cb)
	MySQL.query('SELECT type, label FROM licenses',
	function(result)
		cb(result)
	end)
end

RegisterNetEvent("licenses:addLicense")
AddEventHandler("licenses:addLicense", function(target, type, cb)
	AddLicense(target, type, cb)
end)

RegisterNetEvent("licenses:removeLicense")
AddEventHandler("licenses:removeLicense", function(target, type, cb)
	RemoveLicense(target, type, cb)
end)

RegisterNetEvent("licenses:getLicense")
AddEventHandler("licenses:getLicense", function(type, cb)
	GetLicense(type, cb)
end)

RegisterNetEvent("licenses:getLicenses")
AddEventHandler("licenses:getLicenses", function(target, cb)
	GetLicenses(target, cb)
end)

RegisterNetEvent("licenses:checkLicense")
AddEventHandler("licenses:checkLicense", function(target, type, cb)
	CheckLicense(target, type, cb)
end)

RegisterNetEvent("licenses:getLicensesList")
AddEventHandler("licenses:getLicensesList", function(cb)
	GetLicensesList(cb)
end)

Framework.RegisterServerCallback("licenses:getLicense", function(source, cb, type)
	GetLicense(type, cb)
end)

Framework.RegisterServerCallback("licenses:getLicenses", function(source, cb, target)
	GetLicenses(target, cb)
end)

Framework.RegisterServerCallback("licenses:checkLicense", function(source, cb, target, type)
	CheckLicense(target, type, cb)
end)

Framework.RegisterServerCallback("licenses:getLicensesList", function(source, cb)
	GetLicensesList(cb)
end)

Framework.RegisterCommand('givelicense', {'owner'}, function(xPlayer, args, showError)

	TriggerEvent("licenses:getLicense", args.license, function(licenses)
		if next(licenses) then
			TriggerEvent("licenses:addLicense", args.playerId.source, args.license)
			args.playerId.showNotification("~g~Vous avez une nouvelle license !")
		else
			xPlayer.showNotification("~r~Cette license n'existe pas !")
		end
	end)

end, true, {help = "Give une license à un Joueur", validate = true, arguments = {
	{name = 'playerId', help = 'ID du Joueur', type = 'player'},
	{name = 'license', help = 'Type de License', type = 'string'}
}})
