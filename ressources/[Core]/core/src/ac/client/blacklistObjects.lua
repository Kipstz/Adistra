
local blacklistObjects = {}

AddEventHandler('entityCreating', function(entity)
    if blacklistObjects[tonumber(GetEntityModel(entity))] then
        CancelEvent()
    end
end)