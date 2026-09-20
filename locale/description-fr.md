# IA : longes à bœufs

L’IA d’origine applique une limite fixe de trois longes à bœufs par carrière lorsqu’elle décide d’en ajouter une. Elle place aussi automatiquement une longe à chaque construction ou reconstruction d’une carrière. Ces deux règles peuvent déséquilibrer le transport de pierre au fil de la partie.

Cette extension permet de dépasser trois longes par carrière et de personnaliser les règles, y compris pour chaque personnalité d’IA. Elle compte les **longes rattachées** de façon dynamique : une longe est rattachée à la carrière où son ouvrier a récupéré de la pierre pour la dernière fois.

## Utiliser les paramètres AIC

Activez IA : longes à bœufs dans les personnalisations et sélectionnez le mode AIC par IA (`use_aic`). Ajouter le module au contenu ne suffit pas à l’activer. Placez les champs ci-dessous dans `Personality` d’un fichier AIC Loader, ou dans `aic` du fichier `character.json` d’AI Swapper.

Utilisez des valeurs numériques. Les cinq limites et seuils ci-dessous s’appliquent à la logique dynamique (`AIOxTethers_Logic: 1`). Le réglage de la longe initiale est indépendant.

## Paramètres AIC

### `AIOxTethers_DisableInitialOxTether`

- **0 :** Conserver le comportement d’origine : placer automatiquement une longe à chaque construction ou reconstruction d’une carrière.
- **1 :** Ne pas placer cette longe initiale automatique. Des longes supplémentaires peuvent toujours être demandées.

### `AIOxTethers_Logic`

- **0 :** Utiliser la logique d’origine du jeu pour demander des longes supplémentaires.
- **1 :** Utiliser la logique dynamique de l’extension et les paramètres suivants.

### `AIOxTethers_MaxOxTethers`

La limite totale de longes pour chaque joueur IA. Les demandes dynamiques cessent lorsque le nombre total de longes atteint cette valeur.

### `AIOxTethers_DynamicMaxOxTethers`

Une seconde limite totale : **cette valeur × le nombre de carrières**. Les demandes dynamiques cessent dès que l’une des deux limites totales est atteinte. Il s’agit d’un multiplicateur du total, pas d’une limite des longes rattachées à chaque carrière.

### `AIOxTethers_MinimumOxTethersPerQuarry`

Si une carrière a moins de longes rattachées que cette valeur, l’IA en demande une autre pour elle, à condition qu’aucune limite totale ne soit atteinte. Cette vérification du minimum est prioritaire sur celle de la charge de pierre.

### `AIOxTethers_MaximumOxTethersPerQuarry`

Lorsque le nombre de longes rattachées à une carrière atteint cette valeur, celle-ci est exclue des demandes liées à la charge de pierre. Gardez le minimum inférieur ou égal à ce maximum : la vérification du minimum ne tient pas compte de ce maximum.

### `AIOxTethers_ThresholdStoneLoad`

L’IA demande une autre longe lorsque **pierre en attente à la carrière ÷ longes rattachées** dépasse cette valeur, dans le respect des limites totales et par carrière. Sans longe rattachée, la quantité de pierre en attente est utilisée directement. Une pile pleine contient 48 unités de pierre.

Ces limites régissent les demandes dynamiques de nouvelles longes. Elles ne suppriment pas les longes existantes et ne limitent pas le placement automatique distinct des longes initiales. Utilisez `AIOxTethers_DisableInitialOxTether: 1` pour désactiver aussi ce placement automatique.
