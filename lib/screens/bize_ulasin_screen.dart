import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class BizeUlasinScreen extends StatefulWidget {
  const BizeUlasinScreen({super.key});

  @override
  State<BizeUlasinScreen> createState() => _BizeUlasinScreenState();
}

class _BizeUlasinScreenState extends State<BizeUlasinScreen> {
  final ApiService _apiService = ApiService();
  bool _yukleniyor = true;
  Map<String, dynamic>? _icerik;

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  Future<void> _verileriYukle() async {
    setState(() => _yukleniyor = true);

    try {
      final icerik = await _apiService.getBizeUlasin();
      setState(() {
        _icerik = icerik;
        _yukleniyor = false;
      });
    } catch (e) {
      setState(() => _yukleniyor = false);
    }
  }

  Future<void> _telefonAra(String telefon) async {
    final telUri = Uri.parse('tel:${telefon.replaceAll(RegExp(r'[^\d]'), '')}');
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    }
  }

  Future<void> _emailGonder(String email) async {
    final emailUri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _haritadaAc(String adres) async {
    final encodedAddress = Uri.encodeComponent(adres);
    final googleMapsUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encodedAddress');

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bize Ulaşın'),
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : _icerik == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 60, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('İçerik yüklenemedi'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _verileriYukle,
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _verileriYukle,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Başlık
                        if (_icerik!['baslik'] != null) ...[
                          Text(
                            _icerik!['baslik'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // İletişim Bilgileri Kartları
                        if (_icerik!['telefon'] != null)
                          _buildIletisimCard(
                            icon: Icons.phone,
                            baslik: 'Telefon',
                            icerik: _icerik!['telefon'],
                            onTap: () => _telefonAra(_icerik!['telefon']),
                          ),

                        if (_icerik!['email'] != null)
                          _buildIletisimCard(
                            icon: Icons.email,
                            baslik: 'E-posta',
                            icerik: _icerik!['email'],
                            onTap: () => _emailGonder(_icerik!['email']),
                          ),

                        if (_icerik!['adres'] != null)
                          _buildIletisimCard(
                            icon: Icons.location_on,
                            baslik: 'Adres',
                            icerik: _icerik!['adres'],
                            onTap: () => _haritadaAc(_icerik!['adres']),
                          ),

                        if (_icerik!['whatsapp'] != null)
                          _buildIletisimCard(
                            icon: Icons.message,
                            baslik: 'WhatsApp',
                            icerik: _icerik!['whatsapp'],
                            onTap: () => _telefonAra(_icerik!['whatsapp']),
                          ),

                        // Açıklama
                        if (_icerik!['aciklama'] != null) ...[
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),
                          Text(
                            _icerik!['aciklama'],
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildIletisimCard({
    required IconData icon,
    required String baslik,
    required String icerik,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.red[700], size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      baslik,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      icerik,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
