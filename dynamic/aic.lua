local aiRequiresOxTethers = require("dynamic")

local AICDefaults = {
    -- 0 means vanilla (place ox tether every time quarry is built)
    -- 1 means disable this behavior
    ["AIOxTethers_DisableInitialOxTether"]    = 0,
    -- 0 means vanilla
    -- 1 means dynamic
    ["AIOxTethers_Logic"]                     = 0,
    -- total max ox tethers for this player
    ["AIOxTethers_MaxOxTethers"]              = 100,
    -- total max ox tethers will be quarryCount * value
    ["AIOxTethers_DynamicMaxOxTethers"]       = 3,
    -- min ox tethers per quarry
    ["AIOxTethers_MinimumOxTethersPerQuarry"] = 1,
    -- max ox tethers per quarry, value 3 imitates vanilla
    ["AIOxTethers_MaximumOxTethersPerQuarry"] = 3,
    -- decision value (threshold) for when a quarry needs an extra ox tether: stoneCount / tetherCount > threshold
    -- A full pile is 48 stones.
    -- value 20 imitates vanilla
    ["AIOxTethers_ThresholdStoneLoad"]        = 20,
}

local registerAICValues = function()
    for k, v in pairs(AICDefaults) do
        modules.aicloader:setAdditionalAICValue(
            k,
            -- set
            function(aiType, aicValue)
                if type(aicValue) ~= "number" then
                    log(WARNING,
                        string.format("Cannot set AIC '%s', invalid value: %s", k,
                            tostring(aicValue)))
                else
                    log(VERBOSE,
                        string.format("Setting %s for ai #%s to value '%s'", k, aiType,
                            tostring(aicValue)))
                    aiRequiresOxTethers.setOxTetherParameter(aiType, k, aicValue)
                end
            end,
            -- reset
            function(aiType)
                log(VERBOSE,
                    string.format("Resetting %s for ai #%s to value '%s'", k, aiType,
                        tostring(v)))
                aiRequiresOxTethers.setOxTetherParameter(aiType, k, v)
            end
        )
    end
end

return {
  registerAICValues = registerAICValues,
}