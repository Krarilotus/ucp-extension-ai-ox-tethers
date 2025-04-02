
local ns = {}

function ns.setLogFunction(func)
  ns.log_function = func or function(message) end 
end

ns.log_function = function(message) error(debug.traceback(message)) end

return ns