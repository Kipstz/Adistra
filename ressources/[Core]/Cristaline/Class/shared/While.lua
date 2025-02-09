__While = {}
__While.cache = {
    [0] = {},
    [250] = {},
    [500] = {},
    [1000] = {},
    [5000] = {},
    [15000] = {}
}

function __While:addTick(type, name, func)
    __While.cache[type][name] = func;
end

function __While:removeTick(name)
    for k, v in pairs(__While.cache) do
        v[name] = nil;
    end
end

CreateThread(function()
    while true do
        Wait(0);
        for k, func in pairs(__While.cache[0]) do
            func();
        end
    end
end)

CreateThread(function()
    while true do
        Wait(250);
        for k, func in pairs(__While.cache[250]) do
            func();
        end
    end
end)

CreateThread(function()
    while true do
        Wait(500);
        for k, func in pairs(__While.cache[500]) do
            func();
        end
    end
end)

CreateThread(function()
    while true do
        Wait(1000);
        for k, func in pairs(__While.cache[1000]) do
            func();
        end
    end
end)

CreateThread(function()
    while true do
        Wait(5000);
        for k, func in pairs(__While.cache[5000]) do
            func();
        end
    end
end)

CreateThread(function()
    while true do
        Wait(15000);
        for k, func in pairs(__While.cache[15000]) do
            func();
        end
    end
end)