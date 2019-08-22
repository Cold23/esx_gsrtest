ESX = nil
gsrData = {}

TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)

TriggerEvent('es:addCommand', 'gsr', function(source, args, user)
    local Source = source
    local xPlayer = ESX.GetPlayerFromId(Source)
    local number = tonumber(args[1])
    if args[1] ~= nil then 
		if xPlayer.job.name == 'police' and type(number) == "number" then
        	CancelEvent()
        	local identifier = GetPlayerIdentifiers(number)[1]
        	if identifier ~= nil then
                TriggerClientEvent('ger:mythicProgBar', source,Source,identifier)
        	end
    	else
            TriggerClientEvent('chat:addMessage', Source, {
                template = '<div style="padding: 0.5vw; margin: 0vw; background-color: rgba(214, 0, 0, 0.7); border-radius: 3px;" ></i> {0} <br> {1}</div>',
                args = { "[GSR]", "You must be a cop"}
            })
    	end
	else
            TriggerClientEvent('chat:addMessage', Source, {
                template = '<div style="padding: 0.5vw; margin: 0vw; background-color: rgba(214, 0, 0, 0.7); border-radius: 3px;" ></i> {0} <br> {1}</div>',
                args = { "[GSR]", "Correct Usage Is: /gsr <player id>"}
            })
	end
end)

AddEventHandler('esx:playerDropped', function(source)
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        gsrData[identifier] = nil
    end
end)

RegisterNetEvent("gsr:doTest")
AddEventHandler("gsr:doTest", function(id)
    local Source = source
    local xPlayer = ESX.GetPlayerFromId(Source)
    local number = tonumber(id)
    if number ~= nil then 
        if xPlayer.job.name == 'police' and type(number) == "number" then
            local identifier = GetPlayerIdentifiers(number)[1]
            if identifier ~= nil then
                TriggerClientEvent('ger:mythicProgBar', source,Source,identifier)
            end
        else
            TriggerClientEvent('chat:addMessage', Source, {
                template = '<div style="padding: 0.5vw; margin: 0vw; background-color: rgba(214, 0, 0, 0.7); border-radius: 3px;" ></i> {0} <br> {1}</div>',
                args = { "[GSR]", "You must be a cop"}
            })
        end
    else
            TriggerClientEvent('chat:addMessage', Source, {
                template = '<div style="padding: 0.5vw; margin: 0vw; background-color: rgba(214, 0, 0, 0.7); border-radius: 3px;" ></i> {0} <br> {1}</div>',
                args = { "[GSR]", "No player nearby"}
            })
    end
end)

RegisterNetEvent("gsr:doServerCheck")
AddEventHandler("gsr:doServerCheck", function(s,id)
    gsrcheck(s,id)
end)

RegisterNetEvent("GSR:Remove")
AddEventHandler("GSR:Remove", function()
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        gsrData[identifier] = nil
    end
end)

RegisterServerEvent('GSR:SetGSR')
AddEventHandler('GSR:SetGSR', function()
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    gsrData[identifier] = os.time(os.date("!*t")) + Config.gsrTime
end)

function gsrcheck(source, identifier)
    local Source = source
    local identifier = identifier
    if gsrData[identifier] ~= nil then
        TriggerClientEvent('chat:addMessage', Source, {
                template = '<div style="padding: 0.5vw; margin: 0vw; background-color: rgba(214, 0, 0, 0.7); border-radius: 3px;" ></i> {0} <br> {1}</div>',
                args = { "[GSR]", "Test comes back POSITIVE " }
            })
    else
        TriggerClientEvent('chat:addMessage', Source, {
                template = '<div style="padding: 0.5vw; margin: 0vw; background-color: rgba(214, 0, 0, 0.7); border-radius: 3px;" ></i> {0} <br> {1}</div>',
                args = { "[GSR]", "Test comes back NEGATIVE " }
            })
    end
end

RegisterServerEvent('GSR:Status2')
AddEventHandler('GSR:Status2', function(playerid)
    local Source = source
    local identifier = GetPlayerIdentifiers(playerid)[1]
    if gsrData[identifier] ~= nil then
        TriggerClientEvent('chat:addMessage', Source, {
                template = '<div style="padding: 0.5vw; margin: 0vw; background-color: rgba(214, 0, 0, 0.7); border-radius: 3px;" ></i> {0} <br> {1}</div>',
                args = { "[GSR]", "Test comes back POSITIVE " }
            })
    else
        TriggerClientEvent('chat:addMessage', Source, {
                template = '<div style="padding: 0.5vw; margin: 0vw; background-color: rgba(214, 0, 0, 0.7); border-radius: 3px;" ></i> {0} <br> {1}</div>',
                args = { "[GSR]", "Test comes back NEGATIVE " }
            })
    end
end)

ESX.RegisterServerCallback('GSR:Status', function(source, cb)
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

function removeGSR()
    for k, v in pairs(gsrData) do
        if v <= os.time(os.date("!*t")) then
            gsrData[k] = nil
        end
    end
end

function gsrTimer()
    removeGSR()
    SetTimeout(Config.gsrAutoRemove, gsrTimer)
end

gsrTimer()
