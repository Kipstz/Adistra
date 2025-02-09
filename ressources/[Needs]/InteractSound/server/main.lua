TriggerEvent('framework:init', function(obj) Framework = obj end)

RegisterServerEvent('InteractSound_SV:PlayOnOne')
AddEventHandler('InteractSound_SV:PlayOnOne', function(clientNetId, soundFile, soundVolume)
	TriggerClientEvent('InteractSound_CL:PlayOnOne', clientNetId, soundFile, soundVolume)
end)

RegisterServerEvent('InteractSound_SV:PlayOnSource')
AddEventHandler('InteractSound_SV:PlayOnSource', function(soundFile, soundVolume)
	TriggerClientEvent('InteractSound_CL:PlayOnOne', source, soundFile, soundVolume)
end)

RegisterServerEvent('InteractSound_SV:PlayOnAll')
AddEventHandler('InteractSound_SV:PlayOnAll', function(soundFile, soundVolume)
	local _source = source
	print('User played a sound : Sound : ' .. soundFile .. ' | ' .. GetPlayerName(_source) .. ' [' .. _source .. '] - ' .. Framework.GetIdentifier(_source))
	TriggerClientEvent('InteractSound_CL:PlayOnAll', -1, soundFile, soundVolume)
end)

RegisterServerEvent('InteractSound_SV:PlayWithinDistance')
AddEventHandler('InteractSound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
	local _source = source
	print('User played a sound : Sound : ' .. soundFile .. ' | ' .. maxDistance .. ' | ' .. GetPlayerName(_source) .. ' [' .. _source .. '] - ' .. Framework.GetIdentifier(_source))
	TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, source, maxDistance, soundFile, soundVolume)
end)

local allEvents = {
    ['InteractSound_SV:PlayOnOne'] = false,
    ['InteractSound_SV:PlayOnSource'] = false,
    ['InteractSound_SV:PlayOnAll'] = false,
    ['InteractSound_SV:PlayWithinDistance'] = false,
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