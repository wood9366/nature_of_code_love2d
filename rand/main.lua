local Mode = { normal = 1, gaussian = 2 }

local n = 100
local rands = {}
local mode = Mode.normal
local gaussian_width = 1

function love.load()
  love.window.setTitle("Nature of Code - Rand")
  love.window.setMode(1000, 600)

  reset()
end

function reset()
  for i=1,n do
    rands[i] = 0
  end
end

function love.keypressed(key, isrepeat)
  if key == "x" then
    if mode == Mode.normal then
      mode = Mode.gaussian
    elseif mode == Mode.gaussian then
      mode = Mode.normal
    end

    reset()
  elseif key == "q" then
    love.event.quit(0)
  end

  if mode == Mode.gaussian then
    if key == "left" and gaussian_width > 1 then
      gaussian_width = gaussian_width - 1
    end
    if key == "right" and gaussian_width < 5 then
      gaussian_width = gaussian_width + 1
    end

    reset()
  end
end

function love.update()
  for i=1,10 do
    local r = 0

    if mode == Mode.normal then
      r = love.math.random(1, n)
    elseif mode == Mode.gaussian then
      r = love.math.randomNormal()
      r = (r - -gaussian_width) / (2 * gaussian_width)
      r = 1 + math.floor(r * n)
    end

    if r >= 1 and r <= n then
      rands[r] = rands[r] + 1
    end
  end
end

function love.draw()
  local mode_name = "none"
  if mode == Mode.normal then
    mode_name = "normal"
  elseif mode == Mode.gaussian then
    mode_name = "gaussian"
  end
  love.graphics.print(string.format("mode: %s", mode_name), 10, 10)

  if mode == Mode.gaussian then
    love.graphics.print(string.format("gaussian width: %d", gaussian_width), 10, 30)
  end

  local sw, sh, _ = love.window.getMode()
  local w = sw / n
  for i=1,n do
    love.graphics.rectangle("fill", (i - 1) * w, sh - rands[i], w, rands[i])
  end
end
