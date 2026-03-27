import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/haber_model.dart';
import '../models/kategori_model.dart';
import '../models/reklam_model.dart';
import '../models/doviz_model.dart';
import '../models/yazar_model.dart';
import '../models/yorum_model.dart';
import '../models/eczane_model.dart';

class ApiService {
  static const String baseUrl = 'https://www.akyazihaber.com/api.php';

  // Haberleri getir
  Future<List<Haber>> getHaberler() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=haberler'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        return _parseHaberListesi(decodedData);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Kategorileri getir
  Future<List<Kategori>> getKategoriler() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=kategoriler'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));

        if (decodedData is Map && decodedData.containsKey('sonuc')) {
          final list = decodedData['sonuc'] as List;
          return list
              .map((json) => Kategori.fromJson(Map<String, dynamic>.from(json)))
              .toList();
        } else if (decodedData is List) {
          return decodedData
              .map((json) => Kategori.fromJson(Map<String, dynamic>.from(json)))
              .toList();
        }
        return [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Haber detayını getir
  Future<Haber?> getHaberDetay(String haberId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=haberdetay&haberid=$haberId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));

        if (decodedData is Map && decodedData.containsKey('sonuc')) {
          final sonuc = decodedData['sonuc'];
          if (sonuc is List && sonuc.isNotEmpty) {
            return Haber.fromJson(Map<String, dynamic>.from(sonuc[0]));
          } else if (sonuc is Map) {
            return Haber.fromJson(Map<String, dynamic>.from(sonuc));
          }
        } else if (decodedData is Map) {
          return Haber.fromJson(Map<String, dynamic>.from(decodedData));
        } else if (decodedData is List && decodedData.isNotEmpty) {
          return Haber.fromJson(Map<String, dynamic>.from(decodedData[0]));
        }
        return null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Reklam getir
  Future<Reklam?> getReklam(String reklamNo) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=$reklamNo'),
        headers: {'Accept': 'application/json'},
      );

      print(reklamNo);
      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        print(decodedData);
        return Reklam.fromJson(Map<String, dynamic>.from(decodedData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Manşet haberleri getir
  Future<List<Haber>> getMansetler() async {
    return _getHaberListesi('mansetler');
  }

  // Manşet yanı haberleri getir
  Future<List<Haber>> getMansetYaniHaberler() async {
    return _getHaberListesi('mansetyanihaberler');
  }

  // Manşet altı haberleri getir
  Future<List<Haber>> getMansetAltiHaberler() async {
    return _getHaberListesi('mansetaltihaberler');
  }

// Kategori haberleri getir
  Future<List<Haber>> getKategoriHaberleri(String kategoriId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=kategorihaberliste&kategoriid=$kategoriId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        return _parseHaberListesi(decodedData);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // İlgili haberleri getir
  Future<List<Haber>> getIlgiliHaberler(String kategoriId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=ilgilihaberler&kategoriid=$kategoriId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        return _parseHaberListesi(decodedData);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Genel haber listesi getirme
  Future<List<Haber>> _getHaberListesi(String islem) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=$islem'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        return _parseHaberListesi(decodedData);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Haber listesi parse et
  List<Haber> _parseHaberListesi(dynamic decodedData) {
    if (decodedData is Map && decodedData.containsKey('sonuc')) {
      final list = decodedData['sonuc'] as List;
      return list
          .map((json) => Haber.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } else if (decodedData is List) {
      return decodedData
          .map((json) => Haber.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    }
    return [];
  }

  // Döviz kurları getir
  Future<Doviz?> getDoviz() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=doviz'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        return Doviz.fromJson(Map<String, dynamic>.from(decodedData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Yazarlar getir
  Future<List<Yazar>> getYazarlar() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=yazarlar'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));

        if (decodedData is Map && decodedData.containsKey('sonuc')) {
          final list = decodedData['sonuc'] as List;
          return list
              .map((json) => Yazar.fromJson(Map<String, dynamic>.from(json)))
              .toList();
        } else if (decodedData is List) {
          return decodedData
              .map((json) => Yazar.fromJson(Map<String, dynamic>.from(json)))
              .toList();
        }
        return [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Yazı detayı getir
  Future<Yazar?> getYaziDetay(String yaziId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=yazidetay&yaziid=$yaziId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));

        if (decodedData is Map && decodedData.containsKey('sonuc')) {
          final sonuc = decodedData['sonuc'];
          if (sonuc is List && sonuc.isNotEmpty) {
            return Yazar.fromJson(Map<String, dynamic>.from(sonuc[0]));
          } else if (sonuc is Map) {
            return Yazar.fromJson(Map<String, dynamic>.from(sonuc));
          }
        } else if (decodedData is Map) {
          return Yazar.fromJson(Map<String, dynamic>.from(decodedData));
        }
        return null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Haber galerisi getir
  Future<List<String>> getHaberGaleri(String haberId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=habergaleri&haberid=$haberId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));

        if (decodedData is Map && decodedData['success'] == true) {
          final liste = decodedData['liste'] as List;
          return liste
              .map((e) => 'https://www.akyazihaber.com/${e.toString()}')
              .toList();
        }
        return [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Yorumları getir
  Future<List<Yorum>> getYorumlar(String haberId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=yorumlar&haberid=$haberId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));

        if (decodedData is Map && decodedData['success'] == true) {
          final liste = decodedData['liste'] as List;
          return liste
              .map((json) => Yorum.fromJson(Map<String, dynamic>.from(json)))
              .toList();
        }
        return [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Yorum yap
  Future<bool> yorumYap(String haberId, String isim, String mesaj) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'islem': 'yorumyap',
          'haberid': haberId,
          'isim': isim,
          'mesaj': mesaj,
        },
      );
      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        return decodedData['success'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Nöbetçi eczaneler getir
  Future<NobetciEczaneResponse?> getNobetciEczaneler() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=nobetcieczaneler'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        return NobetciEczaneResponse.fromJson(
            Map<String, dynamic>.from(decodedData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // FCM Token kaydet
  Future<bool> tokenKaydet(String token, {String platform = 'android'}) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'islem': 'tokenkaydet',
          'token': token,
          'platform': platform,
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        return decodedData['success'] == true;
      }
      return false;
    } catch (e) {
      print('Token kaydetme hatası: $e');
      return false;
    }
  }

  // Bize Ulaşın
  Future<Map<String, dynamic>?> getBizeUlasin() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=bizeulasin'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        if (decodedData['success'] == true) {
          return Map<String, dynamic>.from(decodedData);
        }
      }
      return null;
    } catch (e) {
      print('Bize ulaşın hatası: $e');
      return null;
    }
  }

  // Hakkımızda
  Future<Map<String, dynamic>?> getHakkimizda() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?islem=hakkimizda'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        if (decodedData['success'] == true) {
          return Map<String, dynamic>.from(decodedData);
        }
      }
      return null;
    } catch (e) {
      print('Hakkımızda hatası: $e');
      return null;
    }
  }
}
