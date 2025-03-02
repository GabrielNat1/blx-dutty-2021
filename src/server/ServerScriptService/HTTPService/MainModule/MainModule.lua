local API = {}

local id = nil
local remoteEvent = script.ReportGoogleAnalyticsEvent
local helper = script.GoogleAnalyticsHelper
local category = "PlaceId-" .. tostring(game.PlaceId)
local googleUserTrackingId = game:GetService("HttpService"):GenerateGUID()
local lastTimeGeneratedGoogleUserId = os.time()

function convertNewlinesToVertLine(stack)
	local rebuiltStack = ""
	local first = true
	for line in stack:gmatch("[^\r\n]+") do
		if first then
			rebuiltStack = line
			first = false
		else
			rebuiltStack = rebuiltStack .. " | " .. line
		end
	end
	return rebuiltStack
end

function removePlayerNameFromStack(stack)
	stack = string.gsub(stack, "Players%.[^.]+%.", "Players.<Player>.")
	return stack
end

function setupScriptErrorTracking()
	game:GetService("ScriptContext").Error:connect(function (message, stack)
		API.ReportEvent(category,
			removePlayerNameFromStack(message) .. " | " .. 
			removePlayerNameFromStack(stack), "none", 1)
	end)
	-- adicionar rastreamento para clientes
	helper.Parent = game.StarterGui
	-- adicionar a todos os jogadores que já estão no jogo
	for i, c in ipairs(game.Players:GetChildren()) do
		helper:Clone().Parent = (c:WaitForChild("PlayerGui"))
	end
end

function printEventInsteadOfActuallySendingIt(category, action, label, value)
	print("GA EVENT: " ..
		"Category: [" .. tostring(category) .. "] " .. 
		"Action: [" .. tostring(action) .. "] " ..
		"Label: [" .. tostring(label) .. "] " ..
		"Value: [" .. tostring(value) .. "]")
end

function API.ReportEvent(category, action, label, value)
	if game:FindFirstChild("NetworkServer") ~= nil then
		if id == nil then
			print("WARNING: not reporting event because Init() has not been called")
			return
		end
		
		-- Tente detectar o servidor de início de estúdio + jogador
		if game.CreatorId <= 0 then
			printEventInsteadOfActuallySendingIt(category, action, label, value)
			return
		end
		
		if os.time() - lastTimeGeneratedGoogleUserId > 7200 then
			googleUserTrackingId = game:GetService("HttpService"):GenerateGUID()
			lastTimeGeneratedGoogleUserId = os.time()
		end

		local hs = game:GetService("HttpService")
		hs:PostAsync(
			"http://www.google-analytics.com/collect",
			"v=1&t=event&sc=start" ..
			"&tid=" .. id .. 
			"&cid=" .. googleUserTrackingId ..
			"&ec=" .. hs:UrlEncode(category) ..
			"&ea=" .. hs:UrlEncode(action) .. 
			"&el=" .. hs:UrlEncode(label) ..
			"&ev=" .. hs:UrlEncode(value),
			Enum.HttpContentType.ApplicationUrlEncoded)
	elseif game:FindFirstChild("NetworkClient") ~= nil then
		game:GetService("ReplicatedStorage").ReportGoogleAnalyticsEvent:FireServer(category, action, label, value)
	else
		printEventInsteadOfActuallySendingIt(category, action, label, value)
	end
end

function API.Init(userId, config)
	if game:FindFirstChild("NetworkServer") == nil then
		error("Init() can only be called from game server")
	end
	if id == nil then
		if userId == nil then
			error("Cannot Init with nil Analytics ID")
		end

		id = userId
		remoteEvent.Parent = game:GetService("ReplicatedStorage")
		remoteEvent.OnServerEvent:connect(
			function (client, ...) API.ReportEvent(...) end)
		
		if config == nil or not config["DoNotReportScriptErrors"] then
			setupScriptErrorTracking()
		end

		if config == nil or not config["DoNotTrackServerStart"] then
			API.ReportEvent(category, "ServerStartup", "none", 0)
		end
		
		if config == nil or not config["DoNotTrackVisits"] then
			game.Players.ChildAdded:connect(function ()
				API.ReportEvent(category, "Visit", "none", 1)
			end)
		end
	else
		error("Attempting to re-initalize Analytics Module")
	end
end

return API
