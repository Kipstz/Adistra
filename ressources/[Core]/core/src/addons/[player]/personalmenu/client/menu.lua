
PersonalMenu.Main = RageUI.CreateMenu(Config['PersonalMenu'].MenuTitle.Main, "", 8, 200)

PersonalMenu.InventoryMenu = RageUI.CreateSubMenu(PersonalMenu.Main, Config['PersonalMenu'].MenuTitle.Main, Config['PersonalMenu'].MenuSubTitle.InventoryMenu, 8, 200)
PersonalMenu.LoadoutMenu = RageUI.CreateSubMenu(PersonalMenu.Main, Config['PersonalMenu'].MenuTitle.Main, Config['PersonalMenu'].MenuSubTitle.LoadoutMenu, 8, 200)
PersonalMenu.ActionsMenu = RageUI.CreateSubMenu(PersonalMenu.Main, Config['PersonalMenu'].MenuTitle.Main, Config['PersonalMenu'].MenuSubTitle.ActionsMenu, 8, 200)
PersonalMenu.GestionVehicule = RageUI.CreateSubMenu(PersonalMenu.Main, Config['PersonalMenu'].MenuTitle.Main, Config['PersonalMenu'].MenuSubTitle.GestionVehicule, 8, 200)
PersonalMenu.GestionEntreprise = RageUI.CreateSubMenu(PersonalMenu.Main, Config['PersonalMenu'].MenuTitle.Main, Config['PersonalMenu'].MenuSubTitle.GestionEntreprise, 8, 200)
PersonalMenu.GestionFaction = RageUI.CreateSubMenu(PersonalMenu.Main, Config['PersonalMenu'].MenuTitle.Main, Config['PersonalMenu'].MenuSubTitle.GestionFaction, 8, 200)
PersonalMenu.PFMENU = RageUI.CreateSubMenu(PersonalMenu.Main, Config['PersonalMenu'].MenuTitle.Main, Config['PersonalMenu'].MenuSubTitle.PFMENU, 8, 200)
PersonalMenu.BillingsMenu = RageUI.CreateSubMenu(PersonalMenu.PFMENU, Config['PersonalMenu'].MenuTitle.Main, Config['PersonalMenu'].MenuSubTitle.BillingsMenu, 8, 200)
PersonalMenu.DiversMenu = RageUI.CreateSubMenu(PersonalMenu.Main, Config['PersonalMenu'].MenuTitle.Main, Config['PersonalMenu'].MenuSubTitle.DiversMenu, 8, 200)
PersonalMenu.ClothesMenu = RageUI.CreateSubMenu(PersonalMenu.DiversMenu, Config['PersonalMenu'].MenuTitle.Main, Config['PersonalMenu'].MenuSubTitle.ClothesMenu, 8, 200)
PersonalMenu.AccessoriesMenu = RageUI.CreateSubMenu(PersonalMenu.DiversMenu, Config['PersonalMenu'].MenuTitle.Main, Config['PersonalMenu'].MenuSubTitle.AccessoriesMenu, 8, 200)

PersonalMenu.Indexs = {
    g_clothe = 1,
    g_clotheGestion = 1,
    g_accessories = 1,
    g_gestionAcc = 1,
    carteidentite = 1,
    permis_conduire = 1,
    permis_arme = 1,
    veh_gestionPorte = 1,
    veh_gestionVitesse = 1,
}

PersonalMenu.Main.Closed = function()
    open = false
end

local open = false

function PersonalMenu:OpenMenu()
    local currentWeight = 0

    for k,v in pairs(Framework.PlayerData.inventory) do
		if v.count > 0 then
			currentWeight = currentWeight + (v.weight * v.count)
		end
	end

    if open then
        RageUI.CloseAll()
        RageUI.Visible(PersonalMenu.Main, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(PersonalMenu.Main, true)
        open = true

        PersonalMenu.Main:SetSubtitle(" ~r~"..GetPlayerName(PlayerId()).."~s~, Bienvenue sur ".._Config.serverName)

        CreateThread(function()
            while open do
                Wait(1)

                plyPed = PlayerPedId()
                inVeh = IsPedInAnyVehicle(plyPed)

                RageUI.IsVisible(PersonalMenu.Main, true, true, true, function()

                    RageUI.Separator(" Connecté avec l'ID [~p~"..GetPlayerServerId(PlayerId()).."~s~]")

                    RageUI.ButtonWithStyle("Inventaire ( ~b~".. currentWeight .." ~s~/ ~r~".. Framework.PlayerData.maxWeight.." KG~s~ )", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, PersonalMenu.InventoryMenu)

                    RageUI.ButtonWithStyle("Gestion des Armes", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, PersonalMenu.LoadoutMenu)

                    RageUI.ButtonWithStyle("Porte-Feuille", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, PersonalMenu.PFMENU)

                    if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Gestion Entreprise", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end, PersonalMenu.GestionEntreprise)
                    end

                    if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job2'].grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Gestion Faction", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end, PersonalMenu.GestionFaction)
                    end

                    if inVeh then
                        local vehicle = GetVehiclePedIsIn(plyPed)
                        local isDriver = (GetPedInVehicleSeat(vehicle, -1) == plyPed)

                        if isDriver then
                            RageUI.ButtonWithStyle("Gestion Véhicule", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    PersonalMenu.gestionVeh = { doors = {}, hood = false, trunk = false, motor = true }

                                    PersonalMenu.gestionVeh.doors['1'] = false
                                    PersonalMenu.gestionVeh.doors['2'] = false
                                    PersonalMenu.gestionVeh.doors['3'] = false
                                    PersonalMenu.gestionVeh.doors['4'] = false
                                end
                            end, PersonalMenu.GestionVehicule)
                        end
                    end

                    RageUI.ButtonWithStyle("Divers", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, PersonalMenu.DiversMenu)

                    RageUI.Line()

                end)

                RageUI.IsVisible(PersonalMenu.InventoryMenu, true, true, true, function()
                    
                    RageUI.ButtonWithStyle("Argent Liquide: ", nil, { RightLabel = "~g~"..Framework.Math.GroupDigits(Framework.PlayerData.accounts['money'].money).."$" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            PersonalMenu.actionsSelect = {
                                type = 'item_accounts',
                                name = 'money',
                                label = "Argent Liquide",
                                count = Framework.PlayerData.accounts['money'].money
                            }
                        end
                    end, PersonalMenu.ActionsMenu)

                    RageUI.ButtonWithStyle("Argent Sale: ", nil, { RightLabel = "~r~"..Framework.Math.GroupDigits(Framework.PlayerData.accounts['black_money'].money).."$" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            PersonalMenu.actionsSelect = {
                                type = 'item_accounts',
                                name = 'black_money',
                                label = "Argent Sale",
                                count = Framework.PlayerData.accounts['black_money'].money
                            }
                        end
                    end, PersonalMenu.ActionsMenu)

                    RageUI.Line()

                    for k,v in pairs(Framework.PlayerData.inventory) do
                        if v.count > 0 then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~p~"..Framework.Math.GroupDigits(v.count).."x" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    PersonalMenu.actionsSelect = {
                                        type = 'item_standard',
                                        name = v.name,
                                        label = v.label,
                                        count = v.count,
                                        canRemove = v.canRemove,
                                        usable = v.usable
                                    }
                                end
                            end, PersonalMenu.ActionsMenu)
                        end
                    end

                end)

                RageUI.IsVisible(PersonalMenu.LoadoutMenu, true, true, true, function()

                    for k,v in pairs(Framework.PlayerData.loadout) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~p~"..Framework.Math.GroupDigits(v.ammo).." Muns" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                PersonalMenu.actionsSelect = {
                                    type = 'item_weapon',
                                    name = v.name,
                                    label = v.label,
                                    count = v.ammo
                                }
                            end
                        end, PersonalMenu.ActionsMenu)
                    end

                end)

                RageUI.IsVisible(PersonalMenu.ActionsMenu, true, true, true, function()

                    if PersonalMenu.actionsSelect.type == 'item_accounts' then
                        RageUI.ButtonWithStyle("Donner", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local closestPlayer, closestDistance = Framework.Game.GetClosestPlayer()

                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    local closestPed = GetPlayerPed(closestPlayer)
            
                                    if IsPedOnFoot(closestPed) then
                                        if PersonalMenu.actionsSelect.name ~= nil and PersonalMenu.actionsSelect.count > 0 then
                                            local qte = VisualManager:KeyboardOutput("Quantité", "", 15)
                                            if tonumber(qte) and PersonalMenu.actionsSelect.count >= tonumber(qte) then
                                                exports["ac"]:ExecuteServerEvent('personalmenu:Inventory', GetPlayerServerId(closestPlayer), 'item_account', PersonalMenu.actionsSelect.name, tonumber(qte))
                                            
                                                RageUI.CloseAll()
                                            else
                                                Framework.ShowNotification("Veuillez saisir une quantité valide !")
                                            end
                                        else
                                            Framework.ShowNotification("Montant Invalide")
                                        end
                                    else
                                        Framework.ShowNotification("Vous ne pouvez pas donner d'argent a un joueur dans un véhicule !")
                                    end
                                 else
                                     Framework.ShowNotification("Personne a Proximité !")
                                 end
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Jeter", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if IsPedOnFoot(plyPed) then
                                    if PersonalMenu.actionsSelect.name ~= nil then
                                        local qte = VisualManager:KeyboardOutput("Quantité", "", 5)
                                        if VisualManager:keyboardIsValid(qte, true) then
                                            exports["ac"]:ExecuteServerEvent('personalmenu:Inventory2', 'item_account', PersonalMenu.actionsSelect.name, tonumber(qte))
                                            RageUI.CloseAll()
                                        end
                                    end
                                else
                                    Framework.ShowNotification("Vous ne pouvez pas jeter une arme dans un véhicule !")
                                end
                            end
                        end)
                    elseif PersonalMenu.actionsSelect.type == 'item_standard' then
                        RageUI.ButtonWithStyle("Utiliser", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if PersonalMenu.actionsSelect.usable then
                                    exports["ac"]:ExecuteServerEvent('personalmenu:use', PersonalMenu.actionsSelect.name)

                                    Wait(500)

                                    currentWeight = 0

                                    for k,v in ipairs(Framework.PlayerData.inventory) do
                                        if v.count > 0 then
                                            currentWeight = currentWeight + (v.weight * v.count)
                                        end
                                    end
                                else
                                    Framework.ShowNotification("~r~Cet item ne peut pas être utilisé !")
                                end
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Donner", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local closestPlayer, closestDistance = Framework.Game.GetClosestPlayer()

                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    local closestPed = GetPlayerPed(closestPlayer)
            
                                    if IsPedOnFoot(closestPed) then
                                        if PersonalMenu.actionsSelect.name ~= nil and PersonalMenu.actionsSelect.count > 0 then
                                            local qte = VisualManager:KeyboardOutput("Quantité", "", 5)
                                            if tonumber(qte) and PersonalMenu.actionsSelect.count >= tonumber(qte) then
                                                exports["ac"]:ExecuteServerEvent('personalmenu:Inventory', GetPlayerServerId(closestPlayer), 'item_standard', PersonalMenu.actionsSelect.name, tonumber(qte))
                                            
                                                RageUI.CloseAll()
                                            else
                                                Framework.ShowNotification("Veuillez saisir une quantité valide !")
                                            end
                                        else
                                            Framework.ShowNotification("Montant Invalide")
                                        end
                                    else
                                        Framework.ShowNotification("Vous ne pouvez pas donner un item a un joueur dans un véhicule !")
                                    end
                                 else
                                     Framework.ShowNotification("Personne a Proximité !")
                                 end
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Jeter", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if PersonalMenu.actionsSelect.canRemove then
                                    if IsPedOnFoot(plyPed) then
                                        if PersonalMenu.actionsSelect.name ~= nil then
                                            local qte = VisualManager:KeyboardOutput("Quantité", "", 5)
                                            if VisualManager:keyboardIsValid(qte, true) then
                                                exports["ac"]:ExecuteServerEvent('personalmenu:Inventory2', 'item_standard', PersonalMenu.actionsSelect.name, tonumber(qte))
                                                RageUI.CloseAll()
                                            end
                                        end
                                    else
                                        Framework.ShowNotification("Vous ne pouvez pas jeter un item dans un véhicule !")
                                    end
                                else
                                    Framework.ShowNotification("Vous ne pouvez pas jeter cet item !")
                                end
                            end
                        end)
                    elseif PersonalMenu.actionsSelect.type == 'item_weapon' then
                        RageUI.ButtonWithStyle("Donner", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local closestPlayer, closestDistance = Framework.Game.GetClosestPlayer()

                                if closestDistance ~= -1 and closestDistance <= 3 then
                                    local closestPed = GetPlayerPed(closestPlayer)
            
                                    if IsPedOnFoot(closestPed) then
                                        if PersonalMenu.actionsSelect.name ~= nil then
                                            if not Framework.WeaponisBoutique(PersonalMenu.actionsSelect.name) then
                                                exports["ac"]:ExecuteServerEvent('personalmenu:Inventory', GetPlayerServerId(closestPlayer), 'item_weapon', PersonalMenu.actionsSelect.name, PersonalMenu.actionsSelect.count)
                                            
                                                RageUI.CloseAll()
                                            else
                                                Framework.ShowNotification("~r~Vous ne pouvez pas donner une arme boutique !")
                                            end
                                        else
                                            Framework.ShowNotification("Montant Invalide")
                                        end
                                    else
                                        Framework.ShowNotification("Vous ne pouvez pas donner une arme a un joueur dans un véhicule !")
                                    end
                                else
                                    Framework.ShowNotification("Personne a Proximité !")
                                end
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Jeter", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if IsPedOnFoot(PlayerPedId()) then
                                    if not Framework.WeaponisBoutique(PersonalMenu.actionsSelect.name) then
                                        exports["ac"]:ExecuteServerEvent('personalmenu:Inventory2', 'item_weapon', PersonalMenu.actionsSelect.name)
                                        RageUI.CloseAll()
                                    else
                                        Framework.ShowNotification("Vous ne pouvez pas jeter une arme Boutique !")
                                    end
                                else
                                    Framework.ShowNotification("Vous ne pouvez pas jeter une arme dans un véhicule !")
                                end
                            end
                        end)
                    end

                end)

                RageUI.IsVisible(PersonalMenu.PFMENU, true, true, true, function()

                    RageUI.Separator("↓   ~g~Mes Papiers   ~s~↓")

                    RageUI.Separator(Framework.PlayerData.jobs['job'].label.." "..Framework.PlayerData.jobs['job'].grade_label)
                    RageUI.Separator(Framework.PlayerData.jobs['job2'].label.." "..Framework.PlayerData.jobs['job2'].grade_label)

                    RageUI.Line()

                    RageUI.List("Carte d'identité", { "Regarder", "Montrer" }, PersonalMenu.Indexs.carteidentite, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            if Index == 1 then
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                            elseif Index == 2 then
                                local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer()

                                if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
                                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
                                else
                                    Framework.ShowNotification("~r~Personne a Proximité !")
                                end
                            end
                        end
                    end, function(Index)
                        PersonalMenu.Indexs.carteidentite = Index
                    end)

                    RageUI.List("Permis de Conduire", { "Regarder", "Montrer" }, PersonalMenu.Indexs.permis_conduire, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            if Index == 1 then
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
                            elseif Index == 2 then
                                local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer()

                                if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
                                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
                                else
                                    Framework.ShowNotification("~r~Personne a Proximité !")
                                end
                            end
                        end
                    end, function(Index)
                        PersonalMenu.Indexs.permis_conduire = Index
                    end)

                    RageUI.List("Permis de Port d'arme", { "Regarder", "Montrer" }, PersonalMenu.Indexs.permis_arme, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            if Index == 1 then
                                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
                            elseif Index == 2 then
                                local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer()

                                if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
                                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
                                else
                                    Framework.ShowNotification("~r~Personne a Proximité !")
                                end
                            end
                        end
                    end, function(Index)
                        PersonalMenu.Indexs.permis_arme = Index
                    end)

                    -- RageUI.Separator("↓   ~g~Actions   ~s~↓")

                    -- RageUI.ButtonWithStyle("Donner de l'argent", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    --     if Selected then
                    --         local closestPlayer, closestDistance = Framework.Game.GetClosestPlayer()

                    --         if closestPlayer ~= -1 and closestDistance < 3 then
                    --             local closestPed = GetPlayerPed(closestPlayer)
        
                    --             if IsPedOnFoot(closestPed) then
                    --                 local qte = VisualManager:KeyboardOutput("Montant", "", 10)

                    --                 if tonumber(qte) and qte ~= '' then
                    --                     exports["ac"]:ExecuteServerEvent('framework:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', 'money', tonumber(qte))
                                            
                    --                     RageUI.CloseAll()
                    --                 else
                    --                     Framework.ShowNotification("Montant Invalide")
                    --                 end
                    --             else
                    --                 Framework.ShowNotification("Vous ne pouvez pas donner une arme a un joueur dans un véhicule !")
                    --             end
                    --         else
                    --             Framework.ShowNotification("Personne a Proximité !")
                    --         end
                    --     end
                    -- end)

                    -- RageUI.ButtonWithStyle("Donner de l'argent sale", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    --     if Selected then
                    --         local closestPlayer, closestDistance = Framework.Game.GetClosestPlayer()

                    --         if closestPlayer ~= -1 and closestDistance < 3 then
                    --             local closestPed = GetPlayerPed(closestPlayer)
        
                    --             if IsPedOnFoot(closestPed) then
                    --                 local qte = VisualManager:KeyboardOutput("Montant", "", 10)

                    --                 if tonumber(qte) and qte ~= '' then
                    --                     exports["ac"]:ExecuteServerEvent('framework:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', 'black_money', tonumber(qte))
                                            
                    --                     RageUI.CloseAll()
                    --                 else
                    --                     Framework.ShowNotification("Montant Invalide")
                    --                 end
                    --             else
                    --                 Framework.ShowNotification("Vous ne pouvez pas donner une arme a un joueur dans un véhicule !")
                    --             end
                    --         else
                    --             Framework.ShowNotification("Personne a Proximité !")
                    --         end
                    --     end
                    -- end)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Mes Factures", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            PersonalMenu.myFactures = {}

                            Framework.TriggerServerCallback("billing:getBills", function(factures)
                                PersonalMenu.myFactures = factures
                            end)
                        end
                    end, PersonalMenu.BillingsMenu)
                end)

                RageUI.IsVisible(PersonalMenu.BillingsMenu, true, true, true, function()

                    for k,v in pairs(PersonalMenu.myFactures) do
                        RageUI.ButtonWithStyle(v.label, "[~p~ENTER~s~] pour payer", { RightLabel = "~p~"..v.amount.."$" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                Framework.TriggerServerCallback("billing:payBill", function()
                                end, v.id)
                                RageUI.GoBack()
                            end
                        end)
                    end
                end)

                RageUI.IsVisible(PersonalMenu.DiversMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Mes vêtements", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, PersonalMenu.ClothesMenu)

                    RageUI.ButtonWithStyle("Mes accessoires", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, PersonalMenu.AccessoriesMenu)

                    RageUI.ButtonWithStyle("Mes clés", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then

                            TriggerEvent('keys:open')
                        end
                    end)

                    RageUI.Line()

                    RageUI.Checkbox("Interface GPS", nil, PersonalMenu.GPS_Check, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            PersonalMenu.GPS_Check = Checked

                            if Checked then 
                                DisplayRadar(true)  
                            else
                                DisplayRadar(false)
                            end
                        end
                    end)

                    RageUI.Checkbox("Interface Joueur", nil, PersonalMenu.IJ_Check, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            PersonalMenu.IJ_Check = Checked

                            if Checked then 
                                ExecuteCommand('hud')
                            else
                                ExecuteCommand('hud')
                            end
                        end
                    end)

                    RageUI.Checkbox("Interface Cinématique", nil, PersonalMenu.IC_Check, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            PersonalMenu.IC_Check = Checked

                            if Checked then 
                                PersonalMenu:OpenCinematique()
                            else
                                PersonalMenu:OpenCinematique()
                            end
                        end
                    end)

                    -- RageUI.ButtonWithStyle("Options Graphiques", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    -- end, PersonalMenu.GraphiquesMenu)

                end)

                RageUI.IsVisible(PersonalMenu.ClothesMenu, true, true, true, function()

                    for k,v in pairs(ClotheShop.myOutfits) do
                        RageUI.List(v.name, { "Mettre", "Donner", "Supprimer" }, PersonalMenu.Indexs.g_clothe, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                if Index == 1 then
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        TriggerEvent('skinchanger:loadClothes', skin, v.outfit)
                                    end)

                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        exports["ac"]:ExecuteServerEvent('skinchanger:save', skin)
                                    end)
                                elseif Index == 2 then
                                    local closestPlayer, closestDistance = Framework.Game.GetClosestPlayer()

                                    if closestDistance ~= -1 and closestDistance <= 3 then
                                        TriggerServerEvent("shop_clothe:donnerOutfit", GetPlayerServerId(closestPlayer), v.id)
    
                                        RageUI.GoBack()
                                    else
                                        Framework.ShowNotification("~r~Personne a Proximité !")
                                    end
                                elseif Index == 3 then
                                    exports["ac"]:ExecuteServerEvent('shop_clothe:deleteOutfit', v.id)
    
                                    RageUI.GoBack()
                                end
                            end
                        end, function(Index)
                            PersonalMenu.Indexs.g_clothe = Index
                        end)
                    end

                    RageUI.Line()

                    RageUI.List("Enlever/Remettre un Vêtement: ", { "Haut", "Bas", "Chaussures", "Sac", "Gilet Par Balle", "Tout" }, PersonalMenu.Indexs.g_clotheGestion, nil, { }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            if Index == 1 then
                                SetVet('haut', PlayerPedId())
                            elseif Index == 2 then
                                SetVet('bas', PlayerPedId())
                            elseif Index == 3 then
                                SetVet('chaussures', PlayerPedId())
                            elseif Index == 4 then
                                SetVet('sac', PlayerPedId())
                            elseif Index == 5 then
                                SetVet('gpb', PlayerPedId())
                            elseif Index == 6 then
                                SetVet('tout', PlayerPedId())
                            end
                        end

                    end, function(Index)
                        PersonalMenu.Indexs.g_clotheGestion = Index
                    end)

                end)

                RageUI.IsVisible(PersonalMenu.AccessoriesMenu, true, true, true, function()

                    for k,v in pairs(AccessoriesShop.myAccessories) do
                        RageUI.List(v.name, { "Mettre", "Donner", "Supprimer" }, PersonalMenu.Indexs.g_accessories, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                if Index == 1 then
                                    TriggerEvent('skinchanger:change', v.cat..'_1', v.key)
                                    TriggerEvent('skinchanger:change', v.cat..'_2', v.val)
                                elseif Index == 2 then
                                    local closestPlayer, closestDistance = Framework.Game.GetClosestPlayer()

                                    if closestDistance ~= -1 and closestDistance <= 3 then
                                        TriggerServerEvent("shop_accessories:donnerAccessorie", GetPlayerServerId(closestPlayer), v.id)
    
                                        RageUI.GoBack()
                                    else
                                        Framework.ShowNotification("~r~Personne a Proximité !")
                                    end
                                elseif Index == 3 then
                                    TriggerServerEvent("shop_accessories:deleteAccessorie", v.id)
    
                                    RageUI.GoBack()
                                end
                            end
                        end, function(Index)
                            PersonalMenu.Indexs.g_accessories = Index
                        end)
                    end

                    RageUI.Line()

                    RageUI.List("Enlever/Remettre un Accessoire: ", { "Masque", "Chapeau", "Lunettes" }, PersonalMenu.Indexs.g_gestionAcc, nil, { }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            if Index == 1 then
                                SetAcc('masque', PlayerPedId())
                            elseif Index == 2 then
                                SetAcc('chapeau', PlayerPedId())
                            elseif Index == 3 then
                                SetAcc('lunettes', PlayerPedId())
                            end
                        end
                    end, function(Index)
                        PersonalMenu.Indexs.g_gestionAcc = Index
                    end)

                end)

                RageUI.IsVisible(PersonalMenu.GestionEntreprise, true, true, true, function()

                    RageUI.ButtonWithStyle("Recruter la Personne Proche", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local closestPlayer, closestDistance = Framework.Game.GetClosestPlayer()

                            if closestDistance ~= -1 and closestDistance <= 3 then
                                exports["ac"]:ExecuteServerEvent('personalmenu:boss_recrute', GetPlayerServerId(closestPlayer), Framework.PlayerData.jobs['job'].name, 0)
                            else
                                Framework.ShowNotification("~r~Personne a Proximité !")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(PersonalMenu.GestionFaction, true, true, true, function()

                    RageUI.ButtonWithStyle("Recruter la Personne Proche", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local closestPlayer, closestDistance = Framework.Game.GetClosestPlayer()

                            if closestDistance ~= -1 and closestDistance <= 3 then
                                exports["ac"]:ExecuteServerEvent('personalmenu:boss_recrute2', GetPlayerServerId(closestPlayer), Framework.PlayerData.jobs['job2'].name, 0)
                            else
                                Framework.ShowNotification("~r~Personne a Proximité !")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(PersonalMenu.GestionVehicule, true, true, true, function()

                    RageUI.ButtonWithStyle("Allumer/Eteindre le Moteur", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()
                            local veh = GetVehiclePedIsIn(plyPed)
                            
                            if PersonalMenu.gestionVeh.motor then
                                SetVehicleEngineOn(veh, 0)
                                SetVehicleUndriveable(veh, 1)
                                
                                PersonalMenu.gestionVeh.motor = false
                            else
                                SetVehicleEngineOn(veh, 1)
                                SetVehicleUndriveable(veh, 0)
                                
                                PersonalMenu.gestionVeh.motor = true
                            end
                        end
                    end)

                    RageUI.List("Limitateur de vitesse ", {"Aucun", "25", "50", "100", "150", "200", "250", "300", "350" }, PersonalMenu.Indexs.veh_gestionVitesse, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local plyPed = PlayerPedId()
                            local veh = GetVehiclePedIsIn(plyPed)
                            local maxVitesse = GetVehicleEstimatedMaxSpeed(veh)
                            if Index == 1 then
                                print(maxVitesse)
                                SetEntityMaxSpeed(veh, maxVitesse)
                            elseif Index == 2 then
                                SetEntityMaxSpeed(veh, 25.0 / 3.6)
                            elseif Index == 3 then
                                SetEntityMaxSpeed(veh, 50.0 / 3.6)
                            elseif Index == 4 then
                                SetEntityMaxSpeed(veh, 100.0 / 3.6)
                            elseif Index == 5 then
                                SetEntityMaxSpeed(veh, 150.0 / 3.6)
                            elseif Index == 6 then
                                SetEntityMaxSpeed(veh, 200.0 / 3.6)
                            elseif Index == 7 then
                                SetEntityMaxSpeed(veh, 250.0 / 3.6)
                            elseif Index == 8 then
                                SetEntityMaxSpeed(veh, 300.0 / 3.6)
                            elseif Index == 9 then
                                SetEntityMaxSpeed(veh, 350.0 / 3.6)
                            end
                        end
                    end, function(Index)
                        PersonalMenu.Indexs.veh_gestionVitesse = Index
                    end)

                    RageUI.List("Ouvrir/Fermer Porte ", {"Avant-Gauche", "Avant-Droite", "Arrière-Gauche", "Arrière-Droite" }, PersonalMenu.Indexs.veh_gestionPorte, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local plyPed = PlayerPedId()
                            local veh = GetVehiclePedIsIn(plyPed)

                            if PersonalMenu.gestionVeh.doors[Index] then
                                SetVehicleDoorShut(veh, Index-1)

                                PersonalMenu.gestionVeh.doors[Index] = false
                            else
                                SetVehicleDoorOpen(veh, Index-1)

                                PersonalMenu.gestionVeh.doors[Index] = true
                            end
                        end
                    end, function(Index)
                        PersonalMenu.Indexs.veh_gestionPorte = Index
                    end)



                    RageUI.ButtonWithStyle("Ouvrir/Fermer le Capôt", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()
                            local veh = GetVehiclePedIsIn(plyPed)

                            if PersonalMenu.gestionVeh.hood then
                                SetVehicleDoorShut(veh, 4)

                                PersonalMenu.gestionVeh.hood = false
                            else
                                SetVehicleDoorOpen(veh, 4)

                                PersonalMenu.gestionVeh.hood = true
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Ouvrir/Fermer le Coffre", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()
                            local veh = GetVehiclePedIsIn(plyPed)
                            
                            if PersonalMenu.gestionVeh.trunk then
                                SetVehicleDoorShut(veh, 5)

                                PersonalMenu.gestionVeh.trunk = false
                            else
                                SetVehicleDoorOpen(veh, 5)

                                PersonalMenu.gestionVeh.trunk = true
                            end
                        end
                    end)

                end)
            end
        end)
    end
end