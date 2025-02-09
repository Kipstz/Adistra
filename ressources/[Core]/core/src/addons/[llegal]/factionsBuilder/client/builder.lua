
FactionsBuilder = {}

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(xPlayer)
    Framework.TriggerServerCallback("factionsBuilder:getFactions", function(factions)
        for k,v in pairs(factions) do
            SharedFactions[v.name] = {}
            SharedFactions[v.name].name = v.name 
            SharedFactions[v.name].label = v.label 
            SharedFactions[v.name].params = v.params
            SharedFactions[v.name].coords = v.coords
            SharedFactions[v.name].data = v.data
            SharedFactions[v.name].vehicle = v.vehicle
        end

        Factions.started = true
    end)
end)

RegisterNetEvent('factionsBuilder:updateFaction')
AddEventHandler('factionsBuilder:updateFaction', function(faction)
    SharedFactions[faction.name] = {}
    SharedFactions[faction.name].name = faction.name 
    SharedFactions[faction.name].label = faction.label 
    SharedFactions[faction.name].params = faction.params
    SharedFactions[faction.name].coords = faction.coords
    SharedFactions[faction.name].data = faction.data
    SharedFactions[faction.name].vehicle = faction.vehicle
end)

RegisterNetEvent('factionsBuilder:deleteFaction')
AddEventHandler('factionsBuilder:deleteFaction', function(factionName)
    SharedFactions[factionName] = nil
end)

FactionsBuilder.B_Main = RageUI.CreateMenu("Factions Builder", "Catégories", 8, 200)

FactionsBuilder.B_create = RageUI.CreateSubMenu(FactionsBuilder.B_Main, "Factions Builder", "Créer une Faction", 8, 200)
FactionsBuilder.B_blip = RageUI.CreateSubMenu(FactionsBuilder.B_create, "Factions Builder", "Blips", 8, 200)
FactionsBuilder.B_garage = RageUI.CreateSubMenu(FactionsBuilder.B_create, "Factions Builder", "Garage", 8, 200)
FactionsBuilder.B_coffre = RageUI.CreateSubMenu(FactionsBuilder.B_create, "Factions Builder", "Coffres", 8, 200)
FactionsBuilder.B_grades = RageUI.CreateSubMenu(FactionsBuilder.B_create, "Factions Builder", "Grades", 8, 200)

FactionsBuilder.B_gestion = RageUI.CreateSubMenu(FactionsBuilder.B_Main, "Factions Builder", "Gestion des Factions", 8, 200)
FactionsBuilder.B_selectedFaction = RageUI.CreateSubMenu(FactionsBuilder.B_gestion, "Factions Builder", "Gestion de la Faction", 8, 200)
FactionsBuilder.B_editBlip = RageUI.CreateSubMenu(FactionsBuilder.B_selectedFaction, "Factions Builder", "Edit Blips", 8, 200)
FactionsBuilder.B_editGarage = RageUI.CreateSubMenu(FactionsBuilder.B_selectedFaction, "Factions Builder", "Edit Garage", 8, 200)
FactionsBuilder.B_editCoffre = RageUI.CreateSubMenu(FactionsBuilder.B_selectedFaction, "Factions Builder", "Edit Coffres", 8, 200)

local open = false

FactionsBuilder.B_Main.Closed = function()
    open = false
end

FactionsBuilder.Indexs = {
    action = 1,
    action2 = 1
}

FactionsBuilder.OpenBuilderMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(FactionsBuilder.B_Main, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(FactionsBuilder.B_Main, true)
        open = true

        FactionsBuilder.selectedFaction = {}
        plyPed = PlayerPedId()

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(FactionsBuilder.B_Main, true, true, true, function()

                    RageUI.ButtonWithStyle("Créer une Faction", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            FactionsBuilder.inBuild = {
                                name = '',
                                label = "ND",

                                params = {
                                    blip = {
                                        active = false,
                                        pos = vector3(0.0, 0.0, 0.0),
                                        name = 'ND',
                                        sprite = 378,
                                        couleur = 0,
                                        taille = 0.5
                                    },
                                    zone = {
                                        active = false,
                                        pos = vector3(0.0, 0.0, 0.0),
                                        couleur = 0
                                    },
                                    coffre = {
                                        poids = 0.0,
                                    }
                                },
                                coords = {
                                    garage = {
                                        posMenu = vector3(0.0, 0.0, 0.0),
                                        posSpawn = vector3(0.0, 0.0, 0.0),
                                        heading = 0.0,
                                        posDeleter = vector3(0.0, 0.0, 0.0),
                                    },
                                    coffre = {
                                        posMenu = vector3(0.0, 0.0, 0.0),
                                    },
                                },
                                data = {
                                    accounts = { ['black_money'] = 0 },
                                    items = {},
                                    weapons = {}
                                },
                                vehicle = {},
                                bossIsCreate = false,
                                gradeId = 0,
                                grades = {}
                            }
                        end
                    end, FactionsBuilder.B_create)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Gérer les Factions", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, FactionsBuilder.B_gestion)

                end)

                RageUI.IsVisible(FactionsBuilder.B_create, true, true, true, function()

                    RageUI.ButtonWithStyle("Nom faction", nil, { RightLabel = "~p~"..FactionsBuilder.inBuild.label }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local name = VisualManager:KeyboardOutput("Nom de la Faction", "", 25)

                            if tostring(name) and name ~= '' then
                                FactionsBuilder.inBuild.name = string.lower(name)
                                FactionsBuilder.inBuild.label = name
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un nom valide !")
                            end
                        end
                    end)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Paramètres Blip", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, FactionsBuilder.B_blip)

                    RageUI.ButtonWithStyle("Paramètres Garages", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, FactionsBuilder.B_garage)

                    RageUI.ButtonWithStyle("Paramètres Gestion/Coffre", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, FactionsBuilder.B_coffre)

                    RageUI.ButtonWithStyle("Paramètres Grades", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, FactionsBuilder.B_grades)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("Valider la faction", nil, { RightBadge = RageUI.BadgeStyle.Tick, Color = { BackgroundColor = RageUI.ItemsColour.GreenDark, HightLightColor = RageUI.ItemsColour.GreenDark } }, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            
                            TriggerServerEvent("factionsBuilder:addFaction",  FactionsBuilder.inBuild)
                        end
                    end)
                end)

                RageUI.IsVisible(FactionsBuilder.B_blip, true, true, true, function()

                    RageUI.Checkbox("Blip", "Pas Obligatoire", FactionsBuilder.inBuild.params.blip.active, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            FactionsBuilder.inBuild.params.blip.active = Checked
                        end
                    end)

                    if FactionsBuilder.inBuild.params.blip.active then
                        RageUI.ButtonWithStyle("Position", ("vector3(%s, %s, %s)"):format(FactionsBuilder.inBuild.params.blip.pos.x, FactionsBuilder.inBuild.params.blip.pos.y, FactionsBuilder.inBuild.params.blip.pos.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local myCoords = GetEntityCoords(plyPed)

                                FactionsBuilder.inBuild.params.blip.pos = myCoords
                            end
                        end)

                        RageUI.ButtonWithStyle("Nom", "Nom du blip", { RightLabel = "~p~"..FactionsBuilder.inBuild.params.blip.name }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local name = VisualManager:KeyboardOutput("Nom du Blip", "", 25)

                                if tostring(name) and name ~= '' then
                                    FactionsBuilder.inBuild.params.blip.name = 'Gang | '..name
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un nom valide !")
                                end
                            end
                        end)

                        RageUI.ButtonWithStyle("Sprite", "378 par default, voir https://docs.fivem.net/docs/game-references/blips/", { RightLabel = "~p~"..FactionsBuilder.inBuild.params.blip.sprite }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local sprite = VisualManager:KeyboardOutput("Sprite", "", 3)

                                if tonumber(sprite) then
                                    FactionsBuilder.inBuild.params.blip.sprite = tonumber(sprite)
                                else
                                    Framework.ShowNotification("~r~Invalide")
                                end
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Couleur", "Voir https://docs.fivem.net/docs/game-references/blips/", { RightLabel = "~p~"..FactionsBuilder.inBuild.params.blip.couleur }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local couleur = VisualManager:KeyboardOutput("Couleur", "", 3)

                                if tonumber(couleur) then
                                    FactionsBuilder.inBuild.params.blip.couleur = tonumber(couleur)
                                else
                                    Framework.ShowNotification("~r~Invalide")
                                end
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Taille", "0.5 par défault", { RightLabel = "~p~"..FactionsBuilder.inBuild.params.blip.taille }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local taille = VisualManager:KeyboardOutput("Taille", "", 3)

                                if tonumber(taille) then
                                    FactionsBuilder.inBuild.params.blip.taille = tonumber(taille)
                                else
                                    Framework.ShowNotification("~r~Invalide")
                                end
                            end
                        end)
                    end

                    RageUI.Line()
                    
                    RageUI.Checkbox("Zone", "Pas Obligatoire", FactionsBuilder.inBuild.params.zone.active, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            FactionsBuilder.inBuild.params.zone.active = Checked
                        end
                    end)

                    if FactionsBuilder.inBuild.params.zone.active then
                        RageUI.ButtonWithStyle("Position", ("vector3(%s, %s, %s)"):format(FactionsBuilder.inBuild.params.zone.pos.x, FactionsBuilder.inBuild.params.zone.pos.y, FactionsBuilder.inBuild.params.zone.pos.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local myCoords = GetEntityCoords(plyPed)

                                FactionsBuilder.inBuild.params.zone.pos = myCoords
                            end
                        end)

                        RageUI.ButtonWithStyle("Couleur", nil, { RightLabel = "~p~"..FactionsBuilder.inBuild.params.zone.couleur }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local couleur = VisualManager:KeyboardOutput("Taille", "", 3)

                                if tonumber(couleur) then
                                    FactionsBuilder.inBuild.params.zone.couleur = tonumber(couleur)
                                else
                                    Framework.ShowNotification("~r~Invalide")
                                end
                            end
                        end)
                    end

                end)
                
                RageUI.IsVisible(FactionsBuilder.B_garage, true, true, true, function()

                    RageUI.ButtonWithStyle("Position du Menu", ("vector3(%s, %s, %s)"):format(FactionsBuilder.inBuild.coords.garage.posMenu.x, FactionsBuilder.inBuild.coords.garage.posMenu.y, FactionsBuilder.inBuild.coords.garage.posMenu.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local myCoords = GetEntityCoords(plyPed)

                            FactionsBuilder.inBuild.coords.garage.posMenu = myCoords
                        end
                    end)

                    RageUI.ButtonWithStyle("Position & Sens du Spawn véhicule", ("vector3(%s, %s, %s)"):format(FactionsBuilder.inBuild.coords.garage.posSpawn.x, FactionsBuilder.inBuild.coords.garage.posSpawn.y, FactionsBuilder.inBuild.coords.garage.posSpawn.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local myCoords = GetEntityCoords(plyPed)
                            local myHeading = GetEntityHeading(plyPed)

                            FactionsBuilder.inBuild.coords.garage.posSpawn = myCoords
                            FactionsBuilder.inBuild.coords.garage.heading = myHeading
                        end
                    end)

                    RageUI.ButtonWithStyle("Position Rangement", ("vector3(%s, %s, %s)"):format(FactionsBuilder.inBuild.coords.garage.posDeleter.x, FactionsBuilder.inBuild.coords.garage.posDeleter.y, FactionsBuilder.inBuild.coords.garage.posDeleter.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local myCoords = GetEntityCoords(plyPed)
                            FactionsBuilder.inBuild.coords.garage.posDeleter = myCoords
                        end
                    end)

                end)

                RageUI.IsVisible(FactionsBuilder.B_coffre, true, true, true, function()
                    RageUI.ButtonWithStyle("Poids Max", "30 par défault", { RightLabel = FactionsBuilder.inBuild.coords.coffre.poids }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local poids = VisualManager:KeyboardOutput("Poids maximal", "", 3)

                            if tonumber(poids) then
                                FactionsBuilder.inBuild.coords.coffre.poids = (tonumber(poids) + 0.0)
                            else
                                Framework.ShowNotification("~r~Invalide")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Position du Menu", ("vector3(%s, %s, %s)"):format(FactionsBuilder.inBuild.coords.coffre.posMenu.x, FactionsBuilder.inBuild.coords.coffre.posMenu.y, FactionsBuilder.inBuild.coords.coffre.posMenu.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local myCoords = GetEntityCoords(plyPed)

                            FactionsBuilder.inBuild.coords.coffre.posMenu = myCoords
                        end
                    end)
                end)

                RageUI.IsVisible(FactionsBuilder.B_grades, true, true, true, function()
                    RageUI.Separator("↓   ~p~Liste des Grades~s~   ↓")

                    if not next(FactionsBuilder.inBuild.grades) then
                        RageUI.ButtonWithStyle("~r~Aucun grade", nil, { RightLabel = "" }, true, function(Hovered, Active, Selected) end)
                    else
                        for k,v in pairs(FactionsBuilder.inBuild.grades) do
                            if v.name ~= 'boss' then
                                RageUI.List("[~b~"..v.id.."~s~] - ~p~"..v.name.." ~s~-~p~ "..v.label, { "Supprimer", "Modifier Nom", "Modifier Label" }, FactionsBuilder.Indexs.action, nil, {}, true, function(Hovered, Active, Selected, Index)
                                    if Selected then
                                        if Index == 1 then
                                            table.remove(FactionsBuilder.inBuild.grades, k)
                                        elseif Index == 2 then
                                            local name = VisualManager:KeyboardOutput("Nom du Grade", "", 25)
                
                                            if tostring(name) and name ~= '' then
                                                FactionsBuilder.inBuild.grades[k].name = name
                                            else
                                                Framework.ShowNotification("~r~Veuillez saisir un nom valide !")
                                            end
                                        elseif Index == 3 then
                                            local name = VisualManager:KeyboardOutput("Label du Grade", "", 25)
                
                                            if tostring(name) and name ~= '' then
                                                FactionsBuilder.inBuild.grades[k].label = name
                                            else
                                                Framework.ShowNotification("~r~Veuillez saisir un nom valide !")
                                            end
                                        end
                                    end
                                end, function(Index)
                                    FactionsBuilder.Indexs.action = Index
                                end)
                            else
                                RageUI.List("[~b~"..v.id.."~s~] - ~p~"..v.name.." ~s~-~p~ "..v.label, { "Supprimer", "Modifier Label" }, FactionsBuilder.Indexs.action2, nil, {}, true, function(Hovered, Active, Selected, Index)
                                    if Selected then
                                        if Index == 1 then
                                            table.remove(FactionsBuilder.inBuild.grades, k)
                                            FactionsBuilder.inBuild.bossIsCreate = false
                                        elseif Index == 2 then
                                            local name = VisualManager:KeyboardOutput("Label du Grade", "", 25)
                
                                            if tostring(name) and name ~= '' then
                                                FactionsBuilder.inBuild.grades[k].label = name
                                            else
                                                Framework.ShowNotification("~r~Veuillez saisir un nom valide !")
                                            end
                                        end
                                    end
                                end, function(Index)
                                    FactionsBuilder.Indexs.action2 = Index
                                end)
                            end
                        end
                    end

                    RageUI.Line()

                    if not FactionsBuilder.inBuild.bossIsCreate then
                        RageUI.ButtonWithStyle("Ajouter un grade", "~r~Ces grades NE DONNERONT PAS accès au menu patron", { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                table.insert(FactionsBuilder.inBuild.grades, {
                                    id = FactionsBuilder.inBuild.gradeId,
                                    name = 'A définir',
                                    label = 'A définir'
                                })
    
                                FactionsBuilder.inBuild.gradeId = FactionsBuilder.inBuild.gradeId + 1
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle("~r~Vous ne pouvez pas créer de nouveau grade une fois le grade patron créer !", nil, {}, false, function(Hovered, Active, Selected)
                        end)
                    end

                    if not FactionsBuilder.inBuild.bossIsCreate then
                        RageUI.ButtonWithStyle("Ajouter le grade PATRON", "~r~Ce grade DONNERA accès au menu patron", { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                FactionsBuilder.inBuild.bossIsCreate = true
                                table.insert(FactionsBuilder.inBuild.grades, {
                                    id = FactionsBuilder.inBuild.gradeId,
                                    name = 'boss',
                                    label = 'A définir'
                                })
                                FactionsBuilder.inBuild.gradeId = FactionsBuilder.inBuild.gradeId + 1
                            end
                        end)
                    end
                    
                end)

                RageUI.IsVisible(FactionsBuilder.B_gestion, true, true, true, function()

                    if next(SharedFactions) then
                        for k,v in pairs(SharedFactions) do
                            RageUI.ButtonWithStyle("~b~"..v.label.."~s~", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    FactionsBuilder.selectedFaction = v
                                end
                            end, FactionsBuilder.B_selectedFaction)
                        end
                    else
                        RageUI.ButtonWithStyle("~r~Aucune Factions", nil, {}, false, function(Hovered, Active, Selected)
                        end)
                    end
                end)

                RageUI.IsVisible(FactionsBuilder.B_selectedFaction, true, true, true, function()

                    if next(FactionsBuilder.selectedFaction) then
                        RageUI.Separator("↓ Informations ↓")

                        RageUI.ButtonWithStyle("Nom faction", nil, { RightLabel = "~p~"..FactionsBuilder.selectedFaction.label }, true, function(Hovered, Active, Selected)
                        end)
    
                        RageUI.Separator("↓ Modifications ↓")
                        
                        RageUI.ButtonWithStyle("Paramètres Blip", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end, FactionsBuilder.B_editBlip)
    
                        RageUI.ButtonWithStyle("Paramètres Garages", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end, FactionsBuilder.B_editGarage)
    
                        RageUI.ButtonWithStyle("Paramètres Gestion/Coffre", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end, FactionsBuilder.B_editCoffre)

                        RageUI.ButtonWithStyle("~g~Valider les Modifications", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent('factionsBuilder:editFaction', FactionsBuilder.selectedFaction)
                            end
                        end)
    
                        RageUI.Line()
    
                        RageUI.ButtonWithStyle("~r~Supprimer la Faction", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent('factionsBuilder:deleteFaction', FactionsBuilder.selectedFaction.name)
                                RageUI.CloseAll()
                            end
                        end)

                    end
                end)

                RageUI.IsVisible(FactionsBuilder.B_editBlip, true, true, true, function()

                    if next(FactionsBuilder.selectedFaction) then
                        if FactionsBuilder.selectedFaction.params.blip.active then
                            RageUI.ButtonWithStyle("Position", ("vector3(%s, %s, %s)"):format(FactionsBuilder.selectedFaction.params.blip.pos.x, FactionsBuilder.selectedFaction.params.blip.pos.y, FactionsBuilder.selectedFaction.params.blip.pos.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local myCoords = GetEntityCoords(plyPed)
    
                                    FactionsBuilder.selectedFaction.params.blip.pos = myCoords
                                end
                            end)
    
                            RageUI.ButtonWithStyle("Nom", "Nom du blip", { RightLabel = "~p~"..FactionsBuilder.selectedFaction.params.blip.name }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local name = VisualManager:KeyboardOutput("Nom du Blip", "", 25)
    
                                    if tostring(name) and name ~= '' then
                                        FactionsBuilder.selectedFaction.params.blip.name = 'Gang | '..name
                                    else
                                        Framework.ShowNotification("~r~Veuillez saisir un nom valide !")
                                    end
                                end
                            end)
    
                            RageUI.ButtonWithStyle("Sprite", "378 par default, voir https://docs.fivem.net/docs/game-references/blips/", { RightLabel = "~p~"..FactionsBuilder.selectedFaction.params.blip.sprite }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local sprite = VisualManager:KeyboardOutput("Sprite", "", 3)
    
                                    if tonumber(sprite) then
                                        FactionsBuilder.selectedFaction.params.blip.sprite = tonumber(sprite)
                                    else
                                        Framework.ShowNotification("~r~Invalide")
                                    end
                                end
                            end)
        
                            RageUI.ButtonWithStyle("Couleur", "Voir https://docs.fivem.net/docs/game-references/blips/", { RightLabel = "~p~"..FactionsBuilder.selectedFaction.params.blip.couleur }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local couleur = VisualManager:KeyboardOutput("Couleur", "", 3)
    
                                    if tonumber(couleur) then
                                        FactionsBuilder.selectedFaction.params.blip.couleur = tonumber(couleur)
                                    else
                                        Framework.ShowNotification("~r~Invalide")
                                    end
                                end
                            end)
        
                            RageUI.ButtonWithStyle("Taille", "0.5 par défault", { RightLabel = "~p~"..FactionsBuilder.selectedFaction.params.blip.taille }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local taille = VisualManager:KeyboardOutput("Taille", "", 3)
    
                                    if tonumber(taille) then
                                        FactionsBuilder.selectedFaction.params.blip.taille = tonumber(taille)
                                    else
                                        Framework.ShowNotification("~r~Invalide")
                                    end
                                end
                            end)
                        end
    
                        if FactionsBuilder.selectedFaction.params.zone.active then
                            RageUI.Line()

                            RageUI.ButtonWithStyle("Position", ("vector3(%s, %s, %s)"):format(FactionsBuilder.selectedFaction.params.zone.pos.x, FactionsBuilder.selectedFaction.params.zone.pos.y, FactionsBuilder.selectedFaction.params.zone.pos.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local myCoords = GetEntityCoords(plyPed)
    
                                    FactionsBuilder.selectedFaction.params.zone.pos = myCoords
                                end
                            end)
    
                            RageUI.ButtonWithStyle("Couleur", nil, { RightLabel = "~p~"..FactionsBuilder.selectedFaction.params.zone.couleur }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local couleur = VisualManager:KeyboardOutput("Taille", "", 3)
    
                                    if tonumber(couleur) then
                                        FactionsBuilder.selectedFaction.params.zone.couleur = tonumber(couleur)
                                    else
                                        Framework.ShowNotification("~r~Invalide")
                                    end
                                end
                            end)
                        end
                    end

                end)

                RageUI.IsVisible(FactionsBuilder.B_editGarage, true, true, true, function()

                    
                    RageUI.ButtonWithStyle("Position du Menu", ("vector3(%s, %s, %s)"):format(FactionsBuilder.selectedFaction.coords.garage.posMenu.x, FactionsBuilder.selectedFaction.coords.garage.posMenu.y, FactionsBuilder.selectedFaction.coords.garage.posMenu.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local myCoords = GetEntityCoords(plyPed)

                            FactionsBuilder.selectedFaction.coords.garage.posMenu = myCoords
                        end
                    end)

                    RageUI.ButtonWithStyle("Position & Sens du Spawn véhicule", ("vector3(%s, %s, %s)"):format(FactionsBuilder.selectedFaction.coords.garage.posSpawn.x, FactionsBuilder.selectedFaction.coords.garage.posSpawn.y, FactionsBuilder.selectedFaction.coords.garage.posSpawn.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local myCoords = GetEntityCoords(plyPed)
                            local myHeading = GetEntityHeading(plyPed)

                            FactionsBuilder.selectedFaction.coords.garage.posSpawn = myCoords
                            FactionsBuilder.selectedFaction.coords.garage.heading = myHeading
                        end
                    end)

                    RageUI.ButtonWithStyle("Position Rangement", ("vector3(%s, %s, %s)"):format(FactionsBuilder.selectedFaction.coords.garage.posDeleter.x, FactionsBuilder.selectedFaction.coords.garage.posDeleter.y, FactionsBuilder.selectedFaction.coords.garage.posDeleter.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local myCoords = GetEntityCoords(plyPed)
                            FactionsBuilder.selectedFaction.coords.garage.posDeleter = myCoords
                        end
                    end)


                end)

                RageUI.IsVisible(FactionsBuilder.B_editCoffre, true, true, true, function()

                    RageUI.ButtonWithStyle("Poids Max", "30 par défault", { RightLabel = FactionsBuilder.selectedFaction.coords.coffre.poids }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local poids = VisualManager:KeyboardOutput("Poids maximal", "", 3)

                            if tonumber(poids) then
                                FactionsBuilder.selectedFaction.coords.coffre.poids = (tonumber(poids) + 0.0)
                            else
                                Framework.ShowNotification("~r~Invalide")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Position du Menu", ("vector3(%s, %s, %s)"):format(FactionsBuilder.selectedFaction.coords.coffre.posMenu.x, FactionsBuilder.selectedFaction.coords.coffre.posMenu.y, FactionsBuilder.selectedFaction.coords.coffre.posMenu.z), { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local myCoords = GetEntityCoords(plyPed)

                            FactionsBuilder.selectedFaction.coords.coffre.posMenu = myCoords
                        end
                    end)

                end)

            end
        end)
    end
end

RegisterNetEvent('factionsBuilder:openBuilder')
AddEventHandler('factionsBuilder:openBuilder', function()
    FactionsBuilder.OpenBuilderMenu()
end)