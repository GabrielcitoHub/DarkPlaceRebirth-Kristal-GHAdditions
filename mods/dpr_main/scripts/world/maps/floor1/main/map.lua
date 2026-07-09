local MainHub, super = Class(Map)

function MainHub:onEnter()
    super.onEnter(self)
    if Game.world:getPartyCharacterInParty("len") then
        local lenNpc = Game.world:getCharacter("len")
        lenNpc:remove()
    end

    if DTRANS then
        Game.world:startCutscene("darkenter")
    end

    local sans = Game.world:getCharacter("sans")
    if sans then
        if Game:getFlag("hasPushedSans") then
            sans.x = 545
        else
            sans.x = 465
        end
    end
    
    Game:rollShiny("dess")
end

return MainHub
