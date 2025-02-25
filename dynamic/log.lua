
local ns = {}

function ns.setLogFunction(func)
  ns.log_function = func or function(v) end 
end

ns.log_function = function(v) error(debug.traceback(v)) end

return ns