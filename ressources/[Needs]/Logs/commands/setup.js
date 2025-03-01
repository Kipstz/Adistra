module.exports = {
	name: 'messageCreate',
	once: false,
	async execute(message) {
		const {channel, content, guild, author} = message;
		if(content.toLowerCase().startsWith(`${client[1].config.prefix}heldaylogs setup`)){
			const tUser = await message.guild.members.cache.get(author.id);
			if(!tUser.permissions.has("ADMINISTRATOR")) return message.reply({content: "⛔ | Missing Permissions to use this command.\nNeeded permission flag: `ADMINISTRATOR`"})
			const channels = JSON.parse(LoadResourceFile(GetCurrentResourceName(), '/config/channels.json'));
			await channel.send('**Starting AdistraLogs Setup!**\n*ETA: 30 seconds*').then(msg => {
				response = msg
			})

			ids = ''

			info = {
				"system": "🧾・system-messages"
			}
	
			baselogs = {
				"all": "📋・all-logs",
				"chat": "💬・chat-logs",
				"join": "📥・join-logs",
				"leave": "📤・leave-logs",
				"death": "💀・death-logs",
				"shooting": "🔫・shooting-logs",
				"resource": "🔧・resource-logs",
				"nameChange": "💠・namechange-logs",
				"explosion": "🧨・explosion-logs",
				"txAdmin": "💻・txadmin-logs",
				"interactions": "🙋‍♂️・interactions-logs",
				"cheatSuspect": "🚨・cheat-suspect-logs",
				"agent": "🚨・agent-immo-logs",
				"jails": "🚧・jails-logs",
				"bans": "📛・bans-logs",
				"adminMenu": "🛑・admin-logs",
				"adminCommands": "🚨・admin-commands-logs",
				"boutique": "💎・boutique-logs",
			}
	
			x = await guild.channels.cache.find(cc => cc.name === `Information` && cc.type === 'GUILD_CATEGORY')
			if(x){
				if(!guild.channels.cache.find(cc => cc.name === `📢・prefech-announcements`)){
					await guild.channels.create("📢・prefech-announcements", {
							type: 'GUILD_TEXT',
							permissionOverwrites: [
								{
								id: guild.id,
								deny: ["VIEW_CHANNEL"],
								},
							],
						}).then(async c => {
						await c.setParent(x.id);
						c.send("This channel has been made so you can follow <#721341781467332668>, <#909488719482994788> and don't miss any updated!")
					})
				}
				for(const v in info) {
					let cc = await guild.channels.cache.find(cc => cc.name === info[v])
					if(!cc){
						await guild.channels.create(info[v], {
							type: 'GUILD_TEXT',
							permissionOverwrites: [
								{
								id: guild.id,
								deny: ["VIEW_CHANNEL"],
								},
							],
						}).then(async c => {
							await c.setParent(x.id);
							if(ids === ''){
								ids = `Channel id for <#${c.id}> is: \`${c.id}\``
							} else {
								ids = `${ids}\nChannel id for <#${c.id}> is: \`${c.id}\``
							}
							channels[v].channelId = c.id
						})
					} else {
						if(ids === ''){
							ids = `Channel id for <#${cc.id}> is: \`${cc.id}\``
						} else {
							ids = `${ids}\nChannel id for <#${cc.id}> is: \`${cc.id}\``
						}
						channels[v].channelId = cc.id
					}
				}
			} else {
				guild.channels.create('Information', {
					type: 'GUILD_CATEGORY',
				}).then(async x => {
					if(!guild.channels.cache.find(cc => cc.name === `📢・prefech-announcements`)){
						await guild.channels.create("📢・prefech-announcements", {
							type: 'GUILD_TEXT',
							permissionOverwrites: [
								{
								id: guild.id,
								deny: ["VIEW_CHANNEL"],
								},
							],
						}).then(async c => {
							await c.setParent(x.id);
							c.send("This channel has been made so you can follow <#721341781467332668>, <#909488719482994788> and don't miss any updated!")
						})
					}
					for(const v in info) {
						let cc = await guild.channels.cache.find(cc => cc.name === baselogs[v])
						if(!cc){
							await guild.channels.create(info[v], {
							type: 'GUILD_TEXT',
							permissionOverwrites: [
								{
								id: guild.id,
								deny: ["VIEW_CHANNEL"],
								},
							],
						}).then(async c => {
								await c.setParent(x.id);
								if(ids === ''){
									ids = `Channel id for <#${c.id}> is: \`${c.id}\``
								} else {
									ids = `${ids}\nChannel id for <#${c.id}> is: \`${c.id}\``
								}
								channels[v].channelId = c.id
							})
						} else {
							if(ids === ''){
								ids = `Channel id for <#${cc.id}> is: \`${cc.id}\``
							} else {
								ids = `${ids}\nChannel id for <#${cc.id}> is: \`${cc.id}\``
							}
							channels[v].channelId = cc.id
						}
					}
				})
			}
	
			x = await guild.channels.cache.find(cc => cc.name === `Main Logs` && cc.type === 'GUILD_CATEGORY')
			if(x){
				for(const v in baselogs) {
					let cc = await guild.channels.cache.find(cc => cc.name === baselogs[v])
					if(!cc){
						await guild.channels.create(baselogs[v], {
							type: 'GUILD_TEXT',
							permissionOverwrites: [
								{
								id: guild.id,
								deny: ["VIEW_CHANNEL"],
								},
							],
						}).then(async c => {
							await c.setParent(x.id);
							if(ids === ''){
								ids = `Channel id for <#${c.id}> is: \`${c.id}\``
							} else {
								ids = `${ids}\nChannel id for <#${c.id}> is: \`${c.id}\``
							}
							channels[v].channelId = c.id
						})
					} else {
						if(ids === ''){
							ids = `Channel id for <#${cc.id}> is: \`${cc.id}\``
						} else {
							ids = `${ids}\nChannel id for <#${cc.id}> is: \`${cc.id}\``
						}
						channels[v].channelId = cc.id
					}
				}
			} else {
				guild.channels.create('Main Logs', {
					type: 'GUILD_CATEGORY',
				}).then(async x => {
					for(const v in baselogs) {
						let cc = await guild.channels.cache.find(cc => cc.name === baselogs[v])
						if(!cc){
							await guild.channels.create(baselogs[v], {
							type: 'GUILD_TEXT',
							permissionOverwrites: [
								{
								id: guild.id,
								deny: ["VIEW_CHANNEL"],
								},
							],
						}).then(async c => {
								await c.setParent(x.id);
								if(ids === ''){
									ids = `Channel id for <#${c.id}> is: \`${c.id}\``
								} else {
									ids = `${ids}\nChannel id for <#${c.id}> is: \`${c.id}\``
								}
								channels[v].channelId = c.id
							})
						} else {
							if(ids === ''){
								ids = `Channel id for <#${cc.id}> is: \`${cc.id}\``
							} else {
								ids = `${ids}\nChannel id for <#${cc.id}> is: \`${cc.id}\``
							}
							channels[v].channelId = cc.id
						}
					}
				})
			}
			setTimeout(() => {
				response.edit(`**Starting AdistraLogs Setup!**\n*ETA: 15 seconds*`)
			}, 15000)
			setTimeout(() => {
				channels['newInstall'] = false
				const newChannels = JSON.stringify(channels, null, 2)
				SaveResourceFile(GetCurrentResourceName(), '/config/channels.json', newChannels);
				response.edit(`**Your Channels:**\n${ids}`)
			}, 30000);
		}
	},
};