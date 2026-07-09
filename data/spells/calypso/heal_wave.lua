local spell, super = Class(Spell, "heal_wave")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Heal Wave"

    -- Battle description
    self.effect = "Heal\nAll"
    -- Menu description
    self.description = "Heals all party members greatly with a wave."

    -- TP cost
    self.cost = 35

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "party"

    -- Tags that apply to this spell
    self.tags = {"water", "heal"}
end

function spell:getTPCost(chara)
    -- remove this function when the spell is finished
    return 500
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." cast "..self:getCastName().."!"
end

function spell:onCast(user, target)
    -- WIP
end

return spell
