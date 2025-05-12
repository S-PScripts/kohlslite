local function Chat(msg)
    game.Players:Chat(msg)
end

local folder = workspace.Terrain._Game.Folder

Chat("clr")

repeat task.wait() until not folder:FindFirstChild("Sound")    

Chat("music 15689455422")

repeat task.wait() until folder:FindFirstChild("Sound") and folder:FindFirstChild("Sound").Playing
local sound = folder:FindFirstChild("Sound")

function CheckSound()
    if not folder:FindFirstChild("Sound").Playing then return false end
    return true
end

-- LRC lyrics as {time, text}
local lyrics = {
    {0.32, "My fellow sigmas (yeah)"},
    {1.50, "Let's mog together today (woah)"},
    {3.62, "And watch skibidi toilet all day (o, o, o, o, o)"},
    {6.47, "We'll rizz and mog all day (yippee)"},
    {9.19, "I have level 600 gyatt in my back"},
    {11.81, "And I rizz like Livvy Dunne"},
    {13.40, "Skibidi toilet in the background too"},
    {15.93, "I just feel like rizzing today"},
    {17.58, "Baby Gronk is here"},
    {19.04, "Kai Cenat too"},
    {20.53, "Today we'll Fanum tax someones food"},
    {23.80, "We're the rizzlers and moggers"},
    {25.80, "And everything that's skibidi"},
    {29.15, "We're the rizzlers and moggers"},
    {31.00, "We Fanum tax everyone"},
    {34.40, "We're the rizzlers and moggers"},
    {36.35, "We'll looksmaxx you till you tax"},
    {39.70, "We're the rizzlers and moggers"},
    {41.57, "Don't hide else we'll rizz you up"},
    {44.45, "Going back from Ohio"},
    {46.55, "With grimace shake in my hand..."},
    {49.21, "I feel like rizzing today so don't even stop me now"},
    {84.14, "Hey, let's mog together today (woah)"},
    {86.57, "And watch skibidi toilet all day (o, o, o, o, o)"},
    {89.10, "We'll rizz and mog all day (yippee)"},
    {91.87, "I have level 600 gyatt in my back"},
    {94.34, "And I rizz like Livvy Dunne"},
    {96.52, "Skibidi toilet in the background too"},
    {99.11, "I just feel like rizzing today"},
    {102.18, "Baby Gronk is here"},
    {103.64, "Kai Cenat too"},
    {105.08, "Today we'll Fanum tax someones food"},
    {112.82, "Someones food"},
    {115.92, "Today we'll Fanum tax someones food"}
}

-- Synchronise lyrics with sound playback
task.spawn(function()
    for i, lyric in ipairs(lyrics) do
        local t = lyric[1]
        local text = lyric[2]
        -- Wait until the sound's TimePosition reaches or passes the lyric time
        while CheckSound() and sound.TimePosition < t do
            task.wait(0.05)
        end
        if CheckSound() then
            Chat(text)
        else
            break
        end
    end
end)
