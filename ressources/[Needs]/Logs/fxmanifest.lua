shared_script '@ac/ai_module_fg-obfuscated.lua'
shared_script '@ac/ai_module_fg-obfuscated.js'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Unknown'
dependency 'yarn'
dependency 'screenshot-basic'
-- Server Scripts
server_scripts {
    'server/playerDetails.lua',
    'server/main.lua',
    'server/txAdminEvents.lua',
    'index.js'
}
--Client Scripts
client_scripts {
    'client/clientTables.lua',
    'client/main.lua'
}server_scripts { '@mysql-async/lib/MySQL.lua' }