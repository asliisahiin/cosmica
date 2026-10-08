import 'dart:convert';
import 'package:http/http.dart' as http;

class BirthChartService {
  static const String endpoint =
      'https://dogum-haritasi-app.onrender.com/api/birth-chart';

  static Future<Map<String, dynamic>> getBirthChart({
    required String birthDate,
    required String birthTime,
    required String city,
  }) async {
    try {
      print('📤 API YE GİDEN VERİ:');
      print('birth_date: $birthDate');
      print('birth_time: $birthTime');
      print('city: $city');

      final response = await http.post(
        Uri.parse(endpoint),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'birth_date': birthDate,
          'birth_time': birthTime,
          'city': city,
        }),
      );

      print('📥 API STATUS: ${response.statusCode}');
      print('📥 API RESPONSE: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(
          'Doğum haritası alınamadı. '
          'Status code: ${response.statusCode}',
        );
      }

      final decoded = utf8.decode(response.bodyBytes);

      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      print('❌ API HATASI: $e');
      rethrow;
    }
  }
}