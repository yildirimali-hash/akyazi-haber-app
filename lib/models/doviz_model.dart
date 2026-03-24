class Doviz {
  final double? dolar;
  final String? dolarDurum;
  final double? euro;
  final String? euroDurum;
  final double? sterlin;
  final String? sterlinDurum;
  final double? altin;
  final String? altinDurum;
  final double? gumus;
  final String? gumusDurum;

  Doviz({
    this.dolar,
    this.dolarDurum,
    this.euro,
    this.euroDurum,
    this.sterlin,
    this.sterlinDurum,
    this.altin,
    this.altinDurum,
    this.gumus,
    this.gumusDurum,
  });

  factory Doviz.fromJson(Map<String, dynamic> json) {
    return Doviz(
      dolar: _parseDouble(json['dolar']),
      dolarDurum: json['dolar_durum']?.toString(),
      euro: _parseDouble(json['euro']),
      euroDurum: json['euro_durum']?.toString(),
      sterlin: _parseDouble(json['sterlin']),
      sterlinDurum: json['sterlin_durum']?.toString(),
      altin: _parseDouble(json['altin']),
      altinDurum: json['altin_durum']?.toString(),
      gumus: _parseDouble(json['gumus']),
      gumusDurum: json['gumus_durum']?.toString(),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  bool isDurumUp(String? durum) => durum == 'up';
  bool isDurumDown(String? durum) => durum == 'down';
}
