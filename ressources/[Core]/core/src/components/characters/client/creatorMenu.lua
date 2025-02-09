
-------- Indexs --------

local Indexs = {
    Sexe = 1,
    Visage = 1,
    CouleurPeau = 1,
    --------
    Coiffure = 1,
    ColorCoiffure_one = 1,
    ColorCoiffure_two = 1,
    ColorCoiffure2_one = 1,
    ColorCoiffure2_two = 1,
    --------
    Sourcils = 1,
    OpaciteSourcils = 1,
    ColorSourcils_one = 1,
    ColorSourcils_two = 1,
    --------
    Barbe = 1,
    OpaciteBarbe = 1,
    ColorBarbe_one = 1,
    ColorBarbe_two = 1,
    --------
    ProblemesPeau = 1,
    OpaciteProblemesPeau = 1,
    --------
    Vieillissement = 1,
    OpaciteVieillissement = 1,
    --------
    Teint = 1,
    OpaciteTeint = 1,
    --------
    Taches = 1,
    OpaciteTaches = 1,
    --------
    AspectPeau = 1,
    OpaciteAspectPeau = 1,
    --------
    CouleurYeux = 1,
    --------
    Maquillage = 1,
    OpaciteMaquillage = 1,
    ColorMaquillage_one = 1,
    ColorMaquillage_two = 1,
    --------
    RougeLevres = 1,
    OpaciteRougeLevres = 1,
    ColorRougeLevres_one = 1,
    ColorRougeLevres_two = 1,
    --------
    Style = 1,
    Tenue = 1,
    Chapeau = 1,
    Lunettes = 1
}

Panel = {
	GridPanel = {
		x = 0.5,
		y = 0.5,
		Top = "Haut",
        Bottom = "Bas",
        Left = "Gauche",
        Right = "Droite",
		enable = false
	},
	GridPanelHorizontal = {
		x = 0.5,
        Left = "Gauche",
        Right = "Droite",
		enable = false
	},
    ColourPanel = {
        index_one = 1,
        index_two = 1,
		name = "Couleur",
        Color = RageUI.PanelColour.HairCut,
		enable = false
	},
	PercentagePanel = {
		index = 1,
        MinText = '0%',
        HeaderText = "Opacité",
        MaxText = '100%',
		enable = false
	}
}

function CreatePanel(type, data)
    if data.Top then Panel[type].Top = data.Top end
    if data.Bottom then Panel[type].Bottom = data.Bottom end
    if data.Left then Panel[type].Left = data.Left end
    if data.Right then Panel[type].Right = data.Right end
    if data.x then Panel[type].PFF = data.x end
    if data.y then Panel[type].PFF2 = data.y end
    if data.name then Panel[type].name = data.name end
    if data.HeaderText then Panel[type].HeaderText = data.HeaderText end
    if type ~= 'ColourPanel' and type ~= 'PercentagePanel' and type ~= '' then
	    if not Panel[type].currentItem then Panel[type].lastItem = data.x else Panel[type].lastItem = Panel[type].currentItem end	
		Panel[type].currentItem = data.x
		if not Panel[type][Panel[type].currentItem] then
			Panel[type][Panel[type].currentItem] = {
				x = 0,
				y = 0
			}
		end
	end
	if type == 'ColourPanel' or type == 'PercentagePanel' then
        if not Panel[type].currentItem then Panel[type].lastItem = data.item else Panel[type].lastItem = Panel[type].currentItem end	
		Panel[type].currentItem = data.item
		if not Panel[type][Panel[type].currentItem] then
			Panel[type][Panel[type].currentItem] = {
				index = 1,
				minindex = 1
			}
		end
        if data.Panel then
			if not Panel[data.Panel].currentItem then Panel[data.Panel].lastItem = data.item else Panel[data.Panel].lastItem = Panel[data.Panel].currentItem end	
			Panel[data.Panel].currentItem = data.item
			if not Panel[data.Panel][Panel[data.Panel].currentItem] then
				Panel[data.Panel][Panel[data.Panel].currentItem] = {
					index = data.Panel == 'PercentagePanel' and 0 or 1,
					minindex = 1
				}
			end
		end
	end
	for k,v in pairs(Panel) do
		if data.Panel then
			if k == type or k == data.Panel then v.enable = true else v.enable = false end
		else
	        if k == type then v.enable = true else v.enable = false end
	    end
    end
end

CreatorMenuIsOpen = false

function Characters:OpenCreatorMenu(id)
    Characters.CreatorMenu = RageUI.CreateMenu(Config["Characters"].MenuTitle.CreatorMenu, Config["Characters"].MenuSubTitle.CreatorMenu, 8, 200)

    Characters.PersoEdit = RageUI.CreateSubMenu(Characters.CreatorMenu, Config["Characters"].MenuTitle.CreatorMenu, Config["Characters"].MenuSubTitle.CreatorMenu, 8, 200)

    Characters.TraitsMenu = RageUI.CreateSubMenu(Characters.PersoEdit, Config["Characters"].MenuTitle.CreatorMenu, Config["Characters"].MenuSubTitle.CreatorMenu, 8, 200)
    Characters.ApparenceMenu = RageUI.CreateSubMenu(Characters.PersoEdit, Config["Characters"].MenuTitle.CreatorMenu, Config["Characters"].MenuSubTitle.CreatorMenu, 8, 200)
    Characters.VetementsMenu = RageUI.CreateSubMenu(Characters.PersoEdit, Config["Characters"].MenuTitle.CreatorMenu, Config["Characters"].MenuSubTitle.CreatorMenu, 8, 200)
    Characters.FinalMenu = RageUI.CreateSubMenu(Characters.PersoEdit, Config["Characters"].MenuTitle.CreatorMenu, Config["Characters"].MenuSubTitle.CreatorMenu, 8, 200)

    Characters.CreatorMenu.Closed = function()
        CreatorMenuIsOpen = false
    end

    if CreatorMenuIsOpen then
        RageUI.CloseAll()
        RageUI.Visible(Characters.CreatorMenu, false)
        CreatorMenuIsOpen = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Characters.CreatorMenu, true)
        CreatorMenuIsOpen = true

        SkinChanger.CreateSkinCam()
        SetEntityHeading(PlayerPedId(), 180.0)
        SkinChanger.zoomOffset = 0.75
        SkinChanger.camOffset = 0.15
        SkinChanger.angle = 255.0

        Characters.identity = {
            nom = "Non-Défini",
            prenom = "Non-Défini",
            ddn = "24/02/2020",
            taille = "Non-Défini",
            sexe = "Non-Défini",
            canValid = false
        }

        Characters.CreatorMenu.Closable = false
        Characters.PersoEdit.Closable = false
        Characters.TraitsMenu.EnableMouse    = true
        Characters.ApparenceMenu.EnableMouse = true

        CreateThread(function()
            while CreatorMenuIsOpen do
                Wait(1)

                RageUI.IsVisible(Characters.CreatorMenu, true, true, true, function()

                    RageUI.Separator("↓   ~p~Identité~s~   ↓")

                    RageUI.ButtonWithStyle("Nom", nil, { RightLabel = Characters.identity.nom }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local nom = VisualManager:KeyboardOutput("Votre Nom", "", 25)

                            if tostring(nom) and nom ~= '' then
                                Characters.identity.nom = nom
                                Characters.identity.canValid = true
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Prénom", nil, { RightLabel = Characters.identity.prenom }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local prenom = VisualManager:KeyboardOutput("Votre Prénom", "", 25)

                            if tostring(prenom) and prenom ~= '' then
                                Characters.identity.prenom = prenom
                                Characters.identity.canValid = true
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Date de Naissance", nil, { RightLabel = Characters.identity.ddn }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local ddn = VisualManager:KeyboardOutput("Date de Naissance (JJ/MM/AAAA)", "", 10)

                            if ddn ~= nil and ddn ~= '' then
                                Characters.identity.ddn = ddn
                                Characters.identity.canValid = true
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Taille", nil, { RightLabel = Characters.identity.taille }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local taille = VisualManager:KeyboardOutput("Taille (ex: 180)", "", 3)

                            if tonumber(taille) and taille ~= '' then
                                Characters.identity.taille = taille
                                Characters.identity.canValid = true
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Sexe", nil, { RightLabel = Characters.identity.sexe }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local sexe = VisualManager:KeyboardOutput("Sexe (m ou f; m = Homme f = Femme)", "", 1)
                            sexe = string.lower(sexe);

                            if tostring(sexe) and sexe ~= '' and (sexe == 'm' or sexe == 'f') then
                                Characters.identity.sexe = sexe
                                Characters.identity.canValid = true

                                if sexe == 'm' then
                                    TriggerEvent('skinchanger:change', 'sex', 0)
                                    Wait(500)
                                    for k,v in pairs(Config["Characters"]['vetements'].m) do
                                        TriggerEvent('skinchanger:change', k, v)
                                    end
                                elseif sexe == 'f' then
                                    TriggerEvent('skinchanger:change', 'sex', 1)
                                    Wait(500)
                                    for k,v in pairs(Config["Characters"]['vetements'].f) do
                                        TriggerEvent('skinchanger:change', k, v)
                                    end
                                end
                            end
                        end
                    end)

                    RageUI.Line()

                    for k,v in pairs(Characters.identity) do
                        if v == "Non-Défini" or v == "24/02/2020" then
                            Characters.identity.canValid = false

                            break
                        end
                    end

                    RageUI.ButtonWithStyle("~g~Valider l'identité", nil, { RightLabel = "→" }, Characters.identity.canValid, function(Hovered, Active, Selected)
                    end, Characters.PersoEdit)

                end)

                RageUI.IsVisible(Characters.PersoEdit, true, true, true, function()

                    Framework.ShowHelpNotification("Utilisez ~INPUT_VEH_FLY_ROLL_LEFT_ONLY~ et ~INPUT_VEH_FLY_ROLL_RIGHT_ONLY~ pour tourner la vue.")

                    RageUI.ButtonWithStyle("Sexe du Personnage", "Le sexe de votre personnage ne peut pas être modifier ici. Pour le modifier, vous devrez faire un /register quand vous sortirez de la création de personnage.", { RightLabel = Characters.identity.sexe }, false, function(Hovered, Active, Selected)
                    end)

                    RageUI.Line()

                    RageUI.List("Visage", { 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45 }, Indexs.Visage, nil, {}, true, function(Hovered, Active, Selected, Index)
					end, function(Index, Item)
                        Indexs.Visage = Index

                        SkinChanger.zoomOffset = 0.6
                        SkinChanger.camOffset = 0.65

						TriggerEvent('skinchanger:change', 'face', Index-1)
                    end)

                    RageUI.List("Couleur de Peau", { 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45 }, Indexs.CouleurPeau, nil, {}, true, function(Hovered, Active, Selected, Index)
                    end, function(Index)
                        Indexs.CouleurPeau = Index

                        SkinChanger.zoomOffset = 0.95
                        SkinChanger.camOffset = 0.25

                        TriggerEvent("skinchanger:change", 'skin', Index-1)
                    end)

                    RageUI.Line()

					RageUI.ButtonWithStyle("Traits du Visage", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SkinChanger.zoomOffset = 0.4
                            SkinChanger.camOffset = 0.65
                        end
                    end, Characters.TraitsMenu)

					RageUI.ButtonWithStyle("Apparence", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SkinChanger.zoomOffset = 0.6
                            SkinChanger.camOffset = 0.65
                        end
                    end, Characters.ApparenceMenu)

					RageUI.Line()

                    RageUI.ButtonWithStyle("Valider le Personnage", nil, { RightLabel = "→", Color = { BackgroundColor = RageUI.ItemsColour.GreenDark, HightLightColor = RageUI.ItemsColour.GreenDark } }, true, function(Hovered, Active, Selected)
                    end, Characters.FinalMenu)
                end)

                RageUI.IsVisible(Characters.TraitsMenu, true, true, true, function()
                    Framework.ShowHelpNotification("Utilisez ~INPUT_VEH_FLY_ROLL_LEFT_ONLY~ et ~INPUT_VEH_FLY_ROLL_RIGHT_ONLY~ pour tourner la vue.")

                    RageUI.ButtonWithStyle("Nez", nil, {}, true, function(Hovered, Active, Selected)
                        if Active then
                            CreatePanel('GridPanel', {x = 'nose_1', y = 'nose_2', Top = "Relevé", Bottom = "Bas", Left = "Fin", Right = "Épais"})
                        end
                    end)

                    RageUI.ButtonWithStyle("Arête du Nez", nil, {}, true, function(Hovered, Active, Selected)
                        if Active then
                            CreatePanel('GridPanel', {x = 'nose_3', y = 'nose_4', Top = "Saillante", Bottom = "Incurvée", Left = "Longue", Right = "Courte"})
                        end
                    end)

                    RageUI.ButtonWithStyle("Bout du Nez", nil, {}, true, function(Hovered, Active, Selected)
                        if Active then
                            CreatePanel('GridPanel', {x = 'nose_6', y = 'nose_5', Top = "Bout vers le Haut", Bottom = "Bout vers le Bas", Left = "Cassé Droite", Right = "Cassé Gauche"})
                        end
                    end)

                    RageUI.ButtonWithStyle("Bas du Front", nil, {}, true, function(Hovered, Active, Selected)
                        if Active then
                            CreatePanel('GridPanel', {x = 'eyebrows_6', y = 'eyebrows_5', Top = "Haut", Bottom = "Bas", Left = "Intérieur", Right = "Extérieur"})
                        end
                    end)

                    RageUI.ButtonWithStyle("Pommettes", nil, {}, true, function(Hovered, Active, Selected)
                        if Active then
                            CreatePanel('GridPanel', {x = 'cheeks_2', y = 'cheeks_1', Top = "Haut", Bottom = "Bas", Left = "Intérieur", Right = "Extérieur"})
                        end
                    end)

                    RageUI.ButtonWithStyle("Joues", nil, {}, true, function(Hovered, Active, Selected)
                        if Active then
                            CreatePanel('GridPanelHorizontal', {x = 'cheeks_3', Left = "Bouffi", Right = "Émacié"})
                        end
                    end)

                    RageUI.ButtonWithStyle("Yeux", nil, {}, true, function(Hovered, Active, Selected)
                        if Active then
                            CreatePanel('GridPanelHorizontal', {x = 'eye_squint', Left = "Ouverts", Right = "Plisées"})
                        end
                    end)

                    RageUI.ButtonWithStyle("Lèvres", nil, {}, true, function(Hovered, Active, Selected)
                        if Active then
                            CreatePanel('GridPanelHorizontal', {x = 'lip_thickness', Left = "Épaisses", Right = "Minces"})
                        end
                    end)

                    RageUI.ButtonWithStyle("Mâchoire", nil, {}, true, function(Hovered, Active, Selected)
                        if Active then
                            CreatePanel('GridPanel', {x = 'jaw_1', y = 'jaw_2', Top = "Ronde", Bottom = "Carré", Left = "Étroite", Right = "Large"})
                        end
                    end)

                    RageUI.ButtonWithStyle("Profil du Menton", nil, {}, true, function(Hovered, Active, Selected)
                        if Active then
                            CreatePanel('GridPanel', {x = 'chin_2', y = 'chin_1', Top = "Haut", Bottom = "Bas", Left = "Intérieur", Right = "Extérieur"})
                        end
                    end)

                    RageUI.ButtonWithStyle("Forme du Menton", nil, {}, true, function(Hovered, Active, Selected)
                        if Active then
                            CreatePanel('GridPanel', {x = 'chin_3', y = 'chin_4', Top = "Arrondi", Bottom = "Fossette", Left = "Pointu", Right = "Carré"})
                        end
                    end)

                    RageUI.ButtonWithStyle("Largeur Du Coup", nil, {}, true, function(Hovered, Active, Selected)
                        if Active then
                            CreatePanel('GridPanelHorizontal', {x = 'neck_thickness', Left = "Mince", Right = "Épais"})
                        end
                    end)

                end, function() 
                    if Panel.GridPanel.enable then
                        RageUI.GridPanel(Panel.GridPanel.x, Panel.GridPanel.y, Panel.GridPanel.Top, Panel.GridPanel.Bottom, Panel.GridPanel.Left, Panel.GridPanel.Right, function(Hovered, Active, X, Y)
                            if Panel.GridPanel.lastItem == Panel.GridPanel.currentItem then
                                Panel.GridPanel.x = X
                                Panel.GridPanel.y = Y
                            else
                                Panel.GridPanel.x = Panel.GridPanel[Panel.GridPanel.currentItem].x
                                Panel.GridPanel.y = Panel.GridPanel[Panel.GridPanel.currentItem].y
                            end
            
            
                            if Active then
                                Panel.GridPanel[Panel.GridPanel.currentItem].x = X
                                Panel.GridPanel[Panel.GridPanel.currentItem].y = Y

                                TriggerEvent("skinchanger:change", Panel.GridPanel.PFF, math.floor(X*10))
                                TriggerEvent("skinchanger:change", Panel.GridPanel.PFF2, math.floor(Y*10))
                            end
                        end)
                    end
            
                    if Panel.GridPanelHorizontal.enable then
                        RageUI.GridPanelHorizontal(Panel.GridPanelHorizontal.x, Panel.GridPanelHorizontal.Left, Panel.GridPanelHorizontal.Right, function(Hovered, Active, X)
                            if Panel.GridPanelHorizontal.lastItem == Panel.GridPanelHorizontal.currentItem then
                                Panel.GridPanelHorizontal.x = X
                            else
                                Panel.GridPanelHorizontal.x = Panel.GridPanelHorizontal[Panel.GridPanelHorizontal.currentItem].x
                            end

                            if Active then
                                Panel.GridPanelHorizontal[Panel.GridPanelHorizontal.currentItem].x = X

                                TriggerEvent("skinchanger:change", Panel.GridPanelHorizontal.PFF, math.floor(X*10))
                            end
                        end)
                    end
                end)

                RageUI.IsVisible(Characters.ApparenceMenu, true, true, true, function()
                    Framework.ShowHelpNotification("Utilisez ~INPUT_VEH_FLY_ROLL_LEFT_ONLY~ et ~INPUT_VEH_FLY_ROLL_RIGHT_ONLY~ pour tourner la vue.")

                    RageUI.List("Coiffure", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78 }, Indexs.Coiffure, nil, {}, true, function(Hovered, Active, Selected, Index)
                    end, function(Index)
                        Indexs.Coiffure = Index
                        TriggerEvent("skinchanger:change", 'hair_1', Index-1)
                    end)

                    RageUI.List("Sourcils", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33 }, Indexs.Sourcils, nil, {}, true, function(Hovered, Active, Selected, Index)
                    end, function(Index)
                        Indexs.Sourcils = Index
                        TriggerEvent("skinchanger:change", 'eyebrows_1', Index-1)
                    end)

                    RageUI.List("Barbe", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28 }, Indexs.Barbe, nil, {}, true, function(Hovered, Active, Selected, Index)
                    end, function(Index)
                        Indexs.Barbe = Index
                        TriggerEvent("skinchanger:change", 'beard_1', Index-1)
                    end)

                    RageUI.List("Problèmes de Peau", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 }, Indexs.ProblemesPeau, nil, {}, true, function(Hovered, Active, Selected, Index)
                    end, function(Index)
                        Indexs.ProblemesPeau = Index
                        TriggerEvent("skinchanger:change", 'blemishes_1', Index-1)
                    end)

                    RageUI.List("Signes de Vieillissement", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14 }, Indexs.Vieillissement, nil, {}, true, function(Hovered, Active, Selected, Index)
                    end, function(Index)
                        Indexs.Vieillissement = Index
                        TriggerEvent("skinchanger:change", 'age_1', Index-1)
                    end)

                    RageUI.List("Teint", { 1,2,3,4,5,6,7,8,9,10,11 }, Indexs.Teint, nil, {}, true, function(Hovered, Active, Selected, Index)
                    end, function(Index)
                        Indexs.Teint = Index
                        TriggerEvent("skinchanger:change", 'complexion_1', Index-1)
                    end)

                    RageUI.List("Taches Cutannées", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17 }, Indexs.Taches, nil, {}, true, function(Hovered, Active, Selected, Index)
                    end, function(Index)
                        Indexs.Taches = Index
                        TriggerEvent("skinchanger:change", 'moles_1', Index-1)
                    end)

                    RageUI.List("Aspect de la Peau", { 1,2,3,4,5,6,7,8,9,10 }, Indexs.AspectPeau, nil, {}, true, function(Hovered, Active, Selected, Index)
                    end, function(Index)
                        Indexs.AspectPeau = Index
                        TriggerEvent("skinchanger:change", 'sun_1', Index-1)
                    end)

                    RageUI.List("Couleur des Yeux", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31 }, Indexs.CouleurYeux, nil, {}, true, function(Hovered, Active, Selected, Index)
                    end, function(Index)
                        Indexs.CouleurYeux = Index
                        TriggerEvent("skinchanger:change", 'eye_color', Index-1)
                    end)

                    RageUI.List("Maquillage des Yeux", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94 }, Indexs.Maquillage, nil, {}, true, function(Hovered, Active, Selected, Index)
                    end, function(Index)
                        Indexs.Maquillage = Index
                        TriggerEvent("skinchanger:change", 'makeup_1', Index-1)
                    end)

                    RageUI.List("Rouge à Lèvres", { 1,2,3,4,5,6,7,8,9 }, Indexs.RougeLevres, nil, {}, true, function(Hovered, Active, Selected, Index)
                    end, function(Index)
                        Indexs.RougeLevres = Index
                        TriggerEvent("skinchanger:change", 'lipstick_1', Index-1)
                    end)

                end, function() 

                    RageUI.ColourPanel("Couleur Principale", RageUI.PanelColour.HairCut, Indexs.ColorCoiffure_one, Indexs.ColorCoiffure_two, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        Indexs.ColorCoiffure_one = MinimumIndex
                        Indexs.ColorCoiffure_two = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'hair_color_1', Indexs.ColorCoiffure_two)
                        end
                    end, 1);

                    RageUI.ColourPanel("Couleur Secondaire", RageUI.PanelColour.HairCut, Indexs.ColorCoiffure2_one, Indexs.ColorCoiffure2_two, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        Indexs.ColorCoiffure2_one = MinimumIndex
                        Indexs.ColorCoiffure2_two = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'hair_color_2', Indexs.ColorCoiffure2_two)
                        end
                    end, 1);

                    RageUI.PercentagePanel(Indexs.OpaciteSourcils, "Opacité des Sourcils", "0%", "100%", function(Hovered, Active, Percent)
                        Indexs.OpaciteSourcils = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'eyebrows_2', Indexs.OpaciteSourcils*10)
                        end
                    end, 2);

                    RageUI.ColourPanel("Couleur des Sourcils", RageUI.PanelColour.HairCut, Indexs.ColorSourcils_one, Indexs.ColorSourcils_two, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        Indexs.ColorSourcils_one = MinimumIndex
                        Indexs.ColorSourcils_two = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'eyebrows_3', Indexs.ColorSourcils_two)
                        end
                    end, 2);

                    RageUI.PercentagePanel(Indexs.OpaciteBarbe, "Opacité de la Barbe", "0%", "100%", function(Hovered, Active, Percent)
                        Indexs.OpaciteBarbe = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'beard_2', Indexs.OpaciteBarbe*10)
                        end
                    end, 3);

                    RageUI.ColourPanel("Couleur de la Barbe", RageUI.PanelColour.HairCut, Indexs.ColorBarbe_one, Indexs.ColorBarbe_two, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        Indexs.ColorBarbe_one = MinimumIndex
                        Indexs.ColorBarbe_two = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'beard_3', Indexs.ColorBarbe_two)
                        end
                    end, 3);

                    RageUI.PercentagePanel(Indexs.OpaciteProblemesPeau, "Opacité", "0%", "100%", function(Hovered, Active, Percent)
                        Indexs.OpaciteProblemesPeau = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'blemishes_2', Indexs.OpaciteProblemesPeau*10)
                        end
                    end, 4);

                    RageUI.PercentagePanel(Indexs.OpaciteVieillissement, "Opacité", "0%", "100%", function(Hovered, Active, Percent)
                        Indexs.OpaciteVieillissement = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'age_2', Indexs.OpaciteVieillissement*10)
                        end
                    end, 5);

                    RageUI.PercentagePanel(Indexs.OpaciteTeint, "Opacité", "0%", "100%", function(Hovered, Active, Percent)
                        Indexs.OpaciteTeint = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'complexion_2', Indexs.OpaciteTeint*10)
                        end
                    end, 6);

                    RageUI.PercentagePanel(Indexs.OpaciteTaches, "Opacité", "0%", "100%", function(Hovered, Active, Percent)
                        Indexs.OpaciteTaches = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'moles_2', Indexs.OpaciteTaches*10)
                        end
                    end, 7);

                    RageUI.PercentagePanel(Indexs.OpaciteAspectPeau, "Opacité des Aspect", "0%", "100%", function(Hovered, Active, Percent)
                        Indexs.OpaciteAspectPeau = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'sun_2', Indexs.OpaciteAspectPeau*10)
                        end
                    end, 8);

                    RageUI.PercentagePanel(Indexs.OpaciteMaquillage, "Opacité des Maquillage", "0%", "100%", function(Hovered, Active, Percent)
                        Indexs.OpaciteMaquillage = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'makeup_2', Indexs.OpaciteMaquillage*10)
                        end
                    end, 10);

                    RageUI.ColourPanel("Couleur Principale", RageUI.PanelColour.HairCut, Indexs.ColorMaquillage_one, Indexs.ColorMaquillage_two, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        Indexs.ColorMaquillage_one = MinimumIndex
                        Indexs.ColorMaquillage_two = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'makeup_3', Indexs.ColorMaquillage_two)
                        end
                    end, 10);

                    RageUI.PercentagePanel(Indexs.OpaciteRougeLevres, "Opacité des Rouge", "0%", "100%", function(Hovered, Active, Percent)
                        Indexs.OpaciteRougeLevres = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'lipstick_2', Indexs.OpaciteRougeLevres*10)
                        end
                    end, 11);

                    RageUI.ColourPanel("Couleur Principale", RageUI.PanelColour.HairCut, Indexs.ColorRougeLevres_one, Indexs.ColorRougeLevres_two, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        Indexs.ColorRougeLevres_one = MinimumIndex
                        Indexs.ColorRougeLevres_two = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'lipstick_3', Indexs.ColorRougeLevres_two)
                        end
                    end, 11);
                end)

                RageUI.IsVisible(Characters.FinalMenu, true, true, true, function()
                    RageUI.ButtonWithStyle("Vos Informations", ("Nom: ~p~%s~s~ \nPrénom: ~p~%s~s~ \nDate de Naissance: ~p~%s~s~ \nTaille: ~p~%s~s~ \nSexe: ~p~%s~s~"):format(Characters.identity.nom, Characters.identity.prenom, Characters.identity.ddn, Characters.identity.taille, Characters.identity.sexe), {}, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end)

                    RageUI.Line()
                    
                    RageUI.ButtonWithStyle("Commencer votre aventure sur ".._Config.serverName.." !", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            DoScreenFadeOut(1500)
                            TriggerServerEvent('characters:save', id, Characters.identity)
                            Wait(5000)
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                exports["ac"]:ExecuteServerEvent('skinchanger:save', skin)
                                SkinChanger.DeleteSkinCam()
                            end)
                            RageUI.CloseAll()

                            Characters.SceneFinal()
                        end
                    end)

                end)
            end
        end)
    end
end