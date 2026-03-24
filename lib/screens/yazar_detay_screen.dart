import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:html_unescape/html_unescape.dart';
import '../models/yazar_model.dart';
import '../services/api_service.dart';

class YazarDetayScreen extends StatefulWidget {
  final String yaziId;

  const YazarDetayScreen({super.key, required this.yaziId});

  @override
  State<YazarDetayScreen> createState() => _YazarDetayScreenState();
}

class _YazarDetayScreenState extends State<YazarDetayScreen> {
  final ApiService _apiService = ApiService();
  final HtmlUnescape _htmlUnescape = HtmlUnescape();
  Yazar? _yazi;
  bool _yukleniyor = true;
  String? _hata;

  @override
  void initState() {
    super.initState();
    _yaziYukle();
  }

  Future<void> _yaziYukle() async {
    setState(() {
      _yukleniyor = true;
      _hata = null;
    });

    try {
      final yazi = await _apiService.getYaziDetay(widget.yaziId);
      setState(() {
        _yazi = yazi;
        _yukleniyor = false;
      });
    } catch (e) {
      setState(() {
        _hata = e.toString();
        _yukleniyor = false;
      });
    }
  }

  void _yaziPaylas() {
    if (_yazi != null) {
      Share.share(
        '${_yazi!.baslik}\n\nhttps://www.akyazihaber.com/${_yazi!.url}',
      );
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
            onPressed: _yaziPaylas,
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
                      const Icon(Icons.error_outline,
                          size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('Yazı yüklenemedi'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _yaziYukle,
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                )
              : _yazi == null
                  ? const Center(child: Text('Yazı bulunamadı'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Resim
                          if (_yazi!.resim != null && _yazi!.resim!.isNotEmpty)
                            CachedNetworkImage(
                              imageUrl: _yazi!.resim!,
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
                                child: const Icon(Icons.person, size: 50),
                              ),
                            ),

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Yazar adı
                                if (_yazi!.yazarAdi != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red[700],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      _yazi!.yazarAdi!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 16),

                                // Başlık
                                Text(
                                  _yazi!.baslik,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Tarih
                                if (_yazi!.tarih != null)
                                  Text(
                                    _yazi!.tarih!,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                const Divider(height: 32),

                                // Detay/İçerik
                                if (_yazi!.detay != null)
                                  Text(
                                    _htmlUnescape.convert(
                                      _yazi!.detay!
                                          .replaceAll(RegExp(r'<[^>]*>'), '')
                                          .trim(),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 1.6,
                                      color: Colors.black87,
                                    ),
                                  )
                                else if (_yazi!.ozet != null)
                                  Text(
                                    _yazi!.ozet!,
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
