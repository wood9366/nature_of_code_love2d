local Vec2 = require "util/vec2"

-- Mover
local Mover = {}
Mover.__index = Mover

function Mover:new(o)
  local o = o or {}
  o.mass = o.mass or 1
  o.pos = o.pos or Vec2:new()
  o.velocity = o.velocity or Vec2:new()
  o.acc = o.acc or Vec2:new()
  o.force = o.force or Vec2:new()
  setmetatable(o, self)
  return o
end

function Mover:add_force(force)
  self.force:add(force)
end

function Mover:update(dt)
  if self.mass > 0 then
    self.acc:set(Vec2.Mul(self.force, 1 / self.mass))
  else
    self.acc:set(self.force)
  end

  self.velocity:add(Vec2.Mul(self.acc, dt))
  self.pos:add(Vec2.Mul(self.velocity, dt))

  self.force:set_xy(0, 0)
end

function Mover:radius()
  return self.mass * 10
end

function Mover:draw()
  love.graphics.circle("line", self.pos.x, self.pos.y, self:radius())
end

-- Ground
local Ground = {}
Ground.__index = Ground

function Ground:new(o)
  local o = o or {}
  local width, height, _ = love.window.getMode()
  o.y = o.y or (height * 3 / 4)
  setmetatable(o, self)
  return o
end

function Ground:draw()
  local width, height, _ = love.window.getMode()
  love.graphics.line(0, self.y, width, self.y)
end

-- Wind
local Wind = {}
Wind.__index = Wind

function Wind:new()
  local o = o or {}
  o.level = o.level or 0
  o.force = Vec2:new()
  setmetatable(o, self)
  return o
end

function Wind:set_level(lv)
  self.level = lv
  self.force.x = self.level
end

function Wind:get_level()
  return self.level
end

function Wind:get_force()
  return self.force
end

-- Main
local movers = {}
local ground = Ground:new()
local wind = Wind:new()

function love.load()
  love.window.setTitle("Nature of Code - Force")
  love.window.setMode(1000, 600)
  love.keyboard.setKeyRepeat(true)

  width, height, _ = love.window.getMode()

  for i=1,5 do
    add_mover(love.math.random(width * 0.1, width * 0.9),
              love.math.random(height * 0.1, height * 0.3))
  end
end

function add_mover(x, y)
  local mover = Mover:new()
  mover.pos:set_xy(x, y)
  movers[#movers + 1] = mover
end

function love.mousepressed(x, y, button)
  if button == 1 then
    add_mover(x, y)
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == 'left' then
    wind:set_level(wind:get_level() - 1)
  elseif key == 'right' then
    wind:set_level(wind:get_level() + 1)
  end
end

local g = Vec2:new{x=0,y=50}

function love.update(dt)
  for _, mover in ipairs(movers) do
    mover:add_force(Vec2.Mul(g, mover.mass))
    mover:add_force(wind:get_force())
    mover:update(dt)

    if mover.pos.y >= ground.y - mover:radius() then
      mover.pos.y = ground.y - mover:radius()
      mover.velocity.y = -mover.velocity.y * 0.9
    end

    width, height, _ = love.window.getMode()

    if mover.pos.x >= width - mover:radius() then
      mover.pos.x = width - mover:radius()
      mover.velocity.x = -mover.velocity.x
    elseif mover.pos.x <= mover:radius() then
      mover.pos.x = mover:radius()
      mover.velocity.x = -mover.velocity.x
    end
  end
end

local function get_cur_time()
  local sec = math.floor(love.timer.getTime())
  local min = math.floor(sec / 60)
  sec = sec - min * 60
  local hour = math.floor(min / 60)
  min = min - hour * 60

  return hour, min, sec
end

function love.draw()
  love.graphics.print(string.format("time: %02d:%02d:%02d", get_cur_time()), 10, 10)
  love.graphics.print(string.format("ground: y: %.2f", ground.y), 10, 30)
  love.graphics.print(string.format("wind: level: %.2f, force: %.2f, %2.f",
                                    wind:get_level(), wind:get_force().x, wind:get_force().y),
                      10, 50)

  ground:draw()
  for _, mover in ipairs(movers) do
    mover:draw()
  end
end
