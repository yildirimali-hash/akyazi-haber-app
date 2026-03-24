import 'package:intl/intl.dart';

class TarihHelper {
  static String formatla(String tarihStr) {
    try {
      // API'den gelen tarih formatını parse et
      DateTime tarih;

      // Farklı tarih formatlarını dene
      try {
        tarih = DateTime.parse(tarihStr);
      } catch (e) {
        // Eğer parse edilemezse, farklı format dene
        try {
          tarih = DateFormat('dd.MM.yyyy HH:mm:ss').parse(tarihStr);
        } catch (e) {
          tarih = DateFormat('dd.MM.yyyy').parse(tarihStr);
        }
      }

      final simdi = DateTime.now();
      final fark = simdi.difference(tarih);

      // Eğer bugün ise
      if (fark.inDays == 0) {
        if (fark.inHours == 0) {
          if (fark.inMinutes == 0) {
            //return 'Şimdi';
          }
          // return '${fark.inMinutes} dakika önce';
        }
        //return '${fark.inHours} saat önce';
      }

      // Eğer dün ise
      if (fark.inDays == 1) {
        //return 'Dün ${DateFormat('HH:mm').format(tarih)}';
      }

      // Eğer bu hafta ise
      if (fark.inDays < 7) {
        //return '${fark.inDays} gün önce';
      }

      // Aksi halde tam tarih
      return DateFormat('dd.MM.yyyy HH:mm').format(tarih);
    } catch (e) {
      return tarihStr; // Hata durumunda orijinal string'i döndür
    }
  }

  static String tamTarih(String tarihStr) {
    try {
      final tarih = DateTime.parse(tarihStr);
      return DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(tarih);
    } catch (e) {
      return tarihStr;
    }
  }
}
