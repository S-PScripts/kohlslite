if setclipboard then
  setclipboard(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"))
else
  print(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"))
end
-- Once you have copied the code above, join an empty server and run the code. Next, open a text editor like Notepad and find a string that looks like this: '5568CCBED82CD30E127119030810CE98'.
-- Once you have found the string, copy it and input it into the playertoken variable.

--[[
Example:
{"previousPageCursor":null,"nextPageCursor":null,"data":[{"id":"fae6b9b9-29a2-49b4-96ca-197ddcbc36a4","maxPlayers":8,"playing":1,"playerTokens":["F5EDE1379E3D63C1E07059C82BB8FCD0"],"players":[],"fps":59.997513,"ping":167}]}
]]
