local Vector = require 'modules.hump.camera'
local Signal = require 'modules.hump.signal'
local Timer = require 'modules.hump.timer'
local Player = require 'src.objects.player'
local Raindrop = require 'src.objects.raindrop'
local Bird = require 'src.objects.bird'
local Hummingbird = require 'src.objects.hummingbird'
local Camera = require 'src.camera'
local Constants = require 'src.constants'
local Music = require 'src.music'
local Objects = require 'src.objects'
local Rain = require 'src.rain'

local Game = {}

local sprites = {
    backgroundBlur = love.graphics.newImage('res/background_blur.png'),
}

function Game:init()
    Signal.register('cam_shake', function(shake)
        self.camera:shake(shake)
    end)
    Music.init()
end

function Game:enter()
    self.objects = Objects()
    self.player = Player(self.objects, 180, 120)
    self.camera = Camera(self.player, { damping = 12 })
    self.rain = Rain()

    ----------------------------------------------------------------------------
    -- TODO: Add spawning logic here.
    self.timer = Timer.new()
    self.timer:every(120, function()
        local x, y = self.camera:getPosition():unpack()
        if math.random(0, 1) == 0 then
            Bird(self.objects, x + 700, math.random(20, 220), self.player)
        else
            Hummingbird(self.objects, x + 700, math.random(20, 220), self.player)
        end
    end)
    self.timer:every(60, function()
        Raindrop(self.objects, 200, -100, math.random(4, 50))
    end)
    ----------------------------------------------------------------------------

    self.timer:every(1, function()
        self.rain:add(math.random() * Constants.GAME_WIDTH)
    end)
end

function Game:update(dt)
    self.player:update(dt)
    self.objects:update(dt)
    self.camera:follow(self.player)
    self.camera:update(dt)
    self.rain:update(dt)
    self.timer:update(dt)
end

function Game:draw()
    local camPos = self.camera:getPosition()
    local camX = -((camPos.x / 4) % 480)
    for x = camX, love.graphics.getWidth(), 480 do
        love.graphics.draw(sprites.backgroundBlur, x, 0)
    end
    self.rain:draw()
    self.camera:draw(function()
        self.player:draw()
        self.objects:draw()
    end)
end

return Game