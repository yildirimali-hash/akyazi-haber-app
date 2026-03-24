import 'package:flutter/material.dart';
import '../models/haber_model.dart';
import '../utils/tarih_helper.dart';
import '../widgets/optimized_image.dart';

class HaberCard extends StatelessWidget {
  final Haber haber;
  final VoidCallback onTap;

  const HaberCard({
    super.key,
    required this.haber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim
            if (haber.resim != null && haber.resim!.isNotEmpty)
              OptimizedImage(
                imageUrl: haber.resim!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori ve Tarih
                  Row(
                    children: [
                      if (haber.kategori != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[700],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            haber.kategori!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const Spacer(),
                      if (haber.tarih != null)
                        Text(
                          TarihHelper.formatla(haber.tarih!),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Başlık
                  Text(
                    haber.baslik,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Özet
                  if (haber.ozet != null && haber.ozet!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      haber.ozet!,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // Görüntülenme
                  if (haber.goruntulenme != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.visibility,
                            size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${haber.goruntulenme} görüntülenme',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
