# UCP extension: AI Ox Tethers
This is a mod for the game Stronghold Crusader (Firefly Studios).
The mod works with the Unofficial Crusader Patch.

Vanilla AI has an upper bound on three ox tethers per quarry, plus it always builds an ox tether when it places a quarry.

This combination leads to strange behavior as the game progress. This extension addresses this.

The core feature of this extension is that the ox tethers that belong to a quarry are no longer hardcoded but dynamically computed based on the quarry the ox tether worker took stones from last. These ox tethers are termed "linked ox tethers".

## Features
- Allow more than 3 ox tethers per quarry
- Customize the decision rules for placing more ox tethers
- Customize the rules per AI via the AIC

## AIC parameters

| Field | Values | Meaning |
| --- | --- | --- |
| `AIOxTethers_DisableInitialOxTether` | 0 or 1 | 0 keeps the automatic tether when a quarry is built/rebuilt; 1 disables it. |
| `AIOxTethers_Logic` | 0 or 1 | 0 uses the game's additional-tether decision; 1 uses the module's dynamic rules below. |
| `AIOxTethers_MaxOxTethers` | Non-negative integer | Stop requesting additional tethers when the player's total reaches this limit. |
| `AIOxTethers_DynamicMaxOxTethers` | Non-negative number | Stop requesting additional tethers when the total reaches this multiplier × quarry count. |
| `AIOxTethers_MinimumOxTethersPerQuarry` | Non-negative integer | Request a tether for a quarry below this linked-tether count, subject to the two total limits. |
| `AIOxTethers_MaximumOxTethersPerQuarry` | Non-negative integer | Exclude a quarry from stone-load requests when its linked count is at or above this value. Keep the minimum at or below this maximum. |
| `AIOxTethers_ThresholdStoneLoad` | Non-negative number | Request another tether when stored stone / linked tethers exceeds this value. With no linked tether, use stored stone directly. A full stone pile is 48. |

With the module's AIC mode (`oxtethers.mode: use_aic`), put these fields in an AI's `Personality`:

```json
{
  "AIOxTethers_DisableInitialOxTether": 1,
  "AIOxTethers_Logic": 1,
  "AIOxTethers_MaxOxTethers": 100,
  "AIOxTethers_DynamicMaxOxTethers": 4,
  "AIOxTethers_MinimumOxTethersPerQuarry": 1,
  "AIOxTethers_MaximumOxTethersPerQuarry": 6,
  "AIOxTethers_ThresholdStoneLoad": 20
}
```

## Legacy compatibility

The launcher keeps UCP2-Legacy's **Set ox tethers to a maximum of 10 per AI lord**
option off while this module is active. Legacy skips the automatic tether that
comes with a new quarry. That changes the branch this module needs to control
automatic placement per AI. Use `AIOxTethers_DisableInitialOxTether` or the
module's menu to control that placement, and the dynamic limits to cap requests
for additional tethers.
