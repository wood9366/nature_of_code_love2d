
local Vec2 = {}
Vec2.__index = Vec2

function Vec2.Add(a, b)
  return Vec2:new(a).add(b)
end

function Vec2.Sub(a, b)
  return Vec2:new(a).sub(b)
end

function Vec2.Mul(v, f)
  return Vec2:new(v).mul(f)
end

function Vec2.Dot(a, b)
  return Vec2:new(a).dot(b)
end

function Vec2.Norm(v)
  return Vec2:new(v).norm()
end

function Vec2.Distance(a, b)
  return Vec2:new(a).sub(b).mag()
end

function Vec2:new(o)
  local o = o or { x = 0, y = 0 }
  o.x = o.x or 0
  o.y = o.y or 0
  setmetatable(o, self)
  return o
end

function Vec2:add(v)
  self.x = self.x + v.x
  self.y = self.y + v.y
  return self
end

function Vec2:sub(v)
  self.x = self.x - v.x
  self.y = self.y - v.y
  return self
end

function Vec2:mul(f)
  self.x = self.x * f
  self.y = self.y * f
  return self
end

function Vec2:div(f)
  if f > 0 then
    self.x = self.x / f
    self.y = self.y / f
  end
  return self
end

function Vec2:mag()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vec2:norm()
  return self.div(self.mag())
end

function Vec2:dot(v)
  return self.x * v.x + self.y * v.y
end

return Vec2
