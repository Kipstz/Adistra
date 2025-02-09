FibJob.ArmurerieMenu = RageUI.CreateMenu("FIB", "~p~FIB~s~: Armurerie", 8, 200)

local open = false

FibJob.ArmurerieMenu.Closed = function()
    open = false
end

FibJob.OpenArmurerieMenu = function()
    if Framework.PlayerData.jobs['job'].grade < 1 then
        Framework.ShowNotification("~r~Vous n'avez pas accès à l'armurerie")
        return
    end

    if open then
        RageUI.CloseAll()
        RageUI.Visible(FibJob.ArmurerieMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(FibJob.ArmurerieMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(FibJob.ArmurerieMenu, true, true, true, function()
                    
                    RageUI.Separator("↓   Armes   ↓")

                    for k,v in pairs(Config['job_fib'].Armurerie) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    exports["ac"]:ExecuteServerEvent('FibJob:AddWeapon', v.model)
                                end
                            end)
                        end
                    end

                    RageUI.Separator("↓   Autres   ↓")

                    RageUI.ButtonWithStyle("Prendre toute les armes", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local weapons = {}

                            for k,v in pairs(Config['job_fib'].Armurerie) do
                                if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                                    table.insert(weapons, v.model)
                                end
                            end

                            exports["ac"]:ExecuteServerEvent('FibJob:AddAllWeapons', weapons)
                        end
                    end)

                    RageUI.ButtonWithStyle("Déposer tout les armes", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent('FibJob:RemoveAllWeapons')
                        end
                    end)
                end)
            
            end
        end)
    end
end