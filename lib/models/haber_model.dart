class Haber {
  final String id;
  final String baslik;
  final String? ozet;
  final String? icerik;
  final String? resim;
  final String? kategori;
  final String? yazar;
  final String? tarih;
  final String? goruntulenme;
  final String? url;
  final String? kategoriid;

  Haber({
    required this.id,
    required this.baslik,
    this.ozet,
    this.icerik,
    this.resim,
    this.kategori,
    this.yazar,
    this.tarih,
    this.goruntulenme,
    this.url,
    this.kategoriid,
  });

  factory Haber.fromJson(Map<String, dynamic> json) {
    // API'den gelen alan isimlerini buraya göre ayarlayın
    return Haber(
        id: json['haberid']?.toString() ?? json['id']?.toString() ?? '0',
        baslik: json['baslik']?.toString() ?? json['baslik']?.toString() ?? '',
        ozet: json['kisa_aciklama']?.toString() ??
            json['kisa_aciklama']?.toString(),
        icerik: json['detay']?.toString() ?? json['detay']?.toString(),
        resim: (json['mansetresim'] != null &&
                json['mansetresim'].toString().isNotEmpty)
            ? 'https://www.akyazihaber.com/${json['mansetresim']}'
            : (json['sagmansetresim'] != null &&
                    json['sagmansetresim'].toString().isNotEmpty)
                ? 'https://www.akyazihaber.com/${json['sagmansetresim']}'
                : (json['kategoriresim'] != null &&
                        json['kategoriresim'].toString().isNotEmpty)
                    ? 'https://www.akyazihaber.com/${json['kategoriresim']}'
                    : null,
        kategori: json['kategoribaslik']?.toString() ??
            json['kategoribaslik']?.toString(),
        yazar: json['muhabir']?.toString() ?? json['muhabir']?.toString(),
        tarih: json['kayittarih']?.toString() ?? json['kayittarih']?.toString(),
        goruntulenme: json['hit']?.toString() ?? json['hit']?.toString(),
        url: 'https://www.akyazihaber.com/${json['seo']}',
        kategoriid:
            json['kategoriid']?.toString() ?? json['kategoriid']?.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baslik': baslik,
      'ozet': ozet,
      'icerik': icerik,
      'resim': resim,
      'kategori': kategori,
      'yazar': yazar,
      'tarih': tarih,
      'goruntulenme': goruntulenme,
      'url': url,
      'kategoriid': kategoriid
    };
  }
}
