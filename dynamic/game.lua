local function bindAI()
  local site, reason = core.AOBScanUnique(
    "8D ? ? ? ? ? ? 6A 04 51 B9 ? ? ? ? E8 ? ? ? ? 8B ? ? ? ? ? 6A 00 6A 00")
  assert(site, "AI type array: " .. tostring(reason))
  return core.readInteger(site + 3)
end

local function bindGame(ptrCurrentAIArray)
  local function bind(name, pattern)
    local site, reason = core.AOBScanUnique(pattern)
    assert(site, name .. ": " .. tostring(reason))
    return site
  end

  local ECX = core.readInteger(bind("building manager",
        "83 c0 ff 69 c0 a4 02 00 00 83 7c 08 54 00 57 8d 3c 08 7e 50 6a 01 6a 03 52 b9 ? ? ? ? e8 ? ? ? ? 8b c8 85 c9 7f 1d b9 01 00 00 00") +
    26)


  --[[ AI ox tether logic ]]


  local function getAITypeForPlayer(playerID)
      return core.readInteger(ptrCurrentAIArray + (4 * playerID))
  end


  -- playerID, buildingType, includeBool
  local countBuildings_address = bind("building count",
      "8b 51 08 33 c0 83 fa 01 7e 4f 53 8b 5c 24 08 55 56 8b 74 24 18 57 8b 7c 24 18 81 c1 16 04 00 00 83 c2 ff")

  -- playerID, buildingType
  local findFirst_address = bind("first building",
      "53 56 8b 71 08 b8 01 00 00 00 3b f0 57 7e 3c 8b 7c 24 14 8b 5c 24 10 81 c1 10 04 00 00 8d 49 00")

  -- playerID, buildingType, previous buildingID
  local findNext_address = bind("next building",
      "8b 44 24 0c 53 56 8b 71 08 83 c0 01 3b c6 57 7d 42 8b 7c 24 14 8b 5c 24 10 8b d0 69 d2 2c 03 00 00 8d 8c 0a e4 00 00 00")


  local addrset1 = bind("quarry fields", "8B C5 69 C0 F4 39 00 00 3B F7 8D 80 ? ? ? ? 53 89 44 24 14 89 38 0F 84 BB 00 00 00 "
    .. "90 8B CE 69 C9 2C 03 00 00 0F BF 91 ? ? ? ? 69 D2 2C 03 00 00 8B 82 ? ? ? ? 33 DB 8D 91 ? ? ? ? "
    .. "8D 7B 03 0F BF 0A 85 C9 74 25 69 C9 2C 03 00 00 66 83 B9 ? ? ? ? 04 75 10 0F BF 89 ? ? ? ?")
  local countBuildingsForPlayer = core.exposeCode(countBuildings_address, 4, 1)
  local findFirstBuildingIDForPlayerAndType = core.exposeCode(findFirst_address, 3, 1)
  local findNextBuildingForPlayerAndType = core.exposeCode(findNext_address, 4, 1)
  local highestLoadQuarryID_address = core.readInteger(addrset1 + 12)
  local quarryStockPileID_address = core.readInteger(addrset1 + 41)
  local stoneInStock_address = core.readInteger(addrset1 + 41 + 12)
  local quarryLinkedOxtethersArray_address = core.readInteger(addrset1 + 41 + 12 + 8)
  local otBuildingType_address = core.readInteger(addrset1 + 41 + 12 + 8 + 23)
  local oxtetherLinkedQuarryID_address = core.readInteger(addrset1 + 41 + 12 + 8 + 23 + 10)
  local PLAYER_DATA_STRUCT_SIZE = 0x39f4
  local BUILDING_STRUCT_SIZE = 0x32c

  local function countLinkedOxTethers(playerID, quarryID)
      local oxTetherID = findFirstBuildingIDForPlayerAndType(ECX, playerID, 0x04)

      if oxTetherID == 0 then
          return 0
      end

      local count = 0

      while oxTetherID ~= 0 do
          local oxtetherLinkedQuarryID = core.readSmallInteger(oxtetherLinkedQuarryID_address + (BUILDING_STRUCT_SIZE * oxTetherID))
          if oxtetherLinkedQuarryID == quarryID then
              count = count + 1
          end

          oxTetherID = findNextBuildingForPlayerAndType(ECX, playerID, 0x04, oxTetherID)
      end

      return count
  end

  local function selectQuarryToAddOxTetherFor(playerID, quarryID)
      core.writeInteger(highestLoadQuarryID_address + (PLAYER_DATA_STRUCT_SIZE * playerID), quarryID)
  end

  local function countQuarries(playerID)
    return countBuildingsForPlayer(ECX, playerID, 0x14, 0)
  end

  local function countOxTethers(playerID)
    return countBuildingsForPlayer(ECX, playerID, 0x4, 0)
  end

  return {
    ptrCurrentAIArray = ptrCurrentAIArray,
    getAITypeForPlayer = getAITypeForPlayer,
    countBuildingsForPlayer = countBuildingsForPlayer,
    countLinkedOxTethers = countLinkedOxTethers,
    selectQuarryToAddOxTetherFor = selectQuarryToAddOxTetherFor,
    findFirstBuildingIDForPlayerAndType = function(...)
      return findFirstBuildingIDForPlayerAndType(ECX, ...)
    end,
    findNextBuildingForPlayerAndType = function(...)
      return findNextBuildingForPlayerAndType(ECX, ...)
    end,
    findFirstQuarry = function(playerID)
      return findFirstBuildingIDForPlayerAndType(ECX, playerID, 0x14)
    end,
    findNextQuarry = function(playerID, quarryID)
      return findNextBuildingForPlayerAndType(ECX, playerID, 0x14, quarryID)
    end,
    countOxTethers = countOxTethers,
    countQuarries = countQuarries,
    getQuarryStockpileID = function(quarryID)
      return core.readSmallInteger(quarryStockPileID_address + (BUILDING_STRUCT_SIZE * quarryID))
    end,
    getQuarryStockpileStoneInStock = function(quarryStockpileID)
      return core.readInteger(stoneInStock_address + (BUILDING_STRUCT_SIZE * quarryStockpileID))
    end,
    getLinkedOxTetherID = function(quarryID, arrayIndex)
      local quarryLinkedOxtethersArray = quarryLinkedOxtethersArray_address + (BUILDING_STRUCT_SIZE * quarryID)
      return core.readSmallInteger(quarryLinkedOxtethersArray + (2 * arrayIndex))
    end,
    clearInvalidLinkedOxTethers = function(quarryID)
      local quarryLinkedOxtethersArray = quarryLinkedOxtethersArray_address + (BUILDING_STRUCT_SIZE * quarryID)
      for i = 0, 2, 1 do
          local oxTetherID = core.readSmallInteger(quarryLinkedOxtethersArray + (2 * i))
          if oxTetherID ~= 0 then
              local otBuildingType = core.readSmallInteger(otBuildingType_address + (BUILDING_STRUCT_SIZE * oxTetherID))
              local oxtetherLinkedQuarryID = core.readSmallInteger(oxtetherLinkedQuarryID_address +
                  (BUILDING_STRUCT_SIZE * oxTetherID))

              if otBuildingType == 0x4 and oxtetherLinkedQuarryID == quarryID then
                  -- valid
              else
                  -- invalid
                  core.writeSmallInteger(quarryLinkedOxtethersArray + (2 * i), 0)
              end
          end
      end
    end,
  }end

return {bindAI = bindAI, bindGame = bindGame}
