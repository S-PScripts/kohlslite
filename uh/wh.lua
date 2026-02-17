local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- Time
local OSTime = os.time()
local Time = os.date("!*t", OSTime)

-- Player info
local Username = player.Name
local DisplayName = player.DisplayName
local UserId = player.UserId

-- Roblox avatar thumbnail (headshot)
local Avatar = "https://www.roblox.com/headshot-thumbnail/image?userId="
    .. UserId .. "&width=420&height=420&format=png"

local Content = "A player executed the script!"

local Embed = {
    title = "Player Info",
    color = 99999,
    thumbnail = {
        url = Avatar
    },
    footer = {
        text = "JobId: " .. game.JobId
    },
    author = {
        name = "ROBLOX",
        url = "https://www.roblox.com/"
    },
    fields = {
        {
            name = "Username",
            value = Username,
            inline = true
        },
        {
            name = "Display Name",
            value = DisplayName,
            inline = true
        },
        {
            name = "User ID",
            value = tostring(UserId),
            inline = false
        }
    },
    timestamp = string.format(
        "%d-%02d-%02dT%02d:%02d:%02dZ",
        Time.year, Time.month, Time.day,
        Time.hour, Time.min, Time.sec
    )
}

(syn and syn.request or http_request)({
    Url = "webhook url",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode({
        content = Content,
        embeds = { Embed }
    })
})
