
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
local function getAICValue(aiType, field)
    local key = translations[field]
    local value = oxTetherParametersPerAI[aiType][key]
    if key == "logic" then return value == "dynamic" and 1 or 0 end
    return value
end

local function setOxTetherParameter(aiType, parameter, value, report)
    local key = translations[parameter] or parameter
    local default = oxTetherParameters[key]
    local severity
    if key == "logic" then
        if value == 0 or value == "vanilla" then value = "vanilla"
        elseif value == 1 or value == "dynamic" then value = "dynamic"
        else severity = (type(value) == "number" or type(value) == "string") and WARNING or ERROR end
    elseif key == "disableInitialOxTether" then
        if type(value) == "boolean" then value = value and 1 or 0
        elseif type(value) ~= "number" then severity = ERROR
        elseif value ~= 0 and value ~= 1 then severity = WARNING end
    elseif default == nil then
        severity = WARNING
    elseif type(value) ~= "number" then
        severity = ERROR
    else
        local minimum = key == "thresholdStoneLoad" and 1 or 0
        local maximum = key == "thresholdStoneLoad" and 48 or 2000
        if not math.tointeger(value) or value < minimum or value > maximum then severity = WARNING end
    end
    if severity then
        if report ~= false then
            log(severity, "Invalid AI Ox Tethers " .. tostring(parameter) .. "; using the default.")
        end
        value = default
    end
    if default ~= nil then oxTetherParametersPerAI[aiType][key] = value end
end

return {
  oxTetherParametersPerAI = oxTetherParametersPerAI,
  setOxTetherParameter = setOxTetherParameter,
  getAICValue = getAICValue,
}