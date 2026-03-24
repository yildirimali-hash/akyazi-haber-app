import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HakkimizdaScreen extends StatefulWidget {
  const HakkimizdaScreen({super.key});

  @override
  State<HakkimizdaScreen> createState() => _HakkimizdaScreenState();
}

class _HakkimizdaScreenState extends State<HakkimizdaScreen> {
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
      final icerik = await _apiService.getHakkimizda();
      setState(() {
        _icerik = icerik;
        _yukleniyor = false;
      });
    } catch (e) {
      setState(() => _yukleniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hakkımızda'),
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : _icerik == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.grey),
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
                        // Logo/Resim (varsa)
                        if (_icerik!['resim'] != null) ...[
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _icerik!['resim'],
                                height: 120,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.newspaper,
                                      size: 60,
                                      color: Colors.red[700],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Başlık
                        if (_icerik!['baslik'] != null) ...[
                          Center(
                            child: Text(
                              _icerik!['baslik'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],

                        // Alt Başlık
                        if (_icerik!['slogan'] != null) ...[
                          Center(
                            child: Text(
                              _icerik!['slogan'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],

                        // İçerik
                        if (_icerik!['icerik'] != null) ...[
                          Text(
                            _icerik!['icerik'],
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.8,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],

                        // Misyon
                        if (_icerik!['misyon'] != null)
                          _buildInfoCard(
                            icon: Icons.flag,
                            baslik: 'Misyonumuz',
                            icerik: _icerik!['misyon'],
                          ),

                        // Vizyon
                        if (_icerik!['vizyon'] != null)
                          _buildInfoCard(
                            icon: Icons.visibility,
                            baslik: 'Vizyonumuz',
                            icerik: _icerik!['vizyon'],
                          ),

                        // Değerler
                        if (_icerik!['degerler'] != null)
                          _buildInfoCard(
                            icon: Icons.stars,
                            baslik: 'Değerlerimiz',
                            icerik: _icerik!['degerler'],
                          ),

                        // Kuruluş Yılı
                        if (_icerik!['kurulus_yili'] != null) ...[
                          const SizedBox(height: 24),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.calendar_today, 
                                    size: 20, 
                                    color: Colors.red[700],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Kuruluş: ${_icerik!['kurulus_yili']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String baslik,
    required String icerik,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.red[700], size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  baslik,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              icerik,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
