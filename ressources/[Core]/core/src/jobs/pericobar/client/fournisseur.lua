
PericoBarJob.HarvestMenu = RageUI.CreateMenu("Perico Bar", "~p~Perico Bar~s~: Fournisseur", 8, 200)

local open = false

PericoBarJob.HarvestMenu.Closed = function()
    open = false
end

PericoBarJob.OpenHarvestMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(PericoBarJob.HarvestMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(PericoBarJob.HarvestMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(PericoBarJob.HarvestMenu, true, true, true, function()
                    for k,v in pairs(Config['job_pericobar'].itemsHarvest) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~g~"..v.price.."$" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 5)

                                if tonumber(qte) then
                                    TriggerServerEvent('PericoBarJob:buy', v, tonumber(qte))
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