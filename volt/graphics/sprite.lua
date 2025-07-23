local Animation = volt.class:derive("animation")
function Animation:new(f, t, r, s)
	self.img = s.img
	self.currentFrame = 1
	self.yO = s.yO + (s.h * (r - 1))
	self.sXO = s.xO + (s.w * (f - 1))
	self.fA = 1 + t - f
	self.w = s.w
	self.h = s.h
	self.quad = love.graphics.newQuad(self.sXO, self.yO, self.w, self.h, self.img:getDimensions())
	return self
end

function Animation:update(dt, delay)
	self.currentFrame = self.currentFrame or 1
	self.timer = (self.timer or 0) + love.timer.getDelta()
	if self.timer >= delay then
		self.currentFrame = self.currentFrame + 1
		if self.currentFrame > self.fA then
			self.currentFrame = 1
		end
		self.timer = self.timer - delay
	end
	local currentOffset = self.sXO * self.currentFrame
	self.quad:setViewport(currentOffset, self.yO, self.w, self.h, self.img:getDimensions())
end

function Animation:play(x, y, r, sX, sY, oX, oY)
	love.graphics.draw(self.img, self.quad, x, y, r, sX, sY, oX, oY)
end

local Sprite = volt.class:derive("Sprite")

function Sprite:new(anim, img, xo, yo, w, h)
	self.animated = anim
	self.img = img
	self.xO = xo
	self.yO = yo
	self.w = w
	self.h = h
	return self
end

function Sprite:newAnimation(frames, row)
	local f, t = frames:match("^(%d+)%-(%d+)$")
	f = tonumber(f)
	t = tonumber(t)
	return Animation:new(f, t, row, self)
end

function volt.graphics.newAnimatedSprite(imgPath, xO, yO, width, height)
	local img = love.graphics.newImage(imgPath)
	local s = Sprite:new(true, img, xO, yO, width, height)
	return s
end
