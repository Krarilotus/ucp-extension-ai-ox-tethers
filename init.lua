local aiRequiresOxTethers = require("dynamic")
local registerAICValues = require("dynamic.aic").registerAICValues
local logf = require("dynamic.log")

return {
    enable = function(self, config)
        local settings = config.oxtethers
        if settings == nil then return end
        if type(settings) ~= "table" then
            log(ERROR, "AI Ox Tethers settings must be a table.")
            return
        end
        if settings.enabled ~= true then
            if settings.enabled ~= nil and type(settings.enabled) ~= "boolean" then
                log(ERROR, "AI Ox Tethers enabled setting must be a boolean.")
            end
            return
        end

        local useAIC = settings.mode == "use_aic"
        if settings.mode ~= "override_aic" and not useAIC then
            log(type(settings.mode) == "string" and WARNING or ERROR,
                "Invalid AI Ox Tethers mode; using launcher settings.")
        end
        local logic = settings.logic
        if type(logic) ~= "table" or type(logic.dynamic) ~= "boolean" then
            log(ERROR, "AI Ox Tethers dynamic setting must be a boolean; using game logic.")
        end
        local dynamic = type(logic) == "table" and logic.dynamic == true
        local parameters = settings.parameters
        if type(parameters) ~= "table" then
            log(ERROR, "AI Ox Tethers parameters must be a table; using defaults.")
            parameters = {}
        end
        local initial = parameters.disableInitialOxTether
        if initial ~= nil and type(initial) ~= "boolean" then
            log(ERROR, "AI Ox Tethers initial placement setting must be a boolean; using game logic.")
            initial = false
        end

        local logging = settings.log
        if logging ~= nil and type(logging) ~= "table" then
            log(ERROR, "AI Ox Tethers log settings must be a table; logging is off.")
            logging = nil
        elseif logging and logging.enabled ~= nil and type(logging.enabled) ~= "boolean" then
            log(ERROR, "AI Ox Tethers log enabled setting must be a boolean; logging is off.")
        end
        if logging and logging.enabled == true then
            local level = logging.sliderValue
            if type(level) ~= "number" then
                log(ERROR, "AI Ox Tethers log level must be a number; using the default level.")
                level = 2
            elseif not math.tointeger(level) or level < -2 or level > 10 then
                log(WARNING, "Invalid AI Ox Tethers log level; using the default level.")
                level = 2
            end
            logf.setLogFunction(function(message) log(level, message) end)
        else
            logf.setLogFunction(nil)
        end

        for key, value in pairs(parameters) do
            if key ~= "disableInitialOxTether" then
                for ai = 0, 16 do
                    aiRequiresOxTethers.setOxTetherParameter(ai, key, value, ai == 0)
                end
            end
        end
        for ai = 0, 16 do
            aiRequiresOxTethers.setOxTetherParameter(ai, "logic", dynamic and "dynamic" or "vanilla")
            aiRequiresOxTethers.setOxTetherParameter(ai, "disableInitialOxTether", initial == true)
        end

        local wantsDynamic, wantsInitial = dynamic or useAIC, initial or useAIC
        if not wantsDynamic and not wantsInitial then return end

        local bound, aiArray = pcall(aiRequiresOxTethers.bindAI)
        local function install(name, fn)
            local ok, reason = bound, aiArray
            if bound then ok, reason = pcall(fn, aiArray) end
            if not ok then log(ERROR, "AI Ox Tethers " .. name .. " is off: " .. tostring(reason)) end
            return ok
        end
        local dynamicReady = wantsDynamic and install("dynamic placement", aiRequiresOxTethers.enableHook)
        local initialReady = wantsInitial and install("initial placement override", aiRequiresOxTethers.enableOxTetherDisable)
        if useAIC then registerAICValues(dynamicReady, initialReady) end
    end,

    disable = function(self)

    end,

}
