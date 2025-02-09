
AutoEcole.Main = RageUI.CreateMenu("AutoEcole", "Bienvenue à l'Auto-Ecole", 8, 200)

local open = false

AutoEcole.Main.Closed = function()
    open = false
end

AutoEcole.OpenMenu = function()
    AutoEcole.player_money = 0

    for i = 1, #Framework.PlayerData.accounts, 1 do
		if Framework.PlayerData.accounts[i].name == 'money' then
			AutoEcole.player_money = Framework.PlayerData.accounts[i].money
		end
    end

    local ownedLicenses = {}

	for i = 1, #AutoEcole.Licenses, 1 do
		ownedLicenses[AutoEcole.Licenses[i].type] = true
	end
    
    if open then
        RageUI.CloseAll()
        RageUI.Visible(AutoEcole.Main, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(AutoEcole.Main, true)
        open = true

        CreateThread(function()
            while open do
                Wait(0)

                RageUI.IsVisible(AutoEcole.Main, true, true, true, function()

                    if not ownedLicenses['dmv'] then
                        RageUI.ButtonWithStyle("Passer le Code", nil, { RightLabel = "~p~"..AutoEcole_Config.Prices['dmv'].."$"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                if AutoEcole.player_money >= AutoEcole_Config.Prices['dmv'] then
                                    StartTheoryTest()

                                    RageUI.CloseAll()
                                else
                                    Framework.ShowNotification("~r~Vous n'avez pas asser d'argent !")
                                end
                            end
                        end)

                        RageUI.Line()

                        RageUI.ButtonWithStyle("Passer le Permis Voiture", nil, {}, false, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)

                        RageUI.ButtonWithStyle("Passer le Permis Moto", nil, {}, false, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)

                        RageUI.ButtonWithStyle("Passer le Permis Camion", nil, {}, false, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle("Passer le Permis Voiture", nil, { RightLabel = "~p~"..AutoEcole_Config.Prices['drive'].."$"}, not ownedLicenses['drive'], function(Hovered, Active, Selected)
                            if Selected then
                                if AutoEcole.player_money >= AutoEcole_Config.Prices['drive'] then
                                    StartDriveTest('drive')

                                    RageUI.CloseAll()
                                else
                                    Framework.ShowNotification("~r~Vous n'avez pas asser d'argent !")
                                end
                            end
                        end)

                        RageUI.ButtonWithStyle("Passer le Permis Moto", nil, { RightLabel = "~p~"..AutoEcole_Config.Prices['drive_bike'].."$"}, not ownedLicenses['drive_bike'], function(Hovered, Active, Selected)
                            if Selected then
                                if AutoEcole.player_money >= AutoEcole_Config.Prices['drive_bike'] then
                                    StartDriveTest('drive_bike')

                                    RageUI.CloseAll()
                                else
                                    Framework.ShowNotification("~r~Vous n'avez pas asser d'argent !")
                                end
                            end
                        end)

                        RageUI.ButtonWithStyle("Passer le Permis Camion", nil, { RightLabel = "~p~"..AutoEcole_Config.Prices['drive_truck'].."$"}, not ownedLicenses['drive_truck'], function(Hovered, Active, Selected)
                            if Selected then
                                if AutoEcole.player_money >= AutoEcole_Config.Prices['drive_truck'] then
                                    StartDriveTest('drive_truck')

                                    RageUI.CloseAll()
                                else
                                    Framework.ShowNotification("~r~Vous n'avez pas asser d'argent !")
                                end
                            end
                        end)
                    end

                end)
            end
        end)
    end
end