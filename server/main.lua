local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('SmallTattoos:GetPlayerTattoos', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        MySQL.query('SELECT tattoos FROM players WHERE citizenid = @citizenid', {
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

    table.insert(tattooList, tattoo)

    MySQL.query('UPDATE players SET tattoos = @tattoos WHERE citizenid = @citizenid', {
        ['@tattoos'] = json.encode(tattooList),
        ['@citizenid'] = Player.PlayerData.citizenid
    })

    print("You have bought the ~y~" .. tattooName .. "~s~ tattoo for ~g~$" .. price)
    cb(true)

    TriggerClientEvent('Apply:Tattoo', source, tattoo, tattooList)
    else
        TriggerClientEvent('QBCore:Notify', source, "not enough cash", "error")
    end
end)

RegisterNetEvent('SmallTattoos:RemoveTattoo', function(tattooList)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    MySQL.query('UPDATE players SET tattoos = @tattoos WHERE citizenid = @citizenid', {
        ['@tattoos'] = json.encode(tattooList),
        ['@citizenid'] = Player.PlayerData.citizenid
    })
end)


RegisterNetEvent('Select:Tattoos', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.query('SELECT tattoos FROM players WHERE citizenid = @citizenid', {
        ['@citizenid'] = Player.PlayerData.citizenid
    }, function(result)
        if result[1].tattoos then
            local tats = result[1].tattoos
            TriggerClientEvent('Apply:Tattoo', src, tats)
        else
            TriggerEvent('remover:all')
            TriggerClientEvent('remover:tudo', src)
        end
    end)
end)

RegisterNetEvent('remover:all', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        MySQL.query('UPDATE players SET tattoos = @tattoos WHERE citizenid = @citizenid', {
            ['@tattoos'] = 0,
            ['@citizenid'] = Player.PlayerData.citizenid
        })
    end
end)
