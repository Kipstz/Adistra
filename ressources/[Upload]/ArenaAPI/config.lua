Config = {}

-- Message list
Config.MessageList = {
    ["arena_doesnt_exists"] = "L'arène n'existe pas",
    ["player_isnt_in_arena"] = "Vous êtes dans aucune arène.",
    ["player_in_arena"] = "Vous devez quitter votre arène actuelle avant d'en rejoindre une autre.",
    ["arena_joined"] = "Vous avez rejoin l'arène.",
    ["arena_left"] = "Vous avez quitté l'arène.",
    ["maximum_people"] = "Cette arène a atteint le nombre de joueurs maximum.",
    ["cant_acces_this_arena"] = "Vous ne pouvez pas rejoindre cette arène, celle-ci est privée.",
    ["arena_busy"] = "Cette arène est occupée.",
    ["cooldown_to_join"] = "Vous devez attendre %s to join!",
}

-- your current time zone
Config.TimeZone = 1

-- How many seconds player will have to wait before trying to join same lobby after leaving ?
-- This will prevent trollers from trying to stop the lobby start.
Config.TimeCooldown = 25