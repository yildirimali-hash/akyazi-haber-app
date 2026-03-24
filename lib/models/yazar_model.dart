class Yazar {
  final String id;
  final String baslik;
  final String? ozet;
  final String? detay;
  final String? resim;
  final String? yazarAdi;
  final String? tarih;
  final String? url;

  Yazar({
    required this.id,
    required this.baslik,
    this.ozet,
    this.detay,
    this.resim,
    this.yazarAdi,
    this.tarih,
    this.url,
  });

  factory Yazar.fromJson(Map<String, dynamic> json) {
    return Yazar(
      id: json['id']?.toString() ?? '0',
      baslik: json['baslik']?.toString() ?? '',
      ozet: json['kisa_aciklama']?.toString() ?? json['ozet']?.toString(),
      detay: json['detay']?.toString(),
      resim: json['resim'] != null && json['resim'].toString().isNotEmpty
          ? 'https://www.akyazihaber.com/${json['resim']}'
          : null,
      yazarAdi: json['yazar_adi']?.toString() ?? json['yazar']?.toString(),
      tarih: json['tarih']?.toString() ?? json['kayittarih']?.toString(),
      url: json['url']?.toString() ?? json['url']?.toString(),
    );
  }
}
