
Vip.ListIndexs = {
    ColorIndex = 1,
}

Vip.ChecksIndexs = {
    MoneyCheck = false,
    CoinsCheck = false,
    NeonsCheck = false,
    XenonsCheck = false
}

Vip.weaponSelected = {}

Vip.ObjetsSpawneds = {}

Vip.MainMenu = RageUI.CreateMenu("VIP", "Merci de votre abonnement !", 8, 200)

Vip.PedsMenu = RageUI.CreateSubMenu(Vip.MainMenu, "VIP", "Liste des Peds", 8, 200)
Vip.ObjetsMenu = RageUI.CreateSubMenu(Vip.MainMenu, "VIP", "Liste des Objets", 8, 200)
Vip.VehicleMenu = RageUI.CreateSubMenu(Vip.MainMenu, "VIP", "Options Véhicule", 8, 200)
Vip.WeaponsMenu = RageUI.CreateSubMenu(Vip.MainMenu, "VIP", "Customisation d'arme", 8, 200)

local open = false

Vip.MainMenu.Closed = function()
    open = false
end

function Vip:OpenVIP(vip)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Vip.MainMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Vip.MainMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Vip.MainMenu, true, true, true, function()

                    RageUI.Separator("Niveau du VIP: ~b~"..vip.level.."~s~")
                    RageUI.Separator("Date d'expiration: ~p~"..vip.dateEnd.."~s~")

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Liste des Peds", nil,  { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, Vip.PedsMenu)

                    RageUI.ButtonWithStyle("Liste des Objets", nil,  { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, Vip.ObjetsMenu)

                    if IsPedInAnyVehicle(PlayerPedId()) then
                        RageUI.ButtonWithStyle("Options Véhicule", nil,  { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, Vip.VehicleMenu)
                    else
                        RageUI.ButtonWithStyle("Options Véhicule", nil,  { RightLabel = "→→→" }, false, function(Hovered, Active, Selected)
                        end)
                    end

                    if Vip:wlLevel(vip, 'weaponscustom') then
                        if IsPedArmed(PlayerPedId(), 4) then
                            RageUI.ButtonWithStyle("Customisation d'arme", nil,  { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    for k,v in pairs(Framework.GetWeaponList()) do
                                        if joaat(v.name) == GetSelectedPedWeapon(PlayerPedId()) then
                                            Vip.weaponSelected = v;
                                        end
                                    end
                                end
                            end, Vip.WeaponsMenu)
                        else
                            RageUI.ButtonWithStyle("Customisation d'arme", nil,  { RightLabel = "→→→" }, false, function(Hovered, Active, Selected)
                            end)
                        end
                    end

                    RageUI.Line()

                    RageUI.Checkbox("Récuperer mon bonus journalier d'argent", nil, Vip.ChecksIndexs.MoneyCheck, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            if Vip.ChecksIndexs.MoneyCheck then
                               Framework.ShowNotification("~r~Vous avez déjà récuper votre Bonus !~s~")
                            else
                                exports["ac"]:ExecuteServerEvent('vip:recupBonusMoney', vip)
                            end
                        end
                    end)

                    if Vip:wlLevel(vip, 'coins') then
                        RageUI.Checkbox("Récuperer mon bonus journalier de coins", nil, Vip.ChecksIndexs.CoinsCheck, {}, function(Hovered, Active, Selected, Checked)
                            if Selected then
                                if Vip.ChecksIndexs.CoinsCheck then
                                    Framework.ShowNotification("~r~Vous avez déjà récuper votre Bonus !~s~")
                                else
                                    exports["ac"]:ExecuteServerEvent('vip:recupBonusCoins', vip)
                                end
                            end
                        end)
                    end

                end)

                RageUI.IsVisible(Vip.PedsMenu, true, true, true, function()

                    RageUI.Separator("↓ Liste des Peds ↓")

                    if Vip:wlLevel(vip, 'pedscustom') then
                        RageUI.ButtonWithStyle("Ped personalisée", nil,  { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local model = VisualManager:KeyboardOutput("Nom du ped", "", 25)
    
                                if model ~= '' and IsModelValid(model) then
                                    if not Vip:isBlackListModel(model) then
                                        local modelHash = GetHashKey(model)
                                        RequestModel(modelHash)
                                        while not HasModelLoaded(modelHash) do Wait(500) end
                
                                        SetPlayerModel(PlayerId(), modelHash)
                                        SetModelAsNoLongerNeeded(modelHash)
                                        TriggerEvent('framework:restoreLoadout')
                                    else
                                        Framework.ShowNotification("~r~Ce ped est blacklist !~s~")
                                    end
                                else
                                    Framework.ShowNotification("~r~Model Invalide !~s~")
                                end
                            end
                        end)
                    end

                    if Vip:wlLevel(vip, 'pedscustom2') then
                    for k,v in pairs(Config['vip'].listPeds) do
                        RageUI.ButtonWithStyle(v.label, nil,  { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local modelHash = GetHashKey(v.model)
                                RequestModel(modelHash)
                                while not HasModelLoaded(modelHash) do Wait(500) end
        
                                SetPlayerModel(PlayerId(), modelHash)
                                SetModelAsNoLongerNeeded(modelHash)
                                TriggerEvent('framework:restoreLoadout')
                            end
                        end)
                    end
                end

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Remettre mon skin normal", nil,  { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SkinChanger.ReloadTotalSkinPlayer()
                            Wait(1000)
                            TriggerEvent('framework:restoreLoadout')
                        end
                    end)

                end)

                RageUI.IsVisible(Vip.ObjetsMenu, true, true, true, function()

                    RageUI.Separator("↓ Liste des Objets ↓")
                    
                    -- if vip.level == 2 then
                    --     RageUI.ButtonWithStyle("Objet personalisée", nil,  { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    --         if Selected then
                    --             local model = VisualManager:KeyboardOutput("Nom de l'objet", "", 25)
    
                    --             if model ~= '' and IsModelValid(model) then
                    --                 local plyPed = PlayerPedId()
                    --                 local myCoords, forward = GetEntityCoords(plyPed), GetEntityForwardVector(plyPed)
                    --                 local objCoords = (myCoords + forward * 1.0)
                    --                 Framework.Game.SpawnObject(model, objCoords, function(obj) 
                    --                     SetEntityHeading(obj, GetEntityHeading(plyPed))
                    --                     PlaceObjectOnGroundProperly(obj)
                    --                     table.insert(Vip.ObjetsSpawneds, obj)
                    --                 end)
                    --             else
                    --                 Framework.ShowNotification("~r~Objet Invalide !~s~")
                    --             end
                    --         end
                    --     end)
                    -- end

                    for k,v in pairs(Config['vip'].listProps) do
                        RageUI.ButtonWithStyle(v.label, nil,  { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local plyPed = PlayerPedId()
                                local myCoords, forward = GetEntityCoords(plyPed), GetEntityForwardVector(plyPed)
                                local objCoords = (myCoords + forward * 1.0)
                                Framework.Game.SpawnObject(v.model, objCoords, function(obj) 
                                    SetEntityHeading(obj, GetEntityHeading(plyPed))
                                    PlaceObjectOnGroundProperly(obj)
                                    table.insert(Vip.ObjetsSpawneds, obj)
                                end)
                            end
                        end)
                    end

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Supprimer l'objet proche ", nil,  { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local closestObj, closestObjDist = Framework.Game.GetClosestObject()
                            if closestObj ~= -1 then
                                local found = false;
                                for k,v in pairs(Vip.ObjetsSpawneds) do
                                    if v == closestObj then
                                        found = true;
                                        DeleteObject(closestObj)
                                        table.remove(Vip.ObjetsSpawneds, k)
                                    end
                                end
                                Wait(50)
                                if not found then Framework.ShowNotification("~r~Cet objet ne peux pas être supprimé !~s~") end
                            else
                                Framework.ShowNotification("~r~Aucun objet à proximité !~s~")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(Vip.VehicleMenu, true, true, true, function()

                    if Vip:wlLevel(vip, 'boostveh') then
                        RageUI.ButtonWithStyle("Booster le véhicule", nil,  { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local veh = GetVehiclePedIsIn(PlayerPedId())
                                local props = {
                                    modEngine = 3,
                                    modBrakes = 3,
                                    modTransmission = 3,
                                    modSuspension = 3,
                                    modTurbo = true
                                }
                            
                                Framework.Game.SetVehicleProperties(veh, props)
                            end
                        end)
                    end

                    RageUI.ButtonWithStyle("Réparer le véhicule", nil,  { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback('vip:canRepair', function(canRepair)
                                if canRepair then
                                    local veh = GetVehiclePedIsIn(PlayerPedId())

                                    SetVehicleFixed(veh)
                                    SetVehicleDeformationFixed(veh)
                                    SetVehicleUndriveable(veh, false)
                                    SetVehicleEngineOn(veh, true, true)
                                else
                                    Framework.ShowNotification("~r~Limite de réparation atteinte.~s~")
                                end
                            end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Nettoyer le véhicule", nil,  { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local veh = GetVehiclePedIsIn(PlayerPedId())

                            SetVehicleDirtLevel(veh, 0)
                        end
                    end)

                    RageUI.List("Couleur du Véhicule", {"Noir", "Bleu", "Blanc", "Rouge", "Vert", "Jaune"}, Vip.ListIndexs.ColorIndex, "~b~Couleur du Véhicule", {}, true, function(Hovered, Active, Selected, Index)
                        Vip.ListIndexs.ColorIndex = Index
                    end, function(Index)
                        if Index == 1 then
                            rgb = {0, 0, 0}
                        elseif Index == 2 then
                            rgb = {0, 160, 255}
                        elseif Index == 3 then
                            rgb = {255, 255, 255}
                        elseif Index == 4 then
                            rgb = {255, 0, 0}
                        elseif Index == 5 then
                            rgb = {0, 255, 0}
                        elseif Index == 6 then
                            rgb = {255, 255, 0}
                        end

                        local veh = GetVehiclePedIsIn(PlayerPedId())
                        SetVehicleCustomPrimaryColour(veh, rgb[1], rgb[2], rgb[3])
                        SetVehicleCustomSecondaryColour(veh, rgb[1], rgb[2], rgb[3])
                    end)

                    RageUI.Checkbox("Activer/Désactiver les néons", nil, Vip.NeonsCheck, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            Vip.NeonsCheck = Checked;

                            local veh = GetVehiclePedIsIn(PlayerPedId())

                            if Checked then
                                for i = 0, 3 do
                                    SetVehicleNeonLightEnabled(veh, i, true)
                                end
                                local r, g, b = GetVehicleCustomPrimaryColour(veh)
                                SetVehicleNeonLightsColour(veh, r, g, b)
                            else
                                for i = 0, 3 do
                                    SetVehicleNeonLightEnabled(veh, i, false)
                                end
                            end
                        end
                    end)

                    RageUI.Checkbox("Activer/Désactiver les phares xénons", nil, Vip.XenonsCheck, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            Vip.XenonsCheck = Checked;

                            local veh = GetVehiclePedIsIn(PlayerPedId())

                            if Checked then
                                ToggleVehicleMod(veh, 22, true)
                                SetVehicleXenonLightsColour(veh, 2)
                            else
                                ToggleVehicleMod(veh, 22, false)
                            end
                        end
                    end)
                end)

                RageUI.IsVisible(Vip.WeaponsMenu, true, true, true, function()

                    RageUI.Separator("↓ Tints ↓")

                    for k,v in pairs(Vip.weaponSelected.tints) do 
                        RageUI.ButtonWithStyle(v, nil,  { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent('vip:setTint', Vip.weaponSelected.name, k)
                            end
                        end)
                    end

                    RageUI.Separator("↓ Components ↓")

                    for k,v in pairs(Vip.weaponSelected.components) do 
                        RageUI.ButtonWithStyle(v.label, nil,  { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent('vip:equipComponent', Vip.weaponSelected.name, v.name)
                            end
                        end)
                    end

                end)

            end
        end)
    end
end