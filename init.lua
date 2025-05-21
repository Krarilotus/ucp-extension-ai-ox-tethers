local aiRequiresOxTethers = require("dynamic")
local registerAICValues = require("dynamic.aic").registerAICValues
local logf = require("dynamic.log")

return {
    enable = function(self, config)
        --- Check if enabled at all
        local enabled = config.oxtethers.enabled
        if enabled ~= true then
            log(INFO, "Extension is not enabled. Exiting...")
            return
        end

        --- Set the log function depending on the configured log level
        local logging = config.oxtethers.log.enabled
        local loglevel = config.oxtethers.log.sliderValue

        -- By default there is no logging
        if logging then
          logf.setLogFunction(function(message)
            log(loglevel, message)
          end)
        else
          logf.setLogFunction(nil)
        end
 
        if config.oxtethers.logic.dynamic == true then
          config.oxtethers.parameters.logic = "dynamic"
        else
          config.oxtethers.parameters.logic = "vanilla"
        end

        --[[
          Set up the vanilla function hook
        --]]
        aiRequiresOxTethers.enableHook()

        if config.oxtethers.mode == "use_aic" then
            registerAICValues()
        end

        --- Enable ability to set initial ox tether per AI
        local status, err = pcall(aiRequiresOxTethers.enableOxTetherDisable)
        if status == false then
            log(ERROR,
                string.format(
                    "Disabling feature to disable ox tethers could not be enabled (is there a conflict with same feature from ucp2-legacy?)\n%s",
                    tostring(err)))
            error(
                "Disabling feature to disable ox tethers could not be enabled (is there a conflict with same feature from ucp2-legacy?)")
        end

        log(DEBUG, string.format("parameters are as follows:\n%s", yaml.dump(config.oxtethers.parameters)))

        --- Set the initial parameters from the config
        for k, v in pairs(config.oxtethers.parameters) do
            for i = 0, 16, 1 do
                aiRequiresOxTethers.setOxTetherParameter(i, k, v)
            end
        end
    end,

    disable = function(self)

    end,

}
