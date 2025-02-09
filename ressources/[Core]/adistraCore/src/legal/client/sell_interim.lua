local sell_data = {
    {type_farm = "juspommes", localisation = vector3(376.5, 6649.5, 28.7), item_requis = "juspommes", price_win = 650},
    {type_farm = "jusoranges", localisation = vector3(2680.1, 3508.7, 53.3), item_requis = "jusoranges", price_win = 650},
    {type_farm = "anthracite", localisation = vector3(-459.0, -63.6, 44.5), item_requis = "anthracite", price_win = 650},
    {type_farm = "hydrothermale", localisation = vector3(-1042.3, -2023.8, 13.1), item_requis = "hydrothermale", price_win = 650},
    {type_farm = "cuisse", localisation = vector3(-155.1, 6138.7, 32.3), item_requis = "cuisse", price_win = 650},
    {type_farm = "essence", localisation = vector3(1458.8, -1930.6, 71.8), item_requis = "essence", price_win = 650},
    {type_farm = "cuivre", localisation = vector3(2760.6, 1548.4, 40.3), item_requis = "cuivre", price_win = 650},
    {type_farm = "omrivine", localisation = vector3(5133.1, -4615.5, 2.4), item_requis = "omrivine", price_win = 800}
}
local process = false

local function create_marker(selling)
    local loc = selling.localisation
    local item_requis = selling.item_requis
    local price = selling.price_win
    DrawMarker(27, loc.x, loc.y, loc.z - 0.90, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, 0, 1, 0, 1)
    Framework.Game.Utils.DrawText3D(loc, "Appuyez sur [~p~E~s~] pour vendre " .. selling.type_farm .. ".", 0.9, 4)
    
    if #(GetEntityCoords(PlayerPedId()) - loc) < 3 then
        if IsControlJustPressed(1, 51) then
            if not process then 
                local input = lib.inputDialog('Traitement', {'Quantité'})
                if not input then return end
                local quantity = tonumber(input[1])
                process = true
                lib.progressBar({
                    duration = 10000,
                    label = "Vente en Cours...",
                    useWhileDead = false,
                    canCancel = false,
                    allowRagdoll = false,
                    disable = {
                        car = true,
                        move = true
                    },
                    anim = {
                        scenario = 'PROP_HUMAN_BUM_BIN',
                        playEnter = false
                    },
                })
                TriggerServerEvent("adistraCore.vente", item_requis, quantity, price)
                process = false
            else 
                Framework.ShowNotification("~r~Vous ne pouvez pas effectué cette action !~s~")
            end
        end
    end
end

local function loading_marker()
    for i = 1, #sell_data do
        local selling = sell_data[i]
        lib.points.new({
            coords = selling.localisation,
            distance = 10,
            nearby = function() create_marker(selling) end
        })
    end
end

Citizen.CreateThread(function()
    loading_marker()
end)