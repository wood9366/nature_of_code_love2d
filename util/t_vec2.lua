lu = require('luaunit')
Vec2 = require('util/vec2')

TestVec2 = {}

function TestVec2:test_new()
  local v = Vec2:new()
  lu.assertEquals(v, {x=0, y=0})
end

function TestVec2:test_new_with_val()
  local v = Vec2:new{x=2, y=3}
  lu.assertEquals(v, {x=2, y=3})

  v = Vec2:new{x=7}
  lu.assertEquals(v, {x=7, y=0})

  v = Vec2:new{y=3}
  lu.assertEquals(v, {x=0, y=3})
end

function TestVec2:test_add()
  local a = Vec2:new{x=3, y=7}
  local b = Vec2:new{x=1, y=20}

  a:add(b)
  lu.assertEquals(a, {x=4, y=27})
end

function TestVec2:test_add_static()
  local a = Vec2:new{x=3, y=7}
  local b = Vec2:new{x=1, y=20}

  local c = Vec2.add(a, b)
  lu.assertEquals(c, {x=4, y=27})
end

os.exit( lu.LuaUnit.run() )
