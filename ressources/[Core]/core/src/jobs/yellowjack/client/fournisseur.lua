
YellowJackJob.HarvestMenu = RageUI.CreateMenu("Yellow Jack", "~p~Yellow Jack~s~: Fournisseur", 8, 200)

local open = false

YellowJackJob.HarvestMenu.Closed = function()
    open = false
end

YellowJackJob.OpenHarvestMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(YellowJackJob.HarvestMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(YellowJackJob.HarvestMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(YellowJackJob.HarvestMenu, true, true, true, function()
                    for k,v in pairs(Config['job_yellowjack'].itemsHarvest) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~g~"..v.price.."$" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 5)

                                if tonumber(qte) then
                                    TriggerServerEvent('YellowJackJob:buy', v, tonumber(qte))
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un nombre valide !")
                                end
                            end
                        end)
                    end
                end)
            end
        end)
    end
end