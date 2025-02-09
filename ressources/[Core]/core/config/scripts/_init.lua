Config = {}

function Config:gabz()
    local gabz = false;
    if GetResourceState('cfx-gabz-mapdata') ~= 'missing' then gabz = true end
    return gabz;
end