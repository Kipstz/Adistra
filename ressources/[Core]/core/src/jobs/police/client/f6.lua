
PoliceJob.F6Menu = RageUI.CreateMenu("LSPD", "~p~LSPD~s~: Actions", 8, 200)

PoliceJob.InteractionsCitoyens = RageUI.CreateSubMenu(PoliceJob.F6Menu, "LSPD", "~p~LSPD~s~: Interactions Citoyens", 8, 200)
PoliceJob.FacturesMenu = RageUI.CreateSubMenu(PoliceJob.InteractionsCitoyens, "LSPD", "~p~LSPD~s~: Factures", 8, 200)
PoliceJob.FouilleMenu = RageUI.CreateSubMenu(PoliceJob.InteractionsCitoyens, "LSPD", "~p~LSPD~s~: Fouille", 8, 200)

PoliceJob.InteractionsVehicules = RageUI.CreateSubMenu(PoliceJob.F6Menu, "LSPD", "~p~LSPD~s~: Interactions Vehicules", 8, 200)
PoliceJob.VehicleInfosMenu = RageUI.CreateSubMenu(PoliceJob.InteractionsVehicules, "LSPD", "~p~LSPD~s~: Informations du Véhicule", 8, 200)

PoliceJob.GestionsObjets = RageUI.CreateSubMenu(PoliceJob.F6Menu, "LSPD", "~p~LSPD~s~: Gestion Objets", 8, 200)

PoliceJob.AutresMenu = RageUI.CreateSubMenu(PoliceJob.F6Menu, "LSPD", "~p~LSPD~s~: Autres", 8, 200)

local open = false
local canUseRenfort = true

local function canReuseRenfort()
    Citizen.CreateThread(function()
        Citizen.Wait(15000)
        canUseRenfort = true
    end)
end

PoliceJob.F6Menu.Closed = function()
    open = false
end

PoliceJob.ServiceCheck = false

PoliceJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(PoliceJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(PoliceJob.F6Menu, true)
        open = true

        local myCoords = GetEntityCoords(PlayerPedId())
        local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
        local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)

        CreateThread(function()
            while open do
                Wait(1)
                
                RageUI.IsVisible(PoliceJob.F6Menu, true, true, true, function()
                    RageUI.Checkbox("Prise de Service", nil, PoliceJob.ServiceCheck, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            PoliceJob.ServiceCheck = Checked
                            if Framework.PlayerData.identity ~= nil then
                                identity = (Framework.PlayerData.identity.firstname.." "..Framework.PlayerData.identity.lastname)
                            else
                                identity = GetPlayerName(PlayerId())
                            end
                            
                            if Checked then        
                                Framework.TriggerServerCallback("service:enableService", function(canTakeService, maxInService, inServiceCount)
                                    if canTakeService then
                                        local notification = {
                                            title = "~b~POLICE",
                                            subject = "~o~Prise de Service",
                                            msg = "L'agent ~g~"..identity.." ~s~a ~o~Pris ~s~son ~b~Service ~s~!",
                                            banner = 'CHAR_LSPD',
                                            iconType = 1
                                        }
        
                                        TriggerServerEvent("service:notifyAllInService", notification, 'police')
                                    else
                                        Framework.ShowNotification("~r~Il y'a trop de Policier en Service, ~b~" .. inServiceCount .. '/' .. maxInService)
                                    end
                                end, 'police')
                            else
                                local notification = {
                                    title = "~b~POLICE",
                                    subject = "~r~Fin de Service",
                                    msg = "L'agent ~g~"..identity.." ~s~a ~r~Quitter ~s~son ~b~Service ~s~!",
                                    banner = 'CHAR_LSPD',
                                    iconType = 1
                                }
    
                                TriggerServerEvent("service:notifyAllInService", notification, 'police')
    
                                TriggerServerEvent("service:disableService", 'police')
                            end
                        end
                    end)

                    if PoliceJob.ServiceCheck then

                        RageUI.Line()
    
                        RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                        end, PoliceJob.InteractionsCitoyens)
    
                        RageUI.ButtonWithStyle("Interactions Vehicules", nil, { RightLabel = "→→→" }, closestVeh ~= -1 and closestVehDistance < 5, function(Hovered, Active, Selected)
                        end, PoliceJob.InteractionsVehicules)
    
                        RageUI.ButtonWithStyle("Gestions Objets", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end, PoliceJob.GestionsObjets)
    
                        RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end, PoliceJob.AutresMenu)
                    end

                end)

                RageUI.IsVisible(PoliceJob.InteractionsCitoyens, true, true, true, function()
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
                    end, PoliceJob.FacturesMenu)

                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Menotter", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent("PoliceJob:Menotter", GetPlayerServerId(closestPlayer))
                        end
                    end)

                    RageUI.ButtonWithStyle("Escorter", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent("PoliceJob:Escorter", GetPlayerServerId(closestPlayer))
                        end
                    end)

                    RageUI.ButtonWithStyle("Mettre/Sortir du Véhicule", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent("PoliceJob:MettreSortirVeh", GetPlayerServerId(closestPlayer))
                        end
                    end)

                    RageUI.ButtonWithStyle("Fouiller", "~r~La personne doit avoir les mains levées !", { RightLabel = "→" }, handsUp, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback("PoliceJob:getPlayerData", function(data) 
                                playerData = data
                            end, GetPlayerServerId(closestPlayer))
                        end
                    end, PoliceJob.FouilleMenu)

                    RageUI.ButtonWithStyle("Mettre une amende", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de l'amende", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de l'amende", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'police', raison, amount)
                            else
                                Framework.ShowNotification("~r~Arguments Invalide !")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(PoliceJob.FacturesMenu, true, true, true, function()

                    if unpaid_bills ~= nil then
                        for k,v in pairs(unpaid_bills) do
                            RageUI.ButtonWithStyle("Raison : "..v.label, nil, { RightLabel = "~g~"..v.amount.."$" }, true, function(Hovered, Active, Selected)

                            end)
                        end
                    end
                end)

                RageUI.IsVisible(PoliceJob.FouilleMenu, true, true, true, function()
                    if playerData ~= nil then

                        RageUI.Separator("↓   Inventaire   ↓")

                        for k,v in pairs(playerData.inventory) do
                            RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour confisquer", { RightLabel = "~b~x"..v.itemCount }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local quantite = VisualManager:KeyboardOutput("Quantité", "", 10)

                                    if tonumber(quantite) and v.itemCount >= tonumber(quantite) then
                                        v.itemCount = v.itemCount - quantite
                                        exports["ac"]:ExecuteServerEvent("PoliceJob:Confiscate", playerData.src, 'item', { name = v.itemName, label = v.itemLabel, ammo = v.itemCount}, tonumber(quantite))
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
                                        exports["ac"]:ExecuteServerEvent("PoliceJob:Confiscate", playerData.src, 'weapon', { name = v.weaponName, label = v.weaponLabel, ammo = v.weaponAmmo})
                                        table.remove(playerData.loadout, k)
                                    else
                                        Framework.ShowNotification("~r~Vous ne pouvez pas prendre une arme Boutique !")
                                    end
                                end
                            end)
                        end
                    end
                end)

                RageUI.IsVisible(PoliceJob.InteractionsVehicules, true, true, true, function()

                    if closestVeh ~= -1 and closestVehDistance < 5 then
                        RageUI.Separator("↓   Informations   ↓")

                        RageUI.ButtonWithStyle("Informations du Véhicule", nil, {}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local vehicleProps = Framework.Game.GetVehicleProperties(closestVeh)
    
                                Framework.TriggerServerCallback("PoliceJob:getVehicleInfos", function(info)
                                    retrivedInfo = info
                                end, vehicleProps.plate)
                            end
                        end, PoliceJob.VehicleInfosMenu)
    
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

                RageUI.IsVisible(PoliceJob.VehicleInfosMenu, true, true, true, function()
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

                RageUI.IsVisible(PoliceJob.GestionsObjets, true, true, true, function()

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
                    
                    RageUI.ButtonWithStyle("Barrière 2", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()
                            local coords, forward = GetEntityCoords(plyPed), GetEntityForwardVector(plyPed)
                            local objCoords = (coords + forward * 1.0)
            
                            Framework.Game.SpawnObject('prop_mp_barrier_01', objCoords, function(obj)
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

                RageUI.IsVisible(PoliceJob.AutresMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Activer/Désactiver le Bouclier", nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            PoliceJob.ActiveBouclier()
                        end
                    end)

                    RageUI.Separator("↓  Codes Radio   ↓")

                    RageUI.ButtonWithStyle("Code 1", nil, {}, canUseRenfort, function(Hovered, Active, Selected)
                        if Selected then
                            canUseRenfort = false
                            TriggerServerEvent("PoliceJob:Renfort", 'legere', GetEntityCoords(PlayerPedId()))
                            canReuseRenfort()
                        end
                    end)

                    RageUI.ButtonWithStyle("Code 2", nil, {}, canUseRenfort, function(Hovered, Active, Selected)
                        if Selected then
                            canUseRenfort = false
                            TriggerServerEvent("PoliceJob:Renfort", 'importante', GetEntityCoords(PlayerPedId()))
                            canReuseRenfort()
                        end
                    end)

                    RageUI.ButtonWithStyle("Code 3", nil, {}, canUseRenfort, function(Hovered, Active, Selected)
                        if Selected then
                            canUseRenfort = false
                            TriggerServerEvent("PoliceJob:Renfort", 'urgente', GetEntityCoords(PlayerPedId()))
                            canReuseRenfort()
                        end
                    end)
                end)
            end
        end)
    end
end

local bouclierActive = false

PoliceJob.ActiveBouclier = function()
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

RegisterNetEvent("PoliceJob:Menotter")
AddEventHandler("PoliceJob:Menotter", function()
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

RegisterNetEvent("PoliceJob:Escorter")
AddEventHandler("PoliceJob:Escorter", function(copId)
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

RegisterNetEvent("PoliceJob:MettreSortirVeh")
AddEventHandler("PoliceJob:MettreSortirVeh", function()
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

RegisterNetEvent("PoliceJob:setBlip")
AddEventHandler("PoliceJob:setBlip", function(coords, raison)
	if raison == 'legere' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)

		Framework.ShowAdvancedNotification('LSPD', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-2\n~w~Importance: ~g~Légère.', 'CHAR_CALL911')
		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		color = 2
	elseif raison == 'importante' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)

        Framework.ShowAdvancedNotification('LSPD', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-3\n~w~Importance: ~o~Importante.', 'CHAR_CALL911')
		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		color = 47
	elseif raison == 'urgente' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)

        Framework.ShowAdvancedNotification('LSPD', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-99\n~w~Importance: ~r~URGENTE !\nDANGER IMPORTANT', 'CHAR_CALL911')
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
	AddTextComponentString("~r~POLICE ~s~| Demande renfort")
	EndTextCommandSetBlipName(blipId)

	table.insert(RenfortsBlips, blipId)

	Wait(60*1000)

	for i, blipId in pairs(RenfortsBlips) do 
		RemoveBlip(blipId)
	end
end)