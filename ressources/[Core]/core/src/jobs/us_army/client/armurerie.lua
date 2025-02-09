UsArmyJob.ArmurerieMenu = RageUI.CreateMenu("US Army", "~p~US Army~s~: Armurerie", 8, 200)

local open = false

UsArmyJob.ArmurerieMenu.Closed = function()
    open = false
end

UsArmyJob.OpenArmurerieMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(UsArmyJob.ArmurerieMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(UsArmyJob.ArmurerieMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(UsArmyJob.ArmurerieMenu, true, true, true, function()
                    
                    RageUI.Separator("↓   Armes   ↓")

                    for k,v in pairs(Config['job_usarmy'].Armurerie) do
                        if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    exports["ac"]:ExecuteServerEvent('UsArmyJob:AddWeapon', v.model)
                                end
                            end)
                        end
                    end

                    RageUI.Separator("↓   Autres   ↓")

                    RageUI.ButtonWithStyle("Prendre toute les armes", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local weapons = {}

                            for k,v in pairs(Config['job_usarmy'].Armurerie) do
                                if Framework.PlayerData.jobs['job'].grade >= v.minGrade then
                                    table.insert(weapons, v.model)
                                end
                            end

                            exports["ac"]:ExecuteServerEvent('UsArmyJob:AddAllWeapons', weapons)
                        end
                    end)

                    RageUI.ButtonWithStyle("Déposer tout les armes", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent('UsArmyJob:RemoveAllWeapons')
                        end
                    end)
                end)
            
            end
        end)
    end
end