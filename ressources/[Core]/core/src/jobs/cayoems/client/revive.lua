CayoEmsJob.reaPlayer = function(closestPlayer)
	Framework.TriggerServerCallback("AmbulanceJob:getItemAmount", function(qtty)
		if qtty > 0 then
            local tarPed = GetPlayerPed(closestPlayer)
            local health = GetEntityHealth(tarPed)
            
			if health == 0 then
                local plyPed = PlayerPedId()
                
				CreateThread(function()
					Framework.ShowNotification("Réanimation en Cours...")
                    TaskStartScenarioInPlace(plyPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                    Wait(10000)
                    ClearPedTasks(plyPed)

                    if GetEntityHealth(tarPed) == 0 then
						TriggerServerEvent("AmbulanceJob:revive", GetPlayerServerId(closestPlayer))
                    else
                      Framework.ShowNotification("La personne n'est pas inconsciente !")
                    end
                end)
			else
				Framework.ShowNotification("La personne n'est pas inconsciente !")
			end
		else
            Framework.ShowNotification("Vous n'avez pas de Défibrillateur !")
        end
    end, 'defibrillateur')
end

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end

	local t, i = {}, 1

	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end

	return t
end
