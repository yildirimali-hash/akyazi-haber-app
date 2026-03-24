import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/cache_manager.dart';

class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isFresh;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isFresh = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      cacheManager: isFresh 
          ? CustomCacheManager.freshInstance 
          : CustomCacheManager.instance,
      // memCache kaldırıldı - sorun yaratabiliyor
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        print('🔴 Resim hatası: $imageUrl');
        print('🔴 Hata: $error');
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: Icon(
            Icons.broken_image,
            size: height != null && height! < 100 ? 30 : 50,
            color: Colors.grey[600],
          ),
        );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }
}
