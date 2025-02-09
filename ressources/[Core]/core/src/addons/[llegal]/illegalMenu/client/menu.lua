
IllegalMenu.Main = RageUI.CreateMenu("Menu Illégal", "", 8, 200)

IllegalMenu.InteractionsCitoyens = RageUI.CreateSubMenu(IllegalMenu.Main, "Menu Illégal", "Interactions Citoyens", 8, 200)
IllegalMenu.FouilleMenu = RageUI.CreateSubMenu(IllegalMenu.InteractionsCitoyens, "Menu Illégal", "Fouille", 8, 200)
IllegalMenu.InteractionsVehicules = RageUI.CreateSubMenu(IllegalMenu.Main, "Menu Illégal", "Interactions Vehicules", 8, 200)

local open = false

IllegalMenu.Main.Closed = function()
    open = false
end

IllegalMenu.Open = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(IllegalMenu.Main, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(IllegalMenu.Main, true)
        open = true

        if Framework.PlayerData.jobs ~= nil and Framework.PlayerData.jobs['job2'].label ~= nil then
            IllegalMenu.Main:SetSubtitle(Framework.PlayerData.jobs['job2'].label)
        end

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(IllegalMenu.Main, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
                    local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)

                    RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, IllegalMenu.InteractionsCitoyens)

                    RageUI.ButtonWithStyle("Interactions Vehicules", nil, { RightLabel = "→→→" }, closestVeh ~= -1 and closestVehDistance < 5, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, IllegalMenu.InteractionsVehicules)

                end)

                RageUI.IsVisible(IllegalMenu.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
                    local handsUp = IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'random@mugging3', 'handsup_standing_base', 49)

                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Ligoter", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent('IllegalMenu:Ligoter', GetPlayerServerId(closestPlayer))
                        end
                    end)

                    RageUI.ButtonWithStyle("Escorter", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent('IllegalMenu:Escorter', GetPlayerServerId(closestPlayer))
                        end
                    end)

                    RageUI.ButtonWithStyle("Mettre/Sortir du Véhicule", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent('IllegalMenu:MettreSortirVeh', GetPlayerServerId(closestPlayer))
                        end
                    end)

                    RageUI.ButtonWithStyle("Fouiller", "~r~La personne doit avoir les mains levées !", { RightLabel = "→" }, handsUp, function(Hovered, Active, Selected)
                        if Selected then
                            if handsUp then
                                Framework.TriggerServerCallback("IllegalMenu:getPlayerData", function(data) 
                                    playerData = data
                                end, GetPlayerServerId(closestPlayer))
                            else
                                Framework.ShowNotification("~r~La personne doit avoir les mains levées !")

                                RageUI.CloseAll()
                            end
                        end
                    end, IllegalMenu.FouilleMenu)

                end)

                RageUI.IsVisible(IllegalMenu.FouilleMenu, true, true, true, function()
                    if playerData ~= nil then
                        RageUI.Separator("↓   Inventaire   ↓")

                        for k,v in pairs(playerData.inventory) do
                            RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour confisquer", { RightLabel = "~b~x"..v.itemCount }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local quantite = VisualManager:KeyboardOutput("Quantité", "", 10)

                                    if tonumber(quantite) and v.itemCount >= tonumber(quantite) then
                                        v.itemCount = v.itemCount - quantite
                                        exports["ac"]:ExecuteServerEvent('IllegalMenu:Confiscate', playerData.src, 'item', { name = v.itemName, label = v.itemLabel, ammo = v.itemCount}, tonumber(quantite))
                                    else
                                        Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                                    end
                                end
                            end)
                        end
    
                        RageUI.Separator("↓  Armes   ↓")

                        for k,v in pairs(playerData.loadout) do
                            RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour confisquer", { RightLabel = "~o~"..v.weaponAmmo.."Mun" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    if not Framework.WeaponisBoutique(v.weaponName) then
                                        exports["ac"]:ExecuteServerEvent('IllegalMenu:Confiscate', playerData.src, 'weapon', { name = v.weaponName, label = v.weaponLabel, ammo = v.weaponAmmo})
                                        table.remove(playerData.loadout, k)
                                    else
                                        Framework.ShowNotification("~r~Vous ne pouvez pas prendre une arme Boutique !")
                                    end
                                end
                            end)
                        end
                    end
                end)

                RageUI.IsVisible(IllegalMenu.InteractionsVehicules, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)

                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Crocheter", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if DoesEntityExist(closestVeh) then
                                local plyPed = PlayerPedId()
            
                                TaskStartScenarioInPlace(plyPed, 'WORLD_HUMAN_WELDING', 0, true)
                                Wait(20000)
                                ClearPedTasksImmediately(plyPed)
            
                                SetVehicleDoorsLocked(closestVeh, 1)
                                SetVehicleDoorsLockedForAllPlayers(closestVeh, false)
                               Framework.ShowNotification("Véhicule ~g~dévérouillé")
                            else
                                Framework.ShowNotification("~r~Aucun véhicule~s~ à proximité")
                            end
                        end
                    end)
                end)

            end
        end)
    end
end


local Ligoter, Escorter, MisInVeh = false

CreateThread(function()
    while true do
        wait = 5000

        if Ligoter then
            wait = 1

            NetworkSetFriendlyFireOption(false)
            SetCanAttackFriendly(PlayerPedId(), false, true)

            Wait(10)
        end

        Wait(wait)
    end
end)

RegisterNetEvent('IllegalMenu:Ligoter')
AddEventHandler('IllegalMenu:Ligoter', function()
    local PlayerPed = PlayerPedId()

    if not Ligoter then
        SetEnableHandcuffs(PlayerPed, true)
        SetPlayerCanDoDriveBy(PlayerPed, false)
        SetCurrentPedWeapon(PlayerPed, GetHashKey('WEAPON_UNARMED'), true)
        SetPedCanPlayGestureAnims(PlayerPed, false)

        RequestAnimDict('mp_arresting')

        while not HasAnimDictLoaded('mp_arresting') do
            Wait(100)
        end

        TaskPlayAnim(PlayerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

        DisplayRadar(false)
    else
        ClearPedSecondaryTask(PlayerPed)
        SetEnableHandcuffs(PlayerPed, false)
        SetPlayerCanDoDriveBy(PlayerPed, true)
        SetPedCanPlayGestureAnims(PlayerPed, true)
        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(PlayerPed, true, true)
        DisplayRadar(true)
        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(PlayerPed, true, true)
    end

    Ligoter = not Ligoter
end)

RegisterNetEvent('IllegalMenu:Escorter')
AddEventHandler('IllegalMenu:Escorter', function(copId)
    local playerPed
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

RegisterNetEvent('IllegalMenu:MettreSortirVeh')
AddEventHandler('IllegalMenu:MettreSortirVeh', function()
    local PlayerPed = PlayerPedId()
    local vehicle = Framework.Game.GetClosestVehicle()

    if Ligoter and not MisInVeh then
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