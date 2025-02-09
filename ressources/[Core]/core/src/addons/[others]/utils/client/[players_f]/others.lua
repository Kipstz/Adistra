
-- huds = {
-- 	1  = WANTED_STARS
-- 	2  = WEAPON_ICON
-- 	3  = CASH
-- 	4  = MP_CASH
-- 	5  = MP_MESSAGE
-- 	6  = VEHICLE_NAME
-- 	7  = AREA_NAME
-- 	8  = VEHICLE_CLASS
-- 	9  = STREET_NAME
-- 	10 = HELP_TEXT
-- 	11 = FLOATING_HELP_TEXT_1
-- 	12 = FLOATING_HELP_TEXT_2
-- 	13 = CASH_CHANGE
-- 	14 = RETICLE
-- 	15 = SUBTITLE_TEXT
-- 	16 = RADIO_STATIONS
-- 	17 = SAVING_GAME
-- 	18 = GAME_STREAM
-- 	19 = WEAPON_WHEEL
-- 	20 = WEAPON_WHEEL_STATS
-- 	21 = HUD_COMPONENTS
-- 	22 = HUD_WEAPONS
-- },

CreateThread(function()
	ReplaceHudColourWithRgba(116, 80, 0, 255, 255)

	Wait(5000)

	for i = 1, 15 do
		EnableDispatchService(i, false)
	end

	local plyId = PlayerId()
	local plyPed = PlayerPedId()

	SetCanAttackFriendly(plyPed, true, false)
	NetworkSetFriendlyFireOption(true)

	ClearPlayerWantedLevel(plyId)
	SetMaxWantedLevel(0)
	SetDispatchCopsForPlayer(plyId, false)
	SetPlayerHealthRechargeMultiplier(plyId, 0.0)
	SetRunSprintMultiplierForPlayer(plyId, 1.0)
	SetSwimMultiplierForPlayer(plyId, 1.0)

    while true do
        DisablePlayerVehicleRewards(plyId)

		HideHudComponentThisFrame(1)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(5)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(17)

        Wait(1)
    end
end)
