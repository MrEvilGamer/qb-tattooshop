QBCore.Functions.CreateCallback('SmallTattoos:GetPlayerTattoos', function(source, cb)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)

	if Player then
		exports.oxmysql:fetch('SELECT tattoos FROM players WHERE citizenid = ?', { Player.PlayerData.citizenid }, function(result)
			if result[1].tattoos then
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end)
	else
		cb()
	end
end)

QBCore.Functions.CreateCallback('SmallTattoos:PurchaseTattoo', function(source, cb, tattooList, price, tattoo, tattooName)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local PlayerMoney = {
        cash = Player.PlayerData.money.cash,
        bank = Player.PlayerData.money.bank,
    }

	if PlayerMoney.bank >= price then
		Player.Functions.RemoveMoney("bank", price , "purchases-tattoos")
		table.insert(tattooList, tattoo)

		exports.oxmysql:execute('UPDATE players SET tattoos = ? WHERE citizenid = ?', {json.encode(tattooList), Player.PlayerData.citizenid})

		cb(true)

		TriggerClientEvent('Apply:Tattoo', source, tattoo, tattooList)
	else
		TriggerClientEvent("QBCore:Notify", src, "You do not have enough money to purchase this tattoo!", "error")
	end
end)

RegisterServerEvent('SmallTattoos:RemoveTattoo')
AddEventHandler('SmallTattoos:RemoveTattoo', function (tattooList)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)

	exports.oxmysql:execute('UPDATE players SET tattoos = ? WHERE citizenid = ?', {json.encode(tattooList), Player.PlayerData.citizenid})
end)


RegisterServerEvent('Select:Tattoos')
AddEventHandler('Select:Tattoos', function() 

	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	exports.oxmysql:fetch('SELECT tattoos FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		if result[1].tattoos then
			tats = result[1].tattoos
			TriggerClientEvent('Apply:Tattoo', src, tats)
		else
			TriggerEvent('remover:all')
			TriggerClientEvent('remover:tudo', src)
		end
	end)

end)

RegisterServerEvent('remover:all')
AddEventHandler('remover:all', function() 
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player then
		exports.oxmysql:execute('UPDATE players SET tattoos = ? WHERE citizenid = ?', {0, Player.PlayerData.citizenid})
	end
end)
