// lib/services/daily_message_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DailyMessageService {
  static Future<String> syncTodayMessage({
    required String fallbackMessage,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return fallbackMessage;

    final now = DateTime.now();
    final dateKey = 
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final messageRef =
        userRef.collection('daily_messages').doc(dateKey);
    final notificationRef =
        userRef.collection('notifications').doc('daily_message_$dateKey');

    return FirebaseFirestore.instance
        .runTransaction<String>((transaction) async {
      final messageSnapshot = await transaction.get(messageRef);
      final notificationSnapshot = await transaction.get(notificationRef);

      final saved = messageSnapshot.data()?['message'];
      final message = saved is String && saved.isNotEmpty
          ? saved
          : fallbackMessage;

      if (!messageSnapshot.exists) {
        transaction.set(messageRef, {
          'message': message,
          'dateKey': dateKey,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (!notificationSnapshot.exists) {
        transaction.set(notificationRef, {
          'title': '✨ Bugünün Mesajı',
          'body': message,
          'type': 'daily_message',
          'dateKey': dateKey,
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return message;
    });
  }
}