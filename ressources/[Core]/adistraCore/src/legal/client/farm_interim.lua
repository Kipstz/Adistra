local farming_data = {
    {type_farm = "pommes", localisation = vector3(238.1, 6517.4, 31.2), item = "pommes"},
    {type_farm = "oranges", localisation = vector3(2381.4, 4709.0, 34.0), item = "oranges"},
    {type_farm = "charbon", localisation = vector3(-472.7, 2090.2, 120.0), item = "charbon"},
    {type_farm = "ignée", localisation = vector3(-485.2, -985.0,29.1), item = "ignée"},
    {type_farm = "poulet", localisation = vector3(-65.7, 6236.2, 31.0), item = "poulet"},
    {type_farm = "petrol", localisation = vector3(1363.3, -2204.3, 60.2), item = "petrol"},
    {type_farm = "cuivre", localisation = vector3(2753.6, 1522.0, 40.3), item = "cable"},
    {type_farm = "omrivine", localisation = vector3(4751.9, -5756.4, 20.4), item = "plante"}
}


local farming = false
local inTimeout = false

local function create_marker(farm)
    local loc = farm.localisation
    local item = farm.item
    DrawMarker(27, loc.x, loc.y, loc.z - 0.90, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, 0, 1, 0, 1)
    Framework.Game.Utils.DrawText3D(loc, "Appuyez sur [~p~E~s~] pour récolter " .. farm.type_farm .. ".", 0.9, 4)
    
    if #(GetEntityCoords(PlayerPedId()) - loc) < 3 then
        if IsControlJustPressed(1, 51) then
            if not farming then
                if inTimeout then 
                    Framework.ShowNotification("~r~Veillez patienter avant de récolter à nouveau !~s~")
                    return 
                end
                if IsPedSittingInAnyVehicle(PlayerPedId()) then
                    Framework.ShowNotification("~r~Vous ne pouvez pas récolter en étant dans un véhicule !~s~")
                    return 
                end
                farming = true
                lib.progressBar({
                    duration = 10000,
                    label = "Récolte en Cours...",
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
                TriggerServerEvent("adistraCore.recolte", item)
                inTimeout = true
                farming = false
                SetTimeout(2500, function()
                    inTimeout = false
                end)
            else
                Framework.ShowNotification("~r~Vous ne pouvez pas effectué cette action !~s~")
            end
        end
    end
end

local function loading_marker()
    for i = 1, #farming_data do
        local farm = farming_data[i]
        lib.points.new({
            coords = farm.localisation,
            distance = 10,
            nearby = function() create_marker(farm) end
        })
    end
end

Citizen.CreateThread(function()
    loading_marker()
end)