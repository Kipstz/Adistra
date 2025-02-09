
Ascenseurs.MainMenu = RageUI.CreateMenu("Ascenseurs", "A quel étage voulez-vous aller ?", 8, 200)

local open = false

Ascenseurs.MainMenu.Closed = function()
    open = false
end

function Ascenseurs:OpenMenu(etages)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Ascenseurs.MainMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Ascenseurs.MainMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Ascenseurs.MainMenu, true, true, true, function()

                    for k,v in pairs(etages) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                SetEntityCoords(PlayerPedId(), v.tpCoords)
                                RageUI.CloseAll()
                                Framework.ShowNotification("Vous êtes arrivé à ~g~"..v.label.."~s~ !")
                            end
                        end)
                    end

                end)
            end
        end)
    end
end