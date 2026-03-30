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

  
  static Future<void> basla({required GlobalKey<NavigatorState> navigatorKey}) async {
    BildirimServisi.navigatorKey = navigatorKey;
    
    // Önce izin iste
    await izinIste();
    
    // Sonra 3 saniye bekle (iOS APNs token için)
    await Future.delayed(const Duration(seconds: 3));
    
    // Token al
    final token = await getToken();
    if (token != null) {
      await _tokenGonder(token);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Bildirim geldi: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔔 Bildirime tıklandı!');
      _bildirimeTiklandi(message);
    });

    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        Future.delayed(const Duration(seconds: 1), () {
          _bildirimeTiklandi(message);
        });
      }
    });

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }





  // Bildirime tıklama işlemi
  static void _bildirimeTiklandi(RemoteMessage message) {
    print('📨 Message data: ${message.data}');
    final haberId = message.data['haberid']?.toString();
    print('📰 Haber ID: $haberId');

    if (haberId != null && haberId.isNotEmpty) {
      // navigatorKey ile context beklemeden yönlendir
      Future.delayed(const Duration(seconds: 1), () {
        final context = navigatorKey?.currentContext;
        if (context != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HaberDetayScreen(haberId: haberId),
            ),
          );
        } else {
          print('⚠️ Context hala null!');
        }
      });
    }
  }

  static GlobalKey<NavigatorState>? navigatorKey;



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
