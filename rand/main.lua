local n = 100
local rands = {}

function love.load()
  love.window.setTitle("Nature of Code - Rand")
  love.window.setMode(1000, 600)

  for i=1,n do
    rands[i] = 0
  end
end

function love.update()
  for i=1,10 do
    local r = love.math.random(1, n)
    rands[r] = rands[r] + 1
  end
end

function love.draw()
  local sw, sh, _ = love.window.getMode()
  local w = sw / n
  for i=1,n do
    love.graphics.rectangle("fill", (i - 1) * w, sh - rands[i], w, rands[i])
  end
end
