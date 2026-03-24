import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/haber_model.dart';
import '../models/kategori_model.dart';

class ApiService {
  // API base URL
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

        if (decodedData is List) {
          return decodedData.map((json) => Haber.fromJson(json)).toList();
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          final list = decodedData['data'] as List;
          return list.map((json) => Haber.fromJson(json)).toList();
        }
        return [];
      } else {
        throw Exception('Haberler yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
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

        if (decodedData is List) {
          return decodedData.map((json) => Kategori.fromJson(json)).toList();
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          final list = decodedData['data'] as List;
          return list.map((json) => Kategori.fromJson(json)).toList();
        }
        return [];
      } else {
        throw Exception('Kategoriler yüklenemedi');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
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

        if (decodedData is Map) {
          return Haber.fromJson(decodedData);
        } else if (decodedData is List && decodedData.isNotEmpty) {
          return Haber.fromJson(decodedData[0]);
        }
        return null;
      } else {
        throw Exception('Haber detayı yüklenemedi');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }
}
