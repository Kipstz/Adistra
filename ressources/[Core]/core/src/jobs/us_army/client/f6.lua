
UsArmyJob.F6Menu = RageUI.CreateMenu("US Army", "~p~US Army~s~: Actions", 8, 200)

UsArmyJob.InteractionsCitoyens = RageUI.CreateSubMenu(UsArmyJob.F6Menu, "US Army", "~p~US Army~s~: Interactions Citoyens", 8, 200)
UsArmyJob.FacturesMenu = RageUI.CreateSubMenu(UsArmyJob.InteractionsCitoyens, "US Army", "~p~US Army~s~: Factures", 8, 200)
UsArmyJob.FouilleMenu = RageUI.CreateSubMenu(UsArmyJob.InteractionsCitoyens, "US Army", "~p~US Army~s~: Fouille", 8, 200)

UsArmyJob.InteractionsVehicules = RageUI.CreateSubMenu(UsArmyJob.F6Menu, "US Army", "~p~US Army~s~: Interactions Vehicules", 8, 200)
UsArmyJob.VehicleInfosMenu = RageUI.CreateSubMenu(UsArmyJob.InteractionsVehicules, "US Army", "~p~US Army~s~: Informations du Véhicule", 8, 200)

UsArmyJob.GestionsObjets = RageUI.CreateSubMenu(UsArmyJob.F6Menu, "US Army", "~p~US Army~s~: Gestion Objets", 8, 200)

UsArmyJob.AutresMenu = RageUI.CreateSubMenu(UsArmyJob.F6Menu, "US Army", "~p~US Army~s~: Autres", 8, 200)

local open = false
local canUseRenfort = true

local function canReuseRenfort()
    Citizen.CreateThread(function()
        Citizen.Wait(15000)
        canUseRenfort = true
    end)
end

UsArmyJob.F6Menu.Closed = function()
    open = false
end

UsArmyJob.ServiceCheck = false

UsArmyJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(UsArmyJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(UsArmyJob.F6Menu, true)
        open = true

        local myCoords = GetEntityCoords(PlayerPedId())
        local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
        local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)

        CreateThread(function()
            while open do
                Wait(1)
                
                RageUI.IsVisible(UsArmyJob.F6Menu, true, true, true, function()
                    RageUI.Checkbox("Prise de Service", nil, UsArmyJob.ServiceCheck, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            UsArmyJob.ServiceCheck = Checked
                            if Framework.PlayerData.identity ~= nil then
                                identity = (Framework.PlayerData.identity.firstname.." "..Framework.PlayerData.identity.lastname)
                            else
                                identity = GetPlayerName(PlayerId())
                            end
                            
                            if Checked then        
                                Framework.TriggerServerCallback("service:enableService", function(canTakeService, maxInService, inServiceCount)
                                    if canTakeService then
                                        local notification = {
                                            title = "~b~US Army",
                                            subject = "~o~Prise de Service",
                                            msg = "L'agent ~g~"..identity.." ~s~a ~o~Pris ~s~son ~b~Service ~s~!",
                                            banner = 'CHAR_US Army',
                                            iconType = 1
                                        }
        
                                        TriggerServerEvent("service:notifyAllInService", notification, 'usarmy')
                                    else
                                        Framework.ShowNotification("~r~Il y'a trop de Policier en Service, ~b~" .. inServiceCount .. '/' .. maxInService)
                                    end
                                end, 'usarmy')
                            else
                                local notification = {
                                    title = "~b~US Army",
                                    subject = "~r~Fin de Service",
                                    msg = "L'agent ~g~"..identity.." ~s~a ~r~Quitter ~s~son ~b~Service ~s~!",
                                    banner = 'CHAR_US Army',
                                    iconType = 1
                                }
    
                                TriggerServerEvent("service:notifyAllInService", notification, 'usarmy')
    
                                TriggerServerEvent("service:disableService", 'usarmy')
                            end
                        end
                    end)

                    if UsArmyJob.ServiceCheck then

                        RageUI.Line()
    
                        RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                        end, UsArmyJob.InteractionsCitoyens)
    
                        RageUI.ButtonWithStyle("Interactions Vehicules", nil, { RightLabel = "→→→" }, closestVeh ~= -1 and closestVehDistance < 5, function(Hovered, Active, Selected)
                        end, UsArmyJob.InteractionsVehicules)
    
                        RageUI.ButtonWithStyle("Gestions Objets", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end, UsArmyJob.GestionsObjets)
    
                        RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end, UsArmyJob.AutresMenu)
                    end

                end)

                RageUI.IsVisible(UsArmyJob.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
                    local handsUp = IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'random@mugging3', 'handsup_standing_base', 49)

                    RageUI.Separator("↓   Informations   ↓")

                    RageUI.ButtonWithStyle("Amendes Impayées", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback('billing:getTargetBills', function(bills)
                                unpaid_bills = bills
                            end, GetPlayerServerId(closestPlayer))
                        end
                    end, UsArmyJob.FacturesMenu)

                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Menotter", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent("UsArmyJob:Menotter", GetPlayerServerId(closestPlayer))
                        end
                    end)

                    RageUI.ButtonWithStyle("Escorter", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent("UsArmyJob:Escorter", GetPlayerServerId(closestPlayer))
                        end
                    end)

                    RageUI.ButtonWithStyle("Mettre/Sortir du Véhicule", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent("UsArmyJob:MettreSortirVeh", GetPlayerServerId(closestPlayer))
                        end
                    end)

                    RageUI.ButtonWithStyle("Fouiller", "~r~La personne doit avoir les mains levées !", { RightLabel = "→" }, handsUp, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback("UsArmyJob:getPlayerData", function(data) 
                                playerData = data
                            end, GetPlayerServerId(closestPlayer))
                        end
                    end, UsArmyJob.FouilleMenu)

                    RageUI.ButtonWithStyle("Mettre une amende", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de l'amende", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de l'amende", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'usarmy', raison, amount)
                            else
                                Framework.ShowNotification("~r~Arguments Invalide !")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(UsArmyJob.FacturesMenu, true, true, true, function()

                    if unpaid_bills ~= nil then
                        for k,v in pairs(unpaid_bills) do
                            RageUI.ButtonWithStyle("Raison : "..v.label, nil, { RightLabel = "~g~"..v.amount.."$" }, true, function(Hovered, Active, Selected)

                            end)
                        end
                    end
                end)

                RageUI.IsVisible(UsArmyJob.FouilleMenu, true, true, true, function()
                    if playerData ~= nil then

                        RageUI.Separator("↓   Inventaire   ↓")

                        for k,v in pairs(playerData.inventory) do
                            RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour confisquer", { RightLabel = "~b~x"..v.itemCount }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local quantite = VisualManager:KeyboardOutput("Quantité", "", 10)

                                    if tonumber(quantite) and v.itemCount >= tonumber(quantite) then
                                        v.itemCount = v.itemCount - quantite
                                        exports["ac"]:ExecuteServerEvent("UsArmyJob:Confiscate", playerData.src, 'item', { name = v.itemName, label = v.itemLabel, ammo = v.itemCount}, tonumber(quantite))
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
                                        exports["ac"]:ExecuteServerEvent("UsArmyJob:Confiscate", playerData.src, 'weapon', { name = v.weaponName, label = v.weaponLabel, ammo = v.weaponAmmo})
                                        table.remove(playerData.loadout, k)
                                    else
                                        Framework.ShowNotification("~r~Vous ne pouvez pas prendre une arme Boutique !")
                                    end
                                end
                            end)
                        end
                    end
                end)

                RageUI.IsVisible(UsArmyJob.InteractionsVehicules, true, true, true, function()

                    if closestVeh ~= -1 and closestVehDistance < 5 then
                        RageUI.Separator("↓   Informations   ↓")

                        RageUI.ButtonWithStyle("Informations du Véhicule", nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local vehicleProps = Framework.Game.GetVehicleProperties(closestVeh)
    
                                Framework.TriggerServerCallback("UsArmyJob:getVehicleInfos", function(info)
                                    retrivedInfo = info
                                end, vehicleProps.plate)
                            end
                        end, UsArmyJob.VehicleInfosMenu)
    
                        RageUI.Separator("↓   Actions   ↓")
    
                        RageUI.ButtonWithStyle("Mettre en fourrière", nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local plyPed = PlayerPedId()
    
                                TaskStartScenarioInPlace(plyPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                    
                                ClearPedTasks(plyPed)
                                Wait(4000)
                                Framework.Game.DeleteVehicle(closestVeh)
                                ClearPedTasks(plyPed) 
                                Framework.ShowNotification("~g~Véhicule mis en fourrière !")
                            end
                        end)
    
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
                    else
                        RageUI.GoBack()
                    end

                end)

                RageUI.IsVisible(UsArmyJob.VehicleInfosMenu, true, true, true, function()
                    if retrivedInfo ~= nil then
                        RageUI.ButtonWithStyle("Plaque: ~b~"..retrivedInfo.plate, nil, {}, true, function(Hovered, Active, Selected)
                        end)
    
                        if retrivedInfo.owner == nil then
                            RageUI.ButtonWithStyle("Propriétaire: ~r~Inconnu", nil, {}, true, function(Hovered, Active, Selected)
                            end)
                        else
                            RageUI.ButtonWithStyle("Propriétaire: ~b~"..retrivedInfo.owner, nil, {}, true, function(Hovered, Active, Selected)
                            end)
                        end
                    end
                end)

                RageUI.IsVisible(UsArmyJob.GestionsObjets, true, true, true, function()

                    RageUI.ButtonWithStyle("Plot", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()
                            local coords, forward = GetEntityCoords(plyPed), GetEntityForwardVector(plyPed)
                            local objCoords = (coords + forward * 1.0)
            
                            Framework.Game.SpawnObject('prop_roadcone02a', objCoords, function(obj)
                                SetEntityHeading(obj, GetEntityHeading(plyPed))
                                PlaceObjectOnGroundProperly(obj)
                            end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Barrière", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()
                            local coords, forward = GetEntityCoords(plyPed), GetEntityForwardVector(plyPed)
                            local objCoords = (coords + forward * 1.0)
            
                            Framework.Game.SpawnObject('prop_barrier_work05', objCoords, function(obj)
                                SetEntityHeading(obj, GetEntityHeading(plyPed))
                                PlaceObjectOnGroundProperly(obj)
                            end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Herse", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()
                            local coords, forward = GetEntityCoords(plyPed), GetEntityForwardVector(plyPed)
                            local objCoords = (coords + forward * 1.0)
            
                            Framework.Game.SpawnObject('p_ld_stinger_s', objCoords, function(obj)
                                SetEntityHeading(obj, GetEntityHeading(plyPed))
                                PlaceObjectOnGroundProperly(obj)
                            end)
                        end
                    end)

                end)

                RageUI.IsVisible(UsArmyJob.AutresMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Activer/Désactiver le Bouclier", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            UsArmyJob.ActiveBouclier()
                        end
                    end)

                    RageUI.Separator("↓  Codes Radio   ↓")

                    RageUI.ButtonWithStyle("Code 1", nil, {}, canUseRenfort, function(Hovered, Active, Selected)
                        if Selected then
                            canUseRenfort = false
                            TriggerServerEvent("UsArmyJob:Renfort", 'legere', GetEntityCoords(PlayerPedId()))
                            canReuseRenfort()
                        end
                    end)

                    RageUI.ButtonWithStyle("Code 2", nil, {}, canUseRenfort, function(Hovered, Active, Selected)
                        if Selected then
                            canUseRenfort = false
                            TriggerServerEvent("UsArmyJob:Renfort", 'importante', GetEntityCoords(PlayerPedId()))
                            canReuseRenfort()
                        end
                    end)

                    RageUI.ButtonWithStyle("Code 3", nil, {}, canUseRenfort, function(Hovered, Active, Selected)
                        if Selected then
                            canUseRenfort = false
                            TriggerServerEvent("UsArmyJob:Renfort", 'urgente', GetEntityCoords(PlayerPedId()))
                            canReuseRenfort()
                        end
                    end)

                end)
            end
        end)
    end
end

local bouclierActive = false

UsArmyJob.ActiveBouclier = function()
    local animDict = 'combat@gestures@gang@pistol_1h@beckon'
    local animName = '0'
    local prop = 'prop_ballistic_shield'

    if bouclierActive then
        local plyPed = PlayerPedId()

        DeleteEntity(shieldEntity)
        ClearPedTasksImmediately(plyPed)
        SetWeaponAnimationOverride(plyPed, `Default`)
    else
        local plyPed = PlayerPedId()
        local pedPos = GetEntityCoords(plyPed, false)
        
        Framework.Streaming.RequestAnimDict(animDict)

        TaskPlayAnim(plyPed, animDict, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)
        RemoveAnimDict(animDict)

        Framework.Game.SpawnObject(GetHashKey(prop), pedPos, function(object)
            shieldEntity = object
            AttachEntityToEntity(shieldEntity, plyPed, GetEntityBoneIndexByName(plyPed, 'IK_L_Hand'), 0.0, -0.05, -0.10, -30.0, 180.0, 40.0, 0, 0, 1, 0, 0, 1)
        end)
    end

    bouclierActive = not bouclierActive
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

RegisterNetEvent("UsArmyJob:Menotter")
AddEventHandler("UsArmyJob:Menotter", function()
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

RegisterNetEvent("UsArmyJob:Escorter")
AddEventHandler("UsArmyJob:Escorter", function(copId)
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

RegisterNetEvent("UsArmyJob:MettreSortirVeh")
AddEventHandler("UsArmyJob:MettreSortirVeh", function()
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

local RenfortsBlips = {}

RegisterNetEvent("UsArmyJob:setBlip")
AddEventHandler("UsArmyJob:setBlip", function(coords, raison)
	if raison == 'legere' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)

		Framework.ShowAdvancedNotification('US Army', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-2\n~w~Importance: ~g~Légère.', 'CHAR_CALL911')
		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		color = 2
	elseif raison == 'importante' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)

        Framework.ShowAdvancedNotification('US Army', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-3\n~w~Importance: ~o~Importante.', 'CHAR_CALL911')
		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		color = 47
	elseif raison == 'urgente' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)

        Framework.ShowAdvancedNotification('US Army', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-99\n~w~Importance: ~r~URGENTE !\nDANGER IMPORTANT', 'CHAR_CALL911')
		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", 1)
		color = 1
	end

	blipId = AddBlipForCoord(coords)

	SetBlipSprite(blipId, 161)
	SetBlipScale(blipId, 1.2)
	SetBlipColour(blipId, color)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("~r~US Army ~s~| Demande renfort")
	EndTextCommandSetBlipName(blipId)

	table.insert(RenfortsBlips, blipId)

	Wait(60*1000)

	for i, blipId in pairs(RenfortsBlips) do 
		RemoveBlip(blipId)
	end
end)