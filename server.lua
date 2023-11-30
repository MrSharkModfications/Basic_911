-------- Made By ThatGuyShark#3900 Join Discord for Support https://discord.gg/AShzBSdb ------

local emergencyCalls = {}
local webhookUrl = "https://discord.com/api/webhooks/1167856583645069432/3uoZRkK1qaHJrU2qro0EZA01QxrC7UU239WRmytycQvE1BzRfJRX76RG6m_7wtHC9oHi"  -- Replace this with your actual webhook URL

RegisterServerEvent('send911')
AddEventHandler('send911', function(x, y, z, message)
    local playerName = GetPlayerName(source)
    local playerCoords = {x = x, y = y, z = z}

    local callId = GenerateCallId()
    table.insert(emergencyCalls, {id = callId, player = playerName, coords = playerCoords, message = message})

    TriggerClientEvent('911Call', -1, callId, playerName, playerCoords, message)

    if Config.AdminNotification then
        SendAdminWebhook(playerName, playerCoords, message)
    end
end)

RegisterServerEvent('respondToCall')
AddEventHandler('respondToCall', function(callId, serviceType)
    local playerName = GetPlayerName(source)
    local respondingService = GetServiceName(serviceType)

    -- Add logic for emergency services responding to a call
    local call = GetCallById(callId)

    if call then
        -- Notify the player who made the call that help is on the way
        TriggerClientEvent('911CallResponse', callId, respondingService, playerName)

        -- Additional logic based on your server's needs (e.g., teleporting EMS/police to the call location)
    end
end)

function GetServiceName(serviceType)
    if serviceType == 1 then
        return 'EMS'
    elseif serviceType == 2 then
        return 'Police'
    -- Add more service types as needed
    end
end

function GetCallById(callId)
    for _, call in ipairs(emergencyCalls) do
        if call.id == callId then
            return call
        end
    end
    return nil
end

function SendAdminWebhook(playerName, playerCoords, message)
    local headers = {
        ['Content-Type'] = 'application/json',
    }

    local data = {
        username = 'Server',
        content = string.format('**911 Call**\nPlayer: %s\nLocation: %s, %s, %s\nMessage: %s',
            playerName, playerCoords.x, playerCoords.y, playerCoords.z, message),
    }

    PerformHttpRequest(webhookUrl, function(statusCode, response, headers)
        -- You can add error handling logic here
        print("Webhook status code:", statusCode)
    end, 'POST', json.encode(data), headers)
end

function GenerateCallId()
    return math.random(100000, 999999)
end

