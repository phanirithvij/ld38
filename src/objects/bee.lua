local Class = require 'modules.hump.class'
local Body = require 'src.objects.body'

local Bee = Class.new()
Bee:include(Body)
Bee.MAX_ACCEL = 0.1
Bee.MAX_SPEED = 4

local sprite = love.graphics.newImage('res/bee.png')

function Bee:init(objects, x, y, player)
    Body.init(self, objects, x, y)
    self.player = player
    self.offset = math.random()
    self.lag = 1 + math.random() * 2
    self:addTag('bee')
end

function Bee:build(world, x, y)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setLinearDamping(0.1, 0.1)
    self.shape = love.physics.newCircleShape(4)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setRestitution(1)
end

function Bee:update(dt)
    local delta = self.player:getPosition() - self:getPosition()
    delta = delta:trimmed(Bee.MAX_SPEED) / 100 / self.lag
    self.body:applyForce(delta:unpack())

    self.offset = (self.offset + dt / 60) % 1
end

function Bee:draw()
    local x, y = self.body:getPosition()
    local vx, vy = self.body:getLinearVelocity()
    local angle = math.atan2(vy, vx)
    local offset = math.sin(self.offset * math.pi * 2) * 2
    love.graphics.draw(sprite, x, y + offset, angle, 0.5, 0.5, 8, 8)
end

return Bee
