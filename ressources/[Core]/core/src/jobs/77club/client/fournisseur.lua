
NightClub.HarvestMenu = RageUI.CreateMenu("77-Club", "~p~77-Club~s~: Fournisseur", 8, 200)

local open = false

NightClub.HarvestMenu.Closed = function()
    open = false
end

NightClub.OpenHarvestMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(NightClub.HarvestMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(NightClub.HarvestMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(NightClub.HarvestMenu, true, true, true, function()
                    for k,v in pairs(Config['job_77club'].itemsHarvest) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~g~"..v.price.."$" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local qte = VisualManager:KeyboardOutput("Quantité", "", 5)

                                if tonumber(qte) then
                                    TriggerServerEvent('NightClub:buy', v, tonumber(qte))
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