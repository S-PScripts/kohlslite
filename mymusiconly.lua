-- just tweaked for this random admin game lol

music_related = {}
music_related.mymusiconly = true
music_related.mymusiconlyid = 72773974824127
music_related.musicoff = false
kah_np = true
gottenmode = 1
antimlog = false

local function Chat(msg)
game.Players:Chat(msg)
end

-- MUSIC RELATED
task.spawn(function()
 while true do
    task.wait(0)

    if music_related.mymusiconly == true then -- ii's admin since mine had a small bug and was also messy
        	local soundlock = tonumber(music_related.mymusiconlyid)
            	local origsound = soundlock
            	soundlock = "rbxassetid://"..tostring(soundlock)
           	local lastUpdateTime = tick()

		if kah_np == false then
        		music = workspace.Terrain["_Game"].Folder:FindFirstChild("Sound")
		else
			music = game:GetService("Workspace"):FindFirstChild("HDAdminSound")
		end
        	if gottenmode == 1 then
                    	denumba = tonumber(music.TimePosition)
                	--print(music.TimePosition)
        	else 
                	denumba = 0
        	end

            	repeat 
                	task.wait(0.1)
                	local currentTime = tick() 
                	local elapsedTime = currentTime - lastUpdateTime 
                	lastUpdateTime = currentTime 

                        denumba = denumba + elapsedTime 

			if kah_np == false then
        			music = workspace.Terrain["_Game"].Folder:FindFirstChild("Sound")
			else
				music = game:GetService("Workspace"):FindFirstChild("HDAdminSound")
			end
				
                	if music and music_related.musicoff == false then
				if kah_np == false then
        				music = workspace.Terrain["_Game"].Folder:FindFirstChild("Sound")
				else
					music = game:GetService("Workspace"):FindFirstChild("HDAdminSound")
				end                            	
				if music.IsLoaded and music.SoundId == soundlock then
                                -- print(music.TimePosition);print(denumba)
                                	if denumba > music.TimeLength then 
                                            	denumba = 0 
                                	end 

                                	if math.abs(music.TimePosition - denumba) > 0.5 then
                                        	if denumba < music.TimePosition - 1 or denumba > music.TimePosition + 1 then
                                                	-- print(music.TimePosition) ; print(denumba)
                                                        music.TimePosition = denumba ; Remind("Fixed the time position!")
                                           	end
                                	end

					if kah_np == true then
						if game:GetService("Workspace"):FindFirstChild("Sound") then
                                			if game:GetService("Workspace").Sound.PlaybackSpeed ~= 1 then
								print("pitch used - fixed")
								game:GetService("Workspace").Sound.PlaybackSpeed = 1
							end
                        			end
					else
						if workspace.Terrain["_Game"].Folder:FindFirstChild("Sound") then
                                			if workspace.Terrain["_Game"].Folder:FindFirstChild("Sound").PlaybackSpeed ~= 1 then
								workspace.Terrain["_Game"].Folder:FindFirstChild("Sound").PlaybackSpeed = 1
								Chat(";music 0")
							end
                        			end
					end

				--[[	if kah_np == true then
						if workspace.Sound:FindFirstChild("PitchShiftSoundEffect") then
							print("spitch used - stopped music and restarted")
							workspace.Sound.PitchShiftSoundEffect:Destroy()
							Chat("stopmusic")
						end
					end ]]
                            	end

                            	if music.SoundId ~= soundlock then
                                    print(music.SoundId); print(soundlock); print("fart")
                                	if music_related.musicoff == false then
                                        	if antimlog then
                                                	Chat(";music 00000000000000000000000000000"..tostring(origsound))
                                        	else
                                                    	Chat(";music "..tostring(origsound))
                                        	end
                                	end                    
                            	end

                            	if music.Playing == false and music_related.musicoff == false then
                                        music:Play() 
                            	end
                	else
                        	if music_related.musicoff == false then
                                    print("rizz")
                                	if antimlog then
                                        	Chat(";music 00000000000000000000000000000"..tostring(origsound))
                                    	else
                                        	Chat(";music "..tostring(origsound))
                                	end
                            	end
                	end
                until not music_related.mymusiconly
        end
  end

end)
