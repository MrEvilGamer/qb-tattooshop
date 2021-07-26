QBCore.Functions.CreateCallback('SmallTattoos:GetPlayerTattoos', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        exports['ghmattimysql']:execute('SELECT tattoos FROM players WHERE citizenid = @citizenid', {
            ['@citizenid'] = Player.PlayerData.citizenid
        }, function(result)
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
    
    if Player.PlayerData.money.cash >= price then
        Player.Functions.RemoveMoney('cash', price)
        TriggerClientEvent('QBCore:Notify', source, "You bought a tattoo", "success")
    else
        TriggerClientEvent('QBCore:Notify', source, "not enough cash", "error")
    end
    table.insert(tattooList, tattoo)
    
    exports['ghmattimysql']:execute('UPDATE players SET tattoos = @tattoos WHERE citizenid = @citizenid', {
        ['@tattoos'] = json.encode(tattooList),
        ['@citizenid'] = Player.PlayerData.citizenid
    })
    
    print("You have bought the ~y~" .. tattooName .. "~s~ tattoo for ~g~$" .. price)
    cb(true)
    
    TriggerClientEvent('Apply:Tattoo', source, tattoo, tattooList)
end)

RegisterServerEvent('SmallTattoos:RemoveTattoo')
AddEventHandler('SmallTattoos:RemoveTattoo', function(tattooList)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    exports['ghmattimysql']:execute('UPDATE players SET tattoos = @tattoos WHERE citizenid = @citizenid', {
        ['@tattoos'] = json.encode(tattooList),
        ['@citizenid'] = Player.PlayerData.citizenid
    })
end)


RegisterServerEvent('Select:Tattoos')
AddEventHandler('Select:Tattoos', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    exports['ghmattimysql']:execute('SELECT tattoos FROM players WHERE citizenid = @citizenid', {
        ['@citizenid'] = Player.PlayerData.citizenid
    }, function(result)
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
        exports['ghmattimysql']:execute('UPDATE players SET tattoos = @tattoos WHERE citizenid = @citizenid', {
            ['@tattoos'] = 0,
            ['@citizenid'] = Player.PlayerData.citizenid
        })
    end
end)

--[[RegisterServerEvent('Server:Apply:Tattoos')
AddEventHandler('Server:Apply:Tattoos', function() 

	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	exports['ghmattimysql']:execute('SELECT tattoos FROM players WHERE citizenid = @citizenid', {
		['@citizenid'] = Player.PlayerData.citizenid
	}, function(result)
		if result[1].tattoos then
			tats = result[1].tattoos
			TriggerClientEvent('Apply:Tattoo', src, tats)
		end
	end)
end)

RegisterServerEvent('Receive:Tats')
AddEventHandler('Receive:Tats', function(tats, charPed)
	TriggerClientEvent('Apply:PedTattoo', tats, charPed)
end)

RegisterServerEvent('Select:TattoosFromPed')
AddEventHandler('Select:TattoosFromPed', function(charPed)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	exports['ghmattimysql']:execute('SELECT tattoos FROM players WHERE citizenid = @citizenid', {
		['@citizenid'] = Player.PlayerData.citizenid
	}, function(result)
		if result[1].tattoos then
			tats = result[1].tattoos

			TriggerClientEvent('Apply:PedTattoo', tats, charPed)
		end
	end)
end)]]