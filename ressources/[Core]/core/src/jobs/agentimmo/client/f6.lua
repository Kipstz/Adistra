
Agent_ImmoJob.F6Menu = RageUI.CreateMenu("Agence Immobilière", "~p~Agence Immobilière~s~: Actions", 8, 200)

Agent_ImmoJob.InteractionsCitoyens = RageUI.CreateSubMenu(Agent_ImmoJob.F6Menu, "Agence Immobilière", "Interactions Citoyens", 8, 200)
Agent_ImmoJob.AutresMenu = RageUI.CreateSubMenu(Agent_ImmoJob.F6Menu, "Agence Immobilière", "Autres", 8, 200)

Agent_ImmoJob.BuilderMenu = RageUI.CreateSubMenu(Agent_ImmoJob.F6Menu, "Agence Immobilière", "Création d'une Propriété", 8, 200)
Agent_ImmoJob.ParamsMenu =RageUI.CreateSubMenu(Agent_ImmoJob.BuilderMenu, "Agence Immobilière", "Paramètres de la Propriété", 8, 200)
Agent_ImmoJob.InterieursMenu =RageUI.CreateSubMenu(Agent_ImmoJob.ParamsMenu, "Agence Immobilière", "Intérieurs Disponibles", 8, 200)
Agent_ImmoJob.PointsMenu = RageUI.CreateSubMenu(Agent_ImmoJob.BuilderMenu, "Agence Immobilière", "Points de la Propriété", 8, 200)
Agent_ImmoJob.PropertiesMenu = RageUI.CreateSubMenu(Agent_ImmoJob.F6Menu, "Agence Immobilière", "Gestions Propriétés", 8, 200)
Agent_ImmoJob.GestionMenu = RageUI.CreateSubMenu(Agent_ImmoJob.PropertiesMenu, "Agence Immobilière", "Gestions Propriétés", 8, 200)

local open = false

Agent_ImmoJob.F6Menu.Closed = function()
    open = false
end

Agent_ImmoJob.InterieursMenu.Closed = function()
    Agent_ImmoJob:tpVisualisation(PlayerPedId(), Agent_ImmoJob.myCoords)
    Agent_ImmoJob.myCoords = nil
end

Agent_ImmoJob.indexs = {
    typeInt = 1,
    garageActive = false,
    typeVente = 1
}

Agent_ImmoJob.selectedProperty = {}

Agent_ImmoJob.interieurs = {
    ['motel']      = { label = "Motel",             coords = vector3(151.09, -1007.80, -98.99) },
    ['b_gamme']    = { label = "Bas de Gamme",      coords = vector3(265.93, -999.44, -99.00) },
    ['m_appart']   = { label = "Moyen Appartement", coords = vector3(347.26, -999.29, -99.19) },
    ['h_gamme']    = { label = "Haut de Gamme",     coords = vector3(-674.45, 595.61, 145.37) },
    ['h_gamme_2']  = { label = "Haut de Gamme 2",   coords = vector3(-1459.17, -520.58, 56.92) },
    ['luxe']       = { label = "Luxieux",           coords = vector3(-788.38, 320.24, 187.31) },
    ['p_entrepot'] = { label = "Petit Entrepot",    coords = vector3(1104.72, -3100.06, -38.99) },
    ['m_entrepot'] = { label = "Moyen Entrepot",    coords = vector3(1026.87, -3099.87, -38.99) },
    ['g_entrepot'] = { label = "Grand Entrepot",    coords = vector3(1072.84, -3100.03, -38.99) },
}


Agent_ImmoJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Agent_ImmoJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Agent_ImmoJob.F6Menu, true)
        open = true

        Agent_ImmoJob.inBuilder = {
            params = {
                name = "N/A",
                typeInt = "N/A",
                priceVente = 0,
                priceLoc = 0,
                garage = false,
                poidsCoffre = 0.0
            },
            points = {
                enter = vector3(0.0, 0.0, 0.0),
                exit = vector3(0.0, 0.0, 0.0),
                dressing = vector3(0.0, 0.0, 0.0),
                coffre = vector3(0.0, 0.0, 0.0),
                garage = vector3(0.0, 0.0, 0.0),
                vehSpawn = vector3(0.0, 0.0, 0.0),
                vehHeading = vector3(0.0, 0.0, 0.0)
            }
        }

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Agent_ImmoJob.F6Menu, true, true, true, function()

                    RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, Agent_ImmoJob.AutresMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Créer une Propriété", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, Agent_ImmoJob.BuilderMenu)

                    RageUI.ButtonWithStyle("Gestion des Propriétés", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, Agent_ImmoJob.PropertiesMenu)
    
                end)

                RageUI.IsVisible(Agent_ImmoJob.AutresMenu, true, true, true, function()

                    RageUI.Separator("↓   ~p~Annonces~s~   ↓")

                    RageUI.ButtonWithStyle("Faire une annonce", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local annonce = VisualManager:KeyboardOutput("Votre annonce", "", 250)

                            if tostring(annonce) and annonce ~= '' then
                                exports["ac"]:ExecuteServerEvent('bossManagement:annonce', annonce)
                            end
                        end
                    end)
                end)

                RageUI.IsVisible(Agent_ImmoJob.BuilderMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Paramètres de la Propriété", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, Agent_ImmoJob.ParamsMenu)

                    RageUI.ButtonWithStyle("Points de la Propriété", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()
                            Agent_ImmoJob.myCoords = GetEntityCoords(plyPed)
                        end
                    end, Agent_ImmoJob.PointsMenu)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Valider la Propriété", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if Agent_ImmoJob.canCreate() then
                                TriggerServerEvent("AgentImmoJob:createBuilder", Agent_ImmoJob.inBuilder)
                            else
                                Framework.ShowNotification("~r~Vous n'avez pas tout défini correctement !")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(Agent_ImmoJob.ParamsMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Nom Propriété (Obligatoire)", nil, { RightLabel = Agent_ImmoJob.inBuilder.params.name }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local name = VisualManager:KeyboardOutput("Nom Propriété", "", 25)

                            if tostring(name) then
                                Agent_ImmoJob.inBuilder.params.name = tostring(name)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Prix de Location (Obligatoire)", nil, { RightLabel = Framework.Math.GroupDigits(Agent_ImmoJob.inBuilder.params.priceLoc) }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = VisualManager:KeyboardOutput("Prix Location", "", 15)

                            if tonumber(amount) then
                                Agent_ImmoJob.inBuilder.params.priceLoc = tonumber(amount)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Prix de Vente (Obligatoire)", nil, { RightLabel = Framework.Math.GroupDigits(Agent_ImmoJob.inBuilder.params.priceVente) }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = VisualManager:KeyboardOutput("Prix Vente", "", 15)

                            if tonumber(amount) then
                                Agent_ImmoJob.inBuilder.params.priceVente = tonumber(amount)
                            end
                        end
                    end)

                    RageUI.Checkbox("Garage", nil, Agent_ImmoJob.indexs.garageActive, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            Agent_ImmoJob.indexs.garageActive = Checked
                            Agent_ImmoJob.inBuilder.params.garage = Checked
                        end
                    end)

                    RageUI.ButtonWithStyle("Poids Max du Coffre (Obligatoire)", nil, { RightLabel = Agent_ImmoJob.inBuilder.params.poidsCoffre }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = VisualManager:KeyboardOutput("Poids du Coffre", "", 5)

                            if tonumber(amount) then
                                Agent_ImmoJob.inBuilder.params.poidsCoffre = (amount + 0.0)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Définir un Intérieur (Obligatoire)", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()
                            Agent_ImmoJob.myCoords = GetEntityCoords(plyPed)
                        end
                    end, Agent_ImmoJob.InterieursMenu)
                end)

                RageUI.IsVisible(Agent_ImmoJob.InterieursMenu, true, true, true, function()

                    if Agent_ImmoJob.inBuilder.params.typeInt ~= "N/A" then
                        RageUI.Separator("Intérieur Choisi: ~p~" .. Agent_ImmoJob.interieurs[Agent_ImmoJob.inBuilder.params.typeInt].label)
                    else
                        RageUI.Separator("Intérieur Choisi: ~r~Aucun~s~ ")
                    end

                    for k,v in pairs(Agent_ImmoJob.interieurs) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                Agent_ImmoJob.inBuilder.params.typeInt = k

                                Agent_ImmoJob:tpVisualisation(PlayerPedId(), v.coords)
                            end
                        end)
                    end

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Sortir de la prévisualitation", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if Agent_ImmoJob.myCoords ~= nil then
                                Agent_ImmoJob:tpVisualisation(PlayerPedId(), Agent_ImmoJob.myCoords)
                                Agent_ImmoJob.myCoords = nil
                            end
                        end
                    end)
                end)

                RageUI.IsVisible(Agent_ImmoJob.PointsMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Rentré dans l'intérieur choisi", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()
                            Agent_ImmoJob.myCoords = GetEntityCoords(plyPed)
                            
                            if Agent_ImmoJob.interieurs[Agent_ImmoJob.inBuilder.params.typeInt] and Agent_ImmoJob.interieurs[Agent_ImmoJob.inBuilder.params.typeInt].coords ~= nil then
                                Agent_ImmoJob:tpVisualisation(PlayerPedId(), Agent_ImmoJob.interieurs[Agent_ImmoJob.inBuilder.params.typeInt].coords)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Sortir de l'interieur", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if Agent_ImmoJob.myCoords ~= nil then
                                Agent_ImmoJob:tpVisualisation(PlayerPedId(), Agent_ImmoJob.myCoords)
                                Agent_ImmoJob.myCoords = nil
                            end
                        end
                    end)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Position Entrée (Obligatoire)", ("vector3(%s, %s, %s)"):format(Agent_ImmoJob.inBuilder.points.enter.x, Agent_ImmoJob.inBuilder.points.enter.y, Agent_ImmoJob.inBuilder.points.enter.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Agent_ImmoJob.inBuilder.points.enter = GetEntityCoords(PlayerPedId())
                        end
                    end)

                    RageUI.ButtonWithStyle("Position Sortie (Obligatoire)", ("vector3(%s, %s, %s)"):format(Agent_ImmoJob.inBuilder.points.exit.x, Agent_ImmoJob.inBuilder.points.exit.y, Agent_ImmoJob.inBuilder.points.exit.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Agent_ImmoJob.inBuilder.points.exit = GetEntityCoords(PlayerPedId())
                        end
                    end)

                    RageUI.ButtonWithStyle("Position Dressing", ("vector3(%s, %s, %s)"):format(Agent_ImmoJob.inBuilder.points.dressing.x, Agent_ImmoJob.inBuilder.points.dressing.y, Agent_ImmoJob.inBuilder.points.dressing.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Agent_ImmoJob.inBuilder.points.dressing = GetEntityCoords(PlayerPedId())
                        end
                    end)

                    RageUI.ButtonWithStyle("Position Coffre (Obligatoire)", ("vector3(%s, %s, %s)"):format(Agent_ImmoJob.inBuilder.points.coffre.x, Agent_ImmoJob.inBuilder.points.coffre.y, Agent_ImmoJob.inBuilder.points.coffre.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            Agent_ImmoJob.inBuilder.points.coffre = GetEntityCoords(PlayerPedId())
                        end
                    end)

                    if Agent_ImmoJob.inBuilder.params.garage then
                        RageUI.ButtonWithStyle("Position Garage (Obligatoire)", ("vector3(%s, %s, %s)"):format(Agent_ImmoJob.inBuilder.points.garage.x, Agent_ImmoJob.inBuilder.points.garage.y, Agent_ImmoJob.inBuilder.points.garage.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                Agent_ImmoJob.inBuilder.points.garage = GetEntityCoords(PlayerPedId())
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Position Sortie véhicule (Obligatoire)", ("vector3(%s, %s, %s)"):format(Agent_ImmoJob.inBuilder.points.vehSpawn.x, Agent_ImmoJob.inBuilder.points.vehSpawn.y, Agent_ImmoJob.inBuilder.points.vehSpawn.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                Agent_ImmoJob.inBuilder.points.vehSpawn = GetEntityCoords(PlayerPedId())
                                Agent_ImmoJob.inBuilder.points.vehHeading = GetEntityHeading(PlayerPedId())
                            end
                        end)
                    end

                end)

                RageUI.IsVisible(Agent_ImmoJob.PropertiesMenu, true, true, true, function()

                    if Property.properties then
                        for k,v in pairs(Property.properties) do
                            if v.params and v.params.name then
                                RageUI.ButtonWithStyle("[~b~"..v.id.."~s~] - "..v.params.name, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        Agent_ImmoJob.selectedProperty = {}
                                        
                                        if v.owned then
                                            table.insert(Agent_ImmoJob.selectedProperty, {
                                                id_property = v.id,
                                                params = v.params,
                                                points = v.points,
                                                owned = v.owned,
                                                owners = v.owners
                                            })
                                        else
                                            table.insert(Agent_ImmoJob.selectedProperty, {
                                                id_property = v.id,
                                                params = v.params,
                                                points = v.points,
                                                owned = v.owned,
                                                owners = nil
                                            })
                                        end
                                    end
                                end, Agent_ImmoJob.GestionMenu)
                            else
                                RageUI.ButtonWithStyle("[~b~"..v.id.."~s~] - INDEFINI", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        Agent_ImmoJob.selectedProperty = {}
                                        
                                        if v.owned then
                                            table.insert(Agent_ImmoJob.selectedProperty, {
                                                id_property = v.id,
                                                params = v.params,
                                                points = v.points,
                                                owned = v.owned,
                                                owners = v.owners
                                            })
                                        else
                                            table.insert(Agent_ImmoJob.selectedProperty, {
                                                id_property = v.id,
                                                params = v.params,
                                                points = v.points,
                                                owned = v.owned,
                                                owners = nil
                                            })
                                        end
                                    end
                                end, Agent_ImmoJob.GestionMenu)
                            end
                        end
                    end
                end)

                RageUI.IsVisible(Agent_ImmoJob.GestionMenu, true, true, true, function()

                    RageUI.Separator("↓   Informations   ↓")

                    if Agent_ImmoJob.selectedProperty then
                        for k,v in pairs(Agent_ImmoJob.selectedProperty) do
                            RageUI.ButtonWithStyle("Id de propriété: "..v.id_property, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            end)

                            if v.params and v.params.name ~= nil then
                                RageUI.ButtonWithStyle("Nom: "..v.params.name, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                end)
                            end
    
                            if Agent_ImmoJob.interieurs[v.params.typeInt] ~= nil and Agent_ImmoJob.interieurs[v.params.typeInt].label ~= nil then
                                RageUI.ButtonWithStyle("Intérieur: "..Agent_ImmoJob.interieurs[v.params.typeInt].label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                end)
                            else
                                RageUI.ButtonWithStyle("Intérieur: Non-Défini", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                end)
                            end
    
                            if v.params.priceLoc ~= nil then
                                RageUI.ButtonWithStyle("Prix Location: ~g~"..Framework.Math.GroupDigits(v.params.priceLoc).."$~s~", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                end)
                            end
    
                            if v.params.priceVente ~= nil then
                                RageUI.ButtonWithStyle("Prix Vente: ~g~"..Framework.Math.GroupDigits(v.params.priceVente).."$~s~", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                end)
                            end
    
                            if v.params.poidsCoffre ~= nil then
                                RageUI.ButtonWithStyle("Poids du Coffre: ~b~"..v.params.poidsCoffre.." ~s~KG", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                end)
                            end
    
                            if v.params.garage then
                                RageUI.ButtonWithStyle("Garage: ~g~Actif~s~", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                end)
                            else
                                RageUI.ButtonWithStyle("Garage: ~r~Non-Actif~s~", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                end)
                            end
    
                            if v.owned then
                                RageUI.ButtonWithStyle("Possédé: ~g~Oui~s~", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                end)
                            else
                                RageUI.ButtonWithStyle("Possédé: ~r~Non~s~", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                end)
                            end
                        end
                    end

                    RageUI.Separator("↓   Actions   ↓")

                    if Agent_ImmoJob.selectedProperty then
                        local myCoords = GetEntityCoords(PlayerPedId())
                        local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)

                        for k,v in pairs(Agent_ImmoJob.selectedProperty) do
                            RageUI.ButtonWithStyle("Établir un point GPS", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    SetNewWaypoint(v.points.enter.x, v.points.enter.y)
                                end
                            end)

                            if not v.owned then
                                RageUI.List("Louer la Propriété", { "Personne Proche", "Pour moi" }, Agent_ImmoJob.indexs.typeVente, nil, {}, true, function(Hovered, Active, Selected, Index)
                                    if Selected then
                                        if Index == 1 then
                                            if closestPlayer ~= -1 and closestPlayerDistance < 3 then
                                                TriggerServerEvent("AgentImmoJob:addOwner", GetPlayerServerId(closestPlayer), true, Agent_ImmoJob.selectedProperty)
                                            else
                                                Framework.ShowNotification("~r~Personne a proximité !")
                                            end
                                        elseif Index == 2 then
                                            TriggerServerEvent("AgentImmoJob:addOwner", GetPlayerServerId(PlayerId()), true, Agent_ImmoJob.selectedPropertyv)
                                        end
                                    end
                                end, function(Index)
                                    Agent_ImmoJob.indexs.typeVente = Index
                                end)
            
                                RageUI.List("Vendre la Propriété", { "Personne Proche", "Pour moi" }, Agent_ImmoJob.indexs.typeVente, nil, {}, true, function(Hovered, Active, Selected, Index)
                                    if Selected then
                                        if Index == 1 then
                                            if closestPlayer ~= -1 and closestPlayerDistance < 3 then
                                                TriggerServerEvent("AgentImmoJob:addOwner", GetPlayerServerId(closestPlayer), false, Agent_ImmoJob.selectedProperty)
                                            else
                                                Framework.ShowNotification("~r~Personne a proximité !")
                                            end
                                        elseif Index == 2 then
                                            TriggerServerEvent("AgentImmoJob:addOwner", GetPlayerServerId(PlayerId()), false, Agent_ImmoJob.selectedProperty)
                                        end
                                    end
                                end, function(Index)
                                    Agent_ImmoJob.indexs.typeVente = Index
                                end)
        
                                RageUI.Line()
                                
                                if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].grade > 0 then
                                    RageUI.ButtonWithStyle("Supprimer la Propriété", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                        if Selected then
                                            TriggerServerEvent('AgentImmoJob:deleteProperty', v.id_property)
                                        end
                                    end)
                                end
                            else
                                if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].grade > 1 then
                                    RageUI.ButtonWithStyle("Supprimer tout les Propriétaires", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                        if Selected then
                                            TriggerServerEvent('AgentImmoJob:removeOwner', v.id_property)
                                        end
                                    end)

                                    RageUI.Line()
                                end

                                if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].grade > 0 then
                                    RageUI.List("Ajouter un Co-Propriétaire", { "Personne Proche", "Moi-même" }, Agent_ImmoJob.indexs.typeVente, nil, {}, true, function(Hovered, Active, Selected, Index)
                                        if Selected then
                                            if Index == 1 then
                                                if closestPlayer ~= -1 and closestPlayerDistance < 3 then
                                                    TriggerServerEvent("AgentImmoJob:addSubOwner", GetPlayerServerId(closestPlayer), Agent_ImmoJob.selectedProperty)
                                                else
                                                    Framework.ShowNotification("~r~Personne a proximité !")
                                                end
                                            elseif Index == 2 then
                                                TriggerServerEvent("AgentImmoJob:addSubOwner", GetPlayerServerId(PlayerId()), Agent_ImmoJob.selectedProperty)
                                            end
                                        end
                                    end, function(Index)
                                        Agent_ImmoJob.indexs.typeVente = Index
                                    end)
                                else
                                    RageUI.List("Ajouter un Co-Propriétaire", { "Personne Proche" }, Agent_ImmoJob.indexs.typeVente, nil, {}, true, function(Hovered, Active, Selected, Index)
                                        if Selected then
                                            if Index == 1 then
                                                if closestPlayer ~= -1 and closestPlayerDistance < 3 then
                                                    TriggerServerEvent("AgentImmoJob:addSubOwner", GetPlayerServerId(closestPlayer), Agent_ImmoJob.selectedProperty)
                                                else
                                                    Framework.ShowNotification("~r~Personne a proximité !")
                                                end
                                            end
                                        end
                                    end, function(Index)
                                        Agent_ImmoJob.indexs.typeVente = Index
                                    end)
                                end

                                RageUI.List("Supprimer un Co-Propriétaire", { "Personne Proche", "Moi-même" }, Agent_ImmoJob.indexs.typeVente, nil, {}, true, function(Hovered, Active, Selected, Index)
                                    if Selected then
                                        if Index == 1 then
                                            if closestPlayer ~= -1 and closestPlayerDistance < 3 then
                                                TriggerServerEvent('AgentImmoJob:removeSubOwner', GetPlayerServerId(closestPlayer), v.id_property)
                                            else
                                                Framework.ShowNotification("~r~Personne a proximité !")
                                            end
                                        elseif Index == 2 then
                                            TriggerServerEvent('AgentImmoJob:removeSubOwner', GetPlayerServerId(PlayerId()), v.id_property)
                                        end
                                    end
                                end, function(Index)
                                    Agent_ImmoJob.indexs.typeVente = Index
                                end)
                            end
                        end
                    end
                end)

            end
        end)
    end
end

Agent_ImmoJob.canCreate = function()
    local pa = Agent_ImmoJob.inBuilder.params
    local p = Agent_ImmoJob.inBuilder.points

    if pa.garage then 
        if p.enter.x ~= 0.0 and p.exit.x ~= 0.0 and p.coffre.x ~= 0.0 and p.garage.x ~= 0.0 and p.vehSpawn.x ~= 0.0 and p.vehHeading ~= 0.0 then
            if pa.name ~= "N/A" and pa.typeInt ~= "N/A" then
                return true
            end
        end
    elseif not pa.garage then 
        if p.enter.x ~= 0.0 and p.exit.x ~= 0.0 and p.coffre.x ~= 0.0 then
            if pa.name ~= "N/A" and pa.typeInt ~= "N/A" then
                return true
            end
        end
    end

    return false
end