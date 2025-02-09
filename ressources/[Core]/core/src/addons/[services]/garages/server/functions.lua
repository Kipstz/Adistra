
function Garages:GetLabelByPlate(plate)
    local label = MySQL.scalar.await('SELECT `label` FROM `character_vehicles` WHERE `plate` = ? LIMIT 1', {
        plate
    })
    return label
end