local spell, super = Class(Spell, "dark_steal")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Dark Steal"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Heal all\nCosts HP"
    -- Menu description
    self.description = "Shadowly dark restores a little HP to\nall party members in exhange of\nHP, Depends on Enemies and Magic."

    -- TP cost
    self.cost = 50

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "party"

    -- Tags that apply to this spell
    self.tags = {"heal"}
end

function spell:onCast(user, target)
    local heal = user.chara:getStat("magic") * 6
    local dmg = heal * (2 / (user.chara:getStat("magic") / 6))
    user:hurt(dmg * 2)

    local enemies = Game.battle.enemies
    for _,enemy in ipairs(enemies) do
        local enemy_dmg = dmg / 4 * ((user.chara:getStat("magic") / 8) / 2)
        heal = heal + MathUtils.round(enemy_dmg) / 2
        enemy:hurt(MathUtils.round(enemy_dmg), user)
    end

    local heal_amount = Game.battle:applyHealBonuses(MathUtils.round(heal), user.chara)
    for _,battler in ipairs(target) do
        if battler.chara.id == user.chara.id then
            battler:heal(MathUtils.round(heal_amount / 8))
        else
            battler:heal(heal_amount)
        end
    end
end

return spell