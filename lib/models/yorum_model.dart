class Yorum {
  final String isim;
  final String mesaj;
  final int begen;
  final int begenme;
  final String tarih;
  final List<AltYorum> altYorumlar;

  Yorum({
    required this.isim,
    required this.mesaj,
    required this.begen,
    required this.begenme,
    required this.tarih,
    required this.altYorumlar,
  });

  factory Yorum.fromJson(Map<String, dynamic> json) {
    List<AltYorum> altYorumlar = [];
    
    if (json['altyorumlar'] != null) {
      if (json['altyorumlar'] is List) {
        altYorumlar = (json['altyorumlar'] as List)
            .map((e) => AltYorum.fromJson(e))
            .toList();
      } else if (json['altyorumlar'] is Map) {
        altYorumlar = [AltYorum.fromJson(json['altyorumlar'])];
      }
    }

    return Yorum(
      isim: json['isim']?.toString() ?? 'Ziyaretçi',
      mesaj: json['mesaj']?.toString() ?? '',
      begen: int.tryParse(json['begen']?.toString() ?? '0') ?? 0,
      begenme: int.tryParse(json['begenme']?.toString() ?? '0') ?? 0,
      tarih: json['tarih']?.toString() ?? '',
      altYorumlar: altYorumlar,
    );
  }
}

class AltYorum {
  final String isim;
  final String mesaj;
  final int begen;
  final int begenme;
  final String tarih;

  AltYorum({
    required this.isim,
    required this.mesaj,
    required this.begen,
    required this.begenme,
    required this.tarih,
  });

  factory AltYorum.fromJson(Map<String, dynamic> json) {
    return AltYorum(
      isim: json['isim']?.toString() ?? 'Ziyaretçi',
      mesaj: json['mesaj']?.toString() ?? '',
      begen: int.tryParse(json['begen']?.toString() ?? '0') ?? 0,
      begenme: int.tryParse(json['begenme']?.toString() ?? '0') ?? 0,
      tarih: json['tarih']?.toString() ?? '',
    );
  }
}
