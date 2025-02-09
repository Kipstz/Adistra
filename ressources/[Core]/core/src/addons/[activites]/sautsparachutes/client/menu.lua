
SautsParachutes.MainMenu = RageUI.CreateMenu("Sauts en Parachutes", "Se procurer un parachute", 8, 200)

SautsParachutes.MainMenu.Closed = function()
    open = false
end

local open = false

function SautsParachutes:OpenMenu()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(SautsParachutes.MainMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(SautsParachutes.MainMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(SautsParachutes.MainMenu, true, true, true, function()
                    RageUI.ButtonWithStyle("Parachute", nil, { RightLabel = "~g~"..Config['sautsparachutes'].price.."$~s~" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('sautsparachutes:giveParachute')
                        end
                    end)
                end)

            end
        end)
    end
end