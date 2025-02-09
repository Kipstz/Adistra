
UnicornJob.F6Menu = RageUI.CreateMenu("Unicorn", "~p~Unicorn~s~: Actions", 8, 200)
UnicornJob.InteractionsCitoyens = RageUI.CreateSubMenu(UnicornJob.F6Menu, "Unicorn", "~p~Unicorn~s~: Interactions Citoyens", 8, 200)
UnicornJob.AutresMenu = RageUI.CreateSubMenu(UnicornJob.F6Menu, "Unicorn", "~p~Unicorn~s~: Autres", 8, 200)


local open = false

UnicornJob.F6Menu.Closed = function()
    open = false
end

UnicornJob.ServiceCheck = false

UnicornJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(UnicornJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(UnicornJob.F6Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(UnicornJob.F6Menu, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, UnicornJob.InteractionsCitoyens)

                    RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, UnicornJob.AutresMenu)


                end)

                RageUI.IsVisible(UnicornJob.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
            
                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Menotter", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent("UnicornJob:Menotter", GetPlayerServerId(closestPlayer))
                        end
                    end)

                    RageUI.ButtonWithStyle("Escorter", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent("UnicornJob:Escorter", GetPlayerServerId(closestPlayer))
                        end
                    end)

                    RageUI.ButtonWithStyle("Mettre/Sortir du Véhicule", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent("UnicornJob:MettreSortirVeh", GetPlayerServerId(closestPlayer))
                        end
                    end)

                    RageUI.ButtonWithStyle("Mettre une facture", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de la facture", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de la facture", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'unicorn', raison, amount)
                            else
                                Framework.ShowNotification("~r~Arguments Invalide !")
                            end
                        end
                    end)

                end)
            end
        end)
    end
end

local Menotter, Escorter, MisInVeh = false

CreateThread(function()
    while true do
        wait = 5000

        if Menotter then
            wait = 1

            NetworkSetFriendlyFireOption(false)
            SetCanAttackFriendly(PlayerPedId(), false, true)

            Wait(10)
        end

        Wait(wait)
    end
end)

RegisterNetEvent("UnicornJob:Menotter")
AddEventHandler("UnicornJob:Menotter", function()
    local PlayerPed = PlayerPedId()

    if not Menotter then
        SetEnableHandcuffs(PlayerPed, true)
        SetPlayerCanDoDriveBy(PlayerPed, false)
        SetCurrentPedWeapon(PlayerPed, GetHashKey('WEAPON_UNARMED'), true)
        SetPedCanPlayGestureAnims(PlayerPed, false)

        RequestAnimDict('mp_arresting')

        while not HasAnimDictLoaded('mp_arresting') do
            Wait(100)
        end

        TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

        DisplayRadar(false)
    else
        ClearPedSecondaryTask(PlayerPed)
        SetEnableHandcuffs(PlayerPed, false)
        SetPlayerCanDoDriveBy(PlayerPed, true)
        SetPedCanPlayGestureAnims(PlayerPed, true)
        DisplayRadar(true)
        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(PlayerPed, true, true)
    end

    Menotter = not Menotter
end)

RegisterNetEvent("UnicornJob:Escorter")
AddEventHandler("UnicornJob:Escorter", function(copId)
    local plyPed
	local targetPed

    if not Escorter then
        targetPed = GetPlayerPed(GetPlayerFromServerId(tonumber(copId)))

        if not IsPedSittingInAnyVehicle(targetPed) then
            AttachEntityToEntity(PlayerPedId(), targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        else
            DetachEntity(PlayerPedId(), true, false)
        end
    else
        DetachEntity(PlayerPedId(), true, false)
    end

    Escorter = not Escorter
end)

RegisterNetEvent("UnicornJob:MettreSortirVeh")
AddEventHandler("UnicornJob:MettreSortirVeh", function()
    local PlayerPed = PlayerPedId()
    local vehicle = Framework.Game.GetClosestVehicle()

    if Menotter and not MisInVeh then
        local maxSieges, SiegeLibre = GetVehicleMaxNumberOfPassengers(vehicle)

        for i=maxSieges-1,0,-1 do
            if IsVehicleSeatFree(vehicle, i) then
                SiegeLibre = i
                break
            end
        end

        if SiegeLibre then
            TaskWarpPedIntoVehicle(PlayerPed, vehicle, SiegeLibre)
        else
            Framework.ShowNotification("~r~Aucune Place Disponible !")
        end
    else
        TaskLeaveVehicle(PlayerPed, vehicle, 16)
    end

    MisInVeh = not MisInVeh
end)