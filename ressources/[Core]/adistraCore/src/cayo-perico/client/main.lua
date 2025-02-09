CreateThread(function()
	local wait = 2500
	while true do
		if IsPauseMenuActive() then 
			wait = 0
			SetRadarAsExteriorThisFrame()
			SetRadarAsInteriorThisFrame(`h4_fake_islandx`, vec(4700.0, -5145.0), 0, 0)
        else 
            wait = 2500
        end
		Wait(wait)
	end
end)

CreateThread(function()
	Wait(2500)
	local islandLoaded = false
	local islandCoords = vector3(4840.571, -5174.425, 2.0)
	SetDeepOceanScaler(0.0)
	while true do
		local pCoords = GetEntityCoords(PlayerPedId())
        local distance = #(pCoords - islandCoords)
		if distance < 2000.0 then
			if not islandLoaded then
				islandLoaded = true
				Citizen.InvokeNative(0xF74B1FFA4A15FBEA, 1)
			end
		elseif islandLoaded then
			islandLoaded = false
			Citizen.InvokeNative(0xF74B1FFA4A15FBEA, 0)
		end
		Wait(5000)
	end
end)