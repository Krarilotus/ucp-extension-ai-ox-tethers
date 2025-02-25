local game = require("dynamic.game")
local ptrCurrentAIArray = game.ptrCurrentAIArray
local oxTetherParametersPerAI = require("dynamic.parameters").oxTetherParametersPerAI
local logf = require("dynamic.log")

--[[ AI disable ox tether ]]
local function enableOxTetherDisable()
  -- EBP contains playerID
  local detourLoc1 = core.AOBScan("83 ? ? ? ? ? ? 0F ? ? ? ? ? 8B 86 54 45 0B 00")
  local detourSize1 = 7
  local skipBuildingLoc = core.AOBScan("8B 4C 24 10 A1 ? ? ? ?") + 37

  local yoinkAddr = core.allocateCode({ 0x90, 0x90, 0x90, 0x90, 0x90, 0xC3 })
  core.detourCode(function(registers)
      if registers.EAX >= 0 and registers.EAX <= 16 then
          local value = oxTetherParametersPerAI[registers.EAX]["disableInitialOxTether"] or 0
          logf.log_function(string.format("disableInitialOxTether: for aic %s: %s", registers.EAX + 1, value))
          registers.EAX = value
      else
          log(WARNING, string.format("error in getDisable: invalid aic type: %s", registers.EAX))
      end
  end, yoinkAddr, 5)

  core.insertCode(
      detourLoc1,
      detourSize1,
      { core.AssemblyLambda([[

  ; playerID is 0? do original code
    cmp EBP, 0
    je original

  ; aic type for this player
    mov EAX, dword [EBP*4 + ptrCurrentAIArray]
  ; get from lua land if we should disable placing the extra ox tether for this ai type
    call getDisable

    cmp eax, 0
    je original

    jmp skipBuildingLoc

    original:
    ; run original (build ox tether if quarry placement was succesful)
  ]], {
          skipBuildingLoc = skipBuildingLoc,
          ptrCurrentAIArray = ptrCurrentAIArray,
          getDisable = yoinkAddr,
      }) },
      nil, "after")
end

return {
  enableOxTetherDisable = enableOxTetherDisable,
}