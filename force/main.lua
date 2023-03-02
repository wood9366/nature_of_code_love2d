local Vec2 = require "util/vec2"

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

local movers = {}
local ground = Ground:new()

function love.load()
  love.window.setTitle("Nature of Code - Force")
  love.window.setMode(1000, 600)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    local mover = Mover:new()
    mover.pos:set_xy(x, y)
    movers[#movers + 1] = mover
  end
end

local g = Vec2:new{x=0,y=50}

function love.update(dt)
  for _, mover in ipairs(movers) do
    mover:add_force(Vec2.Mul(g, mover.mass))
    mover:update(dt)

    if mover.pos.y >= ground.y - mover:radius() then
      mover.pos.y = ground.y - mover:radius()
      mover.velocity.y = -mover.velocity.y * 0.9
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

  ground:draw()
  for _, mover in ipairs(movers) do
    mover:draw()
  end
end
