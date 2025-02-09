
HookahJob.HarvestMenu = RageUI.CreateMenu("Hookah", "~p~Hookah~s~: Fournisseur", 8, 200)

local open = false

HookahJob.HarvestMenu.Closed = function()
    open = false
end

HookahJob.OpenHarvestMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(HookahJob.HarvestMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(HookahJob.HarvestMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(HookahJob.HarvestMenu, true, true, true, function()
                    for k,v in pairs(Config['job_hookah'].itemsHarvest) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~g~"..v.price.."$" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 5)

                                if tonumber(qte) then
                                    TriggerServerEvent('HookahJob:buy', v, tonumber(qte))
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