local spell, super = Class(Spell, "tide_break")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Tide Break"

    -- Battle description
    self.effect = "Water\nDamage"
    -- Menu description
    self.description = "Blast an enemy with a beam of water, dealing damage and lowering defense in COLD.."

    -- TP cost
    self.cost = 35

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"water", "damage"}
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
