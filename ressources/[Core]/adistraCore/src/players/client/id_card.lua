local open = false

RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function( data, type )
	open = true
    startCanNotOpen()
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end)

function startCanNotOpen()
	Citizen.CreateThread(function()
		while open do
			Citizen.Wait(0)
			if IsControlJustReleased(0, 322) or IsControlJustReleased(0, 177) then
				SendNUIMessage({
					action = "close"
				})
				open = false
			end
		end
	end)
end