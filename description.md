# AI: Ox Tethers

The original AI uses a fixed limit of three ox tethers per quarry when deciding whether to add another tether. It also automatically places a tether whenever it builds or rebuilds a quarry. Together, these rules can lead to uneven stone transport as the game progresses.

This extension allows more than three tethers per quarry and customizable rules, including separate settings for each AI personality. It counts **linked ox tethers** dynamically: a tether is linked to the quarry its worker last collected stone from.

## Using AIC settings

Enable AI: Ox Tethers in Customizations and select the per-AI AIC mode (`use_aic`). Adding the module to Content alone does not enable it. Put the fields below inside `Personality` in an AIC Loader file, or inside `aic` in AI Swapper’s `character.json`.

Use numeric values. The five limits and thresholds below apply to dynamic logic (`AIOxTethers_Logic: 1`). The initial-tether setting is independent.

## AIC parameters

### `AIOxTethers_DisableInitialOxTether`

- **0:** Keep the original behaviour: automatically place a tether whenever a quarry is built or rebuilt.
- **1:** Do not place this automatic initial tether. Requests for additional tethers remain possible.

### `AIOxTethers_Logic`

- **0:** Use the game’s original logic for requesting additional tethers.
- **1:** Use the extension’s dynamic logic and the following settings.

### `AIOxTethers_MaxOxTethers`

The total tether limit for each AI player. Dynamic requests stop when the total number of tethers reaches this value.

### `AIOxTethers_DynamicMaxOxTethers`

A second total limit: **this value × the number of quarries**. Dynamic requests stop when either total limit is reached. This is a multiplier for the total, not a limit on the tethers linked to each quarry.

### `AIOxTethers_MinimumOxTethersPerQuarry`

If a quarry has fewer linked tethers than this value, the AI requests another for it, provided neither total limit has been reached. This minimum check takes priority over the stone-load check.

### `AIOxTethers_MaximumOxTethersPerQuarry`

When a quarry’s linked tether count reaches this value, it is excluded from requests based on stone load. Keep the minimum no higher than this maximum: the minimum check does not use this maximum.

### `AIOxTethers_ThresholdStoneLoad`

The AI requests another tether when **stone waiting at a quarry ÷ linked tethers** is greater than this value, subject to the total and per-quarry limits. If no tethers are linked, it uses the amount of waiting stone directly. A full pile contains 48 stone.

These limits govern dynamic requests for new tethers. They do not remove existing tethers or cap the separate automatic placement of initial tethers. Use `AIOxTethers_DisableInitialOxTether: 1` to stop that automatic placement too.
