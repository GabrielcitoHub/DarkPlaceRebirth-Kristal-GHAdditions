local TeleitemPedestal, super = Class(Event, "teleitem_pedestal")

function TeleitemPedestal:init(data)
    super.init(self, data)
    
    self.item = ""
    self.active = false
    self:setScale(2)
    self:setOrigin(0.5, 1)
    self:setSprite("world/events/pillar")
    self.solid = true
end

function TeleitemPedestal:update()
    super.update(self)
end

function TeleitemPedestal:draw()
    super.draw(self)

    if self.active then
        love.graphics.setColor(love.math.random(0.0,1),love.math.random(0.0,1),love.math.random(0.0,1),0.2)
        love.graphics.draw(Assets.getTexture("world/events/glow"),4)
        love.graphics.setColor(1,1,1,1)
    end
end

function TeleitemPedestal:onInteract(player, dir)
    local darkInventory = Game.inventory:getDarkInventory()
    local items = darkInventory.stored_items

    local found_item
    for item,info in pairs(items) do
        local preUse = item.onPrePedestalUse
        local use = item.onPedestalUse
        local postUse = item.onPostPedestalUse
        local selectable = item.onPedestalSelect and item:onPedestalSelect()
        print(selectable)
        if selectable == nil then selectable = true end

        if type(item) == "table" and (preUse or use or postUse) and selectable then
            found_item = item
            break
        end
    end

    Game.world:startCutscene(function(cutscene)
        if found_item then
            local item = found_item
            local preUse = item.onPrePedestalUse
            local use = item.onPedestalUse
            local postUse = item.onPostPedestalUse

            local wait_time = 1
            local use_text = "* (Your [color:yellow]" .. item.name .. "[color:reset] glided towards the pedestal!)"

            if preUse or use or postUse then
                Assets.playSound("celestial_hit")

                if preUse then
                    local function checkReturn(result)
                        local resultType = type(result)
                        if resultType == true then
                            return
                        elseif resultType == "string" then
                            use_text = result
                        elseif resultType == "number" then
                            wait_time = result
                        elseif resultType == "table" then
                            for _,v in ipairs(result) do
                                checkReturn(v)
                            end
                        end
                    end

                    checkReturn(preUse(item, cutscene))
                end

                self.active = true

                cutscene:text(use_text)
                cutscene:wait(wait_time)

                if use then
                    use(item, cutscene)
                end

                self.active = false

                if postUse then
                    postUse(item, cutscene)
                end

                return
            end
        end

        cutscene:text("* (Seems like you got! [wait:1]\n      nothing special...)")
    end)
end

return TeleitemPedestal