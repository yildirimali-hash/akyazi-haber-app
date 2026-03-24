class Reklam {
  final bool success;
  final String data;
  final String tip; // "img" veya "kod"

  Reklam({
    required this.success,
    required this.data,
    required this.tip,
  });

  factory Reklam.fromJson(Map<String, dynamic> json) {
    return Reklam(
      success: json['success'] ?? false,
      data: json['data']?.toString() ?? '',
      tip: json['tip']?.toString() ?? 'img',
    );
  }

  bool get isImage => tip == 'img';
  bool get isCode => tip == 'kod';
  
  String get imageUrl => isImage && data.isNotEmpty 
      ? 'https://www.akyazihaber.com/$data'
      : '';
}
