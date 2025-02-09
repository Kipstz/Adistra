local wash_coord = {
    vector3(2434.0579, 4968.8311, 42.3476)
}
local washing = false

local function open_menu(self)
    DrawMarker(27, self.coords.x, self.coords.y, self.coords.z - 0.90, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, 0, 1, 0, 1)
    Framework.Game.Utils.DrawText3D((vector3(2434.0579, 4968.8311, 42.3476)), "Appuyez sur [~p~E~s~] pour intéragir.",0.9, 4)	
    if self.currentDistance < 3 then
        if IsControlJustPressed(1, 51) then 
            if not washing then 
                local input = lib.inputDialog('Blanchissement', {'Quantité'})
                if not input then return end
                local quantity = input[1]
                washing = true
                lib.progressBar({
                    duration = 30000,
                    label = "Blanchiment en Cours...",
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        move = true
                    },
                    anim = {
                        scenario = 'PROP_HUMAN_BUM_BIN',
                        playEnter = false
                    },
                })
                TriggerServerEvent("adistraCore.washMoney", quantity)
                washing = false
            else
                Framework.ShowNotification("~r~Vous ne pouvez pas effectué cette action !~s~")
            end
        end
    end
end 

local function loading_marker()
    for i = 1, #wash_coord do
        lib.points.new({
            coords = wash_coord[i],
            distance = 10,
            nearby = open_menu
        })
    end
end

Citizen.CreateThread(function()
    loading_marker()
end)