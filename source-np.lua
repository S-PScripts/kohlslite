-- kohlslite np
local function Chat(msg)
	game:GetService("Players"):Chat(msg)
end

local function Remind(text, num)
	if num == nil then num = 1 end
	game:GetService("StarterGui"):SetCore("SendNotification",
	{
		Title = "KohlsLite NP",
		Text = text,
		Duration = num
	}
	)
end
