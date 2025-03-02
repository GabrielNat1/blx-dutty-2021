local players = game:GetService("Players")
local mps = game:GetService("MarketplaceService")

local banLists = {340135592}

function onPlayerAdded(player)
	print(player.Name.." has entered")
	updateLists(player)
end

function updateLists(player)
	for _, v in pairs(banLists) do
		local listDesc = mps:GetProductInfo(tonumber(v)).Description
		if listDesc:find(player.userId.."[,;]") then
			player:Kick("You have been banned from the game")
		end
	end
end

players.PlayerAdded:connect(onPlayerAdded)

for _, player in pairs(players:GetPlayers()) do
	onPlayerAdded(player)
end

while true do
	wait(60)
	local children = players:GetChildren()
	for i = 1, #children do
		updateLists(children[i])
	end
end