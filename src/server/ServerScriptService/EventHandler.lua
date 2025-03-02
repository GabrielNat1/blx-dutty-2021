local repstore=game.ReplicatedStorage
local servstore=game.ServerStorage
local events=repstore.Events
local respawn=events.Respawn
local getgun=events.GetGun

--------REMOTE FUNCTIONS---------

function getgun.OnServerInvoke(p,gun)
	local model=servstore.GunModels[gun]:Clone()	
	local module=servstore.GunModules[gun]:Clone()
	module.Parent=p.PlayerGui
	model.Parent=p.PlayerGui
	return model,module
end

----------REMOTE EVENTS----------
respawn.OnServerEvent:connect(function(p)
	p:LoadCharacter()
end)
