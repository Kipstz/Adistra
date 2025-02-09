
function Cayo_VDA:isJob()
    for k,v in pairs(Config['cayo_vda'].jobs) do
        if Framework.PlayerData.jobs['job2'].name == v and Framework.PlayerData.jobs['job2'].grade > 4 then
            return true;
        end
    end
    return false;
end
