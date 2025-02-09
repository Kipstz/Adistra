

HD_Cls = {};

HD_Cls.classes = {};

BaseObject = setmetatable({}, {
    __name = "BaseObject";
    __type = "class";
    __call = function(self, ...)
        return self:new(...);
    end
});

function HD_Cls.createClass(name, callback)
    local name = string.lower(name)
    local metatable = getmetatable(BaseObject);
    local extend = callback({});

    setmetatable(extend, {
        __index = BaseObject;
        __super = BaseObject;
        __newindex = metatable.__newindex;
        __call = metatable.__call;
        __len = metatable.__len;
        __unm = metatable.__unm;
        __add = metatable.__add;
        __sub = metatable.__sub;
        __mul = metatable.__mul;
        __div = metatable.__div;
        __pow = metatable.__pow;
        __concat = metatable.__concat;
        __type = "class";
        __new_type = "instance";
        __name = name;
        __tostring = function()
            return name;
        end;
    });

    if HD_Cls.classes[name] ~= nil then
        print("Il y'a 2 classes portant le nom '"..name.."' !")
        return
    end

    HD_Cls.classes[name] = extend;
    return HD_Cls.classes[name];
end

function HD_Cls.importClass(className)
    local className = string.lower(className)
    local classImported, nbTry = false, 0

    if HD_Cls.classes[className] ~= nil then
        classImported = true
        return HD_Cls.classes[className]
    end

    CreateThread(function()
        while not classImported do
            nbTry = nbTry + 1
            if nbTry > 5000 then
                return nil
            end
            Wait(500)
        end
    end)
end

function HD_Cls.run(cb)
    CreateThread(function()
        TickManager = HD_Cls.importClass("TickManager")

        if not IsDuplicityVersion() then            
            plyManag = HD_Cls.importClass("PlayerManager")
            VisualManager = HD_Cls.importClass("VisualManager")

            BlipManager = HD_Cls.importClass("BlipManager")
            ZoneManager = HD_Cls.importClass("ZoneManager")
            EntityManager = HD_Cls.importClass("EntityManager")
        end

        cb()
    end)
end