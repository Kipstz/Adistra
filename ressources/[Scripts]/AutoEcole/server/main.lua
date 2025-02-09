TriggerEvent('framework:init', function(obj) Framework = obj end)

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(src)
	TriggerEvent('licenses:getLicenses', src, function(licenses)
		TriggerClientEvent('AutoEcole:loadLicenses', src, licenses)
	end)
end)

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Wait(5000)
        local xPlayers = Framework.GetExtendedPlayers()

        for _, xPlayer in pairs(xPlayers) do
			TriggerEvent('licenses:getLicenses', xPlayer.source, function(licenses)
				TriggerClientEvent('AutoEcole:loadLicenses', xPlayer.source, licenses)
			end)
        end
    end
end)

RegisterNetEvent('AutoEcole:addLicense')
AddEventHandler('AutoEcole:addLicense', function(type)
	local src = source

	TriggerEvent('licenses:addLicense', src, type, function()
		TriggerEvent('licenses:getLicenses', src, function(licenses)
			TriggerClientEvent('AutoEcole:loadLicenses', src, licenses)
		end)
	end)
end)

RegisterNetEvent('AutoEcole:pay')
AddEventHandler('AutoEcole:pay', function(price)
	local src = source
	local xPlayer = Framework.GetPlayerFromId(src)

	if xPlayer['accounts'].getMoney() >= price then
		xPlayer['accounts'].removeMoney(price)
		xPlayer.showNotification("Vous avez payer ~g~"..price.."$ ~s~!")
	else
		xPlayer.showNotification("~r~Vous n'avez pas assez d'argent !")
	end
end)

local allEvents = {
	['AutoEcole:pay'] = false,
	['AutoEcole:addLicense'] = false,
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