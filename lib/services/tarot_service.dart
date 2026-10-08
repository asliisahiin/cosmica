import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TarotService {
  static Future<void> saveReading({
    required String spreadTitle,
    required List<Map<String, dynamic>> cards,
    required String overallReading,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Kullanıcı giriş yapmamış.');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tarotReadings')
        .add({
      'spreadTitle': spreadTitle,
      'cards': cards,
      'overallReading': overallReading,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}