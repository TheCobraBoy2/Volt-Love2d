volt.class = {}
volt.class.__index = volt.class

-- Default Implementation
function volt.class:new() end

-- Create a new class type from base class
function volt.class:derive(type)
	local class = {}
	class.type = type
	class.super = self
	class.__index = class
	setmetatable(class, self)
	return class
end

function volt.class:__call(...)
	local inst = setmetatable({}, self)
	---@diagnostic disable-next-line: redundant-parameter
	inst:new(...)
	return inst
end

function volt.class:getType()
	return self.type
end
