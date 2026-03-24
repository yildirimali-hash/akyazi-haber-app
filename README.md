# Akyazı Haber Mobil Uygulaması v2.0

Flutter ile geliştirilmiş tam özellikli haber uygulaması.

## 🎉 Yeni Özellikler (v2.0)

### Ana Sayfa
✅ Beyaz navbar (ortada logo)
✅ Yan menü (Drawer) - Kategori listesi  
✅ Reklam alanları (5 farklı konum)
✅ Manşet Carousel (5 saniye otomatik geçiş, noktalı sistem)
✅ Yatay kaydırılabilir haber listeleri
✅ Döviz kurları (Dolar, Euro, Sterlin, Altın, Gümüş)
✅ Yazar yazıları (yatay kaydırılabilir)
✅ Alt alta haber listesi

### Haber Detay  
✅ Fotoğraf galerisi (yatay kaydırılabilir)
✅ Haber reklamları (galeri öncesi ve sonrası)
✅ İlgili haberler (yatay liste)
✅ Yorum yapma formu (isim + mesaj)
✅ Yorum listesi (alt yorumlarla birlikte)

### Yazar Detay
✅ Yazar yazısı detay sayfası

## 🚀 Hızlı Başlangıç

```bash
# Bağımlılıkları yükle
flutter pub get

# Çalıştır
flutter run

# APK oluştur
flutter build apk --release
```

## 📱 Kullanılan API'ler

### Ana Sayfa
- `kategoriler` - Yan menü kategorileri
- `mansetler` - 20 manşet haber (carousel)
- `mansetyanihaberler` - Öne çıkanlar
- `mansetaltihaberler` - Son haberler
- `reklamlar1-5` - 5 farklı reklam alanı
- `doviz` - Döviz kurları
- `yazarlar` - Yazar yazıları

### Haber Detay
- `haberdetay&haberid={id}`
- `habergaleri&haberid={id}`
- `haberreklam1&haberid={id}`
- `haberreklam2&haberid={id}`
- `ilgilihaberler&kategoriid={id}`
- `yorumlar&haberid={id}`
- `yorumyap` (POST: haberid, isim, mesaj)

### Yazar
- `yazidetay&yaziid={id}`

## 📝 Logo Ekleme

1. Logo dosyanızı `assets/images/logo.png` olarak kaydedin
2. `flutter pub get` komutuyla yenileyin

Logo yoksa otomatik olarak "Akyazı Haber" yazısı gösterilir.

## 🎨 Özellik Detayları

**Manşet Carousel**
- 5 saniye otomatik geçiş
- Nokta göstergeleri
- Gradient overlay
- Kategori badge

**Döviz Kurları**
- Dolar, Euro, Sterlin, Altın, Gümüş
- Yükseliş/düşüş ok işaretleri
- Renkli kartlar

**Yorumlar**
- İsim + Mesaj formu
- Alt yorum desteği
- Beğeni/Beğenmeme sayaçları

**Reklamlar**
- 2 tip: Resim (img) veya Kod (kod)
- 5 ana sayfa konumu
- 2 haber detay konumu

## 🔧 Yapılandırma

API URL değiştirme:
```dart
// lib/services/api_service.dart
static const String baseUrl = 'https://www.akyazihaber.com/api.php';
```

## 📁 Dosya Yapısı

```
lib/
├── main.dart
├── models/ (7 model)
├── screens/ (3 ekran)
├── services/ (1 servis)
├── widgets/ (6 widget)
└── utils/ (1 helper)
```

## 🐛 Sorun Giderme

**Resimler görünmüyor:**
- CORS: `.htaccess` ekleyin
```apache
Header set Access-Control-Allow-Origin "*"
```

**Parse hatası:**
- Model dosyalarındaki alan isimlerini API ile eşleştirin

## 📄 Lisans

Akyazı Haber için özel geliştirilmiştir.
