
PersonalMenu.hasCinematic = false

local threads = {}

function PersonalMenu:OpenCinematique()
	PersonalMenu.hasCinematic = not PersonalMenu.hasCinematic

	if PersonalMenu.hasCinematic then
		DisplayRadar(false)
        ExecuteCommand('hud')
        ExecuteCommand('speedometer')

        CreateThread(function()
            threadId = GetIdOfThisThread()
            while PersonalMenu.hasCinematic do
                DrawRect(0.5, 0.0, 1.0, 0.2, 0, 0, 0, 255) -- Haut
                DrawRect(0.5, 1.0, 1.0, 0.2, 0, 0, 0, 255) -- Bas
                Wait(1)
            end
            TerminateThread(threadId)
        end)
	else
		DisplayRadar(true)
        ExecuteCommand('hud')
        ExecuteCommand('speedometer')
	end
end

RegisterNetEvent('cinematique:open')
AddEventHandler('cinematique:open', function()
	PersonalMenu:OpenCinematique()
end)