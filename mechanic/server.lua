local mechanicJobPlayers = {} -- Store players with mechanic job

-- Event to start the mechanic job
RegisterServerEvent("mechanic:startJob")
AddEventHandler("mechanic:startJob", function()
    local source = source
    mechanicJobPlayers[source] = true
end)

-- Event to start the repair process
RegisterServerEvent("mechanic:startRepair")
AddEventHandler("mechanic:startRepair", function()
    local source = source
    if mechanicJobPlayers[source] then
        TriggerClientEvent("mechanic:startRepair", source)
    end
end)
