fx_version 'cerulean'
game 'gta5'

name 'Casino'
description ''
author 'chen'
version '1.0.0'


client_scripts {
    'client/casino_client.lua',
    'client/casino_animations.lua',
    'client/casino_effects.lua',
    'client/casino_interaction.lua',
    'client/casino_utils.lua',
    'client/casino_croupier.lua'
}


server_scripts {
    'server/casino_accounts.lua',
    'server/casino_blackjack_rules.lua',
    'server/casino_jackpot.lua',
    'server/casino_vip.lua',
    'server/casino_loyalty.lua',
    'server/casino_roulette.lua',
    'server/casino_blackjack.lua',
    'server/casino_slot.lua'
}


shared_scripts {
    'shared/casino_config.lua'
}
