local traitement_data = {
    {type_farm = "pommes", localisation = vector3(408.4, 6495.8, 27.9), item_requis = "pommes", item = "juspommes"},
    {type_farm = "oranges", localisation = vector3(2907.9, 4468.8, 48.2), item_requis = "oranges", item = "jusoranges"},
    {type_farm = "charbon", localisation = vector3(-481.6, 1895.1, 119.6), item_requis = "charbon", item = "anthracite"},
    {type_farm = "ignée", localisation = vector3(-452.6, -1003.0, 23.9), item_requis = "ignée", item = "hydrothermale"},
    {type_farm = "poulet", localisation = vector3(-105.9, 6204.8, 31.0), item_requis = "poulet", item = "cuisse"},
    {type_farm = "petrol", localisation = vector3(1473.1, -1602.9, 71.1), item_requis = "petrol", item = "essence"},
    {type_farm = "cuivre", localisation = vector3(2795.6, 1666.8, 21.0), item_requis = "cable", item = "cuivre"},
    {type_farm = "omrivine", localisation = vector3(4503.9, -4554.2, 4.1), item_requis = "plante", item = "omrivine"}
}
local loading = false
local function create_marker(traitement)
    local loc = traitement.localisation
    local item_requis = traitement.item_requis
    local new_item = traitement.item

    DrawMarker(27, loc.x, loc.y, loc.z - 0.90, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, 0, 1, 0, 1)
    Framework.Game.Utils.DrawText3D(loc, "Appuyez sur [~p~E~s~] pour traiter " .. traitement.type_farm .. ".", 0.9, 4)
    
    if #(GetEntityCoords(PlayerPedId()) - loc) < 3 then
        if IsControlJustPressed(1, 51) then
            if not loading then
                local input = lib.inputDialog('Traitement', {'Quantité'})
                if not input then return end
                local quantity = input[1]
                loading = true
                lib.progressBar({
                    duration = 10000,
                    label = "Traitement en Cours...",
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
                TriggerServerEvent("adistraCore.traitement", item_requis, new_item, quantity)
                loading = false
            else 
                Framework.ShowNotification("~r~Vous ne pouvez pas effectué cette action !~s~")
            end
        end
    end
end

local function loading_marker()
    for i = 1, #traitement_data do
        local traitement = traitement_data[i]
        lib.points.new({
            coords = traitement.localisation,
            distance = 10,
            nearby = function() create_marker(traitement) end
        })
    end
end

Citizen.CreateThread(function()
    loading_marker()
end)