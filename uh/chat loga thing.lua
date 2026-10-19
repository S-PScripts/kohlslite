local TextChatService = game:GetService("TextChatService")

TextChatService.MessageReceived:Connect(function(textChatMessage)
	local msg = textChatMessage.Text
	
	local textSource = textChatMessage.TextSource
	if textSource then
		local player = game.Players:GetPlayerByUserId(textSource.UserId)
		if player then
			print(player.Name .. ": " .. msg)
		end
	end
end)
