
CreateThread(function()
	local plyKO = false;
	local count = 60;
	local waiting = 15;

	while true do
		wait = 1000;

		local plyPed = PlayerPedId()

		if inFight then
			if myHealth < 130 then
				waiting = 15;

				Framework.ShowNotification("~r~Tu es assommé !~s~")
				plyKO = true;
				SetEntityHealth(plyPed, 116)
			end
		end

		if plyKO then
			wait = 5;
            local plyID = PlayerId()

			SetPlayerInvincible(plyID, true)
			DisablePlayerFiring(plyID, true)
			SetPedToRagdoll(plyPed, 1000, 1000, 0, 0, 0, 0)
			ResetPedRagdollTimer(plyPed)
				
			if waiting >= 0 then
				count = count - 1

				if count == 0 then
					count = 60;
					waiting = waiting - 1;
					SetEntityHealth(plyPed, GetEntityHealth(plyPed) + 4)
				end
			else
				SetPlayerInvincible(plyID, false)
				plyKO = false;
			end
		end

		Wait(wait)
	end
end)

CreateThread(function()
	while true do
        local plyPed = PlayerPedId()

		inFight = IsPedInMeleeCombat(plyPed)
		myHealth = GetEntityHealth(plyPed)

		-- SetPedConfigFlag(plyPed, 35, false)
		-- SetPedConfigFlag(plyPed, 149, true)
		-- SetPedConfigFlag(plyPed, 438, true)

		Wait(900)
	end
end)
