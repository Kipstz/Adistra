Config['job_agentimmo'] = {
    Points = {
        boss = {
            pos = vector3(-579.5, -712.9, 116.8),
            msg = "Appuyez sur ~INPUT_CONTEXT~ pour acceder au Actions Patron",

            action = function()
                TriggerEvent('bossManagement:openMenu', 'agentimmo')
            end
        }
    }
}