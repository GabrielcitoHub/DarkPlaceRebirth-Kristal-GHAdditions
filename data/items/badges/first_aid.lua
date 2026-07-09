local badge, super = Class(Badge, "first_aid")

function badge:init()
    super.init(self)

    -- Display name
    self.name = "First Aid"

    self.type = "badge"

    -- Menu description
    self.description = "Allow Hero to perform First Aid in battle, healing 25 HP for 0 TP!"

    -- The cost of putting it on
    self.badge_points = 1

    -- Default shop price (sell price is halved)
    self.price = 180
end

function badge:update(equipped)
    if equipped and Game:hasPartyMember("hero") and not Game:getPartyMember("hero"):hasSpell("first_aid") then
        Game:getPartyMember("hero"):addSpell("first_aid")
    end
    if not equipped and Game:hasPartyMember("hero") and Game:getPartyMember("hero"):hasSpell("first_aid") then
        Game:getPartyMember("hero"):removeSpell("first_aid")
    end
end

return badge
