import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../models/haber_model.dart';
import '../services/api_service.dart';
import '../utils/tarih_helper.dart';

class HaberDetayScreen extends StatefulWidget {
  final String haberId;

  const HaberDetayScreen({super.key, required this.haberId});

  @override
  State<HaberDetayScreen> createState() => _HaberDetayScreenState();
}

class _HaberDetayScreenState extends State<HaberDetayScreen> {
  final ApiService _apiService = ApiService();
  Haber? _haber;
  bool _yukleniyor = true;
  String? _hata;

  @override
  void initState() {
    super.initState();
    _haberDetayiniYukle();
  }

  Future<void> _haberDetayiniYukle() async {
    setState(() {
      _yukleniyor = true;
      _hata = null;
    });

    try {
      final haber = await _apiService.getHaberDetay(widget.haberId);
      setState(() {
        _haber = haber;
        _yukleniyor = false;
      });
    } catch (e) {
      setState(() {
        _hata = e.toString();
        _yukleniyor = false;
      });
    }
  }

  void _haberiPaylas() {
    if (_haber != null) {
      final url = _haber!.url ?? 'https://akyazihaber.com';
      Share.share('${_haber!.baslik}\n\n$url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _haberiPaylas,
          ),
        ],
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : _hata != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('Haber yüklenemedi'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _haberDetayiniYukle,
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                )
              : _haber == null
                  ? const Center(child: Text('Haber bulunamadı'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Haber Resmi
                          if (_haber!.resim != null && _haber!.resim!.isNotEmpty)
                            CachedNetworkImage(
                              imageUrl: _haber!.resim!,
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 250,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 250,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported, size: 50),
                              ),
                            ),

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Kategori ve Tarih
                                Row(
                                  children: [
                                    if (_haber!.kategori != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red[700],
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          _haber!.kategori!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 8),
                                    if (_haber!.tarih != null)
                                      Text(
                                        TarihHelper.formatla(_haber!.tarih!),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Başlık
                                Text(
                                  _haber!.baslik,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Yazar ve Görüntülenme
                                Row(
                                  children: [
                                    if (_haber!.yazar != null) ...[
                                      const Icon(Icons.person, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        _haber!.yazar!,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                    ],
                                    if (_haber!.goruntulenme != null) ...[
                                      const Icon(Icons.visibility, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${_haber!.goruntulenme} görüntülenme',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const Divider(height: 32),

                                // İçerik
                                if (_haber!.icerik != null)
                                  Text(
                                    _haber!.icerik!
                                        .replaceAll(RegExp(r'<[^>]*>'), '')
                                        .replaceAll('&nbsp;', ' ')
                                        .replaceAll('&quot;', '"')
                                        .replaceAll('&#39;', "'")
                                        .trim(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 1.6,
                                      color: Colors.black87,
                                    ),
                                  )
                                else if (_haber!.ozet != null)
                                  Text(
                                    _haber!.ozet!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 1.6,
                                      color: Colors.black87,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
