local minutes = game.ReplicatedStorage.ServerSettings.TimeOfDay
minutes.Value = math.random(100,5000)


while true do
	wait(2)
	minutes.Value = minutes.Value + 1
end
