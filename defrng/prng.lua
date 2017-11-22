-- Based on http://osmf.sscc.ru/~smp/
-- Some info https://stackoverflow.com/questions/20154991/generating-uniform-random-numbers-in-lua

local function new(seed)
	local A1 = 727595
	local A2 = 798405  -- 5^17=D20*A1+A2
	local D20 = 1048576 -- 2^20
	local D40 = 1099511627776  -- 2^40
	local x1 = 0
	local x2 = seed or 1
	assert(x2 > 0, "Seed must be greater than 0")
	
	local M = {}
	
	--- Returns a new random generator
	M.new = new
	
	--- Sets the seed of the random generator
	function M.seed(seed)
		x2 = seed or 1
		assert(x2 > 0, "Seed must be greater than 0")
	end
	
	--- Returns a pseudo random number between 0 and 1
	function M.sample()
		local u = x2*A2
	    local v = (x1*A2 + x2*A1) % D20
	    v = (v*D20 + u) % D40
	    x1 = math.floor(v/D20)
	    x2 = v - x1*D20
	    
	    return v/D40
	end	

	--- Returns a pseudo random number between -1 and 1
	function M.sample11()
		return (M.sample() - 0.5) * 2
	end
	
	--- Returns a pseudo random number between from and to
	function M.range(from, to)
		local range = to - from
		return M.sample() * range + from
	end
	
	--- Returns a pseudo random integer number between from and to (inclusive)
	function M.range_int(from, to)
		return math.floor(M.range(from, to+1))
	end
	
	--- Returns a pseudo random integer number between 1 and max (inclusive)
	function M.index(max)
		return M.range_int(1, max)
	end
	
	return M
end


return new()