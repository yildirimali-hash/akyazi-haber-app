import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static const key = 'akyaziHaberCache';

  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7), // 7 gün cache (daha makul)
      maxNrOfCacheObjects: 500, // Maksimum 500 resim
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );

  // Haber resimlerini güncelle
  static CacheManager freshInstance = CacheManager(
    Config(
      'fresh_$key',
      stalePeriod: const Duration(hours: 1), // 6 saat (manşet haberleri için)
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: 'fresh_$key'),
      fileService: HttpFileService(),
    ),
  );

  // Cache'i temizle
  static Future<void> temizle() async {
    await instance.emptyCache();
    await freshInstance.emptyCache();
  }
}
