-- chat loga thing
function PLRSTART(v)
  v.Chatted:Connect(function(msg)
    task.wait(0)
    print(msg)
  end)
end

game.Players.PlayerAdded:Connect(function(player)
  PLRSTART(player)
end)

for i, v in pairs(game.Players:GetPlayers()) do
  PLRSTART(v)
end
