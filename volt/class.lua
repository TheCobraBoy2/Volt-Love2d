volt.Class = {}
volt.Class.__index = volt.Class

-- Default Implementation
function volt.Class:new() end

-- Create a new class type from base class
function volt.Class:derive(type)
	local class = {}
	class["__call"] = volt.Class._call
	class.type = type
	class.super = self
	class.__index = class
	setmetatable(class, self)
	return class
end

function volt.Class:__call(...)
	local inst = setmetatable({}, self)
	---@diagnostic disable-next-line: redundant-parameter
	inst:new(...)
	return inst
end

function volt.Class:getType()
	return self.type
end
