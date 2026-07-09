---@class MyQuest : Quest
local MyQuest, super = Class(Quest, "a_special_delivery")

function MyQuest:init()
    super.init(self)

    self.name = "A Special Delivery?"
    self.description = {COLORS.blue, "Lazul ", COLORS.white, "has \"asked\" you to deliver a package to a man at the ", COLORS.yellow, "WARP HUB", COLORS.white, ".\nHe said the bin code was ", COLORS.yellow, "00000000", COLORS.white, "."}

    self.progress_max = 0
end

function MyQuest:getDescription()
	if self:isCompleted() then
		return "You completed this quest. :D"
	end
    
	return self.description
end

return MyQuest
