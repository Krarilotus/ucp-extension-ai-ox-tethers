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
### `AIOxTethers_DisableInitialOxTether`
0 means vanilla behavior, 1 means do not built an ox tether everytime a quarry is (re)built.

### `AIOxTethers_Logic`
Set the logic to apply. 0 means vanilla, 1 means dynamic.

### `AIOxTethers_MaxOxTethers`
The total amount of ox tethers for this player will never go above this value.

### `AIOxTethers_DynamicMaxOxTethers`
The total amount of ox tethers for this player will never go above this value multiplied by the amount of quarries.

### `AIOxTethers_MinimumOxTethersPerQuarry`
If fewer linked ox tethers take stones from this quarry than this value, an ox tether will be built for this quarry.

### `AIOxTethers_MaximumOxTethersPerQuarry`
If the amount of linked ox tethers for a quarry is higher than this value, no ox tether is built for this quarry.

### `AIOxTethers_ThresholdStoneLoad` 
If `stones/linked ox tethers` goes above this value for a quarry, another ox tether is built for that quarry.
