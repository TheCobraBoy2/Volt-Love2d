volt.Vector2 = volt.Class:derive("Vector2")

---Create a new vector2
---@param x number|nil
---@param y number|nil
function volt.Vector2:new(x, y)
	self.x = x or 0
	self.y = y or 0
end

-- // TODO More vector2 methods
