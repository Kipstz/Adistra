Config['outlawalert'] = {
    jobs = {'fib','police', 'sheriff', 'sheriffpaleto'},
    timer = 1,
    showOutlaw = true,
    gunshotAlert = true,
    carJackingAlert = true,
    meleeAlert = true,
    blipTime = 5,
    blipGunTime = 5,
    blipMeleeTime = 7,
    blipJackingTime = 10
}

Config['outlawalert'].timing = (Config['outlawalert'].timer * 60000)