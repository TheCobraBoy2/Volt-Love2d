local test = {}
local path, anim, animSprite
local animations, fps, currentAnim, fspeed
function test.load()
	require("volt")
	volt.load()

	love.graphics.setDefaultFilter("nearest", "nearest")
	path = "tests/assets/gfx/hero.png"

	animSprite = volt.graphics.newAnimatedSprite(path, 16, 16, 16, 16)
	animations = {}
	animations.idle = animSprite:newAnimation("1-4", 1)
	animations.walk = animSprite:newAnimation("1-6", 2)
	fps = 10
	fspeed = 1 / fps
	currentAnim = animations.walk
end

function test.update(dt)
	currentAnim:update(dt, fspeed)
end

function test.draw()
	currentAnim:play(32, 32, 0, 4, 4, 8, 8)
end
return test
