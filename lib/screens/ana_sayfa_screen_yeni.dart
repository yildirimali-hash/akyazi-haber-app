import 'package:flutter/material.dart';
import '../models/haber_model.dart';
import '../models/kategori_model.dart';
import '../models/reklam_model.dart';
import '../models/doviz_model.dart';
import '../models/yazar_model.dart';
import '../services/api_service.dart';
import '../widgets/manset_carousel.dart';
import '../widgets/yatay_haber_listesi.dart';
import '../widgets/reklam_widget.dart';
import '../widgets/doviz_widget.dart';
import '../widgets/yazar_listesi.dart';
import '../widgets/haber_card.dart';
import 'haber_detay_screen.dart';
import 'yazar_detay_screen.dart';
import 'kategori_haberler_screen.dart';
import 'nobetci_eczaneler_screen.dart';
import 'bize_ulasin_screen.dart';
import 'hakkimizda_screen.dart';
import '../services/analytics_service.dart';

class AnaSayfaScreen extends StatefulWidget {
  const AnaSayfaScreen({super.key});

  @override
  State<AnaSayfaScreen> createState() => _AnaSayfaScreenState();
}

class _AnaSayfaScreenState extends State<AnaSayfaScreen> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  List<Kategori> _kategoriler = [];
  List<Haber> _mansetler = [];
  List<Haber> _mansetYaniHaberler = [];
  List<Haber> _mansetAltiHaberler = [];
  List<Yazar> _yazarlar = [];
  Doviz? _doviz;
  Reklam? _reklam1;
  Reklam? _reklam2;
  Reklam? _reklam3;
  Reklam? _reklam4;
  Reklam? _reklam5;

  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _verileriYukle();
    AnalyticsService.logScreenView('ana_sayfa');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _verileriYukle() async {
    setState(() => _yukleniyor = true);

    try {
      // Paralel olarak tüm verileri çek
      final results = await Future.wait([
        _apiService.getKategoriler(),
        _apiService.getMansetler(),
        _apiService.getMansetYaniHaberler(),
        _apiService.getMansetAltiHaberler(),
        _apiService.getYazarlar(),
        _apiService.getDoviz(),
        _apiService.getReklam('reklamlar1'),
        _apiService.getReklam('reklamlar2'),
        _apiService.getReklam('reklamlar3'),
        _apiService.getReklam('reklamlar4'),
        _apiService.getReklam('reklamlar5'),
      ]);

      setState(() {
        _kategoriler = results[0] as List<Kategori>;
        _mansetler = results[1] as List<Haber>;
        _mansetYaniHaberler = results[2] as List<Haber>;
        _mansetAltiHaberler = results[3] as List<Haber>;
        _yazarlar = results[4] as List<Yazar>;
        _doviz = results[5] as Doviz?;
        _reklam1 = results[6] as Reklam?;
        _reklam2 = results[7] as Reklam?;
        _reklam3 = results[8] as Reklam?;
        _reklam4 = results[9] as Reklam?;
        _reklam5 = results[10] as Reklam?;
        _yukleniyor = false;
      });
    } catch (e) {
      setState(() => _yukleniyor = false);
    }
  }

  void _haberDetayGit(Haber haber) {
    AnalyticsService.logHaberGoruntuleme(haber.id, haber.baslik);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HaberDetayScreen(haberId: haber.id),
      ),
    );
  }

  void _yazarDetayGit(Yazar yazar) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YazarDetayScreen(yaziId: yazar.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
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
          centerTitle: true),
      drawer: _buildDrawer(),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _verileriYukle,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Reklam 1 & 2
                    if (_reklam1 != null)
                      ReklamWidget(reklam: _reklam1, height: 50),
                    if (_reklam2 != null)
                      ReklamWidget(reklam: _reklam2, height: 50),

                    // Manşet Carousel
                    if (_mansetler.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      MansetCarousel(
                        haberler: _mansetler,
                        onTap: _haberDetayGit,
                      ),
                    ],

                    // Reklam 3
                    if (_reklam3 != null)
                      ReklamWidget(reklam: _reklam3, height: 50),

                    // Manşet Yanı Haberler (Yatay)
                    if (_mansetYaniHaberler.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      YatayHaberListesi(
                        haberler: _mansetYaniHaberler.take(10).toList(),
                        onTap: _haberDetayGit,
                        baslik: 'Öne Çıkanlar',
                      ),
                    ],

                    // Reklam 4
                    if (_reklam4 != null)
                      ReklamWidget(reklam: _reklam4, height: 50),

                    // Döviz Kurları
                    if (_doviz != null) ...[
                      const SizedBox(height: 16),
                      DovizWidget(doviz: _doviz!),
                    ],

                    // Yazarlar
                    if (_yazarlar.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      YazarListesi(
                        yazarlar: _yazarlar.take(10).toList(),
                        onTap: _yazarDetayGit,
                      ),
                    ],

                    // Reklam 5
                    if (_reklam5 != null)
                      ReklamWidget(reklam: _reklam5, height: 50),

                    // Manşet Altı Haberler (Liste)
                    if (_mansetAltiHaberler.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                        child: Text(
                          'Son Haberler',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: _mansetAltiHaberler.length,
                        itemBuilder: (context, index) {
                          final haber = _mansetAltiHaberler[index];
                          return HaberCard(
                            haber: haber,
                            onTap: () => _haberDetayGit(haber),
                          );
                        },
                      ),
                    ],

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // ← Köşeleri kaldır
      ),
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red[700],
              borderRadius: BorderRadius.zero,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.newspaper,
                      size: 60,
                      color: Colors.white,
                    );
                  },
                ),
                const SizedBox(height: 8),
                const Text(
                  'Akyazı\'nın Bir Numaralı Haber Sitesi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Ana Sayfa'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.local_pharmacy),
                  title: const Text('Nöbetçi Eczaneler'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NobetciEczanelerScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Kategoriler',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ..._kategoriler.map((kategori) {
                  return ListTile(
                    leading: const Icon(Icons.label_outline, size: 20),
                    title: Text(kategori.ad),
                    dense: true,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KategoriHaberlerScreen(
                            kategori: kategori,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Kurumsal',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Hakkımızda'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HakkimizdaScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.contact_mail),
                  title: const Text('Bize Ulaşın'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BizeUlasinScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
