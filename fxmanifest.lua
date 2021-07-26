fx_version 'cerulean'
game 'gta5'

description 'QB-TattooShop'

shared_script '@qb-core/import.lua'

client_scripts {
	'config.lua',
	'client/jaymenu.lua',
	'client/main.lua'
}

server_script 'server/main.lua'

file 'AllTattoos.json'