Framework = nil
TriggerEvent('framework:init', function(obj) Framework = obj end)

local function draw_txt_3d()
    while true do
        local wait = 2500
        if GetDistanceBetweenCoords(-412.6, 1171.4, 325.8, GetEntityCoords(PlayerPedId())) < 12.0 then
            wait = 0
            Framework.Game.Utils.DrawText3D((vector3(-412.6, 1171.4, 325.8)), "~o~Bienvenue~s~ sur ~p~Adistra~s~ !\nPasse un ~g~agréable~s~ moment parmi nous !",0.9, 4)	
        end
        if GetDistanceBetweenCoords(-419.8, 1174.4, 325.8, GetEntityCoords(PlayerPedId())) < 20.0 then
            wait = 0
            Framework.Game.Utils.DrawText3D(vector3(-419.8, 1174.4, 325.8), "Un problème de personnage, un problème ou une question ?\nAlors faites ~b~/report~s~ dans le chat ~b~[T]~s~ avec votre raison", 0.9, 4)	
        end	
        if GetDistanceBetweenCoords(-404.2, 1170.2, 325.8, GetEntityCoords(PlayerPedId())) < 20.0 then
            wait = 0
            Framework.Game.Utils.DrawText3D(vector3(-404.2, 1170.2, 325.8), "N'oubliez pas de rejoindre notre discord !\n~p~discord.gg/adistrarp~s~", 0.9, 4)	
        end	
        Wait(wait)
    end
end

CreateThread(function()
    draw_txt_3d()
end)