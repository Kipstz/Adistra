
BarberShop.Main = RageUI.CreateMenu(Config["shop_barber"].MenuTitle.MainMenu, Config["shop_barber"].MenuSubTitle.MainMenu, 8, 200)

BarberShop.Indexs = {
    hair_1 = 1,
    hair_2 = 1,
    hair_color_1 = 1,
    hair_color_2 = 1,
    hair_color2_1 = 1,
    hair_color2_2 = 1,
    eyebrows_op = 1,
    eyebrows_1 = 1,
    eyebrows_2 = 1,
    eyebrows_color_1 = 1,
    eyebrows_color_2 = 1,
    eyebrows_color2_1 = 1,
    eyebrows_color2_2 = 1,
    beard_op = 1,
    beard_1 = 1,
    beard_2 = 1,
    beard_color_1 = 1,
    beard_color_2 = 1,
    beard_color2_1 = 1,
    beard_color2_2 = 1,

    CouleurYeux = 1,

    Teint = 1,
    OpaciteTeint = 1,

    Maquillage = 1,
    OpaciteMaquillage = 1,
    ColorMaquillage_one = 1,
    ColorMaquillage_two = 1,

    ColorMaquillage_one_1 = 1,
    ColorMaquillage_two_2 = 1,


    RougeLevres = 1,
    OpaciteRougeLevres = 1,
    ColorRougeLevres_one = 1,
    ColorRougeLevres_two = 1,

    ColorRougeLevres_one_1 = 1,
    ColorRougeLevres_two_2 = 1,

    Pilositee = 1,
    OpacitePilosite = 1,
    ColorPilosite_one = 1,
    ColorPilosite_two = 1,

    Imperfections = 1,
    OpaciteImperfections = 1,

    Rides = 1,
    OpaciteRides = 1,

    Boutons = 1,
    OpaciteBoutons = 1,

    Rougeurs = 1,
    OpaciteRougeurs = 1,
    ColorRougeurs_one = 1,
    ColorRougeurs_two = 1,
    

    DommagesUV = 1,
    OpaciteDommagesUV = 1,

    TacheRousseur = 1,
    OpaciteTacheRousseur = 1,
}

BarberShopMenuIsOpen = false

BarberShop.Main.Closed = function()
    BarberShopMenuIsOpen = false

    SkinChanger.DeleteSkinCam()
end

function BarberShop:OpenMenu()
    for i = 1, #Framework.PlayerData.accounts, 1 do
		if Framework.PlayerData.accounts[i].name == 'money' then
			BarberShop.player_money = Framework.PlayerData.accounts[i].money
		end
    end

    Coiffures = {}
    Sourcils = {}
    Barbes = {}

    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 2) - 1 do
        table.insert(Coiffures, i)
    end

    for i = 0, GetNumHeadOverlayValues(2) - 1 do
        table.insert(Sourcils, i)
    end

    for i = 0, GetNumHeadOverlayValues(1) - 1 do
        table.insert(Barbes, i)
    end

    if BarberShopMenuIsOpen then
        RageUI.CloseAll()
        RageUI.Visible(BarberShop.Main, false)
        BarberShopMenuIsOpen = false
    else
        RageUI.CloseAll()
        RageUI.Visible(BarberShop.Main, true)
        BarberShopMenuIsOpen = true

        BarberShop.Main.Closable = false
        BarberShop.Main.EnableMouse = true

        SkinChanger.CreateSkinCam()

        SkinChanger.zoomOffset = 0.6
        SkinChanger.camOffset = 0.65

        CreateThread(function()
            while BarberShopMenuIsOpen do
                Wait(0)

                RageUI.IsVisible(BarberShop.Main, true, true, true, function()
                    RageUI.List("Coiffure", Coiffures, BarberShop.Indexs.hair_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            print("active")
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de la coiffure", "", 3))
                            if number then
                                BarberShop.Indexs.hair_1 = number
                                TriggerEvent('skinchanger:change', 'hair_1', number-1)
                                Framework.ShowNotification("~g~Coiffure changée pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        BarberShop.Indexs.hair_1 = Index

                        SkinChanger.zoomOffset = 0.6
                        SkinChanger.camOffset = 0.65

                        TriggerEvent('skinchanger:change', 'hair_1', Index-1) 
                        TriggerEvent('skinchanger:change', 'hair_2', 0) 
                    end)

                    
                    RageUI.List("Sourcils", Sourcils, BarberShop.Indexs.eyebrows_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro des sourcils", "", 3))
                            if number then
                                BarberShop.Indexs.eyebrows_1 = number
                                TriggerEvent('skinchanger:change', 'eyebrows_1', number-1)
                                Framework.ShowNotification("~g~Sourcils changés pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        BarberShop.Indexs.eyebrows_1 = Index

                        SkinChanger.zoomOffset = 0.4
                        SkinChanger.camOffset = 0.65

                        TriggerEvent('skinchanger:change', 'eyebrows_1', Index-1) 
                    end)

                    RageUI.List("Barbe", Barbes, BarberShop.Indexs.beard_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de la barbe", "", 3))
                            if number then
                                BarberShop.Indexs.beard_1 = number
                                TriggerEvent('skinchanger:change', 'beard_1', number-1)
                                Framework.ShowNotification("~g~Barbe changée pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        BarberShop.Indexs.beard_1 = Index

                        SkinChanger.zoomOffset = 0.4
                        SkinChanger.camOffset = 0.65

                        TriggerEvent('skinchanger:change', 'beard_1', Index-1) 
                    end)

                    RageUI.List("Couleur des Yeux", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31 }, BarberShop.Indexs.CouleurYeux, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de la couleur des yeux", "", 2))
                            if number and number <= 31 then
                                BarberShop.Indexs.CouleurYeux = number
                                TriggerEvent('skinchanger:change', 'eye_color', number-1)
                                Framework.ShowNotification("~g~Couleur des yeux changée pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide (1-31) !")
                            end
                        end
                    end, function(Index)
                        BarberShop.Indexs.CouleurYeux = Index
                        TriggerEvent("skinchanger:change", 'eye_color', Index-1)
                    end)

                    RageUI.List("Teint", { 1,2,3,4,5,6,7,8,9,10,11 }, BarberShop.Indexs.Teint, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro du teint", "", 2))
                            if number and number <= 11 then
                                BarberShop.Indexs.Teint = number
                                TriggerEvent('skinchanger:change', 'complexion_1', number-1)
                                Framework.ShowNotification("~g~Teint changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide (1-11) !")
                            end
                        end
                    end, function(Index)
                        BarberShop.Indexs.Teint = Index
                        TriggerEvent("skinchanger:change", 'complexion_1', Index-1)
                    end)

                    RageUI.List("Maquillage", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94 }, BarberShop.Indexs.Maquillage, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro du maquillage", "", 2))
                            if number and number <= 94 then
                                BarberShop.Indexs.Maquillage = number
                                TriggerEvent('skinchanger:change', 'makeup_1', number-1)
                                Framework.ShowNotification("~g~Maquillage changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide (1-94) !")
                            end
                        end
                    end, function(Index)
                        BarberShop.Indexs.Maquillage = Index
                        TriggerEvent("skinchanger:change", 'makeup_1', Index-1)
                    end)

                    RageUI.List("Rouge à Lèvres", { 1,2,3,4,5,6,7,8,9,10 }, BarberShop.Indexs.RougeLevres, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro du rouge à lèvres", "", 1))
                            if number and number <= 9 then
                                BarberShop.Indexs.RougeLevres = number
                                TriggerEvent('skinchanger:change', 'lipstick_1', number-1)
                                Framework.ShowNotification("~g~Rouge à lèvres changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide (1-9) !")
                            end
                        end
                    end, function(Index)
                        BarberShop.Indexs.RougeLevres = Index
                        TriggerEvent("skinchanger:change", 'lipstick_1', Index-1)
                    end)

                    RageUI.List("Pilositée", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16 }, BarberShop.Indexs.Pilositee, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de la pilositée", "", 1))
                            if number and number <= 16 then
                                BarberShop.Indexs.Pilositee = number
                                TriggerEvent('skinchanger:change', 'chest_1', number-1)
                                Framework.ShowNotification("~g~Pilositée changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide (1-16) !")
                            end
                        end
                    end, function(Index)
                        BarberShop.Indexs.Pilositee = Index

                        SkinChanger.zoomOffset = 0.6
                        SkinChanger.camOffset = 0.35

                        TriggerEvent("skinchanger:change", 'chest_1', Index-1)
                    end)

                    RageUI.List("Imperfections", { 1,2,3,4,5,6,7,8,9,10,11 }, BarberShop.Indexs.Imperfections, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de l'imperfections", "", 1))
                            if number and number <= 11 then
                                BarberShop.Indexs.Pilositee = number
                                TriggerEvent('skinchanger:change', 'bodyb_1', number-1)
                                Framework.ShowNotification("~g~Imperfections changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide (1-11) !")
                            end
                        end
                    end, function(Index)
                        BarberShop.Indexs.Imperfections = Index


                        TriggerEvent("skinchanger:change", 'bodyb_1', Index-1)
                    end)

                    RageUI.List("Rides", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14 }, BarberShop.Indexs.Rides, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de rides", "", 1))
                            if number and number <= 14 then
                                BarberShop.Indexs.Rides = number
                                TriggerEvent('skinchanger:change', 'age_1', number-1)
                                Framework.ShowNotification("~g~Rides changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide (1-14) !")
                            end
                        end
                    end, function(Index)
                        BarberShop.Indexs.Rides = Index


                        TriggerEvent("skinchanger:change", 'age_1', Index-1)
                    end)

                    RageUI.List("Boutons", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 }, BarberShop.Indexs.Boutons, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de boutons", "", 1))
                            if number and number <= 23 then
                                BarberShop.Indexs.Boutons = number
                                TriggerEvent('skinchanger:change', 'blemishes_1', number-1)
                                Framework.ShowNotification("~g~Boutons changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide (1-23) !")
                            end
                        end
                    end, function(Index)
                        BarberShop.Indexs.Boutons = Index


                        TriggerEvent("skinchanger:change", 'blemishes_1', Index-1)
                    end)

                    RageUI.List("Rougeurs", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32 }, BarberShop.Indexs.Rougeurs, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de rougeurs", "", 1))
                            if number and number <= 32 then
                                BarberShop.Indexs.Rougeurs = number
                                TriggerEvent('skinchanger:change', 'blush_1', number-1)
                                Framework.ShowNotification("~g~Rougeurs changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide (1-32) !")
                            end
                        end
                    end, function(Index)
                        BarberShop.Indexs.Rougeurs = Index


                        TriggerEvent("skinchanger:change", 'blush_1', Index-1)
                    end)

                    
                    RageUI.List("Dommages UV", { 1,2,3,4,5,6,7,8,9,10}, BarberShop.Indexs.DommagesUV, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de rougeurs", "", 1))
                            if number and number <= 10 then
                                BarberShop.Indexs.DommagesUV = number
                                TriggerEvent('skinchanger:change', 'sun_1', number-1)
                                Framework.ShowNotification("~g~Dommages UV changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide (1-10) !")
                            end
                        end
                    end, function(Index)
                        BarberShop.Indexs.DommagesUV = Index


                        TriggerEvent("skinchanger:change", 'sun_1', Index-1)
                    end)

                    RageUI.List("Taches de Rousseurs", { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17 }, BarberShop.Indexs.TacheRousseur, nil, {}, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de tache de rousseur", "", 1))
                            if number and number <= 17 then
                                BarberShop.Indexs.TacheRousseur = number
                                TriggerEvent('skinchanger:change', 'moles_1', number-1)
                                Framework.ShowNotification("~g~Tache de rousseurs changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide (1-17) !")
                            end
                        end
                    end, function(Index)
                        BarberShop.Indexs.TacheRousseur = Index


                        TriggerEvent("skinchanger:change", 'moles_1', Index-1)
                    end)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Valider le Personnage", nil, { RightLabel = "~p~100$"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if BarberShop.player_money > 100 then
                                TriggerEvent('skinchanger:getSkin', function(skin)
                                    exports["ac"]:ExecuteServerEvent('skinchanger:save', skin)
                                    exports["ac"]:ExecuteServerEvent('shop_barber:pay')
                            
                                    SkinChanger.DeleteSkinCam()
                                end)
    
                                RageUI.CloseAll()
                            else
                                SkinChanger.ReloadSkinPlayer()
                                Framework.ShowNotification("~r~Vous n'avez pas asser d'argent !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Retour", nil, { RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SkinChanger.ReloadSkinPlayer()
                            SkinChanger.DeleteSkinCam()
                            RageUI.GoBack()
                        end
                    end)

                end, function() 

                    RageUI.ColourPanel("Couleur Principale", RageUI.PanelColour.HairCut, BarberShop.Indexs.hair_color_1, BarberShop.Indexs.hair_color_2, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        BarberShop.Indexs.hair_color_1 = MinimumIndex
                        BarberShop.Indexs.hair_color_2 = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'hair_color_1', BarberShop.Indexs.hair_color_2)
                        end
                    end, 1);

                    RageUI.ColourPanel("Couleur Secondaire", RageUI.PanelColour.HairCut, BarberShop.Indexs.hair_color2_1, BarberShop.Indexs.hair_color2_2, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        BarberShop.Indexs.hair_color2_1 = MinimumIndex
                        BarberShop.Indexs.hair_color2_2 = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'hair_color_2', BarberShop.Indexs.hair_color2_2)
                        end
                    end, 1);

                    RageUI.PercentagePanel(BarberShop.Indexs.eyebrows_op, "Opacité des Sourcils", "0%", "100%", function(Hovered, Active, Percent)
                        BarberShop.Indexs.eyebrows_op = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'eyebrows_2', BarberShop.Indexs.eyebrows_op*10)
                        end
                    end, 2);

                    RageUI.ColourPanel("Couleur Principale", RageUI.PanelColour.HairCut, BarberShop.Indexs.hair_color_1, BarberShop.Indexs.hair_color_2, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        BarberShop.Indexs.hair_color_1 = MinimumIndex
                        BarberShop.Indexs.hair_color_2 = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'eyebrows_3', BarberShop.Indexs.hair_color_2)
                        end
                    end, 2);

                    RageUI.ColourPanel("Couleur Secondaire", RageUI.PanelColour.HairCut, BarberShop.Indexs.hair_color2_1, BarberShop.Indexs.hair_color2_2, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        BarberShop.Indexs.hair_color2_1 = MinimumIndex
                        BarberShop.Indexs.hair_color2_2 = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'eyebrows_4', BarberShop.Indexs.hair_color2_2)
                        end
                    end, 2);

                    RageUI.PercentagePanel(BarberShop.Indexs.beard_op, "Opacité de la Barbe", "0%", "100%", function(Hovered, Active, Percent)
                        BarberShop.Indexs.beard_op = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'beard_2', BarberShop.Indexs.beard_op*10)
                        end
                    end, 3);

                    RageUI.ColourPanel("Couleur Principale", RageUI.PanelColour.HairCut, BarberShop.Indexs.hair_color_1, BarberShop.Indexs.hair_color_2, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        BarberShop.Indexs.hair_color_1 = MinimumIndex
                        BarberShop.Indexs.hair_color_2 = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'beard_3', BarberShop.Indexs.hair_color_2)
                        end
                    end, 3);

                    RageUI.ColourPanel("Couleur Secondaire", RageUI.PanelColour.HairCut, BarberShop.Indexs.hair_color2_1, BarberShop.Indexs.hair_color2_2, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        BarberShop.Indexs.hair_color2_1 = MinimumIndex
                        BarberShop.Indexs.hair_color2_2 = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'beard_4', BarberShop.Indexs.hair_color2_2)
                        end
                    end, 3);

                    RageUI.PercentagePanel(BarberShop.Indexs.OpaciteTeint, "Opacité", "0%", "100%", function(Hovered, Active, Percent)
                        BarberShop.Indexs.OpaciteTeint = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'complexion_2', BarberShop.Indexs.OpaciteTeint*10)
                        end
                    end, 5);
                    
                    RageUI.PercentagePanel(BarberShop.Indexs.OpaciteMaquillage, "Opacité des Maquillage", "0%", "100%", function(Hovered, Active, Percent)
                        BarberShop.Indexs.OpaciteMaquillage = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'makeup_2', BarberShop.Indexs.OpaciteMaquillage*10)
                        end
                    end, 6);

                    RageUI.ColourPanel("Couleur Principale", RageUI.PanelColour.HairCut, BarberShop.Indexs.ColorMaquillage_one, BarberShop.Indexs.ColorMaquillage_two, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        BarberShop.Indexs.ColorMaquillage_one = MinimumIndex
                        BarberShop.Indexs.ColorMaquillage_two = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'makeup_3', BarberShop.Indexs.ColorMaquillage_two)
                        end
                    end, 6);

                    RageUI.ColourPanel("Couleur Secondaire", RageUI.PanelColour.HairCut, BarberShop.Indexs.ColorMaquillage_one_1, BarberShop.Indexs.ColorMaquillage_two_2, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        BarberShop.Indexs.ColorMaquillage_one_1 = MinimumIndex
                        BarberShop.Indexs.ColorMaquillage_two_2 = CurrentIndex
                        if Active then        
                            TriggerEvent("skinchanger:change", 'makeup_4', BarberShop.Indexs.ColorMaquillage_two_2)
                        end
                    end, 6);

                    RageUI.PercentagePanel(BarberShop.Indexs.OpaciteRougeLevres, "Opacité des Rouge", "0%", "100%", function(Hovered, Active, Percent)
                        BarberShop.Indexs.OpaciteRougeLevres = Percent
                        if Active then
                            TriggerEvent("skinchanger:change", 'lipstick_2', BarberShop.Indexs.OpaciteRougeLevres*10)
                        end
                    end, 7);

                    RageUI.ColourPanel("Couleur Principale", RageUI.PanelColour.HairCut, BarberShop.Indexs.ColorRougeLevres_one, BarberShop.Indexs.ColorRougeLevres_two, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        BarberShop.Indexs.ColorRougeLevres_one = MinimumIndex
                        BarberShop.Indexs.ColorRougeLevres_two = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'lipstick_3', BarberShop.Indexs.ColorRougeLevres_two)
                        end
                    end, 7);

                    
                    RageUI.ColourPanel("Couleur Secondaire", RageUI.PanelColour.HairCut, BarberShop.Indexs.ColorRougeLevres_one_1, BarberShop.Indexs.ColorRougeLevres_two_2, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        BarberShop.Indexs.ColorRougeLevres_one_1 = MinimumIndex
                        BarberShop.Indexs.ColorRougeLevres_two_2 = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'lipstick_4', BarberShop.Indexs.ColorRougeLevres_two_2)
                        end
                    end, 7);

                    RageUI.PercentagePanel(BarberShop.Indexs.OpacitePilosite, "Opacité", "0%", "100%", function(Hovered, Active, Percent)
                        BarberShop.Indexs.OpacitePilosite = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'chest_2', BarberShop.Indexs.OpacitePilosite*10)
                        end
                    end, 8);

                    RageUI.ColourPanel("Couleur Secondaire", RageUI.PanelColour.HairCut, BarberShop.Indexs.ColorPilosite_one, BarberShop.Indexs.ColorPilosite_two, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        BarberShop.Indexs.ColorPilosite_one = MinimumIndex
                        BarberShop.Indexs.ColorPilosite_two = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'chest_3', BarberShop.Indexs.ColorPilosite_two)
                        end
                    end, 8);

                    RageUI.PercentagePanel(BarberShop.Indexs.OpaciteImperfections, "Opacité", "0%", "100%", function(Hovered, Active, Percent)
                        BarberShop.Indexs.OpaciteImperfections = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'bodyb_2', BarberShop.Indexs.OpaciteImperfections*10)
                        end
                    end, 9);



                    RageUI.PercentagePanel(BarberShop.Indexs.OpaciteRides, "Opacité", "0%", "100%", function(Hovered, Active, Percent)
                        BarberShop.Indexs.OpaciteRides = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'age_2', BarberShop.Indexs.OpaciteRides*10)
                        end
                    end, 10);

                    RageUI.PercentagePanel(BarberShop.Indexs.OpaciteBoutons, "Opacité", "0%", "100%", function(Hovered, Active, Percent)
                        BarberShop.Indexs.OpaciteBoutons = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'blemishes_2', BarberShop.Indexs.OpaciteBoutons*10)
                        end
                    end, 11);



                    RageUI.PercentagePanel(BarberShop.Indexs.OpaciteRougeurs, "Opacité", "0%", "100%", function(Hovered, Active, Percent)
                        BarberShop.Indexs.OpaciteRougeurs = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'blush_2', BarberShop.Indexs.OpaciteRougeurs*10)
                        end
                    end, 12);

                    RageUI.ColourPanel("Couleur Principale", RageUI.PanelColour.HairCut, BarberShop.Indexs.ColorRougeurs_one, BarberShop.Indexs.ColorRougeurs_two, function(Hovered, Active, MinimumIndex, CurrentIndex)
                        BarberShop.Indexs.ColorRougeurs_one = MinimumIndex
                        BarberShop.Indexs.ColorRougeurs_two = CurrentIndex

                        if Active then        
                            TriggerEvent("skinchanger:change", 'blush_3', BarberShop.Indexs.ColorRougeurs_two)
                        end
                    end, 12);


                    
                    RageUI.PercentagePanel(BarberShop.Indexs.OpaciteDommagesUV, "Opacité", "0%", "100%", function(Hovered, Active, Percent)
                        BarberShop.Indexs.OpaciteDommagesUV = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'sun_2', BarberShop.Indexs.OpaciteDommagesUV*10)
                        end
                    end, 13);


                    RageUI.PercentagePanel(BarberShop.Indexs.OpaciteTacheRousseur, "Opacité", "0%", "100%", function(Hovered, Active, Percent)
                        BarberShop.Indexs.OpaciteTacheRousseur = Percent

                        if Active then
                            TriggerEvent("skinchanger:change", 'moles_2', BarberShop.Indexs.OpaciteTacheRousseur*10)
                        end
                    end, 14);
                end)

            end
        end)
    end
end