local item, super = Class(Item, "flurrier_bandana")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Flurrier Bandana"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Reclaimed\nscarf"
    -- Menu description
    self.description = "A bandana made of dark fluff. It's surface its as fluff\nas it can be, targets the weak points of shop keepers\nhalving prices by 50%."

    -- Default shop price (sell price is halved)
    self.price = 1200
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        defense = 25,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        len = false,
    }

    -- Character reactions
    self.reactions = {
        susie = "Yeah! free stuff",
        ralsei = "Too comfortable to say no",
        noelle = "This fluff feels illegal...",
        dess = "Even better",
        len = "...",
    }
end

function item:onPedestalSelect()
    return false
end

---@param cutscene WorldCutscene
function item:onPedestalUse(cutscene)
    Game.inventory:removeItem(self)
    Game:getQuest("delivering_a_bandana"):addProgress(1)
    cutscene:text("* ([color:yellow]" .. self:getName() .. "[color:reset] has been delivered correctly.)")
end

return item
