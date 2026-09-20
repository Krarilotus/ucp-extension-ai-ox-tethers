# IA: puestos de bueyes

La IA original usa un límite fijo de tres puestos de bueyes por cantera al decidir si añade otro. Además, coloca un puesto automáticamente cada vez que construye o reconstruye una cantera. Estas dos reglas pueden desequilibrar el transporte de piedra a medida que avanza la partida.

Esta extensión permite más de tres puestos por cantera y reglas personalizables, incluso para cada personalidad de IA. Cuenta los **puestos vinculados** de forma dinámica: un puesto se vincula a la cantera de la que su trabajador recogió piedra por última vez.

## Usar los ajustes AIC

Activa IA: puestos de bueyes en Personalizaciones y selecciona el modo AIC por IA (`use_aic`). Añadir el módulo a Contenido no basta para activarlo. Pon los campos siguientes en `Personality` de un archivo de AIC Loader, o en `aic` del archivo `character.json` de AI Swapper.

Usa valores numéricos. Los cinco límites y umbrales siguientes se aplican a la lógica dinámica (`AIOxTethers_Logic: 1`). El ajuste del puesto inicial es independiente.

## Parámetros AIC

### `AIOxTethers_DisableInitialOxTether`

- **0:** Mantener el comportamiento original: colocar un puesto automáticamente cada vez que se construye o reconstruye una cantera.
- **1:** No colocar ese puesto inicial automático. Se pueden seguir solicitando puestos adicionales.

### `AIOxTethers_Logic`

- **0:** Usar la lógica original del juego para solicitar puestos adicionales.
- **1:** Usar la lógica dinámica de la extensión y los ajustes siguientes.

### `AIOxTethers_MaxOxTethers`

El límite total de puestos para cada jugador de IA. Las solicitudes dinámicas se detienen cuando el número total de puestos alcanza este valor.

### `AIOxTethers_DynamicMaxOxTethers`

Un segundo límite total: **este valor × el número de canteras**. Las solicitudes dinámicas se detienen al alcanzar cualquiera de los dos límites totales. Es un multiplicador del total, no un límite de los puestos vinculados a cada cantera.

### `AIOxTethers_MinimumOxTethersPerQuarry`

Si una cantera tiene menos puestos vinculados que este valor, la IA solicita otro para ella, siempre que no se haya alcanzado ninguno de los límites totales. Esta comprobación del mínimo tiene prioridad sobre la comprobación de la carga de piedra.

### `AIOxTethers_MaximumOxTethersPerQuarry`

Cuando el número de puestos vinculados a una cantera alcanza este valor, se excluye esa cantera de las solicitudes por carga de piedra. No establezcas el mínimo por encima de este máximo: la comprobación del mínimo no tiene en cuenta este máximo.

### `AIOxTethers_ThresholdStoneLoad`

La IA solicita otro puesto cuando **piedra pendiente en la cantera ÷ puestos vinculados** supera este valor, respetando los límites totales y por cantera. Si no hay puestos vinculados, se usa directamente la cantidad de piedra pendiente. Una pila llena contiene 48 unidades de piedra.

Estos límites controlan las solicitudes dinámicas de nuevos puestos. No eliminan puestos existentes ni limitan la colocación automática independiente de los puestos iniciales. Usa `AIOxTethers_DisableInitialOxTether: 1` para desactivar también esa colocación automática.
