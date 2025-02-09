__Bucket = {}
__Bucket.world = {
    ["spawn"] = 1,
    ["freeroam"] = 2,
    ["Sandaren"] = 3,
    ["Dust"] = 4,
    ["RedZone"] = 5
}

__Bucket.cache = {
    ["spawn"] = {},
    ["freeroam"] = {},
    ["Sandaren"] = {},
    ["Dust"] = {},
    ["RedZone"] = {}
}
function __Bucket:SetPlayer(source, world)
    table.insert(__Bucket.cache[world], source .. ":" .. GetPlayerName(source))
    SetPlayerRoutingBucket(source, __Bucket.world[world])
end

function __Bucket:RemovePlayer(source, world)
    for i, v in pairs(__Bucket.cache[world]) do
        if v == source .. ":" .. GetPlayerName(source) then
            table.remove(__Bucket.cache[world], i)
        end
    end
end

function __Bucket:SetEntity(entity, world)
    SetEntityRoutingBucket(entity, __Bucket.world[world])
end

function __Bucket:getEntityBucketByBucketId(id)
for k, v in pairs(__Bucket.world) do
        if v == id then
            return k
        end
    end
end

function __Bucket:Get(world)
    return __Bucket.cache[world]
end