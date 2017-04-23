local Vector = require 'modules.hump.vector'
local Gamestate = require 'modules.hump.gamestate'
local Signal = require 'modules.hump.signal'
local Timer = require 'modules.hump.timer'
local Transition = require 'src.states.transition'
local Player = require 'src.objects.player'
local Raindrop = require 'src.objects.raindrop'
local Camera = require 'src.camera'
local ChunkSpawner = require 'src.chunkSpawner'
local Constants = require 'src.constants'
local Music = require 'src.music'
local Objects = require 'src.objects'
local Rain = require 'src.rain'

local Game = {}

local sprites = {
    background = love.graphics.newImage('res/background_blur.png'),
    foreground = love.graphics.newImage('res/foreground_blur.png'),
}

function Game:init()
    Signal.register('cam_shake', function(shake)
        self.camera:shake(shake)
    end)
    Music.game()
    self.transition = Transition()
end

function Game:enter()
    self.transition:fadeIn()
    self.objects = Objects()
    self.player = Player(self.objects, 180, 120)
    local x, y = self.player:getPosition():unpack()
    self.camera = Camera(x, y, { damping = 12 })
    self.chunkSpawner = ChunkSpawner(self.objects, self.player)

    self.rain = Rain()
    self.timer = Timer.new()
    self.timer:every(1, function()
        self.rain:add(math.random() * Constants.GAME_WIDTH)
        self.rain:add(math.random() * Constants.GAME_WIDTH)
    end)
end

function Game:update(dt)
    self.transition:update(dt)
    local mousePos = self.camera:getPosition() + Vector(love.mouse.getPosition()) / 2 - Camera.HALF_SCREEN
    self.player:setMouse(mousePos)
    self.player:update(dt)
    self.objects:update(dt)

    local px, py = self.player:getPosition():unpack()
    px = px + 100
    self.camera:follow(px, py)

    self.chunkSpawner:update(dt)
    self.camera:update(dt)
    self.rain:update(dt)
    self.timer:update(dt)

    -- for now
    Music.setFade(1 - self.player.bees / 100)
end

function Game:keypressed(key)
    if Constants.DEBUG and key == 'r' then
        Gamestate.switch(Game)
    end
end

function Game:draw()
    local camPos = self.camera:getPosition()
    local camX = -((camPos.x / 4) % 480)
    for x = camX, love.graphics.getWidth(), 480 do
        love.graphics.draw(sprites.background, x, 0)
    end
    camX = -((camPos.x / 2) % 320)
    for x = camX, love.graphics.getWidth(), 320 do
        love.graphics.draw(sprites.foreground, x, Constants.GAME_HEIGHT - 160)
    end
    self.rain:draw()
    self.camera:draw(function()
        self.chunkSpawner:draw()
        self.objects:draw()
        self.player:draw()
    end)
    self.transition:draw()
end

return Game
