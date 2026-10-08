import 'dart:convert';

import 'package:http/http.dart' as http;

class HoroscopeService {
  static const String _baseUrl =
      'https://api.astroway.info/v1/public/horoscope/daily';

  static const Map<String, String> _signMap = {
    'Koç': 'aries',
    'Boğa': 'taurus',
    'İkizler': 'gemini',
    'Yengeç': 'cancer',
    'Aslan': 'leo',
    'Başak': 'virgo',
    'Terazi': 'libra',
    'Akrep': 'scorpio',
    'Yay': 'sagittarius',
    'Oğlak': 'capricorn',
    'Kova': 'aquarius',
    'Balık': 'pisces',
  };

  static Future<Map<String, dynamic>?> getDailyData(
    String turkishSign,
  ) async {
    try {
      final sign = _signMap[turkishSign];

      if (sign == null) {
        return null;
      }

      final uri = Uri.parse(
        '$_baseUrl?sign=$sign&lang=tr',
      );

      final response = await http.get(
        uri,
        headers: const {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        return null;
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      if (decoded['ok'] != true) {
        return null;
      }

      final data = decoded['data'];

      if (data is! Map<String, dynamic>) {
        return null;
      }

      return Map<String, dynamic>.from(data);
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // GÜNÜN BURÇ YORUMU
  // Kısa + burca özel
  // ============================================================

  static String createCosmicaComment(
    String sign,
    Map<String, dynamic>? data,
  ) {
    final day = DateTime.now().day;

    final messages = _messagesForSign(sign);

    if (messages.isEmpty) {
      return 'Bugün kendi ritmini dinlemek sana iyi gelebilir.';
    }

    return messages[day % messages.length];
  }

  static List<String> _messagesForSign(String sign) {
    switch (sign) {
      case 'Koç':
        return [
          'Bugün harekete geçmek istediğin konuda cesur ol.',
          'Yeni bir başlangıç için güzel bir enerji taşıyorsun.',
          'Kararlarını fazla ertelemeden ilerlemeyi deneyebilirsin.',
          'Bugün enerjini doğru yere yönlendirmek önemli.',
          'Kendine güvenmen gereken bir gün olabilir.',
        ];

      case 'Boğa':
        return [
          'Bugün sakin kalmak sana düşündüğünden daha çok şey kazandırabilir.',
          'Güven duyduğun şeylere biraz daha fazla zaman ayır.',
          'Acele etmeden ilerlemek bugün senin avantajına.',
          'Küçük ama sağlam adımlar sana iyi gelebilir.',
          'Bugün huzurunu bozacak şeylerden biraz uzaklaş.',
        ];

      case 'İkizler':
        return [
          'Bugün bir konuşma sana yeni bir fikir verebilir.',
          'Merak ettiğin bir konunun peşinden gitmek iyi gelebilir.',
          'İletişimde olduğun insanlardan biri dikkatini çekebilir.',
          'Bugün zihnin oldukça hareketli olabilir.',
          'Yeni bir fikir beklemediğin bir anda gelebilir.',
        ];

      case 'Yengeç':
        return [
          'Bugün duygularını biraz daha fazla dinlemek isteyebilirsin.',
          'Kendine ayıracağın kısa bir zaman sana iyi gelebilir.',
          'Geçmişten gelen bir konu tekrar aklına düşebilir.',
          'Bugün huzurunu korumak her şeyden daha önemli olabilir.',
          'Hislerini görmezden gelmek yerine onlara kulak ver.',
        ];

      case 'Aslan':
        return [
          'Bugün kendini göstermekten çekinme.',
          'Dikkatini çeken bir konuda ilk adımı sen atabilirsin.',
          'Enerjini seni gerçekten heyecanlandıran şeylere ayır.',
          'Bugün özgüvenin çevrendekiler tarafından fark edilebilir.',
          'Kendin olmaktan vazgeçmeden ilerlemeye devam et.',
        ];

      case 'Başak':
        return [
          'Bugün her şeyi aynı anda çözmeye çalışma.',
          'Önceliklerini belirlemek gününü kolaylaştırabilir.',
          'Detaylara takılmadan büyük resme bakmayı dene.',
          'Bugün düzenlemek istediğin bir konu netleşebilir.',
          'Kendinden mükemmellik beklemek yerine ilerlemeye odaklan.',
        ];

      case 'Terazi':
        return [
          'Bugün ilişkilerinde açık olmak sana iyi gelebilir.',
          'Kendi isteklerini başkalarının önüne koymaktan çekinme.',
          'Bir konuşma aranızdaki bir konuyu netleştirebilir.',
          'Bugün dengeyi korumak senin için önemli olabilir.',
          'Karar verirken kendi sesini de dinlemeyi unutma.',
        ];

      case 'Akrep':
        return [
          'Bugün sezgilerine biraz daha fazla güvenebilirsin.',
          'Hemen tepki vermek yerine gözlem yapmayı seç.',
          'Aklındaki bir konu düşündüğünden daha net hale gelebilir.',
          'Bugün bazı şeyleri sessizce çözmek isteyebilirsin.',
          'İçinden gelen sese kulak vermenin zamanı olabilir.',
        ];

      case 'Yay':
        return [
          'Bugün rutininden çıkmak sana iyi gelebilir.',
          'Yeni bir fikir gününün havasını değiştirebilir.',
          'Farklı bir şey denemekten çekinme.',
          'Bugün merak ettiğin bir konunun peşinden git.',
          'Küçük bir değişiklik bile sana iyi gelebilir.',
        ];

      case 'Oğlak':
        return [
          'Bugün hedeflerine odaklanmak daha kolay olabilir.',
          'Her şeyi tek başına halletmek zorunda değilsin.',
          'Planlarından birine bugün küçük bir adım ekleyebilirsin.',
          'Sorumluluklarının arasında kendine de zaman ayır.',
          'Sabırlı ilerlemek bugün sana kazandırabilir.',
        ];

      case 'Kova':
        return [
          'Bugün farklı düşünmek sana avantaj sağlayabilir.',
          'Aklına gelen sıra dışı fikri hemen kenara atma.',
          'Kendi yolundan gitmek bugün daha doğru hissettirebilir.',
          'Yeni bir bakış açısı bir konuyu çözebilir.',
          'Bugün özgünlüğün ön plana çıkabilir.',
        ];

      case 'Balık':
        return [
          'Bugün sezgilerin sana güzel bir ipucu verebilir.',
          'Biraz yavaşlamak zihnini rahatlatabilir.',
          'Hayal gücünü kullanabileceğin bir konu gündeme gelebilir.',
          'Duygularını bastırmak yerine anlamaya çalış.',
          'Bugün kendine karşı daha anlayışlı ol.',
        ];

      default:
        return [
          'Bugün kendi ritmini dinlemek sana iyi gelebilir.',
          'Kendine biraz zaman ayırmayı unutma.',
          'Bugün küçük bir değişiklik iyi gelebilir.',
          'İçinden gelen sese kulak vermeyi dene.',
          'Bugün acele etmeden ilerlemek sana iyi gelebilir.',
        ];
    }
  }
}