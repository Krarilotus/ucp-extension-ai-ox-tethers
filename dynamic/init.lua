local original_func


local oxTetherParametersPerAI = require("dynamic.parameters").oxTetherParametersPerAI

local game = require("dynamic.game")
local getAITypeForPlayer = game.getAITypeForPlayer
local countOxTethers = game.countOxTethers
local countQuarries = game.countQuarries
local selectQuarryToAddOxTetherFor = game.selectQuarryToAddOxTetherFor
local countLinkedOxTethers = game.countLinkedOxTethers
local getQuarryStockpileID = game.getQuarryStockpileID
local getQuarryStockpileStoneInStock = game.getQuarryStockpileStoneInStock
local findFirstQuarry = game.findFirstQuarry
local findNextQuarry = game.findNextQuarry

local patch = require("dynamic.patch")

local setOxTetherParameter = require("dynamic.parameters").setOxTetherParameter

local logf = require("dynamic.log")

local function newAiRequiresExtraOxTethers(this, playerID)
    local oxTetherParameters = oxTetherParametersPerAI[getAITypeForPlayer(playerID)]

    if oxTetherParameters.logic == "vanilla" then
      logf.log_function(string.format("Executing vanilla logic"))
      return original_func(this, playerID)
    end

    if oxTetherParameters.logic ~= "dynamic" then
        log(WARNING,
            string.format("unimplemented logic: '%s' (player: #%s), using vanilla logic", oxTetherParameters.logic,
                playerID))
        return original_func(this, playerID)
    end

    local quarryCount = countQuarries(playerID)
    local oxtetherCount = countOxTethers(playerID)

    logf.log_function(string.format("Player #%s: quarries = %s ox tethers = %s", playerID, quarryCount, oxtetherCount))

    if quarryCount == 0 then
      logf.log_function(string.format("Player #%s: no ox tethers required as there are no quarries", playerID))
        return 0
    end
    if oxtetherCount >= oxTetherParameters.maxOxTethers then
      logf.log_function(string.format("Player #%s: is over or at the ox tether limit (AIOxTethers_MaxOxTethers = %s)", playerID, oxTetherParameters.maxOxTethers))
        return 0
    end
    local dynMax = (quarryCount * oxTetherParameters.dynamicMaxOxTethers)
    if oxtetherCount >= dynMax then
      logf.log_function(string.format(
            "Player #%s: over or at the dynamic ox tethers limit (AIOxTethers_DynamicMaxOxTethers = %s): %s", playerID, oxTetherParameters.dynamicMaxOxTethers, dynMax))
        return 0
    end

    -- set highest loaded quarry to 0
    selectQuarryToAddOxTetherFor(playerID, 0)

    local lowestOxTetherCountQuarryID = 0
    local lowestOxTetherCount = oxTetherParameters.maxOxTethers

    local highestLoadQuarryID = 0
    local highestLoad = 0

    local quarryID = findFirstQuarry(playerID)

    if quarryID == 0 then
      logf.log_function(string.format(
            "Player #%s: has no quarries", playerID))
        return 0
    end

    while quarryID ~= 0 do
        local quarryStockPileID = getQuarryStockpileID(quarryID)
        local stoneInStock = getQuarryStockpileStoneInStock(quarryStockPileID)

        local linkedTetherCount = countLinkedOxTethers(playerID, quarryID)

        -- Although this part is not required anymore for counting tethers, it is still required to clean up tether linking.
        -- Until we know what that is used for throughout the game, let's keep it.
        game.clearInvalidLinkedOxTethers(quarryID)

        logf.log_function(string.format("Player #%s: Quarry #%s has %s Tethers and %s stone in stock", playerID, quarryID, linkedTetherCount, stoneInStock))

        local overMax = false

        if linkedTetherCount >= oxTetherParameters.maximumOxTethersPerQuarry then
          logf.log_function(string.format(
                "Player #%s: has too many ox tethers %s for quarry %s (AIOxTethers_MaximumOxTethersPerQuarry = %s)", playerID,
                linkedTetherCount, quarryID, oxTetherParameters.maximumOxTethersPerQuarry))
            overMax = true
        end

        if linkedTetherCount < lowestOxTetherCount then
            lowestOxTetherCount = linkedTetherCount
            lowestOxTetherCountQuarryID = quarryID
        end

        local stoneLoad = 0
        if linkedTetherCount > 0 then
            stoneLoad = stoneInStock / linkedTetherCount
        else
            -- divide by 0 is not an issue this way
            -- However, if a quarry is misplaced (ox tether units die or can't reach)
            -- this is counterproductive. Shouldn't it be 0, and let minimal try to handle it?
            stoneLoad = stoneInStock
        end

        if (stoneLoad > highestLoad) and (not overMax) then
            highestLoad = stoneLoad
            highestLoadQuarryID = quarryID
        end

        quarryID = findNextQuarry(playerID, quarryID)
    end

    -- TODO: can this cause an infinite spam on badly designed maps where the AI misplaces quarries?
    if lowestOxTetherCount < oxTetherParameters.minimumOxTethersPerQuarry then
      logf.log_function(string.format(
          "Player #%s: has too few ox tethers %s for quarry #%s (AIOxTethers_MinimumOxTethersPerQuarry = %s)", playerID,
          lowestOxTetherCount, lowestOxTetherCountQuarryID, oxTetherParameters.minimumOxTethersPerQuarry))
      selectQuarryToAddOxTetherFor(playerID, lowestOxTetherCountQuarryID)
      -- TODO: maybe not return here and not break the loop?
      return 1
    end

    logf.log_function(string.format("Player #%s: heaviest loaded quarry #%s has a stone load of %s", playerID, highestLoadQuarryID,
        highestLoad))

    if highestLoad > oxTetherParameters.thresholdStoneLoad then
      logf.log_function(string.format(
            "Player #%s: has a too heavy loaded quarry #%s (AIOxTethers_ThresholdStoneLoad = %s). Let's try build an ox tether!",
            playerID,
            highestLoadQuarryID,
            oxTetherParameters.thresholdStoneLoad
            ))
        selectQuarryToAddOxTetherFor(playerID, highestLoadQuarryID)
        return 1
    end

    logf.log_function(string.format("Player #%s doesn't need another ox tether", playerID))
    return 0
end


return {
    ["newAIRequiresExtraOxTethersFunction"] = newAiRequiresExtraOxTethers,

    ["setOxTetherParameters"] = function(aicType, parameters) -- use 0 for player
        for k, v in pairs(parameters) do
            log(DEBUG, string.format("setting ox tether parameter %s for AI %s to %s", k, aicType, v))
            setOxTetherParameter(aicType, k, v)
        end
    end,
    ["setOxTetherParameter"] = setOxTetherParameter,
    -- ["setOriginalAIRequiresExtraOxTethersFunction"] = function(func)
    --     original_func = func
    -- end,
    ["enableOxTetherDisable"] = patch.enableOxTetherDisable,
    ["enableHook"] = function()
    
      -- 0x004cb3a0
      local hookAddress = core.AOBScan(
        "83 ec 08 55 8b 6c 24 10 56 57 6a 14 55 b9 ? ? ? ? e8 ? ? ? ? 6a 01 6a 04 33 ff 55 b9 ? ? ? ?")

      original_func = core.hookCode(function(this, playerID)
          log(VERBOSE, string.format("aiRequiresExtraOxtethers(%s)", playerID))

          local value =  newAiRequiresExtraOxTethers(this, playerID)

          log(VERBOSE, string.format("aiRequiresExtraOxtethers(%s) => %s", playerID, value))

          return value
      end, hookAddress, 2, 1, 8)
    end,
}
