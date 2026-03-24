class Kategori {
  final String id;
  final String ad;
  final String? renk;
  final String? ikon;

  Kategori({
    required this.id,
    required this.ad,
    this.renk,
    this.ikon,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['kategoriid']?.toString() ?? json['id']?.toString() ?? '0',
      ad: json['kategoriad']?.toString() ?? json['baslik']?.toString() ?? '',
      renk: json['kategorirenk']?.toString() ?? json['renk']?.toString(),
      ikon: json['kategoriikon']?.toString() ?? json['ikon']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'renk': renk,
      'ikon': ikon,
    };
  }
}
