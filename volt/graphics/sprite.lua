local Animation = volt.Class:derive("animation")
function Animation:new(f, t, r, s)
	self.img = s.img
	self.currentFrame = 1
	self.frame_count = 1 + t - f
	self.size = volt.Vector2(s.w, s.h)
	self.offset = volt.Vector2(s.xO + (s.w * (f - 1)), s.yO + (s.h * (r - 1)))
	self.margin = volt.Vector2(s.xO)
	self.quad = love.graphics.newQuad(self.offset.x, self.offset.y, self.size.x, self.size.y, self.img:getDimensions())
	return self
end

function Animation:update(dt, delay)
	if dt > 0.035 then
		return
	end
	self.currentFrame = self.currentFrame or 1
	self.timer = (self.timer or 0) + love.timer.getDelta()
	if self.timer >= delay then
		self.currentFrame = self.currentFrame + 1
		if self.currentFrame > self.frame_count then
			self.currentFrame = 1
		end
		self.timer = self.timer - delay
	end
	local frameX = self.offset.x * self.currentFrame
	self.quad:setViewport(frameX, self.offset.y, self.size.x, self.size.y, self.img:getDimensions())
end

function Animation:play(x, y, r, sX, sY, oX, oY)
	love.graphics.draw(self.img, self.quad, x, y, r, sX, sY, oX, oY)
end

function Animation:freeze(frame, x, y, r, sX, sY, oX, oY)
	self.quad:setViewport(self.margin.x + (self.offset.x * frame), self.size.x, self.size.y, self.img:getDimensions())
	self:play(x, y, r, sX, sY, oX, oY)
end

local Sprite = volt.Class:derive("Sprite")

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
