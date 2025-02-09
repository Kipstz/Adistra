
AdminMenu.MainMenu = RageUI.CreateMenu(Config['AdminMenu'].MenuTitle.Main, "Administration de ".._Config.serverName)

AdminMenu.GestionJoueurs = RageUI.CreateSubMenu(AdminMenu.MainMenu, Config['AdminMenu'].MenuTitle.Main, "Gestion des Joueurs")
AdminMenu.gestionJoueur = RageUI.CreateSubMenu(AdminMenu.GestionJoueurs, Config['AdminMenu'].MenuTitle.Main, "Gestion du Joueur")
AdminMenu.showInventory = RageUI.CreateSubMenu(AdminMenu.gestionJoueur, Config['AdminMenu'].MenuTitle.Main, "Gestion de l'inventaire")
AdminMenu.GestionReports = RageUI.CreateSubMenu(AdminMenu.MainMenu, Config['AdminMenu'].MenuTitle.Main, "Gestion des Reports")
AdminMenu.gestionReport = RageUI.CreateSubMenu(AdminMenu.GestionReports, Config['AdminMenu'].MenuTitle.Main, "Gestion du Report")
AdminMenu.GestionVehicules = RageUI.CreateSubMenu(AdminMenu.MainMenu, Config['AdminMenu'].MenuTitle.Main, "Gestion des Véhicules")
AdminMenu.myGestion = RageUI.CreateSubMenu(AdminMenu.MainMenu, Config['AdminMenu'].MenuTitle.Main, "Gestion de Moi-Même")

AdminMenu.ObjectMenu = RageUI.CreateMenu(Config['AdminMenu'].MenuTitle.Main, "Administration de ".._Config.serverName)
AdminMenu.playerMenu = RageUI.CreateMenu(Config['AdminMenu'].MenuTitle.Main, "Administration de ".._Config.serverName)
AdminMenu.showPlayerInventory = RageUI.CreateSubMenu(AdminMenu.playerMenu, Config['AdminMenu'].MenuTitle.Main, "Gestion de l'inventaire")

local open = false
local objectOpen = false
local playerOpen = false

AdminMenu.MainMenu.Closed = function()
    open = false
end

AdminMenu.ObjectMenu.Closed = function()
    objectOpen = false
end

AdminMenu.playerMenu.Closed = function()
    playerOpen = false
end

AdminMenu.indexs = {
    staffMode_check = false,
    noclip_check = false,
    showNames_check = false,
    showBlips_check = false
}

AdminMenu.isStaffMode = false

local groupsRelative = {
    ["user"] = 1,
    ["mod"] = 2,
    ["cm"] = 3,
    ["admin"] = 4,
    ["gi"] = 5,
    ["gl"] = 6,
    ["superadmin"] = 7,
    ["owner"] = 8
}

local groupsInfos = {
    [1] = { label = "Joueur", group = "user" },
    [2] = { label = "Modérateur", group = "mod" },
    [3] = { label = "Community Manager", group = "cm" },
    [4] = { label = "Admin", group = "admin" },
    [5] = { label = "Gérant Illegal", group = "gi" },
    [6] = { label = "Gérant Legal", group = "gl" },
    [7] = { label = "Super Admin", group = "superadmin" },
    [8] = { label = "FONDATION", group = "owner" }
}

AdminMenu.getGroupDisplay = function(group)
    local groups = {
        ["owner"] = "~r~[FONDATION] ~s~",
        ["superadmin"] = "~o~[S.Admin] ~s~",
        ["gamemaster"] = "~b~[G.Master] ~s~",
        ["main-team"] = "~p~[Main-Team] ~s~",
        ["gl"] = "~g~[Gérant Legal] ~s~",
        ["gi"] = "~y~[Gérant Illegal] ~s~",
        ["admin"] = "~o~[Admin] ~s~",
        ["cm"] = "~b~[Community Manager] ~s~",
        ["mod"] = "~b~[Modérateur] ~s~",
    }

    return groups[group] or ""
end

AdminMenu.getTakenDisplay = function(bool)
    if bool then
        return ""
    else
        return "~r~[EN ATTENTE]~s~ "
    end
end

AdminMenu.statsSeparator = function()
    RageUI.Separator("Connectés: ~g~" .. AdminMenu.connecteds .. " ~r~|~s~ Staff en ligne: ~o~" .. AdminMenu.staff)
end

AdminMenu.displayTakenBy = function(reportID)
    if AdminMenu.reportsTable[reportID].taken then
        return "~s~ | Pris par: ~o~" .. AdminMenu.reportsTable[reportID].takenBy
    else
        return ""
    end
end

AdminMenu.OpenAdminMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(AdminMenu.MainMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(AdminMenu.MainMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(AdminMenu.MainMenu, true, true, true, function()

                    RageUI.Line()
                    RageUI.Separator("Bienvenue : ~p~" ..GetPlayerName(PlayerId()))
                    RageUI.Separator("Nombre de reports : [~r~" .. AdminMenu.reportCount .. "~s~]")
                    RageUI.Line()

                    RageUI.Checkbox("Mode-Staff", nil, AdminMenu.indexs.staffMode_check, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            AdminMenu.indexs.staffMode_check = Checked

                            if Checked then
                                AdminMenu.isStaffMode = true

                                AdminMenu.msg("~y~Activation du StaffMode...")
                                exports["ac"]:ExecuteServerEvent('admin_menu:setStaffState', true)

                                if Framework.PlayerData.group ~= 'owner' and Framework.PlayerData.group ~= 'superadmin' then

                                    Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin)
                                        if skin.sex == 0 then
                                            for k,v in pairs(Config['AdminMenu'][tostring(Framework.PlayerData.group)].tenue.skin.m) do
                                                TriggerEvent('skinchanger:change', k, v)
                                                if k == 'bags_1' then TriggerServerEvent('skinchanger:setWeight', v) end
                                            end
                                        else
                                            for k,v in pairs(Config['AdminMenu'][tostring(Framework.PlayerData.group)].tenue.skin.f) do
                                                TriggerEvent('skinchanger:change', k, v)
                                                if k == 'bags_1' then TriggerServerEvent('skinchanger:setWeight', v) end
                                            end
                                        end
                                    end)


                                    TriggerEvent('framework:restoreLoadout')
                                end
                            else
                                AdminMenu.isStaffMode = false

                                if Framework.PlayerData.group ~= 'owner' and Framework.PlayerData.group ~= 'superadmin' then
                                    SkinChanger.ReloadTotalSkinPlayer()
                                    Wait(1000)
                                    TriggerEvent('framework:restoreLoadout')
                                end

                                AdminMenu.msg("~y~Désactivation du StaffMode...")
                                exports["ac"]:ExecuteServerEvent('admin_menu:setStaffState', false)
                            end
                        end
                    end)

                    if AdminMenu.isStaffMode then
                        RageUI.Line()

                        RageUI.ButtonWithStyle("Téléportation Aléatoire", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if AdminMenu.isfreecam or AdminMenu.indexs.noclip_check then
                                    exports["ac"]:ExecuteServerEvent('admin_menu:gotoRandomPlayer')
                                else
                                    Framework.ShowNotification("~r~Vous devez être en noclip avant de vous téléportez a un joueur.")
                                end
                            end
                        end)

                        RageUI.ButtonWithStyle("Gestion Joueurs", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, AdminMenu.GestionJoueurs)

                        RageUI.ButtonWithStyle("Gestion des Reports", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, AdminMenu.GestionReports)

                        RageUI.ButtonWithStyle("Gestion Véhicules", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, AdminMenu.GestionVehicules)

                        RageUI.ButtonWithStyle("Gestion de Moi-Même", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, AdminMenu.myGestion)
                    end

                end)

                RageUI.IsVisible(AdminMenu.GestionJoueurs, true, true, true, function()

                    AdminMenu.statsSeparator()

                    RageUI.Line()
                    for src,player in pairs(AdminMenu.players) do
                        if player.identifier ~= '20ef97fcfefc7c9b4549fceec8c51d9d5c076164' then
                            if player.name ~= nil then
                                if AdminMenu.getGroupDisplay(player.group) then
                                    RageUI.ButtonWithStyle(AdminMenu.getGroupDisplay(player.group) .. " ~s~- [~b~" .. src .. "~s~] - " .. player.name .. "", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                        if Selected then
                                            selectedPlayer = src
                                        end
                                    end, AdminMenu.gestionJoueur)
                                else
                                    RageUI.ButtonWithStyle("[~r~GROUP INVALIDE~s~] - [~b~" .. src .. "~s~] - " .. player.name .. "", nil, { RightLabel = "→→→" }, false, function(Hovered, Active, Selected)
                                    end)
                                end
                            else
                                RageUI.ButtonWithStyle("JOUEUR INVALIDE - [~b~" .. src .. "~s~]", nil, { RightLabel = "→→→" }, false, function(Hovered, Active, Selected)
                                end)
                            end
                        end
                    end
                end)

                RageUI.IsVisible(AdminMenu.gestionJoueur, true, true, true, function()

                    if not AdminMenu.players[selectedPlayer] then
                        RageUI.Separator("")
                        RageUI.Separator("~r~Ce joueur n'est plus connecté !")
                        RageUI.Separator("")
                    else
                        AdminMenu.statsSeparator()

                        RageUI.Line()

                        RageUI.Separator("Gestion: ~p~" .. AdminMenu.players[selectedPlayer].name .. " ~s~(~b~" .. selectedPlayer .. "~s~)")
    
                        RageUI.Line()

                        RageUI.ButtonWithStyle("Se téléporter sur lui", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                ExecuteCommand("goto "..selectedPlayer)
                            end
                        end)

                        RageUI.ButtonWithStyle("Le téléporter a moi", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                ExecuteCommand("bring "..selectedPlayer)
                            end
                        end)

                        RageUI.ButtonWithStyle("Le renvoyer a sa position initiale", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                ExecuteCommand("goback "..selectedPlayer)
                            end
                        end)

                        -- →→ TODO
                        -- RageUI.ButtonWithStyle("Le téléporter au Parking Central", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        --     if Selected then
                        --     end
                        -- end)

                        RageUI.Line()

                        -- →→ TODO

                        -- if not AdminMenu.inSpectate then
                        --     RageUI.ButtonWithStyle("Spectate", nil, { RightLabel = "~g~Activé" }, true, function(Hovered, Active, Selected)
                        --         if Selected then
                        --             if GetEntityCoords(GetPlayerFromServerId(selectedPlayer)).x == 0 then
                        --                 Wait(50)
                        --                 SPECTATE_PLAYER(GetPlayerFromServerId(selectedPlayer))
                        --             else
                        --                 SPECTATE_PLAYER(GetPlayerFromServerId(selectedPlayer))
                        --             end
                        --         end
                        --     end)
                        -- else
                        --     RageUI.ButtonWithStyle("Spectate", nil, { RightLabel = "~r~Désactiver" }, true, function(Hovered, Active, Selected)
                        --         if Selected then
                        --             if GetEntityCoords(GetPlayerFromServerId(selectedPlayer)).x == 0 then
                        --                 Wait(50)
                        --                 oldCoords = GetEntityCoords(PlayerPedId())
                        --                 SPECTATE_PLAYER(GetPlayerFromServerId(selectedPlayer))
                        --             else
                        --                 oldCoords = GetEntityCoords(PlayerPedId())
                        --                 SPECTATE_PLAYER(GetPlayerFromServerId(selectedPlayer))
                        --             end
                        --         end
                        --     end)
                        -- end

                        RageUI.ButtonWithStyle("Message", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local msg = VisualManager:KeyboardOutput("Message", "", 100)

                                if msg ~= nil and msg ~= '' then
                                    exports["ac"]:ExecuteServerEvent('admin_menu:msg', selectedPlayer, msg)
                                else
                                    Framework.ShowNotification("~r~Veuillez envoyer un message correct !")
                                end
                            end
                        end)

                        RageUI.ButtonWithStyle("Kick", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local raison = VisualManager:KeyboardOutput("Raison", "", 80)

                                if raison ~= nil and tostring(raison) ~= '' then
                                    exports["ac"]:ExecuteServerEvent('admin_menu:kick', selectedPlayer, raison)
                                else
                                    Framework.ShowNotification("~r~Veuillez mettre une raison correct !")
                                end
                            end
                        end)

                        RageUI.ButtonWithStyle("Menu Vetement", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                ExecuteCommand("skin "..selectedReport)
                            end
                        end)

                        RageUI.Line()

                        RageUI.ButtonWithStyle("Voir l'inventaire", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                AdminMenu.getPlyInv(selectedPlayer)
                            end
                        end, AdminMenu.showInventory)

                        RageUI.Line()

                    end

                end)

                RageUI.IsVisible(AdminMenu.showInventory, true, true, true, function()

                    AdminMenu.statsSeparator()
                    RageUI.Line()
                    RageUI.Separator("Gestion: ~y~" .. AdminMenu.players[selectedPlayer].name .. " ~s~(~o~" .. selectedPlayer .. "~s~)")
                    RageUI.Line()

                    RageUI.Separator("↓   ~o~Compte   ~s~↓")

                    for k,v  in pairs(AdminMenu.ArgentBank) do
                        RageUI.ButtonWithStyle("Argent en banque : ", nil, { RightLabel = "~g~"..v.label.."$" }, true, function(Hovered, Active, Selected)
                        end)
                    end
                    for k,v  in pairs(AdminMenu.ArgentCash) do
                        RageUI.ButtonWithStyle("Argent Liquide : ", nil, { RightLabel = "~g~"..v.label.."$" }, true, function(Hovered, Active, Selected)
                        end)
                    end
                    for k,v  in pairs(AdminMenu.ArgentSale) do
                        RageUI.ButtonWithStyle("Argent Sale : ", nil, { RightLabel = "~g~"..v.label.."$" }, true, function(Hovered, Active, Selected)
                        end)
                    end

                    RageUI.Separator("↓   ~g~Inventaire   ~s~↓")

                    for k,v in pairs(AdminMenu.Items) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~b~x"..v.count }, true, function(Hovered, Active, Selected)
                        end)
                    end

                    RageUI.Separator("↓   ~r~Armes   ~s~↓")

                    for k,v in pairs(AdminMenu.Weapons) do
                        if v.label == nil then
                            v.label = "Invalide"
                        elseif v.ammo == nil then
                            v.ammo = 0
                        end

                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~o~"..v.ammo.."Muns" }, true, function(Hovered, Active, Selected)
                        end)
                    end

                end)

                RageUI.IsVisible(AdminMenu.GestionReports, true, true, true, function()

                    AdminMenu.statsSeparator()

                    RageUI.Line()

                    for sender, infos in pairs(AdminMenu.reportsTable) do
                        if infos.taken then
                            RageUI.ButtonWithStyle(AdminMenu.getTakenDisplay(infos.taken) .. " ~s~- [~b~" .. infos.id .. "~s~] - " .. infos.name .. "", "~g~Créé il y a~s~: "..infos.timeElapsed[1].."m"..infos.timeElapsed[2].."h~n~~r~ID Unique~s~: #" .. infos.id .. "~n~~y~Description~s~: " .. infos.reason .. "~n~~o~Pris en charge par~s~: " .. infos.takenBy, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    selectedReport = sender
                                end
                            end, AdminMenu.gestionReport)
                        else
                            RageUI.ButtonWithStyle(AdminMenu.getTakenDisplay(infos.taken) .. " ~s~- [~b~" .. infos.id .. "~s~] - " .. infos.name .. "", "~g~Créé il y a~s~: "..infos.timeElapsed[1].."m"..infos.timeElapsed[2].."h~n~~r~ID Unique~s~: #" .. infos.id .. "~n~~y~Description~s~: " .. infos.reason, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    selectedReport = sender
                                end
                            end, AdminMenu.gestionReport)
                        end
                    end
                end)

                RageUI.IsVisible(AdminMenu.gestionReport, true, true, true, function()

                    if AdminMenu.reportsTable[selectedReport] ~= nil then
                        RageUI.Separator("ID du Report: ~r~#" .. AdminMenu.reportsTable[selectedReport].uniqueId .. " ~s~| ID de l'auteur: ~y~" .. selectedReport .. AdminMenu.displayTakenBy(selectedReport))
                        RageUI.Separator("↓ ~g~Actions sur le report ~s~↓")

                        local infos = AdminMenu.reportsTable[selectedReport]

                        if not AdminMenu.reportsTable[selectedReport].taken then
                            RageUI.ButtonWithStyle("Prendre en Charge", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    exports["ac"]:ExecuteServerEvent('admin_menu:takeReport', selectedReport)
                                end
                            end)
                        end
    
                        RageUI.ButtonWithStyle("Cloturer ce Report", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                exports["ac"]:ExecuteServerEvent('admin_menu:closeReport', selectedReport)
                            end
                        end)
    
                        RageUI.Line()
                        
                        RageUI.ButtonWithStyle("Reanimer", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                ExecuteCommand("rea "..selectedReport)
                            end
                        end)

                        RageUI.ButtonWithStyle("Soigner", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                ExecuteCommand("heal "..selectedReport)
                            end
                        end)

                        RageUI.ButtonWithStyle("Message", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local msg = VisualManager:KeyboardOutput("Message", "", 100)

                                if msg ~= nil and msg ~= '' then
                                    exports["ac"]:ExecuteServerEvent('admin_menu:msg', selectedReport, msg)
                                else
                                    Framework.ShowNotification("~r~Veuillez envoyer un message correct !")
                                end
                            end
                        end)

                        RageUI.ButtonWithStyle("Menu Vetement", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                ExecuteCommand("skin "..selectedReport)
                            end
                        end)
                        
                        RageUI.Line()
    
                        RageUI.ButtonWithStyle("Se téléporter a lui", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                ExecuteCommand("goto "..selectedReport)
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Le téléporter a moi", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                ExecuteCommand("bring "..selectedReport)
                            end
                        end)

                        RageUI.ButtonWithStyle("Le renvoyer a sa position initiale", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                ExecuteCommand("goback "..selectedReport)
                            end
                        end)
    
                        -- →→ TODO

                        -- RageUI.ButtonWithStyle("Le téléporter au Parking Central", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        --     if Selected then
                        --     end
                        -- end)
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Ce report n'est plus valide")
                        RageUI.Separator("")
                    end
                end)

                RageUI.IsVisible(AdminMenu.GestionVehicules, true, true, true, function()

                    AdminMenu.statsSeparator()

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Spawn un véhicule", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local veh = VisualManager:KeyboardOutput("Nom du véhicule", "", 25)

                            if veh ~= nil and veh ~= '' then
                                local model = GetHashKey(veh)

                                if IsModelValid(model) then
                                    ExecuteCommand('car '..veh)
                                else
                                    AdminMenu.msg("~r~Ce modèle n'existe pas")
                                end
                            end
                        end
                    end)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Supprimer le véhicule", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Active then
                            AdminMenu.ClosetVehWithDisplay()
                        end

                        if Selected then
                            CreateThread(function()
                                local veh = Framework.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))

                                NetworkRequestControlOfEntity(veh)
                                while not NetworkHasControlOfEntity(veh) do
                                    Wait(1)
                                end

                                DeleteEntity(veh)

                                AdminMenu.msg("~g~Véhicule supprimé")
                            end)
                        end
                    end)

                    RageUI.ButtonWithStyle("Réparé le véhicule", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if Active then
                                AdminMenu.ClosetVehWithDisplay()
                            end
    
                            if Selected then
                                CreateThread(function()
                                    local veh = Framework.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
    
                                    NetworkRequestControlOfEntity(veh)
                                    while not NetworkHasControlOfEntity(veh) do
                                        Wait(1)
                                    end
    
                                    SetVehicleFixed(veh)
                                    SetVehicleDeformationFixed(veh)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    SetVehicleEngineHealth(veh, 1000.0)
    
                                    AdminMenu.msg("~g~Véhicule réparé")
                                end)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Retourner le véhicule", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if Active then
                                AdminMenu.ClosetVehWithDisplay()
                            end
    
                            if Selected then
                                CreateThread(function()
                                    local veh = Framework.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
    
                                    SetVehicleOnGroundProperly(veh)
    
                                    AdminMenu.msg("~g~Véhicule retourner")
                                end)
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(AdminMenu.myGestion, true, true, true, function()

                    RageUI.Checkbox("No-Clip", nil, AdminMenu.indexs.noclip_check, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            AdminMenu.indexs.noclip_check = Checked

                            if Checked then
                                AdminMenu.NoClip(true)
                            else
                                AdminMenu.NoClip(false)
                            end
                        end
                    end)

                    RageUI.Checkbox("Freecam", nil, AdminMenu.indexs.freecam_check, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            AdminMenu.indexs.freecam_check = Checked

                            if Checked then
                                AdminMenu.freecam(true)
                            else
                                AdminMenu.freecam(false)
                            end
                        end
                    end)

                    RageUI.Checkbox("Affichage des Noms", nil, AdminMenu.indexs.showNames_check, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            AdminMenu.indexs.showNames_check = Checked

                            if Checked then
                                AdminMenu.show_Names(true)
                            else
                                AdminMenu.show_Names(false)
                            end
                        end
                    end)

                    RageUI.Checkbox("Affichage des Blips", nil, AdminMenu.indexs.showBlips_check, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            AdminMenu.indexs.showBlips_check = Checked

                            if Checked then
                                AdminMenu.show_Blips(true)
                            else
                                AdminMenu.show_Blips(false)
                            end
                        end
                    end)

                end)
                
            end
        end)
    end
end

AdminMenu.openObjectMenu = function(entityHit)
    if objectOpen then
        RageUI.CloseAll()
        RageUI.Visible(AdminMenu.ObjectMenu, false)
        objectOpen = false
    else
        RageUI.CloseAll()
        RageUI.Visible(AdminMenu.ObjectMenu, true)
        objectOpen = true
        CreateThread(function()
            while objectOpen do
            Wait(1)

            RageUI.IsVisible(AdminMenu.ObjectMenu, true, true, true, function()
                    local entityType = GetEntityType(entityHit)
                    local entityTypeStr = "Inconnu"
        
                    if entityType == ENTITY_TYPE_PED then
                        entityTypeStr = "Ped"
                    elseif entityType == ENTITY_TYPE_VEHICLE then
                        entityTypeStr = "Véhicule"
                    elseif entityType == ENTITY_TYPE_OBJECT then
                        entityTypeStr = "Objet"
                    end
                    RageUI.Separator("Type d'entité : ~p~" .. entityTypeStr)

                    RageUI.Separator("Entité netID : ~p~" ..NetworkGetNetworkIdFromEntity(entityHit))

                    RageUI.ButtonWithStyle("Supprimer l'entité", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent('admin_menu:deleteEntity', NetworkGetNetworkIdFromEntity(entityHit))
                        end
                    end)

                end)
            end
        end)
    end
end

AdminMenu.openPlayerMenu = function(entityHit)
    if playerOpen then
        RageUI.CloseAll()
        RageUI.Visible(AdminMenu.playerMenu, false)
        playerOpen = false
    else
        RageUI.CloseAll()
        RageUI.Visible(AdminMenu.playerMenu, true)
        playerOpen = true
        CreateThread(function()
            while playerOpen do
            Wait(1)

            RageUI.IsVisible(AdminMenu.playerMenu, true, true, true, function()
                AdminMenu.statsSeparator()

                RageUI.Line()

                RageUI.Separator("Gestion: ~p~" .. AdminMenu.players[entityHit].name .. " ~s~(~b~" .. entityHit .. "~s~)")
   
                RageUI.Line()

                RageUI.ButtonWithStyle("Se téléporter sur lui", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        ExecuteCommand("goto "..entityHit)
                    end
                end)

                RageUI.ButtonWithStyle("Le téléporter a moi", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        ExecuteCommand("bring "..entityHit)
                    end
                end)

                RageUI.ButtonWithStyle("Le renvoyer a sa position initiale", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        ExecuteCommand("goback "..entityHit)
                    end
                end)

                -- →→ TODO
                -- RageUI.ButtonWithStyle("Le téléporter au Parking Central", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                --     if Selected then
                --     end
                -- end)

                RageUI.Line()

                -- →→ TODO

                -- if not AdminMenu.inSpectate then
                --     RageUI.ButtonWithStyle("Spectate", nil, { RightLabel = "~g~Activé" }, true, function(Hovered, Active, Selected)
                --         if Selected then
                --             if GetEntityCoords(GetPlayerFromServerId(selectedPlayer)).x == 0 then
                --                 Wait(50)
                --                 SPECTATE_PLAYER(GetPlayerFromServerId(selectedPlayer))
                --             else
                --                 SPECTATE_PLAYER(GetPlayerFromServerId(selectedPlayer))
                --             end
                --         end
                --     end)
                -- else
                --     RageUI.ButtonWithStyle("Spectate", nil, { RightLabel = "~r~Désactiver" }, true, function(Hovered, Active, Selected)
                --         if Selected then
                --             if GetEntityCoords(GetPlayerFromServerId(selectedPlayer)).x == 0 then
                --                 Wait(50)
                --                 oldCoords = GetEntityCoords(PlayerPedId())
                --                 SPECTATE_PLAYER(GetPlayerFromServerId(selectedPlayer))
                --             else
                --                 oldCoords = GetEntityCoords(PlayerPedId())
                --                 SPECTATE_PLAYER(GetPlayerFromServerId(selectedPlayer))
                --             end
                --         end
                --     end)
                -- end

                RageUI.ButtonWithStyle("Message", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local msg = VisualManager:KeyboardOutput("Message", "", 100)

                        if msg ~= nil and msg ~= '' then
                            exports["ac"]:ExecuteServerEvent('admin_menu:msg', entityHit, msg)
                        else
                            Framework.ShowNotification("~r~Veuillez envoyer un message correct !")
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Kick", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local raison = VisualManager:KeyboardOutput("Raison", "", 80)

                        if raison ~= nil and tostring(raison) ~= '' then
                            exports["ac"]:ExecuteServerEvent('admin_menu:kick', entityHit, raison)
                        else
                            Framework.ShowNotification("~r~Veuillez mettre une raison correct !")
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Menu Vetement", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        ExecuteCommand("skin ".. entityHit)
                    end
                end)

                end)
            end
        end)
    end
end