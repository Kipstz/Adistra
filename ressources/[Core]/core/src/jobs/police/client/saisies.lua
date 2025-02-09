PoliceJob.SaisiesMenu = RageUI.CreateMenu("LSPD", "~p~LSPD~s~: Saisies", 8, 200)

PoliceJob.AddSaisieMenu = RageUI.CreateSubMenu(PoliceJob.SaisiesMenu, "LSPD", "~p~LSPD~s~: Ajouter une Saisie", 8, 200)
PoliceJob.SaisieInventoryMenu = RageUI.CreateSubMenu(PoliceJob.AddSaisieMenu, "LSPD", "~p~LSPD~s~: Objets de la Saisie", 8, 200)

PoliceJob.GestionSaisiesMenu = RageUI.CreateSubMenu(PoliceJob.SaisiesMenu, "LSPD", "~p~LSPD~s~: Saisies", 8, 200)
PoliceJob.SelectedSaisieMenu = RageUI.CreateSubMenu(PoliceJob.GestionSaisiesMenu, "LSPD", "~p~LSPD~s~: Saisies", 8, 200)
PoliceJob.EditSaisieMenu = RageUI.CreateSubMenu(PoliceJob.SelectedSaisieMenu, "LSPD", "~p~LSPD~s~: Saisies", 8, 200)
PoliceJob.EditSaisieInventoryMenu = RageUI.CreateSubMenu(PoliceJob.EditSaisieMenu, "LSPD", "~p~LSPD~s~: Saisies", 8, 200)

local open = false

PoliceJob.SaisiesMenu.Closed = function()
    open = false
end

PoliceJob.OpenSaisiesMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(PoliceJob.SaisiesMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(PoliceJob.SaisiesMenu, true)
        open = true

        PoliceJob.saisies = {}
        PoliceJob.selectedSaisie = {}

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(PoliceJob.SaisiesMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Ajouter une Saisie", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            PoliceJob.buildSaisie = {
                                appartenance = '',
                                motif = '',
                                accounts = {},
                                items = {},
                                weapons = {},
                            }
                        end
                    end, PoliceJob.AddSaisieMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Acceder aux Saisies", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Framework.TriggerServerCallback('PoliceJob:getAllSaisies', function(saisies)
                                PoliceJob.saisies = saisies
                            end)
                        end
                    end, PoliceJob.GestionSaisiesMenu)
                end)

                RageUI.IsVisible(PoliceJob.AddSaisieMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Appartenance", "A qui appartient la saisie (ex: un gang, orga ...etc) \nAppartenance: ~b~"..PoliceJob.buildSaisie.appartenance, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Appartenance", "", 50)

                            if tostring(txt) then
                                PoliceJob.buildSaisie.appartenance = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Motif", "Motif de la saisie: ~b~"..PoliceJob.buildSaisie.motif, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Motif", "", 50)

                            if tostring(txt) then
                                PoliceJob.buildSaisie.motif = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Objets", "Déposer les objets saisies", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            PoliceJob.saisiePlayerData = {
                                accounts = {},
                                inventory = {},
                                loadout = {}
                            }
                            Framework.TriggerServerCallback("PoliceJob:getSaisiePlayerData", function(data) 
                                PoliceJob.saisiePlayerData = data
                            end)
                        end
                    end, PoliceJob.SaisieInventoryMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Valider la saisie", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if PoliceJob.buildSaisie.appartenance ~= '' and PoliceJob.buildSaisie.motif ~= '' then
                                if next(PoliceJob.buildSaisie.accounts) or next(PoliceJob.buildSaisie.items) or next(PoliceJob.buildSaisie.weapons) then
                                    TriggerServerEvent('PoliceJob:addSaisie', PoliceJob.buildSaisie)
                                    RageUI.CloseAll()
                                else
                                    Framework.ShowNotification("~r~Invalide !~s~")
                                end
                            else
                                Framework.ShowNotification("~r~Invalide !~s~")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(PoliceJob.SaisieInventoryMenu, true, true, true, function()

                    RageUI.Separator("↓ ~b~Vos Objets~s~ ↓")

                    for k,v in pairs(PoliceJob.saisiePlayerData.inventory) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~b~x"..v.itemCount }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                                if tonumber(qte) and v.itemCount >= tonumber(qte) and not Framework.WeaponisBoutique(v.itemName) then
                                    local itemFound = false;
                                    if not next(PoliceJob.buildSaisie.items) then
                                        table.insert(PoliceJob.buildSaisie.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })

                                        v.itemCount = v.itemCount - qte
                                    else
                                        for k2,v2 in pairs(PoliceJob.buildSaisie.items) do
                                            if v.itemName == v2.itemName then
                                                itemFound = true
                                                v2.itemCount = tonumber(v2.itemCount + qte)
                                            end
                                        end

                                        if not itemFound then
                                            table.insert(PoliceJob.buildSaisie.items, {
                                                itemName = v.itemName,
                                                itemLabel = v.itemLabel,
                                                itemCount = tonumber(qte)
                                            })
                                        end

                                        v.itemCount = v.itemCount - qte
                                    end
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~o~Vos Armes~s~ ↓")

                    for k,v in pairs(PoliceJob.saisiePlayerData.loadout) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~o~"..v.weaponAmmo.."Mun" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local weaponFound = false;
                                if not Framework.WeaponisBoutique(v.name) then
                                    if not next(PoliceJob.buildSaisie.weapons) then
                                        table.insert(PoliceJob.buildSaisie.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                        table.remove(PoliceJob.saisiePlayerData.loadout, k)
                                    else
                                        for k2,v2 in pairs(PoliceJob.buildSaisie.weapons) do
                                            if v.weaponName == v2.weaponName then
                                                weaponFound = true;
                                                v2.count = tonumber(v2.count + 1)
                                            end
                                        end
    
                                        if not weaponFound then
                                            table.insert(PoliceJob.buildSaisie.weapons, {
                                                weaponName = v.weaponName,
                                                weaponLabel = v.weaponLabel,
                                                weaponAmmo = v.weaponAmmo,
                                                count = 1
                                            })
                                        end
    
                                        table.remove(PoliceJob.saisiePlayerData.loadout, k)
                                    end
                                else
                                    Framework.ShowNotification("~r~Vous ne pouvez pas déposer une arme boutique !")
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(PoliceJob.buildSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                                if tonumber(qte) and tonumber(v.itemCount) >= tonumber(qte) then v.itemCount = tonumber(v.itemCount - qte) end
                                if v.itemCount == 0 then table.remove(PoliceJob.buildSaisie.items, k) end

                                for k2,v2 in pairs(PoliceJob.saisiePlayerData.inventory) do
                                    if v2.itemName == v.itemName then
                                        v2.itemCount = tonumber(v2.itemCount + qte)
                                    end
                                end
                            end
                        end)
                    end

                    for k,v in pairs(PoliceJob.buildSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                v.count = tonumber(v.count - 1)
                                if v.count == 0 then table.remove(PoliceJob.buildSaisie.weapons, k) end
                                table.insert(PoliceJob.saisiePlayerData.loadout, v)
                            end
                        end)
                    end

                end)

                RageUI.IsVisible(PoliceJob.GestionSaisiesMenu, true, true, true, function()

                    if not next(PoliceJob.saisies) then
                        RageUI.ButtonWithStyle("~r~Aucune saisies", nil, { RightLabel = "" }, false, function(Hovered, Active, Selected)
                        end)
                    else
                        for k,v in pairs(PoliceJob.saisies) do
                            RageUI.ButtonWithStyle(v.appartenance, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    PoliceJob.selectedSaisie = {
                                        id = v.id,
                                        appartenance = v.appartenance,
                                        motif = v.motif,
                                        items = v.items,
                                        weapons = v.weapons
                                    }
                                end
                            end, PoliceJob.SelectedSaisieMenu)
                        end
                    end

                end)

                RageUI.IsVisible(PoliceJob.SelectedSaisieMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Appartenance: ~g~"..PoliceJob.selectedSaisie.appartenance, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    end)

                    RageUI.ButtonWithStyle("Motif: ~b~"..PoliceJob.selectedSaisie.motif, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    end)

                    if Framework.PlayerData.jobs['job'].grade >= 18 then
                        RageUI.Line()

                        RageUI.ButtonWithStyle("Modifier la saisie", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        end, PoliceJob.EditSaisieMenu)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(PoliceJob.selectedSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, nil, { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)
                    end

                    for k,v in pairs(PoliceJob.selectedSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, nil, { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)
                    end

                end)

                RageUI.IsVisible(PoliceJob.EditSaisieMenu, true, true, true, function()

                    RageUI.Separator("↓ Modification ↓")

                    RageUI.ButtonWithStyle("Appartenance", "Appartenance: ~b~"..PoliceJob.selectedSaisie.appartenance, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Appartenance", "", 50)

                            if tostring(txt) then
                                PoliceJob.selectedSaisie.appartenance = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Motif", "Motif de la saisie: ~b~"..PoliceJob.selectedSaisie.motif, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local txt = VisualManager:KeyboardOutput("Motif", "", 50)

                            if tostring(txt) then
                                PoliceJob.selectedSaisie.motif = tostring(txt)
                            else
                                Framework.ShowNotification("~r~Invalide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Objets", "Modifier les objets saisies", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            PoliceJob.editedPlayerData = {
                                accounts = {},
                                items = {},
                                weapons = {}
                            }
                            PoliceJob.editedPlayerData2 = {
                                accounts = {},
                                items = {},
                                weapons = {}
                            }
                            PoliceJob.saisiePlayerData = {
                                accounts = {},
                                inventory = {},
                                loadout = {}
                            }
                            Framework.TriggerServerCallback("PoliceJob:getSaisiePlayerData", function(data) 
                                PoliceJob.saisiePlayerData = data
                            end)
                        end
                    end, PoliceJob.EditSaisieInventoryMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Valider les modifications", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('PoliceJob:editSaisie', PoliceJob.selectedSaisie, PoliceJob.editedPlayerData, PoliceJob.editedPlayerData2)
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.Separator("↓ Actions ↓")

                    RageUI.ButtonWithStyle("~r~Supprimer la Saisie", "~r~Vous PERDEREZ tout ce qui est dans la saisie !~s~", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('PoliceJob:removeSaisie', PoliceJob.selectedSaisie)
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.ButtonWithStyle("~b~Récupérer la Saisie", "~b~Vous allez récupérer tout ce qui est dans la saisie !~s~", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('PoliceJob:giveSaisie', PoliceJob.selectedSaisie)
                            RageUI.CloseAll()
                        end
                    end)

                end)

                RageUI.IsVisible(PoliceJob.EditSaisieInventoryMenu, true, true, true, function()

                    RageUI.Separator("↓ ~b~Vos Objets~s~ ↓")

                    for k,v in pairs(PoliceJob.saisiePlayerData.inventory) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~b~x"..v.itemCount }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                                if tonumber(qte) and v.itemCount >= tonumber(qte) and not Framework.WeaponisBoutique(v.itemName) then
                                    local itemFound = false;
                                    if not next(PoliceJob.selectedSaisie.items) then
                                        table.insert(PoliceJob.selectedSaisie.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })
                                        table.insert(PoliceJob.editedPlayerData.items, {
                                            itemName = v.itemName,
                                            itemLabel = v.itemLabel,
                                            itemCount = tonumber(qte)
                                        })

                                        v.itemCount = tonumber(v.itemCount - qte)
                                    else
                                        for k2,v2 in pairs(PoliceJob.selectedSaisie.items) do
                                            if v.itemName == v2.itemName then
                                                itemFound = true
                                                v2.itemCount = tonumber(v2.itemCount + qte)
                                                table.insert(PoliceJob.editedPlayerData.items, {
                                                    itemName = v.itemName,
                                                    itemLabel = v.itemLabel,
                                                    itemCount = tonumber(qte)
                                                })
                                            end
                                        end

                                        if not itemFound then
                                            table.insert(PoliceJob.selectedSaisie.items, {
                                                itemName = v.itemName,
                                                itemLabel = v.itemLabel,
                                                itemCount = tonumber(qte)
                                            })
                                            table.insert(PoliceJob.editedPlayerData.items, {
                                                itemName = v.itemName,
                                                itemLabel = v.itemLabel,
                                                itemCount = tonumber(qte)
                                            })
                                        end

                                        v.itemCount = tonumber(v.itemCount - qte)
                                    end
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~o~Vos Armes~s~ ↓")

                    for k,v in pairs(PoliceJob.saisiePlayerData.loadout) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour déposer", { RightLabel = "~o~"..v.weaponAmmo.."Mun" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local weaponFound = false;
                                if not next(PoliceJob.selectedSaisie.weapons) then
                                    table.insert(PoliceJob.selectedSaisie.weapons, {
                                        weaponName = v.weaponName,
                                        weaponLabel = v.weaponLabel,
                                        weaponAmmo = v.weaponAmmo,
                                        count = 1
                                    })
                                    table.insert(PoliceJob.editedPlayerData.weapons, {
                                        weaponName = v.weaponName,
                                        weaponLabel = v.weaponLabel,
                                        weaponAmmo = v.weaponAmmo,
                                        count = 1
                                    })

                                    table.remove(PoliceJob.saisiePlayerData.loadout, k)
                                else
                                    for k2,v2 in pairs(PoliceJob.selectedSaisie.weapons) do
                                        if v.weaponName == v2.weaponName then
                                            weaponFound = true;
                                            v2.count = tonumber(v2.count + 1)
                                            table.insert(PoliceJob.editedPlayerData.weapons, {
                                                weaponName = v.weaponName,
                                                weaponLabel = v.weaponLabel,
                                                weaponAmmo = v.weaponAmmo,
                                                count = 1
                                            })
                                        end
                                    end

                                    if not weaponFound then
                                        table.insert(PoliceJob.selectedSaisie.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                        table.insert(PoliceJob.editedPlayerData.weapons, {
                                            weaponName = v.weaponName,
                                            weaponLabel = v.weaponLabel,
                                            weaponAmmo = v.weaponAmmo,
                                            count = 1
                                        })
                                    end

                                    table.remove(PoliceJob.saisiePlayerData.loadout, k)
                                end
                            end
                        end)
                    end

                    RageUI.Separator("↓ ~p~Contenue de la saisie~s~ ↓")

                    for k,v in pairs(PoliceJob.selectedSaisie.items) do
                        RageUI.ButtonWithStyle(v.itemLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~b~"..v.itemCount.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 10)
                                local add = false
                                if tonumber(qte) and v.itemCount >= tonumber(qte) then v.itemCount = v.itemCount - qte end
                                if v.itemCount == 0 then table.remove(PoliceJob.selectedSaisie.items, k) end

                                for k2,v2 in pairs(PoliceJob.saisiePlayerData.inventory) do
                                    if v2.itemName == v.itemName then
                                        add = true;
                                        v2.itemCount = tonumber(v2.itemCount + qte)
                                    end
                                end

                                if not add then
                                    table.insert(PoliceJob.saisiePlayerData.inventory, {
                                        itemName = v.itemName,
                                        itemLabel = v.itemLabel,
                                        itemCount = tonumber(qte)
                                    })
                                end
                                table.insert(PoliceJob.editedPlayerData2.items, {
                                    itemName = v.itemName,
                                    itemLabel = v.itemLabel,
                                    itemCount = tonumber(qte)
                                })
                            end
                        end)
                    end

                    for k,v in pairs(PoliceJob.selectedSaisie.weapons) do
                        RageUI.ButtonWithStyle(v.weaponLabel, "~r~ENTER ~s~pour retirer", { RightLabel = "~o~"..v.weaponAmmo.."x" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                v.count = v.count - 1
                                if v.count == 0 then table.remove(PoliceJob.selectedSaisie.weapons, k) end
                                table.insert(PoliceJob.saisiePlayerData.loadout, v)
                                table.insert(PoliceJob.editedPlayerData2.weapons, v)
                            end
                        end)
                    end

                end)

            end
        end)
    end
end