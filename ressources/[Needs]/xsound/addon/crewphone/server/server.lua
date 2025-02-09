RegisterCommand("startPurge", function(source, args, rawCommand)
    if source == 0 then
        PlayUrl(-1, "purgeStart", "https://www.youtube.com/watch?v=FL4disFETnM", 1, false)
    else
        DropPlayer(source, "Vous n'avez pas l'autorisation d'éxécuter cette commande.")
    end
end)

RegisterCommand("startNuclear", function(source, args, rawCommand)
    if source == 0 then
        PlayUrl(-1, "purgeStart", "https://www.youtube.com/watch?v=T2qwIWIrztQ", 1, false)
    else
        DropPlayer(source, "Vous n'avez pas l'autorisation d'éxécuter cette commande.")
    end
end)

RegisterCommand("startScreameur", function(source, args, rawCommand)
    if source == 0 then
        PlayUrl(-1, "purgeStart", "https://www.youtube.com/watch?v=Yc-CGFVb_EE", 1, false)
    else
        DropPlayer(source, "Vous n'avez pas l'autorisation d'éxécuter cette commande.")
    end
end)