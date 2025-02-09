__Controls = {}
__Controls.cache = {}

function __Controls:Register(Controls, ControlName, Description, Action)
    local _Keys = {
        CONTROLS = Controls
    }
    RegisterKeyMapping(string.format('Keys-%s', ControlName), Description, "keyboard", Controls)
    RegisterCommand(string.format('Keys-%s', ControlName), function(source, args)
        if (Action ~= nil) then
            Action();
        end
    end, false)
    return setmetatable(_Keys, Keys)
end

function __Controls:Exists(Controls)
    return self.CONTROLS == Controls and true or false
end