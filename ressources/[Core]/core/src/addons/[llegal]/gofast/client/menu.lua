GoFast.MainMenu = RageUI.CreateMenu("GoFast", "Actions: ", 8, 200)

local open = false

GoFast.MainMenu.Closed = function()
    open = false
end

function GoFast:OpenMainMenu()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(GoFast.MainMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(GoFast.MainMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(GoFast.MainMenu, true, true, true, function()

                    if not GoFast.inGoFast then
                        RageUI.ButtonWithStyle("Lancer un GoFast", nil, {}, true, function(Hovered, Active, Selected) 
                            if Selected then
                                GoFast:start()
                                RageUI.CloseAll()
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle("~r~Un GoFast est déjà en cours !~s~", nil, {}, false, function(Hovered, Active, Selected) 
                        end)
                    end

                end)
            end
        end)
    end
end