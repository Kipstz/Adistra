
CayoAutoJob.CraftMenu = RageUI.CreateMenu("Mécano", "~p~Mécano~s~: Craft", 8, 200)

local open = false

CayoAutoJob.CraftMenu.Closed = function()
    open = false
end

CayoAutoJob.OpenCraftMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(CayoAutoJob.CraftMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(CayoAutoJob.CraftMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(CayoAutoJob.CraftMenu, true, true, true, function()
                    for k,v in pairs(Config['job_cayoauto'].itemsCraft) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                CayoAutoJob.startCraft(v.need, v.name, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

CayoAutoJob.startCraft = function(need, type, msg)
    CayoAutoJob.canNotif = true

    if not CayoAutoJob.inCraft then
        for k,v in pairs(Framework.PlayerData.inventory) do
            if v.name == need then
                if v.count > 0 then
                    CayoAutoJob.canNotif = false
                    CayoAutoJob.inCraft = true
    
                    exports["ac"]:ExecuteServerEvent("CayoAutoJob:startCraft", need, type)
                
                    CayoAutoJob:progress(msg, anim)
                else
                    CayoAutoJob.canNotif = false
                    CayoAutoJob.canCraft = false
                    Framework.ShowNotification("~r~Vous n'avez pas les outils requis !")
    
                    return
                end
            end
        end

        if CayoAutoJob.canNotif then
            Framework.ShowNotification("~r~Vous n'avez pas les outils requis !")
        end
    end
end

RegisterNetEvent('CayoAutoJob:stopCraft')
AddEventHandler('CayoAutoJob:stopCraft', function()
    CayoAutoJob.inCraft = false
    FreezeEntityPosition(PlayerPedId(), false)
end)