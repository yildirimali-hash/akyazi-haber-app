import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/yazar_model.dart';

class YazarListesi extends StatelessWidget {
  final List<Yazar> yazarlar;
  final Function(Yazar) onTap;

  const YazarListesi({
    super.key,
    required this.yazarlar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (yazarlar.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Yazarlar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: yazarlar.length,
            itemBuilder: (context, index) {
              final yazar = yazarlar[index];
              return GestureDetector(
                onTap: () => onTap(yazar),
                child: Container(
                  width: 180,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Resim
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: yazar.resim != null
                              ? CachedNetworkImage(
                                  imageUrl: yazar.resim!,
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
                                    child: const Icon(Icons.person, size: 40),
                                  ),
                                )
                              : Container(
                                  height: 120,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.person, size: 40),
                                ),
                        ),
                        
                        // İçerik
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (yazar.yazarAdi != null)
                                  Text(
                                    yazar.yazarAdi!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.red[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: Text(
                                    yazar.baslik,
                                    style: const TextStyle(
                                      fontSize: 14,
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
