if setclipboard then
  setclipboard(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"))
else
  print(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"))
end
-- Once you have copied the code above, join an empty server and run the code. Next, open a text editor like Notepad and find a string that looks like this: '5568CCBED82CD30E127119030810CE98'.
-- Once you have found the string, copy it and input it into the playertoken variable.
