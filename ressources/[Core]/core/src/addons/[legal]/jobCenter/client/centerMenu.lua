JobCenter.CenterMenu = RageUI.CreateMenu("Pôle-Emploi", "Quel métier voulez-vous faire ?", 8, 200)

local open = false

JobCenter.CenterMenu.Closed = function()
    open = false
end

function JobCenter:OpenMenu()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(JobCenter.CenterMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(JobCenter.CenterMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(JobCenter.CenterMenu, true, true, true, function()

                    for k,v in pairs(Config['jobcenter']['metiers']) do
                        RageUI.ButtonWithStyle(v.label, v.desc, {}, true, function(Hovered, Active, Selected) 
                            if Selected then
                                exports["ac"]:ExecuteServerEvent('jobcenter:newJob', v.name)
                            end
                        end)
                    end

                end)
            end
        end)
    end
end