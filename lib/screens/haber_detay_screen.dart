import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:html_unescape/html_unescape.dart';
import '../models/haber_model.dart';
import '../models/reklam_model.dart';
import '../models/yorum_model.dart';
import '../services/api_service.dart';
import '../utils/tarih_helper.dart';
import '../widgets/yatay_haber_listesi.dart';
import '../widgets/reklam_widget.dart';
import '../widgets/tam_ekran_galeri.dart';
import '../services/analytics_service.dart';

class HaberDetayScreen extends StatefulWidget {
  final String haberId;

  const HaberDetayScreen({super.key, required this.haberId});

  @override
  State<HaberDetayScreen> createState() => _HaberDetayScreenState();
}

class _HaberDetayScreenState extends State<HaberDetayScreen> {
  final ApiService _apiService = ApiService();
  final HtmlUnescape _htmlUnescape = HtmlUnescape();
  final TextEditingController _isimController = TextEditingController();
  final TextEditingController _yorumController = TextEditingController();

  Haber? _haber;
  List<String> _galeri = [];
  List<Yorum> _yorumlar = [];
  List<Haber> _ilgiliHaberler = [];
  Reklam? _haberReklam1;
  Reklam? _haberReklam2;
  Reklam? _haberReklam3;

  bool _yukleniyor = true;
  bool _yorumGonderiliyor = false;
  String? _hata;

  @override
  void initState() {
    super.initState();
    _haberYukle();
  }

  @override
  void dispose() {
    _isimController.dispose();
    _yorumController.dispose();
    super.dispose();
  }

  Future<void> _haberYukle() async {
    setState(() {
      _yukleniyor = true;
      _hata = null;
    });

    try {
      // 1. ÖNCELİK: Haber detayını hemen yükle ve göster
      final haber = await _apiService.getHaberDetay(widget.haberId);

      if (haber != null) {
        setState(() {
          _haber = haber;
          _yukleniyor = false; // Haberi göster, loading kapat
        });

        // 2. ARKA PLANDA: Diğer verileri yükle (kullanıcı haberi okurken)
        _apiService.getHaberGaleri(widget.haberId).then((galeri) {
          if (mounted) {
            setState(() => _galeri = galeri);
          }
        });

        _apiService.getYorumlar(widget.haberId).then((yorumlar) {
          if (mounted) {
            setState(() => _yorumlar = yorumlar);
          }
        });

        _apiService.getIlgiliHaberler(haber.kategoriid ?? '').then((haberler) {
          if (mounted) {
            setState(() => _ilgiliHaberler = haberler);
          }
        });

        _apiService.getReklam('haberreklam1').then((reklam) {
          if (mounted) {
            setState(() => _haberReklam1 = reklam);
          }
        });

        _apiService.getReklam('haberreklam2').then((reklam) {
          if (mounted) {
            setState(() => _haberReklam2 = reklam);
          }
        });

        _apiService.getReklam('haberreklam3').then((reklam) {
          if (mounted) {
            setState(() => _haberReklam3 = reklam);
          }
        });

      } else {
        setState(() {
          _hata = 'Haber bulunamadı';
          _yukleniyor = false;
        });
      }
    } catch (e) {
      setState(() {
        _hata = e.toString();
        _yukleniyor = false;
      });
    }
  }

  Future<void> _yorumGonder() async {
    if (_isimController.text.trim().isEmpty ||
        _yorumController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İsim ve yorum alanlarını doldurun')),
      );
      return;
    }

    setState(() => _yorumGonderiliyor = true);

    try {
      final basarili = await _apiService.yorumYap(
        widget.haberId,
        _isimController.text.trim(),
        _yorumController.text.trim(),
      );

      if (basarili) {
        _isimController.clear();
        _yorumController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yorumunuz başarıyla gönderildi'),
            backgroundColor: Colors.green,
          ),
        );
        // Yorumları yenile
        final yorumlar = await _apiService.getYorumlar(widget.haberId);
        setState(() => _yorumlar = yorumlar);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yorum gönderilemedi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      setState(() => _yorumGonderiliyor = false);
    }
  }

  void _haberiPaylas() {
    if (_haber != null) {
      final url = _haber!.url;
      Share.share('${_haber!.baslik}\n\n$url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'Akyazı Haber',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.outbox_outlined, color: Colors.black87),
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
                      const Icon(Icons.error_outline,
                          size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('Haber yüklenemedi'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _haberYukle,
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
                          if (_haber!.resim != null &&
                              _haber!.resim!.isNotEmpty)
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
                                child: const Icon(Icons.image_not_supported,
                                    size: 50),
                              ),
                            ),

                           if(_haberReklam3 != null) ReklamWidget(reklam:_haberReklam3),
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
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                                Row(children: [
                                  if (_haber!.yazar != null) ...[
                                    const Icon(Icons.person,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      _haber!.yazar!,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                  ]
                                ]),
                                const Divider(height: 32),

                                // İçerik
                                if (_haber!.icerik != null)
                                  Text(
                                    _htmlUnescape.convert(
                                      _haber!.icerik!
                                          .replaceAll(RegExp(r'<[^>]*>'), '')
                                          .trim(),
                                    ),
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

                          // Galeri - Reklam 1 öncesi
                          if (_haberReklam1 != null)
                            ReklamWidget(reklam: _haberReklam1, height: 100),

                          // Galeri
                          if (_galeri.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Fotoğraf Galerisi',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                itemCount: _galeri.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TamEkranGaleri(
                                            resimler: _galeri,
                                            baslangicIndex: index,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 300,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: _galeri[index],
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Container(
                                                color: Colors.grey[300],
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                    Icons.broken_image,
                                                    size: 40),
                                              ),
                                            ),
                                            // Zoom ikonu
                                            Positioned(
                                              bottom: 8,
                                              right: 8,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Icon(
                                                  Icons.zoom_in,
                                                  color: Colors.white,
                                                  size: 20,
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

                          // Galeri - Reklam 2 sonrası
                          if (_haberReklam2 != null)
                            ReklamWidget(reklam: _haberReklam2, height: 100),

                          // İlgili Haberler
                          if (_ilgiliHaberler.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            YatayHaberListesi(
                              haberler: _ilgiliHaberler.take(10).toList(),
                              onTap: (haber) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HaberDetayScreen(haberId: haber.id),
                                  ),
                                );
                              },
                              baslik: 'İlgili Haberler',
                            ),
                          ],

                          // Yorum Formu
                          _buildYorumFormu(),

                          // Yorumlar
                          if (_yorumlar.isNotEmpty) _buildYorumlar(),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildYorumFormu() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yorum Yap',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _isimController,
            decoration: InputDecoration(
              labelText: 'İsim',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _yorumController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Yorumunuz',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.comment),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _yorumGonderiliyor ? null : _yorumGonder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _yorumGonderiliyor
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text(
                      'Gönder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYorumlar() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yorumlar (${_yorumlar.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ..._yorumlar.map((yorum) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red[700],
                        child: Text(
                          yorum.isim[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              yorum.isim,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              yorum.tarih,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(yorum.mesaj),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.thumb_up_outlined,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${yorum.begen}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Icon(Icons.thumb_down_outlined,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${yorum.begenme}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Alt yorumlar
                  if (yorum.altYorumlar.isNotEmpty)
                    ...yorum.altYorumlar.map((altYorum) {
                      return Container(
                        margin: const EdgeInsets.only(left: 24, top: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  altYorum.isim,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  altYorum.tarih,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              altYorum.mesaj,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
