local spell, super = Class(Spell, "headwind")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Headwind"

    -- Battle description
    self.effect = "Proj\nBuff"
    -- Menu description
    self.description = "Calls a mighty headwind, increasing potency of all projectile actions for 3 turns."

    -- TP cost
    self.cost = 48

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "none"

    -- Tags that apply to this spell
    self.tags = {"wind"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." created a headwind.\n* All projectile-based actions are boosted for 3 turns!"
end

function spell:onCast(user, target)
    Assets.playSound("whistlebreath")
    Game.battle.headwind = 4    -- TODO: Effect
end

return spell
