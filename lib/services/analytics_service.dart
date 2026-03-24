import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: _analytics);

  // Sayfa görüntüleme
  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenName,
    );
    print('📊 Analytics: Screen view - $screenName');
  }

  // Haber görüntüleme
  static Future<void> logHaberGoruntuleme(
      String haberId, String haberBaslik) async {
    await _analytics.logEvent(
      name: 'haber_goruntuleme',
      parameters: {
        'haber_id': haberId,
        'haber_baslik': haberBaslik,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    print('📊 Analytics: Haber görüntüleme - $haberBaslik');
  }

  // Kategori tıklama
  static Future<void> logKategoriTiklama(String kategoriAd) async {
    await _analytics.logEvent(
      name: 'kategori_tiklama',
      parameters: {
        'kategori': kategoriAd,
      },
    );
    print('📊 Analytics: Kategori - $kategoriAd');
  }

  // Galeri açma
  static Future<void> logGaleriAcma(String haberId) async {
    await _analytics.logEvent(
      name: 'galeri_acma',
      parameters: {
        'haber_id': haberId,
      },
    );
    print('📊 Analytics: Galeri açıldı');
  }

  // Yorum yapma
  static Future<void> logYorumYapma(String haberId) async {
    await _analytics.logEvent(
      name: 'yorum_yapma',
      parameters: {
        'haber_id': haberId,
      },
    );
    print('📊 Analytics: Yorum yapıldı');
  }

  // Paylaşma
  static Future<void> logPaylasma(String haberId, String platform) async {
    await _analytics.logEvent(
      name: 'paylasma',
      parameters: {
        'haber_id': haberId,
        'platform': platform, // whatsapp, facebook, etc.
      },
    );
    print('📊 Analytics: Paylaşıldı - $platform');
  }

  // Eczane arama
  static Future<void> logEczaneArama() async {
    await _analytics.logEvent(name: 'eczane_arama');
    print('📊 Analytics: Eczane arandı');
  }

  // Telefon arama
  static Future<void> logTelefonArama(String tip) async {
    await _analytics.logEvent(
      name: 'telefon_arama',
      parameters: {
        'tip': tip, // eczane, iletisim
      },
    );
    print('📊 Analytics: Telefon araması - $tip');
  }

  // Dark mode değişimi
  static Future<void> logDarkModeToggle(bool isDark) async {
    await _analytics.logEvent(
      name: 'dark_mode_toggle',
      parameters: {
        'durum': isDark ? 'acik' : 'kapali',
      },
    );
    print('📊 Analytics: Dark mode - ${isDark ? "açık" : "kapalı"}');
  }

  // Bildirim tıklama
  static Future<void> logBildirimTiklama(String haberId) async {
    await _analytics.logEvent(
      name: 'bildirim_tiklama',
      parameters: {
        'haber_id': haberId,
      },
    );
    print('📊 Analytics: Bildirime tıklandı');
  }

  // Custom event
  // Custom event
  static Future<void> logCustomEvent(
    String eventName,
    Map<String, Object>? parameters, // ← dynamic yerine Object
  ) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
    print('📊 Analytics: $eventName');
  }
}
