--- STEAMODDED HEADER
--- MOD_NAME: FPS Limiter
--- MOD_ID: fpslimiter
--- MOD_AUTHOR: [YourName]
--- MOD_DESCRIPTION: Limits the FPS to 60 for smoother gameplay and reduced resource usage.
--- DISPLAY_NAME: FPS Limiter
--- BADGE_COLOUR: 00FF00

local target_fps = 120 -- Target FPS limit
local frame_time = 1 / target_fps

-- Hook into the main Love2D functions to enforce FPS limiting
local oldUpdate = love.update
local oldGraphicsPresent = love.graphics.present
local lastFrameTime = love.timer.getTime()

function love.update(dt)
    if oldUpdate then oldUpdate(dt) end
    -- Enforce a sleep to maintain the target frame rate
    local currentTime = love.timer.getTime()
    local timeToWait = frame_time - (currentTime - lastFrameTime)
    if timeToWait > 0 then
        love.timer.sleep(timeToWait)
    end
    lastFrameTime = love.timer.getTime()
end

-- Ensure the graphics frame is presented after enforcing FPS limits
function love.graphics.present()
    if oldGraphicsPresent then oldGraphicsPresent() end
    lastFrameTime = love.timer.getTime()
end
