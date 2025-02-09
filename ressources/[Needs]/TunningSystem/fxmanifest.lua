shared_script '@ac/ai_module_fg-obfuscated.lua'
fx_version 'adamant'
games { 'gta5' }

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/script.js',
	'html/img/*.png',
	'html/main.css',
    'html/*.svg',
}

client_scripts {
	'config.lua',
	'client/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
   'config.lua',
   'server/*.lua',
}