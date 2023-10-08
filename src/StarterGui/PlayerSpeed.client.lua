local player = game.Players.LocalPlayer

player.CharacterAdded:Connect(function(character)

    character:WaitForChild("Humanoid").WalkSpeed = 100

end)

wait(1)
player.Character.Humanoid.WalkSpeed = 100