local debug = false
local prt = print

if IsDuplicityVersion() then
    function print(...)
        if debug then
            local args = {...}
            local str = ""
            for i = 1, #args do
                str = str .. tostring(args[i]) .. " "
            end
            str = str:sub(1, -2)
            TriggerClientEvent("CRISTALINE:DebugMode:Print", -1, str)
        end
    end
else
    function print(...)
        if debug then
            prt("^7[^1DEBUG^7] [^4CLIENT^7] ^7" .. ...)
        end
    end
    RegisterNetEvent("CRISTALINE:DebugMode:Print", function(str)
        if debug then
            prt("^7[^1DEBUG^7] [^6SERVER^7] ^7" .. str)
        end
    end)
    CreateThread(function()
        while debug do
            Wait(0)
            if __Zone then
                if debug then
                    __Zone:startDebugZone()
                end
                break
            end
        end
    end)
end