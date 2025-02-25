
local oxTetherParametersPerAI = {}

local oxTetherParameters = {
    -- whether to disable placing an ox tether whenever quarry is built
    -- 1 means disable
    disableInitialOxTether = 0,
    -- logic to choose
    logic = "vanilla",
    -- total max ox tethers for a player
    maxOxTethers = 100,
    -- total max ox tethers will be quarryCount * value
    dynamicMaxOxTethers = 3,
    -- min ox tethers to build. This does not work, because the AI will place minOxTethers right when it built the first quarry
    --minOxTethers = 10,
    -- min ox tethers per quarry
    minimumOxTethersPerQuarry = 1,
    -- max ox tethers per quarry
    maximumOxTethersPerQuarry = 6,
    -- decision value for building an extra ox tether if a quarry needs it: stoneCount / tetherCount
    -- A full pile is 48 stones.
    thresholdStoneLoad = 20,
}



local function shallowCopy(t)
    local cp = {}
    for k, v in pairs(t) do
        cp[k] = v
    end
    return cp
end

for i = 0, 16, 1 do
    oxTetherParametersPerAI[i] = shallowCopy(oxTetherParameters)
end


local translations = {
    ["AIOxTethers_DisableInitialOxTether"]    = "disableInitialOxTether",
    ["AIOxTethers_Logic"]                     = "logic",
    ["AIOxTethers_MaxOxTethers"]              = "maxOxTethers",
    ["AIOxTethers_DynamicMaxOxTethers"]       = "dynamicMaxOxTethers",
    ["AIOxTethers_MinimumOxTethersPerQuarry"] = "minimumOxTethersPerQuarry",
    ["AIOxTethers_MaximumOxTethersPerQuarry"] = "maximumOxTethersPerQuarry",
    ["AIOxTethers_ThresholdStoneLoad"]        = "thresholdStoneLoad",
}
local function translate(aicType, key)
    if string.find(key, "AIOxTethers_") ~= 1 then
        return key
    end
    local tkey = translations[key]
    if tkey == nil then
        error(string.format("failed to set ox tether parameter (for ai %s), unknown parameter name %s", aicType,
            key))
    end

    return tkey
end

local logics = {
    [0] = "vanilla",
    [1] = "dynamic",
}

local logics_rev = {}
for k, v in pairs(logics) do logics_rev[v] = k end

local function setOxTetherParameter(aicType, parameter, value) -- use 0 for player
    local tparameter = translate(aicType, parameter)
    if tparameter == "logic" then
        if type(value) == "number" then
          oxTetherParametersPerAI[aicType][tparameter] = logics[value] or 0
          return
        elseif type(value) == "string" then
          oxTetherParametersPerAI[aicType][tparameter] = value
          return
        end
    elseif tparameter == "disableInitialOxTether" then
        if type(value) == "boolean" then
            if value then
                oxTetherParametersPerAI[aicType][tparameter] = 1
            else
                oxTetherParametersPerAI[aicType][tparameter] = 0
            end
            return
        end
    end

    if type(value) ~= "number" then
        error(string.format(
            "failed to set ox tether parameter for aic type %s parameter %s value %s, value is of invalid type",
            aicType,
            parameter, tostring(value)))
    end
    oxTetherParametersPerAI[aicType][tparameter] = value
end


return {
  oxTetherParametersPerAI = oxTetherParametersPerAI,
  setOxTetherParameter = setOxTetherParameter,
}