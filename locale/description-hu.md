# MI: ökörkarámok

Az eredeti MI kőfejtőnként legfeljebb három ökörkarámmal számol, amikor eldönti, hogy szükség van-e újabbra. Emellett minden kőfejtő építésekor vagy újjáépítésekor automatikusan elhelyez egy karámot. E két szabály együtt a játék előrehaladtával egyenetlen kőszállításhoz vezethet.

Ez a bővítmény háromnál több karámot is lehetővé tesz kőfejtőnként, és testreszabható szabályokat kínál, akár MI-személyiségenként külön. Dinamikusan számolja a **hozzárendelt ökörkarámokat**: egy karám ahhoz a kőfejtőhöz tartozik, ahonnan a dolgozója legutóbb követ vitt el.

## Az AIC-beállítások használata

Engedélyezd az MI: ökörkarámok funkciót a testreszabásoknál, és válaszd az MI-nkénti AIC-módot (`use_aic`). A modul hozzáadása a tartalmakhoz önmagában nem kapcsolja be. Az alábbi mezőket az AIC Loader fájl `Personality` részébe vagy az AI Swapper `character.json` fájljának `aic` részébe írd.

Számértékeket használj. Az alábbi öt korlát és küszöbérték a dinamikus logikára vonatkozik (`AIOxTethers_Logic: 1`). A kezdeti karám beállítása ettől független.

## AIC-paraméterek

### `AIOxTethers_DisableInitialOxTether`

- **0:** Az eredeti viselkedés megtartása: minden kőfejtő építésekor vagy újjáépítésekor automatikusan kerüljön le egy karám.
- **1:** Ez az automatikus kezdeti karám ne kerüljön le. További karámok továbbra is igényelhetők.

### `AIOxTethers_Logic`

- **0:** A játék eredeti logikája döntsön a további karámok igényléséről.
- **1:** A bővítmény dinamikus logikája és az alábbi beállítások érvényesüljenek.

### `AIOxTethers_MaxOxTethers`

Az egyes MI-játékosok összes karámjára vonatkozó korlát. A dinamikus igénylések leállnak, ha a karámok összesített száma eléri ezt az értéket.

### `AIOxTethers_DynamicMaxOxTethers`

Egy második összesített korlát: **ez az érték × a kőfejtők száma**. A dinamikus igénylések leállnak, amint bármelyik összesített korlátot elérik. Ez az összesített szám szorzója, nem az egyes kőfejtőkhöz rendelt karámok korlátja.

### `AIOxTethers_MinimumOxTethersPerQuarry`

Ha egy kőfejtőhöz ennél kevesebb karám tartozik, az MI újabbat igényel hozzá, feltéve, hogy egyik összesített korlátot sem érte el. A minimum ellenőrzése megelőzi a kőterhelés vizsgálatát.

### `AIOxTethers_MaximumOxTethersPerQuarry`

Ha a kőfejtőhöz rendelt karámok száma eléri ezt az értéket, a kőfejtő kimarad a kőterhelés alapján történő igénylésekből. A minimum ne legyen nagyobb ennél a maximumnál: a minimum ellenőrzése nem veszi figyelembe ezt a maximumot.

### `AIOxTethers_ThresholdStoneLoad`

Az MI újabb karámot igényel, ha a **kőfejtőnél elszállításra váró kő ÷ hozzárendelt karámok** értéke meghaladja ezt a küszöböt, az összesített és a kőfejtőnkénti korlátok mellett. Ha nincs hozzárendelt karám, közvetlenül a várakozó kő mennyiségét használja. Egy teljes halom 48 követ tartalmaz.

Ezek a korlátok az új karámok dinamikus igénylését szabályozzák. Nem távolítják el a meglévő karámokat, és nem korlátozzák a kezdeti karámok különálló, automatikus elhelyezését. Ennek kikapcsolásához is használd az `AIOxTethers_DisableInitialOxTether: 1` beállítást.
