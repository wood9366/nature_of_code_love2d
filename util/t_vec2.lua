lu = require('luaunit')
Vec2 = require('util/vec2')

TestVec2 = {}

function TestVec2:test_new()
  local t = Vec2:new()
  lu.assertEquals(t, {x=0, y=0})

  local a = Vec2:new{x=2, y=3}
  lu.assertEquals(a, {x=2, y=3})

  local b = Vec2:new{x=7}
  lu.assertEquals(b, {x=7, y=0})

  local c = Vec2:new{y=3}
  lu.assertEquals(c, {x=0, y=3})

  local d = Vec2:new(c)
  lu.assertEquals(d, {x=0, y=3})
  lu.assertTrue(c ~= d)
end

function TestVec2:test_add()
  local a = Vec2:new{x=3, y=7}
  local b = Vec2:new{x=1, y=20}

  lu.assertEquals(Vec2.Add(a, b), {x=4, y=27})

  a:add(b)
  lu.assertEquals(a, {x=4, y=27})
end

function TestVec2:test_sub()
  local a = Vec2:new{x=20,y=5}
  local b = Vec2:new{x=3,y=22}

  lu.assertEquals(Vec2.Sub(a, b), {x=17,y=-17})

  a:sub(b)
  lu.assertEquals(a, {x=17,y=-17})
end

function TestVec2:test_mul()
  local a = Vec2:new{x=20,y=5}

  lu.assertEquals(Vec2.Mul(a, 3), {x=60,y=15})

  a:mul(3)
  lu.assertEquals(a, {x=60,y=15})
end

function TestVec2:test_mag()
  local a = Vec2:new{x=20,y=5}

  lu.assertEquals(a:mag(), math.sqrt(a.x * a.x + a.y * a.y))
end

function TestVec2:test_norm()
  local a = Vec2:new{x=20,y=5}

  local mag = math.sqrt(a.x * a.x + a.y * a.y)
  local ret = {x=a.x/mag, y=a.y/mag}

  lu.assertEquals(Vec2.Norm(a), ret)
  lu.assertEquals(Vec2.Norm(a):mag(), 1)

  a:norm()
  lu.assertEquals(a, ret)
  lu.assertEquals(a:mag(), 1);

  local b = Vec2:new{x=0,y=0}
  b:norm()
  lu.assertEquals(b, {x=0, y=0})
end

function TestVec2:test_dot()
  local a = Vec2:new{x=1,y=0}
  local b = Vec2:new{x=math.cos(math.pi / 3),y=math.sin(math.pi / 3)}

  local ret = a:mag() * b:mag() * math.cos(math.pi / 3)

  lu.assertEquals(Vec2.Dot(a, b), ret)
  lu.assertEquals(a:dot(b), ret)
end

function TestVec2:test_cross()
  local a = Vec2:new{x=1,y=0}
  local b = Vec2:new{x=math.cos(math.pi / 6),y=math.sin(math.pi / 6)}

  local ret = a:mag() * b:mag() * math.sin(math.pi / 6)

  lu.assertAlmostEquals(Vec2.Cross(a, b), ret)
  lu.assertAlmostEquals(Vec2.Cross(b, a), -ret)

  lu.assertAlmostEquals(a:cross(b), ret)
  lu.assertAlmostEquals(b:cross(a), -ret)
end

function TestVec2:test_distance()
  local a = Vec2:new{x=1, y=0}
  local b = Vec2:new{x=5, y=0}

  lu.assertEquals(Vec2.Distance(a, b), 4)
end

os.exit( lu.LuaUnit.run() )
