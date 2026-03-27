import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/haber_detay_screen.dart';
import 'package:flutter/foundation.dart';

class BildirimServisi {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static BuildContext? _context;

  static Future<void> izinIste() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Bildirim izni verildi');
    }
  }

  static Future<String?> getToken() async {
    try {
      // iOS için önce APNs token bekle
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        String? apnsToken;
        int retries = 0;
        while (apnsToken == null && retries < 5) {
          apnsToken = await _messaging.getAPNSToken();
          if (apnsToken == null) {
            await Future.delayed(const Duration(seconds: 2));
            retries++;
          }
        }
        print('📱 APNs Token: $apnsToken');
      }
      
      final token = await _messaging.getToken();
      print('📱 FCM Token: $token');
      return token;
    } catch (e) {
      print('❌ Token alınamadı: $e');
      return null;
    }
  }

  static Future<void> basla(BuildContext context) async {
    _context = context;

    await Future.delayed(const Duration(seconds: 3));

    await izinIste();
    final token = await getToken();
    if (token != null) {
      await _tokenGonder(token);
    }

    // Uygulama AÇIKKEN bildirim geldiğinde
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Bildirim geldi: ${message.notification?.title}');
      print('📄 Data: ${message.data}');

      // Bildirim otomatik gösterilir
      // Kullanıcı tıklarsa onMessageOpenedApp çalışır
    });

    // Bildirime TIKLAYINCA (uygulama açıkken veya arka planda)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔔 Bildirime tıklandı!');
      _bildirimeTiklandi(message);
    });

    // Uygulama KAPALI iken bildirime tıklanınca
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('🔔 Uygulama kapalıyken bildirime tıklandı!');
        // Biraz bekle (uygulama yüklenmesi için)
        Future.delayed(const Duration(seconds: 1), () {
          _bildirimeTiklandi(message);
        });
      }
    });

    // Arka plan handler
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }

  // Bildirime tıklama işlemi
  static void _bildirimeTiklandi(RemoteMessage message) {
    final haberId = message.data['haberid']?.toString();

    if (haberId != null && _context != null) {
      print('📰 Haber açılıyor: $haberId');

      Navigator.push(
        _context!,
        MaterialPageRoute(
          builder: (context) => HaberDetayScreen(haberId: haberId),
        ),
      );
    } else {
      print('⚠️ Haber ID bulunamadı veya context yok');
    }
  }

  static Future<void> _tokenGonder(String token) async {
    try {
      final apiService = ApiService();
      final platform = defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
      final basarili = await apiService.tokenKaydet(token, platform: platform);
      if (basarili) {
        print('✅ Token başarıyla kaydedildi ($platform)');
      }
    } catch (e) {
      print('❌ Token gönderilemedi: $e');
    }
  }


}

// Arka plan handler
@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {
  print('🔔 Arka plan bildirimi: ${message.notification?.title}');
}
