import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/eczane_model.dart';
import '../services/api_service.dart';
import '../services/analytics_service.dart';

class NobetciEczanelerScreen extends StatefulWidget {
  const NobetciEczanelerScreen({super.key});

  @override
  State<NobetciEczanelerScreen> createState() => _NobetciEczanelerScreenState();
}

class _NobetciEczanelerScreenState extends State<NobetciEczanelerScreen> {
  final ApiService _apiService = ApiService();
  NobetciEczaneResponse? _response;
  bool _yukleniyor = true;
  String? _hata;

  @override
  void initState() {
    super.initState();
    _eczaneleriYukle();
    AnalyticsService.logScreenView('nobetci_eczaneler');
  }

  Future<void> _eczaneleriYukle() async {
    setState(() {
      _yukleniyor = true;
      _hata = null;
    });

    try {
      final response = await _apiService.getNobetciEczaneler();
      setState(() {
        _response = response;
        _yukleniyor = false;
      });
    } catch (e) {
      setState(() {
        _hata = e.toString();
        _yukleniyor = false;
      });
    }
  }

  Future<void> _telefonAra(String telefon) async {
    final telUri = Uri.parse('tel:${telefon.replaceAll(RegExp(r'[^\d]'), '')}');
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Telefon açılamadı')),
        );
      }
    }
  }

  Future<void> _haritadaAc(String adres) async {
    final encodedAddress = Uri.encodeComponent(adres);
    final googleMapsUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encodedAddress');

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(
        googleMapsUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harita açılamadı')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Nöbetçi Eczaneler'),
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
                      const Text('Veriler yüklenemedi'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _eczaneleriYukle,
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                )
              : _response == null || !_response!.success
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_pharmacy,
                                size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Henüz nöbetçi eczane listesi eklenmedi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _eczaneleriYukle,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Günün Nöbetçisi (Öne Çıkan)
                            if (_response!.nobetci != null)
                              _buildNobetciCard(_response!.nobetci!),

                            // Liste Başlığı
                            if (_response!.liste.isNotEmpty)
                              const Padding(
                                padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                                child: Text(
                                  'Nöbetçi Eczaneler',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                            // Liste
                            ..._response!.liste.map((eczane) {
                              return _buildEczaneCard(eczane);
                            }).toList(),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget _buildNobetciCard(Eczane eczane) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[700]!, Colors.red[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_pharmacy, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'BUGÜN NÖBETÇİ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  eczane.baslik,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  eczane.tarih,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _telefonAra(eczane.telefon),
                        icon: const Icon(Icons.phone, size: 20),
                        label: Text(
                          eczane.telefon,
                          style: const TextStyle(fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red[700],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => _haritadaAc(eczane.maps),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red[700],
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Icon(Icons.map, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  eczane.maps,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEczaneCard(Eczane eczane) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.local_pharmacy,
                      color: Colors.red[700],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eczane.baslik,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          eczane.tarih,
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
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _telefonAra(eczane.telefon),
                      icon: const Icon(Icons.phone, size: 18),
                      label: Text(eczane.telefon),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[700],
                        side: BorderSide(color: Colors.red[700]!),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => _haritadaAc(eczane.maps),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red[700],
                      side: BorderSide(color: Colors.red[700]!),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: const Icon(Icons.map, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                eczane.maps,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
