volt.Signal = volt.Class:derive("Signal")

function volt.Signal:new()
	self._connections = {}
	self._onceConnections = {}
	self._parallelConnections = {}
	self._onceParallelConnections = {}
	self._waitingThreads = {}
	return self
end

-- Internal: Creates a connection wrapper
local function createConnection(callback, list)
	local conn = {
		callback = callback,
		active = true,
	}

	function conn:disconnect()
		if not self.active then
			return
		end
		self.active = false
		for i = #list, 1, -1 do
			if list[i] == self then
				table.remove(list, i)
				break
			end
		end
	end

	table.insert(list, conn)
	return conn
end

-- Normal persistent connection
function volt.Signal:connect(callback)
	return createConnection(callback, self._connections)
end

-- Fires only once
function volt.Signal:connectOnce(callback)
	return createConnection(callback, self._onceConnections)
end

-- Parallel connection (runs in coroutine)
function volt.Signal:connectParallel(callback)
	return createConnection(callback, self._parallelConnections)
end

-- Parallel connection (fires once, in coroutine)
function volt.Signal:connectOnceParallel(callback)
	return createConnection(callback, self._onceParallelConnections)
end

-- Coroutine-based wait
function volt.Signal:wait()
	local co = coroutine.running()
	assert(co, ":wait() must be called from inside a coroutine")
	table.insert(self._waitingThreads, co)
	return coroutine.yield()
end

-- Fire all listeners
function volt.Signal:fire(...)
	local args = { ... }

	-- Normal connections
	for _, conn in ipairs(self._connections) do
		if conn.active then
			conn.callback(unpack(args))
		end
	end

	-- Once-only
	for _, conn in ipairs(self._onceConnections) do
		if conn.active then
			conn.callback(unpack(args))
		end
	end
	self._onceConnections = {}

	-- Parallel connections (coroutines)
	for _, conn in ipairs(self._parallelConnections) do
		if conn.active then
			coroutine.wrap(function()
				conn.callback(unpack(args))
			end)()
		end
	end

	-- Once-only parallel connections
	for _, conn in ipairs(self._onceParallelConnections) do
		if conn.active then
			coroutine.wrap(function()
				conn.callback(unpack(args))
			end)()
		end
	end
	self._onceParallelConnections = {}

	-- Resume any threads waiting for signal
	for _, thread in ipairs(self._waitingThreads) do
		coroutine.resume(thread, table.unpack(args))
	end
	self._waitingThreads = {}
end

-- Disconnect all
function volt.Signal:disconnectAll()
	self._connections = {}
	self._onceConnections = {}
	self._parallelConnections = {}
	self._onceParallelConnections = {}
	self._waitingThreads = {}
end
