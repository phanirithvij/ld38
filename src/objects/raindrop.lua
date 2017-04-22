local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'
local Animation = require 'src.animation'

local Raindrop = Class.new()
Raindrop:include(Object)

local sprites = {
    small = love.graphics.newImage('res/raindrop_small.png'),
    medium = love.graphics.newImage('res/raindrop_medium.png'),
    large = love.graphics.newImage('res/raindrop_large.png'),
}

function Raindrop:init(objects, x, y, radius)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y, radius)
    self.radius = radius
end

function Raindrop:build(world, x, y, radius)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setLinearDamping(0.1, 0.1)
    self.shape = love.physics.newCircleShape(radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
end

function Raindrop:update(dt)
end

function Raindrop:draw()
    local x, y = self.body:getPosition()
    if self.radius > 16 then
        local scale = 32 / self.radius
        love.graphics.draw(sprites.large, x, y, 0, scale, scale, 32, 32)
    elseif self.radius > 8 then
        local scale = 16 / self.radius
        love.graphics.draw(sprites.medium, x, y, 0, scale, scale, 16, 16)
    else
        local scale = 8 / self.radius
        love.graphics.draw(sprites.small, x, y, 0, scale, scale, 8, 8)
    end
end

return Raindrop
