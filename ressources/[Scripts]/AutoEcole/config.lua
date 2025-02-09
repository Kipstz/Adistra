AutoEcole_Config = {
	MaxErrors = 5,
	SpeedMultiplier = 3.6,
	
	Zones = {
		DMVSchool = {
			pos = vector3(239.4, -1381.0, 33.7),
		},
		VehicleSpawnPoint = {
			pos = vector3(249.40, -1407.23, 30.40),
		}
	},

	Prices = {
		dmv = 1000,
		drive = 5000,
		drive_bike = 2500,
		drive_truck = 10000
	},

	VehicleModels = {
		drive = 'blista',
		drive_bike = 'thrust',
		drive_truck = 'mule3'
	},

	SpeedLimits = {
		residence = 50,
		town = 80,
		freeway = 130
	},

	CheckPoints = {
		{
			Pos = vector3(255.139, -1400.731, 29.537),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText("Allez vers le prochain passage ! Vitesse limite : ~y~" .. AutoEcole_Config.SpeedLimits['residence'] .. 'km/h', 5000)
			end
		},
		{
			Pos = vector3(271.874, -1370.574, 30.932),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText("Allez vers le prochain passage !", 5000)
			end
		},
		{
			Pos = vector3(234.907, -1345.385, 29.542),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				CreateThread(function()
					DrawMissionText("Faite rapidement un ~r~stop~s~ pour le piéton qui ~y~traverse", 5000)
					PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
					FreezeEntityPosition(vehicle, true)
					Wait(4000)
					FreezeEntityPosition(vehicle, false)
					DrawMissionText("~g~Bien!~s~ continuons !", 5000)
				end)
			end
		},
		{
			Pos = vector3(217.821, -1410.520, 28.292),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				setCurrentZoneType('town')
	
				CreateThread(function()
					DrawMissionText("Marquer rapidement un ~r~stop~s~ et regardez à votre ~y~gauche~s~. Vitesse limite : ~y~" .. AutoEcole_Config.SpeedLimits['town'] .. 'km/h', 5000)
					PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
					FreezeEntityPosition(vehicle, true)
					Wait(6000)
					FreezeEntityPosition(vehicle, false)
					DrawMissionText("~g~Bien!~s~ prenez à ~y~droite~s~ et suivez votre file", 5000)
				end)
			end
		},
		{
			Pos = vector3(178.550, -1401.755, 27.725),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText("Observez le traffic ~y~allumez vos feux~s~ !", 5000)
			end
		},
		{
			Pos = vector3(113.160, -1365.276, 27.725),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText("Allez vers le prochain passage !", 5000)
			end
		},
		{
			Pos = vector3(-73.542, -1364.335, 27.789),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText("Marquez le stop pour laisser passer les véhicules !", 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(6000)
				FreezeEntityPosition(vehicle, false)
			end
		},
		{
			Pos = vector3(-355.143, -1420.282, 27.868),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText("Allez vers le prochain passage !", 5000)
			end
		},
		{
			Pos = vector3(-439.148, -1417.100, 27.704),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText("Allez vers le prochain passage !", 5000)
			end
		},
		{
			Pos = vector3(-453.790, -1444.726, 27.665),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				setCurrentZoneType('freeway')
	
				DrawMissionText("Il est temps d\'aller sur la rocade ! Vitesse limite : ~y~" .. AutoEcole_Config.SpeedLimits['freeway'] .. 'km/h', 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
			end
		},
		{
			Pos = vector3(-463.237, -1592.178, 37.519),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText("Allez vers le prochain passage !", 5000)
			end
		},
		{
			Pos = vector3(-900.647, -1986.28, 26.109),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText("Allez vers le prochain passage !", 5000)
			end
		},
		{
			Pos = vector3(1225.759, -1948.792, 38.718),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText("Allez vers le prochain passage !", 5000)
			end
		},
		{
			Pos = vector3(1225.759, -1948.792, 38.718),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				setCurrentZoneType('town')
				DrawMissionText("Entrée en ville, attention à votre vitesse ! Vitesse limite : ~y~" .. AutoEcole_Config.SpeedLimits['town'] .. 'km/h', 5000)
			end
		},
		{
			Pos = vector3(1163.603, -1841.771, 35.679),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText("Bravo, restez vigiliant !", 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
			end
		},
		{
			Pos = vector3(235.283, -1398.329, 28.921),
			Action = function(playerPed, vehicle, setCurrentZoneType)
				Framework.Game.DeleteVehicle(vehicle)
			end
		}
	}
}