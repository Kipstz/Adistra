fx_version('cerulean')
games({ 'gta5' })
lua54{'yes'}
version '2.6.2'

client_scripts{
    'clients/*.lua',
    'config.lua'
}

server_scripts{
    'sv.lua',
    'sv_custom.lua',
    'config.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

ui_page('html/index.html')

files({
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/bonebreak.ogg',
    'html/flightCharge_launch.wav',
    'html/flightCharge_loop.wav',
    'html/flyingSound.wav',
})

escrow_ignore{
    'config.lua',
    'sv_custom.lua'
}
dependency '/assetpacks'