local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")

local player = Players.LocalPlayer

-- Time
local OSTime = os.time()
local Time = os.date("!*t", OSTime)

-- Player info
local Username = player.Name
local DisplayName = player.DisplayName
local UserId = player.UserId
local AccountAge = player.AccountAge

-- Player country
local Region = "Unknown"
pcall(function()
    Region = LocalizationService:GetCountryRegionForPlayerAsync(player)
end)

-- Roblox avatar
local thumbResponse = HttpService:JSONDecode(
    game:HttpGet(
        "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="
        .. UserId ..
        "&size=420x420&format=Png&isCircular=false"
    )
)

local Avatar = thumbResponse.data[1].imageUrl

-- Executor check
local executor = "Unknown"

pcall(function()
    if identifyexecutor then
        executor = identifyexecutor()
    end
end)

-- Embed
local Embed = {
    title = "Player Info",
    color = 99999,
    thumbnail = {
        url = Avatar
    },
    footer = {
        text = "JobId: " .. game.JobId
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
        },
        {
            name = "Executor",
            value = executor,
            inline = true
        },
        {
            name = "Account Age",
            value = tostring(AccountAge) .. " days",
            inline = true
        },
        {
            name = "Region",
            value = Region,
            inline = true
        }
    },
    timestamp = string.format(
        "%d-%02d-%02dT%02d:%02d:%02dZ",
        Time.year, Time.month, Time.day,
        Time.hour, Time.min, Time.sec
    )
}

(syn and syn.request or http_request)({
    Url = "",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode({
        content = "I have been struck by the ban hammer!",
        embeds = { Embed }
    })
})
