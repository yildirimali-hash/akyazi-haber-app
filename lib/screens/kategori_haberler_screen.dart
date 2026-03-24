import 'package:flutter/material.dart';
import '../models/haber_model.dart';
import '../models/kategori_model.dart';
import '../services/api_service.dart';
import '../widgets/haber_card.dart';
import 'haber_detay_screen.dart';
import '../services/analytics_service.dart';

class KategoriHaberlerScreen extends StatefulWidget {
  final Kategori kategori;

  const KategoriHaberlerScreen({
    super.key,
    required this.kategori,
  });

  @override
  State<KategoriHaberlerScreen> createState() => _KategoriHaberlerScreenState();
}

class _KategoriHaberlerScreenState extends State<KategoriHaberlerScreen> {
  final ApiService _apiService = ApiService();
  List<Haber> _haberler = [];
  bool _yukleniyor = true;
  String? _hata;

  @override
  void initState() {
    super.initState();
    _haberleriYukle();

    AnalyticsService.logScreenView('kategori');
  }

  Future<void> _haberleriYukle() async {
    setState(() {
      _yukleniyor = true;
      _hata = null;
    });

    try {
      final haberler =
          await _apiService.getKategoriHaberleri(widget.kategori.id);
      setState(() {
        _haberler = haberler;
        _yukleniyor = false;
      });
    } catch (e) {
      setState(() {
        _hata = e.toString();
        _yukleniyor = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.kategori.ad),
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
                      Text(
                        'Haberler yüklenemedi',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _hata!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _haberleriYukle,
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                )
              : _haberler.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article_outlined,
                              size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Bu kategoride henüz haber yok',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _haberleriYukle,
                      child: ListView.builder(
                        itemCount: _haberler.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final haber = _haberler[index];
                          return HaberCard(
                            haber: haber,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HaberDetayScreen(
                                    haberId: haber.id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
    );
  }
}
