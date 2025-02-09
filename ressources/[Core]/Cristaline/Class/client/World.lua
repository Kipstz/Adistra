__World = {}
__World.cache = {}

---@class World : __World

function __World:GetCountryName()
    return GetLabelText(GetNameOfZone(GetEntityCoords(PlayerPedId())))
end

function __World:GetStreetPedName()
    return GetStreetNameFromHashKey(GetStreetNameAtCoord(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z))
end