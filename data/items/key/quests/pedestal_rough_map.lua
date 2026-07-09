local item, super = Class(Item, "pedestal_rough_map")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Pedestal Map"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "key"
    -- Item icon (for equipment)
    self.icon = nil
    -- Whether this item is for the light world
    self.light = false

    -- Battle description
    self.effect = "Rough map of a pedestal for the Bandana quest.\nOnly usable outside battles."
    -- Shop description
    self.shop = "Rough map of a pedestal for a quest."
    -- Menu description
    self.description = "Rough map of a pedestal for the Bandana quest.\nUse to view."
    -- Light world check text
    self.check = "A blank piece of paper."

    -- Default shop price (sell price is halved)
    self.price = 1
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "world"
end

function item:onWorldUse(target)
    Assets.playSound("item")
    Game.world:startCutscene(function(cutscene)
        local map = Sprite("world/pedestal_rough_map", 92, 114)
        map:setLayer(99999)
        Game.stage:addChild(map)
        cutscene:wait(1)
        Game.world.timer:tween(0.4, map, {y = 96})
        cutscene:setTextboxTop(false)
        cutscene:text("* (It appears to be a roughly made map of somewhere.)")
        if Game.world.map.id == "floor1/spamgolor_meeting" then
            cutscene:text("* (...On further inspection,[wait:5] this drawing seems to match the room.)")
            cutscene:text("* (It must be somewhere around here)")
        end
        map:remove()
        Assets.playSound("noise")
    end)
end

return item