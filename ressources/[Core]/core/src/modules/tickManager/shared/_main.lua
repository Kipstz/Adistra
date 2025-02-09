
HD_Cls.createClass("TickManager", function(cls)
    local class = cls

    class.ticks = {}

    function class:addTick(name,func)
        if class.ticks[name] == nil or class.ticks[name] == '' then
            class.ticks[name] = func;
        end
    end

    function class:removeTick(name)
        if class.ticks[name] ~= nil or class.ticks[name] ~= '' then
            class.ticks[name] = '';
        end
    end

    function class:analayze()
        CreateThread(function()
            while true do
                wait = 2000;

                if next(class.ticks) then
                    wait = 5;
                    if next(class.ticks) then
                        for k,func in pairs(class.ticks) do
                            if func and func ~= nil and func ~= '' then
                                func()
                            end
                        end
                    end
                end

                Wait(wait)
            end
        end)
    end

    class:analayze()

    return class
end)
