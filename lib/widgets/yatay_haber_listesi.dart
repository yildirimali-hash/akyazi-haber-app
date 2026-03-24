import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/haber_model.dart';

class YatayHaberListesi extends StatelessWidget {
  final List<Haber> haberler;
  final Function(Haber) onTap;
  final String? baslik;

  const YatayHaberListesi({
    super.key,
    required this.haberler,
    required this.onTap,
    this.baslik,
  });

  @override
  Widget build(BuildContext context) {
    if (haberler.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (baslik != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              baslik!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: haberler.length,
            itemBuilder: (context, index) {
              final haber = haberler[index];
              return GestureDetector(
                onTap: () => onTap(haber),
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Resim
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          child: haber.resim != null
                              ? CachedNetworkImage(
                                  imageUrl: haber.resim!,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    height: 120,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    height: 120,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image, size: 40),
                                  ),
                                )
                              : Container(
                                  height: 120,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                        ),
                        
                        // Başlık
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (haber.kategori != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red[700],
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Text(
                                      haber.kategori!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: Text(
                                    haber.baslik,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
