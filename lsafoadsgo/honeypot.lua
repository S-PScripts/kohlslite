repeat game:GetService("ReplicatedStorage").Remotes.RequestTeamChange:InvokeServer(
        game:GetService("Teams").Neutral
    )
    task.wait()
until game.Players.LocalPlayer.Team == game:GetService("Teams").Neutral

repeat
    game:GetService("ReplicatedStorage").Remotes.RequestTeamChange:InvokeServer(
        game:GetService("Teams").Inmates
    )
    game:GetService("ReplicatedStorage").Remotes.RequestTeamChange:InvokeServer(
        game:GetService("Teams").Guards
    )
    task.wait()
until game.Players.LocalPlayer.Team == game:GetService("Teams").Inmates or game.Players.LocalPlayer.Team == game:GetService("Teams").Guards

task.wait(1)

game.Players.LocalPlayer:Kick("You will get banned by Aesthetical soon! Goodbye!")
