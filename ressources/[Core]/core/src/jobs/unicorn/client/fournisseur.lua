
UnicornJob.HarvestMenu = RageUI.CreateMenu("Unicorn", "~p~Unicorn~s~: Fournisseur", 8, 200)

local open = false

UnicornJob.HarvestMenu.Closed = function()
    open = false
end

UnicornJob.OpenHarvestMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(UnicornJob.HarvestMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(UnicornJob.HarvestMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(UnicornJob.HarvestMenu, true, true, true, function()
                    for k,v in pairs(Config['job_unicorn'].itemsHarvest) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~g~"..v.price.."$" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 5)

                                if tonumber(qte) then
                                    TriggerServerEvent('UnicornJob:buy', v, tonumber(qte))
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