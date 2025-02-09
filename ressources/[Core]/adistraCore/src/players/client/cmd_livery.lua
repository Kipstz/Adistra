RegisterCommand('setliveryveh', function(src, args)
    local inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
    local getVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local liveryIndex = tonumber(args[1])

    if inVehicle then
        local liveryIndex = tonumber(args[1])
        if liveryIndex and liveryIndex >= 0 and liveryIndex < GetNumberOfVehicleLiveries(getVehicle) then
            SetVehicleLivery(getVehicle, liveryIndex)
        end
    end
end)