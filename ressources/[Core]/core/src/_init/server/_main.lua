TriggerEvent('framework:init', function(obj) Framework = obj end)

HD_Cls.run(function()
    Wait(5000)

    local xPlayers = Framework.GetExtendedPlayers()
    Framework.SavePlayers()

    for _, xPlayer in pairs(xPlayers) do
        if xPlayer.characterId ~= 0 then
            TriggerEvent('framework:restoreCharacter', xPlayer.source, xPlayer.characterId)
        end
    end
end)
