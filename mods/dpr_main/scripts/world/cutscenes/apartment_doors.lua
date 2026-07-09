local function deliver(cutscene)
	cutscene:text("* Ok wait there i'll give you what you have to deliver")
	-- woah an item goes trough the wall :o
	Assets.playSound("bluh")
	cutscene:wait(1)
	local success, result_text = Game.inventory:tryGiveItem("fluffy_bandana")
	if success then
		local success2, result_text2 = Game.inventory:tryGiveItem("pedestal_rough_map")
		cutscene:text(result_text2)
		if not success2 then
			Game.inventory:removeItem("fluffy_bandana")
			cutscene:text("* ...")
			Assets.playSound("bluh")
			cutscene:wait(1)
			cutscene:text("* You need more [color:yellow]KEYs[color:reset] inventory space...")
			cutscene:text("* It's okay tho,[wait:5] you can still come back later")
		else
			Game:setFlag("ken_quest_gaveBandana", 1)
			Game:getQuest("delivering_a_bandana"):unlock()
			Assets.playSound("item")
			cutscene:text(result_text)
			cutscene:text("* There!")
			cutscene:text("* Come back once you deliver it and i might give you a tip")
		end
	else
		cutscene:text(result_text)
		cutscene:text("* ...")
		Assets.playSound("bluh")
		cutscene:wait(1)
		cutscene:text("* It's okay, you can still come back later")
	end
end

return {
	jamm = function(cutscene, event)
		cutscene:text("* It's a door.")
		cutscene:text("* The sign reads \"This apartment belongs to Luthane Jamm and Marcy Jamm.\"")
		if Game:getFlag("acj_quest_prog", 0) >= 2 then
			if not Game:hasPartyMember("jamm") then
				if Game:getFlag("jamm_waiting") then
					cutscene:text("* Didn't Jamm say he'd wait for you here?")
				end
				cutscene:text("* Will you knock?")
			else
				cutscene:text("* Will you enter the apartment?")
			end
			
			local choice = cutscene:choicer({"Yes", "No"})
			
			if choice == 1 then
				if not Game:hasPartyMember("jamm") then
					Assets.playSound("knock")
					cutscene:text("* You knock on the door...")
						
					cutscene:showNametag("Jamm")
					cutscene:text("[voice:jamm]* Oh,[wait:5] coming!")
					cutscene:hideNametag()
				else
					cutscene:text("* Jamm pulls a key card out of his pocket and unlocks the door...")
				end
				
				cutscene:wait(cutscene:fadeOut(0))
				Assets.playSound("dooropen")
				
				cutscene:wait(1)
				
				Assets.playSound("doorclose")
				cutscene:loadMap("floor2/apartments/jamm/jamm_apartment", "entry")
				cutscene:wait(cutscene:fadeIn(0))
			else
				cutscene:text("* You decide not to.")
			end
		end
	end,

	---@param cutscene WorldCutscene
	papereater = function(cutscene, event)
		local paper = cutscene:getCharacter('papereater')
		cutscene:text("* Hey there buddy! Its me paper eater!")
		cutscene:text("* Want me to eat your paper? (I also find bandannas quite SCRUMPTIOUS)")
		local choice = cutscene:choicer({"Yes", "No"})
		if choice == 1 then
			local len = cutscene:getCharacter("len")
			local hadBandana = false
			if len and Game:getFlag("len_protects_bandana_from_paper_monster") and Game.inventory:hasItem("fluffy_bandana") and Game.inventory:hasItem("paper_hat") then
				Game.inventory:removeItem("fluffy_bandana")
				Assets.playSound("item", 1, 0.7)
				cutscene:text("* (Len took your [color:yellow]FluffyBandana[color:reset] so it doesn't get eaten.)")
				hadBandana = true
			end

			paper:setAnimation("open")
			cutscene:wait(1)
			if Game.inventory:hasItem("paper_hat") then
				paper:setAnimation("eat",false)
				Game.inventory:removeItem("paper_hat")
				cutscene:text("* I have eaten your paper!")
			else
				cutscene:text("* YOU HAVE NO PAPER. FOOL.")
				paper:resetSprite()
				return
			end

			if Game.inventory:hasItem("fluffy_bandana") then
				paper:setAnimation("bandana",false)
				Game.inventory:removeItem("fluffy_bandana")
				if not len then
					cutscene:text("* I have eaten your bandana!")
				else
					Game:setFlag("len_protects_bandana_from_paper_monster", true)
					cutscene:text("* I have eaten you-", {wait = false, auto = true})
					cutscene:wait(0.4)
					len:alert()
					cutscene:wait(0.6)
					cutscene:wait(cutscene:walkTo(len, paper.x, paper.y + 50, 0.3))
					paper:setAnimation("bandana_struggle",false)
					len:setAnimation("reach")
					local timer = Game.world.timer
					local shakyTimer = timer:every(0.8, function()
						len:shake()
						paper:shake(0.4)
						Assets.playSound("wing")
					end)
					
					cutscene:textTagged("* No![wait:5] give it back![wait:5] give it back!!!", "dumb", "len")
					timer:cancel(shakyTimer)
					paper:setAnimation("open")
					local bandana = Game.inventory:addItem("fluffy_bandana")
					Assets.playSound("item")
					paper:resetSprite()
					len:resetSprite()
					len:setFacing("up")
					cutscene:text("* ([color:yellow]" .. bandana:getName() .. "[color:reset] has returned to your [color:yellow]ARMOURs[color:reset].)")
					len:setFacing("down")

					local resolution = Game:getFlag("ken_quest_resolution")
					if resolution == 2 then
						cutscene:textTagged("* ...[wait:8] actually...[wait:5] i think i'll keep this.", "neutral_closed", "len")
						cutscene:textTagged("* W-Why?[wait:5] to keep it safe, obviously...", "nervous", "len")

						local lenParty = Game:getPartyMember("len")
						local equipped = lenParty.equipped
						if equipped then
							local armors = equipped.armor
							if armors then
								local has_space = #armors < 2
								if has_space then
									local bandana = Game.inventory:removeItem("fluffy_bandana")
									table.insert(armors, bandana)
									Game:setFlag("ken_quest_gaveBandana", false)
									Assets.playSound("item", 1, 0.7)
									cutscene:text("* ([color:yellow]" .. bandana:getName() .. "[color:reset] has returned to Len [color:yellow]ARMOURs[color:reset].)")
								else
									Assets.playSound("bump")
									cutscene:text("* (Len tried to return [color:yellow]FluffyBandana[color:reset] to their [color:yellow]ARMOURs[color:reset].)")
									cutscene:text("* (...[wait:5]but their [color:yellow]ARMOURs[color:reset] inventory was full.)")
									cutscene:textTagged("* ...[wait:5]Okay,[wait:5] i guess you can have it then...", "nervous", "len")
									Assets.playSound("item")
									cutscene:text("* ([color:yellow]" .. bandana:getName() .. "[color:reset] has returned to your [color:yellow]ARMOURs[color:reset]...[wait:5] again.)")
								end
							end
						end

						Game:setFlag("ken_quest_resolution", 3)
					else
						cutscene:textTagged("* Close one...", "nervous", "len")
					end
					
					cutscene:wait(cutscene:attachFollowers())
					return
				end
			end

			if len and Game:getFlag("len_protects_bandana_from_paper_monster") and hadBandana then
				local bandana = Game.inventory:addItem("fluffy_bandana")
				Assets.playSound("item")
				cutscene:text("* ([color:yellow]" .. bandana:getName() .. "[color:reset] has returned to your [color:yellow]ARMOURs[color:reset].)")
			end

			paper:setAnimation("close")
			cutscene:wait(0.4)
			paper:setAnimation(nil)
		end
		if choice == 2 then
		cutscene:text("* you starve me.")
		end
	end,

	ddelta = function(cutscene, event)
		cutscene:text("* It's a door.")
		cutscene:text("* The sign reads \"This\napartment belongs to Diamond Deltahedron.\"")
		-- To write
	end,

	brenda = function(cutscene, event)
		cutscene:text("* It's a door.")
		cutscene:text("* The sign reads \"This apartment belongs to Brenda Kathiline.\"")
		if Game:hasPartyMember("brenda") then
			if not Game:getFlag("a_brenda_door") then
				cutscene:showNametag("Brenda")
				cutscene:text("* Oh wow,[wait:5] my own apartment?", "shocked", "brenda")
				cutscene:text("* Wait hold on,[wait:5] I just got here...", "suspicious_b", "brenda")
				cutscene:text("* How the hell do I have my own personalized apartment?", "suspicious_b", "brenda")
                if Game:hasPartyMember("jamm") then
                    cutscene:showNametag("Jamm")
					cutscene:text("* Beats me.[wait:10]\n* I asked the same thing too.", "neutral", "jamm")
					cutscene:text("* I was surprised Marcy's name was on it.[wait:10]\n* She's just a kid.", "nervous_left", "jamm")
                    cutscene:showNametag("Brenda")
                end
				cutscene:text("* Eh whatever,[wait:5] don't look a Giftrot in the mouth as they say.", "suspicious", "brenda")
				cutscene:hideNametag()
			end
			if not Game:getFlag("a_brenda_key") then
				cutscene:text("* Unfortunately,[wait:5] it's locked.")
			else

			end
		else
			cutscene:text("* It's locked.")
		end
	end,

	nell = function(cutscene, event)
		cutscene:text("* It's a blank door with a yellow soul emblem.")
		cutscene:text("* You can't help but wonder who it might belong to.")
		-- To write (in like a 1000 years when this gremlin's DLC will come out)
	end,

	gen = function(cutscene, event)
		Game.world.music:pause()
		cutscene:wait(1)
		cutscene:text("[wait:30][sound:giygastalk][voice:none][speed:0.3][shake]* Come in...")
		cutscene:text("[wait:30][sound:giygastalk][voice:none][speed:0.3][shake]* Come and see [wait:10]the story...")
		cutscene:text("[wait:30][sound:giygastalk][voice:none][speed:0.3][shake]* The story of [wait:10]a man\n[wait:10]* Who went too deep...")
		cutscene:wait(1)
		Game.world.music:play()
	end,

	ken = function(cutscene, event)
		Assets.playSound("knock")
		cutscene:wait(1)

		if Game:hasPartyMember("len") or (Game:getFlag("movedKen") or Game:getFlag("lostKen")) then -- Don't question this, please
			cutscene:text("* (No response...)")
			return
		end

		cutscene:text("* Oh someowsne at the door...")
		cutscene:text("* Wait are you that delivery guy i contacted?...")
		local choice = cutscene:choicer({"Yes", "No"})
		if choice == 1 then
			local resolution = Game:getFlag("ken_quest_resolution")
			if resolution and resolution > 0 and resolution ~= 3 then
				Assets.playSound("bluh")
				cutscene:wait(1)
			end
			if resolution == 1 then
				local success, result_text = Game.inventory:tryGiveItem("bowl_hat")
				if success then
					Assets.playSound("item")
					cutscene:text(result_text)
					cutscene:text("* There you go")
					cutscene:text("* Come back if you want more")
				else
					Assets.playSound("bluh")
					cutscene:text(result_text)
					cutscene:text("* Oh well you can always come back later")
				end
				return
			elseif resolution == 2 then
				local success, result_text = Game.inventory:tryGiveItem("paper_hat")
				if success then
					Assets.playSound("item")
					cutscene:text(result_text)
					cutscene:text("* There you go...")
				else
					Assets.playSound("bluh")
					cutscene:text(result_text)
					cutscene:text("* Oh...")
				end
				return
			elseif resolution == 3 then
				local kenTalk = Game:getFlag("ken_rob_caught")
				if kenTalk then
					cutscene:text("* Please leave.")
					return
				end

				Game:setFlag("ken_rob_caught", true)
				cutscene:text("* So,[wait:5] A bird told me some things...")
				cutscene:text("* Things about the destiny of my deliver.")
				cutscene:text("* They said you not only didn't deliver it but you also tried to give it to a paper monster??")
				cutscene:text("* I trust my friend,[wait:5] and i know they wouln't lie...")
				cutscene:text("* ...[wait:5]Did you lie to me?")

				local c = cutscene:choicer({"Yes", "No"})
				if c == 1 then
					cutscene:text("* Why?[wait:5] was the armour so good you though you could lie to keep it?")
					cutscene:text("* I don't get it...")
				else
					cutscene:text("* I know you're lying...[wait:5] do you just not feel shame at all to lie so blatantly?")
					cutscene:text("* You must not even be the delivery guy!")
				end

				cutscene:text("* I don't trust you...[wait:5] not anymore.")
				cutscene:text("* You don't even deserve my [color:yellow]PaperHats[color:reset],[wait:5] Leave.")
				cutscene:text("* Please leave.")
				return
			end
			if Game:getFlag("ken_quest_gaveBandana") == 1 then
				cutscene:text("* Have you delivered the thing yet?")
				local choice3 = cutscene:choicer({"Yes", "No"})
				if choice3 == 1 then
					local hasBandana = Game.inventory:hasItem("fluffy_bandana")
					if hasBandana or not Game:getQuest("delivering_a_bandana"):isCompleted() then
						cutscene:text("* ... are you REALLY sure you delivered it?")
						local choice4 = cutscene:choicer({"Yes", "No"})
						if choice4 == 1 then
							cutscene:text("* ... okay")
							cutscene:text("* Here's a little something for your troubles")
							local success, result_text = Game.inventory:tryGiveItem("paper_hat")
							if success then
								Game:setFlag("ken_quest_resolution", 2)
								Assets.playSound("item")
								cutscene:text(result_text)
								cutscene:text("* There you go...")
								cutscene:text("* You can come back here anytime for more")
							else
								Assets.playSound("bluh")
								cutscene:text(result_text)
								cutscene:text("* oh well, try again when you have more space")
							end
							return
						elseif choice4 == 2 then
							cutscene:text("* Oh... okay")
						end
					else
						cutscene:text("* Okay!")
						cutscene:text("* Here's a little something for your troubles")
						local success, result_text = Game.inventory:tryGiveItem("bowl_hat")
						if success then
							Game:setFlag("ken_quest_resolution", 1)
							Assets.playSound("item")
							cutscene:text(result_text)
							cutscene:text("* There you go")
							cutscene:text("* Come back if you want more")
							cutscene:text("* Have a nice day and thank you")
						else
							Assets.playSound("bluh")
							cutscene:text(result_text)
							cutscene:text("* Oh well you can always come back later")
						end
						return
					end
				else
					cutscene:text("* Oh... okay")
					return
				end
			else
				deliver(cutscene)
				return
			end
		else
			if Game:getFlag("ken_quest_gaveBandana") == 1 then
				cutscene:text("* ...")
				return
			else
				cutscene:text("* Oh... well do you want to deliver something for me?")
				local choice2 = cutscene:choicer({"Yes", "No"})
				if choice2 == 1 then
					deliver(cutscene)
				else
					cutscene:text("* ...")
					return
				end
			end
		end
	end,

	ceroba = function(cutscene, event)
		if Game:getFlag("ceroba_dead") then
			cutscene:text("* You have a feeling that this room might be left empty forever...")
		elseif Game:hasPartyMember("ceroba") then
			cutscene:text("* That's my room.", "neutral", "ceroba")
			cutscene:text("* You want to come in?", "alt", "ceroba")
			local choice = cutscene:choicer({"Yes", "No"})
			cutscene:text("* Alright then.", "neutral", "ceroba")
			if choice == 1 then
				cutscene:mapTransition("floor2/apartments/ceroba", "entrance")
			end
		elseif Game:hasUnlockedPartyMember("ceroba") then
			cutscene:text("* Knock on the door?")
			local choice = cutscene:choicer({"Yes", "No"})
			if choice == 1 then
				Assets.playSound("knock", 0.8)
				cutscene:wait(1)
				cutscene:text("* Come in!", nil, "ceroba")
				Assets.playSound("dooropen")
				cutscene:mapTransition("floor2/apartments/ceroba", "entrance")
			end
		else
			cutscene:text("* A door with an interesting style choice. It's locked.")
		end
	end,
}
