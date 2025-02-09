
Jail = {}

Jail.inJail = false

local timeRest

RegisterNetEvent("jail:sendtoJail")
AddEventHandler("jail:sendtoJail", function(jailTime, raison)
    if not Jail.inJail then
        Jail.SendJail(jailTime, raison)
    end
end)

RegisterNetEvent("jail:unjail")
AddEventHandler("jail:unjail", function()
    if Jail.inJail then
        Jail.Unjail()
    end
end)

Jail.SendJail = function(jailTime, raison)
    jailCoords = Jail_Config.jailCoords
    timeRest = jailTime * 60

    Jail.inJail = true

    local plyPed = PlayerPedId()
    
    SetEntityCoords(plyPed, jailCoords)

    SetCanAttackFriendly(plyPed, false, false)
    NetworkSetFriendlyFireOption(false)

    Wait(5000)

    while Jail.inJail do
        local plyPed = PlayerPedId()
        local myCoords = GetEntityCoords(plyPed)
        local distJail = Vdist(myCoords, jailCoords)

        if distJail > 15.0 then
            SetEntityCoords(plyPed, jailCoords)

            Framework.ShowNotification("Bien tenter !")
        end

        Jail.drawMsg(("Vous êtes en Jail pour ~r~"..raison.."\n~w~ Temps Restant: %s secondes"):format(Framework.Math.Round(timeRest)))

        Wait(1)
    end
end

Jail.Unjail = function()
    timeRest = 0
    Jail.inJail = false

    SetEntityCoords(PlayerPedId(), Jail_Config.unjailCoords)
    SetCanAttackFriendly(PlayerPedId(), true, false)
    NetworkSetFriendlyFireOption(true)

    exports["ac"]:ExecuteServerEvent("jail:unjail")

    Framework.ShowNotification("Vous êtes sorti(e) de Jail ! Faites attention la prochaine fois !")
end

CreateThread(function()
    while true do
        wait = 1500
        
        if Jail.inJail then
            wait = 1000

            timeRest = timeRest - 1

            if timeRest <= 0 then
                Jail.Unjail()
            end
        end
        
        Wait(wait)
    end
end)

Jail.drawMsg = function(msg)
	SetTextFont(4)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayText(0.450, 0.850)
end

AddEventHandler('playerDropped', function(raison)
	local src = source

    if Jail.inJail then
        exports["ac"]:ExecuteServerEvent("jail:updateTime", (timeRest/60))
    end
end)