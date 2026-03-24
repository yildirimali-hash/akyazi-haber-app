class Eczane {
  final String baslik;
  final String telefon;
  final String maps;
  final String tarih;

  Eczane({
    required this.baslik,
    required this.telefon,
    required this.maps,
    required this.tarih,
  });

  factory Eczane.fromJson(Map<String, dynamic> json) {
    return Eczane(
      baslik: json['baslik']?.toString() ?? '',
      telefon: json['telefon']?.toString() ?? '',
      maps: json['maps']?.toString() ?? '',
      tarih: json['tarih']?.toString() ?? '',
    );
  }

  // Telefonu temizle (sadece rakamlar)
  String get temizTelefon {
    return telefon.replaceAll(RegExp(r'[^\d]'), '');
  }
}

class NobetciEczaneResponse {
  final bool success;
  final Eczane? nobetci;
  final List<Eczane> liste;

  NobetciEczaneResponse({
    required this.success,
    this.nobetci,
    required this.liste,
  });

  factory NobetciEczaneResponse.fromJson(Map<String, dynamic> json) {
    return NobetciEczaneResponse(
      success: json['success'] ?? false,
      nobetci: json['nobetci'] != null
          ? Eczane.fromJson(Map<String, dynamic>.from(json['nobetci']))
          : null,
      liste: json['liste'] != null
          ? (json['liste'] as List)
              .map((e) => Eczane.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : [],
    );
  }
}
