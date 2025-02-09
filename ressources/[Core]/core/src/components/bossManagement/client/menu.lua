
bossManagement.MainMenu = RageUI.CreateMenu("Société Management", "~p~Société~s~: Actions", 8, 200)

bossManagement.BossMenu = RageUI.CreateSubMenu(bossManagement.MainMenu, "Société Management", "~p~Société~s~: Actions Patron", 8, 200)
bossManagement.AnnoncesMenu = RageUI.CreateSubMenu(bossManagement.MainMenu, "Société Management", "~p~Société~s~: Annonces", 8, 200)
bossManagement.employeesMenu = RageUI.CreateSubMenu(bossManagement.BossMenu, "Société Management", "~p~Société~s~: Gestion des Employées", 8, 200)
bossManagement.PromoteMenu = RageUI.CreateSubMenu(bossManagement.employeesMenu, "Société Management", "~p~Société~s~: Promouvoir", 8, 200)

bossManagement.CoffreMenu = RageUI.CreateSubMenu(bossManagement.MainMenu, "Coffre", "~p~Coffre~s~: Actions", 8, 200)
bossManagement.DepositMenu = RageUI.CreateSubMenu(bossManagement.MainMenu, "Coffre", "~p~Coffre~s~: Déposer un objet/une arme", 8, 200)
bossManagement.RemoveMenu = RageUI.CreateSubMenu(bossManagement.MainMenu, "Coffre", "~p~Coffre~s~: Retirer un objet/une arme", 8, 200)

local open = false

bossManagement.MainMenu.Closed = function()
    open = false
end

bossManagement.Indexs = {
    empGestion = 1
}

bossManagement.OpenBossMenu = function(societeName, wlGrades)
    if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == societeName then else return end

    if Framework.PlayerData.jobs['job'].grade == 0 and Framework.PlayerData.jobs['job'].grade_name ~= 'boss' then
        Framework.ShowNotification("~r~Vous n'avez pas un grade asser élever !")
        return
    end

    if SharedSocietes[societeName] == nil or SharedSocietes[societeName].label == nil then
        Framework.ShowNotification("~r~Société invalide, contacter le développeur du serveur par ticket sur le discord.")
        return
    end

    if open then
        RageUI.CloseAll()
        RageUI.Visible(bossManagement.MainMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(bossManagement.MainMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(bossManagement.MainMenu, true, true, true, function()

                    if SharedSocietes[societeName] ~= nil and SharedSocietes[societeName].label ~= nil then
                        RageUI.Separator("Société: ~p~"..SharedSocietes[societeName].label)

                        RageUI.ButtonWithStyle("Acceder au Coffre", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        end, bossManagement.CoffreMenu)
    
                        if Framework.PlayerData.jobs['job'].grade_name == 'boss' or bossManagement.isOtherWLbyGrade(wlGrades, Framework.PlayerData.jobs['job'].grade_name) then
                            RageUI.ButtonWithStyle("Annonces", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            end, bossManagement.AnnoncesMenu)
                            
                            RageUI.ButtonWithStyle("Acceder aux Actions Patron", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    Framework.TriggerServerCallback("bossManagement:getSocietyAccount", function(money)
                                        SharedSocietes[societeName].data.accounts['money'] = money
                                    end, societeName)
                                end
                            end, bossManagement.BossMenu)
                        end
                    end
                end)

                RageUI.IsVisible(bossManagement.AnnoncesMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Faire une annonce", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local annonce = VisualManager:KeyboardOutput("Votre annonce", "", 250)

                            if tostring(annonce) and annonce ~= '' then
                                exports["ac"]:ExecuteServerEvent('bossManagement:annonce', annonce)
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(bossManagement.BossMenu, true, true, true, function()
                    RageUI.Separator("Argent Société : ~g~".. SharedSocietes[societeName].data.accounts['money'] .."$~s~")

                    RageUI.ButtonWithStyle("Déposer de l'argent", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = VisualManager:KeyboardOutput("Montant", "", 10)

                            if tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('bossManagement:depositMoney', societeName, tonumber(amount))

                                Wait(50)

                                Framework.TriggerServerCallback("bossManagement:getSocietyAccount", function(money)
                                    SharedSocietes[societeName].data.accounts['money'] = money
                                end, societeName)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                            end
                        end
                    end)



                    RageUI.ButtonWithStyle("Retirer de l'argent", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = VisualManager:KeyboardOutput("Montant", "", 10)

                            if tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('bossManagement:removeMoney', societeName, tonumber(amount))

                                Wait(50)

                                Framework.TriggerServerCallback("bossManagement:getSocietyAccount", function(money)
                                    SharedSocietes[societeName].data.accounts['money'] = money
                                end, societeName)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                            end
                        end
                    end)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Gestion des Employées", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            bossManagement.employees = {}

                            Framework.TriggerServerCallback("bossManagement:getEmployees", function(employees)
                                bossManagement.employees = employees
                            end, societeName)
                        end
                    end, bossManagement.employeesMenu)

                end)

                RageUI.IsVisible(bossManagement.employeesMenu, true, true, true, function()

                    for k,v in pairs(bossManagement.employees) do
                        local gradeLabel = (v.job.grade_label == '' and v.job.label or v.job.grade_label)

                        RageUI.List(v.name, { "Promouvoir", "Virer" }, bossManagement.Indexs.empGestion, gradeLabel, {}, true, function(Hovered, Active, Selected, Index)
                            bossManagement.Indexs.empGestion = Index

                            if Selected then
                                if Index == 1 then
                                    bossManagement.promoteJobs = {}

                                    Framework.TriggerServerCallback("bossManagement:getJob", function(jobs)
                                        bossManagement.promoteJobs = jobs
                                    end, societeName)

                                    RageUI.CloseAll()

                                    RageUI.Visible(bossManagement.PromoteMenu, true)

                                    bossManagement.promotePlayerIdentifier = v.identifier
                                    bossManagement.promotePlayerCharacterID = v.characterId
                                elseif Index == 2 then
                                    exports["ac"]:ExecuteServerEvent('bossManagement:virer', v.characterId, v.identifier)

                                    RageUI.GoBack()
                                end
                            end
                        end)
                    end

                    -- RageUI.Line()

                    -- RageUI.ButtonWithStyle("Recruter", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    -- end)

                end)

                RageUI.IsVisible(bossManagement.PromoteMenu, true, true, true, function()
                    if next(bossManagement.promoteJobs) then
                        for k,v in pairs(bossManagement.promoteJobs.grades) do
                            local gradeLabel = (v.label == '' and bossManagement.promoteJobs.label or v.label)
    
                            RageUI.ButtonWithStyle(gradeLabel, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    exports["ac"]:ExecuteServerEvent("bossManagement:promote", bossManagement.promotePlayerCharacterID, bossManagement.promotePlayerIdentifier, societeName, v.grade)
                                
                                    RageUI.CloseAll()
                                    RageUI.Visible(bossManagement.BossMenu, true)
                                end
                            end)
                        end
                    end
                end)

                RageUI.IsVisible(bossManagement.CoffreMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Déposer un objet/une arme", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    end, bossManagement.DepositMenu)

                    if Framework.PlayerData.jobs['job'].grade_name == 'boss' or bossManagement.isOtherWLbyGrade(wlGrades, Framework.PlayerData.jobs['job'].grade_name) then
                        RageUI.ButtonWithStyle("Retirer un objet/une arme", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                Framework.TriggerServerCallback('bossManagement:getCoffre', function(coffre) 
                                    SharedSocietes[societeName].data = coffre
                                end, societeName)
                            end
                        end, bossManagement.RemoveMenu)
                    end

                end)

                RageUI.IsVisible(bossManagement.DepositMenu, true, true, true, function()

                    RageUI.Separator("↓   ~p~Mon Inventaire~s~   ↓")

                    for k,v in pairs(Framework.PlayerData.inventory) do
                        if v.count > 0 then
                            RageUI.ButtonWithStyle("[~b~"..v.count.."x~s~] - "..v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local qte = VisualManager:KeyboardOutput("Quantité", "", 5)

                                    if tonumber(qte) then
                                        RageUI.GoBack()

                                        TriggerServerEvent('bossManagement:deposit', societeName, 'item_standard', v, tonumber(qte))
                                    else
                                        Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                                    end
                                end
                            end)
                        end
                    end

                    RageUI.Separator("↓   ~p~Mes armes~s~   ↓")

                    for k,v in pairs(Framework.PlayerData.loadout) do
                        RageUI.ButtonWithStyle("[~o~"..v.ammo.."Muns~s~] - "..v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if not Framework.WeaponisBoutique(v.name) then
                                    RageUI.GoBack()

                                    TriggerServerEvent('bossManagement:deposit', societeName, 'item_weapon', v)
                                else
                                    Framework.ShowNotification("~r~Vous ne pouvez pas déposer une arme boutique !")
                                end
                            end
                        end)
                    end
                end)

                RageUI.IsVisible(bossManagement.RemoveMenu, true, true, true, function()

                    RageUI.Separator("↓   ~p~Objets~s~   ↓")

                    for k,v in pairs(SharedSocietes[societeName].data["items"]) do
                        if v.count > 0 then
                            RageUI.ButtonWithStyle("[~b~"..v.count.."x~s~] - "..v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local qte = VisualManager:KeyboardOutput("Quantité", "", 5)

                                    if tonumber(qte) then
                                        RageUI.GoBack()

                                        TriggerServerEvent('bossManagement:remove', societeName, 'item_standard', v, tonumber(qte))
                                    else
                                        Framework.ShowNotification("~r~Veuillez saisir une quantité valide !")
                                    end
                                end
                            end)
                        end
                    end

                    RageUI.Separator("↓   ~p~Armes~s~   ↓")

                    for k,v in pairs(SharedSocietes[societeName].data["weapons"]) do
                        RageUI.ButtonWithStyle("[~b~"..v.count.."x~s~] - "..v.label, nil, { RightLabel = "~o~"..v.ammo.."Muns~s~" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                RageUI.GoBack()

                                TriggerServerEvent('bossManagement:remove', societeName, 'item_weapon', v)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end
