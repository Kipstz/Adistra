local vehiclesList = {
    `buffalo4`,
    `tampa3`,
    `buffalosxpol`
}

CreateThread(function()
    local wait = 1500

    while true do
        local inVeh = IsPedInAnyVehicle(PlayerPedId())

        if inVehicle then 
            local car = GetVehiclePedIsIn(PlayerPedId(), false)

            for _, model in ipairs(vehiclesList) do
                if IsVehicleModel(car, model) then
                    local _, weaponHash = GetCurrentPedVehicleWeapon(PlayerPedId())
                    DisableVehicleWeapon(true, weaponHash, car, PlayerPedId())
                    break
                end
            end
            wait = 2000
        end
        Wait(wait)
    end
end)