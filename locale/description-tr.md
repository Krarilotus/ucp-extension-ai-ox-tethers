# Yapay zekâ: öküz bağlama yerleri

Oyunun özgün yapay zekâsı, yeni bir öküz bağlama yeri gerekip gerekmediğine karar verirken taş ocağı başına üç bağlama yeri sınırını kullanır. Ayrıca bir taş ocağı her inşa edildiğinde veya yeniden yapıldığında otomatik olarak bir bağlama yeri yerleştirir. Bu iki kural, oyun ilerledikçe taş taşımacılığında dengesizliğe yol açabilir.

Bu eklenti, taş ocağı başına üçten fazla bağlama yerine ve her yapay zekâ kişiliği için ayrı ayrı da ayarlanabilen kurallara izin verir. **İlişkili bağlama yerlerini** dinamik olarak sayar: Bir bağlama yeri, işçisinin en son taş aldığı taş ocağıyla ilişkilidir.

## AIC ayarlarını kullanma

Özelleştirmeler bölümünde yapay zekâ için öküz bağlama yerleri özelliğini etkinleştirin ve yapay zekâ başına AIC modunu (`use_aic`) seçin. Modülü İçerik bölümüne eklemek tek başına etkinleştirmez. Aşağıdaki alanları AIC Loader dosyasındaki `Personality` içine veya AI Swapper’ın `character.json` dosyasındaki `aic` içine ekleyin.

Sayısal değerler kullanın. Aşağıdaki beş sınır ve eşik dinamik mantık için geçerlidir (`AIOxTethers_Logic: 1`). İlk bağlama yeri ayarı bundan bağımsızdır.

## AIC parametreleri

### `AIOxTethers_DisableInitialOxTether`

- **0:** Özgün davranışı korur: Taş ocağı her inşa edildiğinde veya yeniden yapıldığında otomatik olarak bir bağlama yeri yerleştirir.
- **1:** Bu otomatik ilk bağlama yerini yerleştirmez. Ek bağlama yeri talepleri hâlâ mümkündür.

### `AIOxTethers_Logic`

- **0:** Ek bağlama yeri talepleri için oyunun özgün mantığını kullanır.
- **1:** Eklentinin dinamik mantığını ve aşağıdaki ayarları kullanır.

### `AIOxTethers_MaxOxTethers`

Her yapay zekâ oyuncusunun toplam bağlama yeri sınırıdır. Toplam sayı bu değere ulaştığında dinamik talepler durur.

### `AIOxTethers_DynamicMaxOxTethers`

İkinci bir toplam sınırdır: **bu değer × taş ocağı sayısı**. İki toplam sınırdan birine ulaşıldığında dinamik talepler durur. Bu, toplam sayıya uygulanan bir çarpandır; her taş ocağıyla ilişkili bağlama yerlerinin sınırı değildir.

### `AIOxTethers_MinimumOxTethersPerQuarry`

Bir taş ocağıyla ilişkili bağlama yeri sayısı bu değerden azsa ve iki toplam sınırdan hiçbirine ulaşılmamışsa yapay zekâ o ocak için bir tane daha talep eder. Bu minimum kontrolü, taş yükü kontrolünden önce gelir.

### `AIOxTethers_MaximumOxTethersPerQuarry`

Bir taş ocağıyla ilişkili bağlama yeri sayısı bu değere ulaştığında o ocak, taş yüküne dayalı taleplerin dışında tutulur. Minimumu bu maksimumdan yüksek tutmayın: Minimum kontrolü bu maksimumu dikkate almaz.

### `AIOxTethers_ThresholdStoneLoad`

**Taş ocağında bekleyen taş ÷ ilişkili bağlama yeri sayısı** bu değeri aştığında yapay zekâ, toplam sınırlar ve ocak başına sınır çerçevesinde bir bağlama yeri daha talep eder. İlişkili bağlama yeri yoksa doğrudan bekleyen taş miktarı kullanılır. Tam bir yığın 48 taş içerir.

Bu sınırlar, yeni bağlama yerlerine yönelik dinamik talepleri yönetir. Mevcut bağlama yerlerini kaldırmaz ve ilk bağlama yerlerinin ayrı otomatik yerleştirme işlemini sınırlamaz. Otomatik yerleştirmeyi de durdurmak için `AIOxTethers_DisableInitialOxTether: 1` kullanın.
