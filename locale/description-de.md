# KI: Ochsenjoche

Die ursprüngliche KI verwendet ein festes Limit von drei Ochsenjochen pro Steinbruch, wenn sie entscheidet, ob ein weiteres Joch benötigt wird. Außerdem setzt sie bei jedem Bau oder Wiederaufbau eines Steinbruchs automatisch ein Joch. Zusammen können diese Regeln im Spielverlauf zu ungleichmäßigem Steintransport führen.

Diese Erweiterung erlaubt mehr als drei Joche pro Steinbruch und anpassbare Regeln, auch getrennt für jede KI-Persönlichkeit. Sie zählt **zugeordnete Ochsenjoche** dynamisch: Ein Joch gehört zu dem Steinbruch, von dem sein Arbeiter zuletzt Stein abgeholt hat.

## AIC-Einstellungen verwenden

Aktiviere KI: Ochsenjoche unter Anpassungen und wähle den AIC-Modus für einzelne KIs (`use_aic`). Das Hinzufügen des Moduls unter Inhalte allein aktiviert es nicht. Trage die folgenden Felder unter `Personality` in einer AIC-Loader-Datei oder unter `aic` in der Datei `character.json` von AI Swapper ein.

Verwende Zahlenwerte. Die folgenden fünf Grenz- und Schwellenwerte gelten für die dynamische Logik (`AIOxTethers_Logic: 1`). Die Einstellung für das anfängliche Joch ist davon unabhängig.

## AIC-Parameter

### `AIOxTethers_DisableInitialOxTether`

- **0:** Ursprüngliches Verhalten beibehalten: Bei jedem Bau oder Wiederaufbau eines Steinbruchs automatisch ein Joch setzen.
- **1:** Dieses automatische anfängliche Joch nicht setzen. Weitere Joche können weiterhin angefordert werden.

### `AIOxTethers_Logic`

- **0:** Die ursprüngliche Spiellogik für die Anforderung weiterer Joche verwenden.
- **1:** Die dynamische Logik der Erweiterung mit den folgenden Einstellungen verwenden.

### `AIOxTethers_MaxOxTethers`

Das Gesamtlimit an Jochen für jeden KI-Spieler. Dynamische Anforderungen stoppen, sobald die Gesamtzahl der Joche diesen Wert erreicht.

### `AIOxTethers_DynamicMaxOxTethers`

Ein zweites Gesamtlimit: **dieser Wert × Anzahl der Steinbrüche**. Dynamische Anforderungen stoppen, sobald eines der beiden Gesamtlimits erreicht ist. Dies ist ein Multiplikator für die Gesamtzahl, kein Limit für die einem einzelnen Steinbruch zugeordneten Joche.

### `AIOxTethers_MinimumOxTethersPerQuarry`

Hat ein Steinbruch weniger zugeordnete Joche als dieser Wert, fordert die KI ein weiteres dafür an, sofern keines der Gesamtlimits erreicht ist. Diese Mindestprüfung hat Vorrang vor der Prüfung der Steinlast.

### `AIOxTethers_MaximumOxTethersPerQuarry`

Erreicht die Zahl der zugeordneten Joche diesen Wert, wird der Steinbruch bei Anforderungen aufgrund der Steinlast nicht mehr berücksichtigt. Setze das Minimum nicht höher als dieses Maximum: Die Mindestprüfung berücksichtigt dieses Maximum nicht.

### `AIOxTethers_ThresholdStoneLoad`

Die KI fordert ein weiteres Joch an, wenn **wartender Stein am Steinbruch ÷ zugeordnete Joche** größer als dieser Wert ist, unter Beachtung der Gesamtlimits und des Limits pro Steinbruch. Ohne zugeordnete Joche wird die wartende Steinmenge direkt verwendet. Ein voller Stapel enthält 48 Stein.

Diese Limits steuern dynamische Anforderungen neuer Joche. Sie entfernen keine vorhandenen Joche und begrenzen nicht das separate automatische Setzen anfänglicher Joche. Mit `AIOxTethers_DisableInitialOxTether: 1` lässt sich auch dieses automatische Setzen abschalten.
