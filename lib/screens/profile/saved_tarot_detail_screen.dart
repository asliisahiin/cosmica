import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavedTarotDetailScreen extends StatelessWidget {
  final String readingId;
  final Map<String, dynamic> reading;

  const SavedTarotDetailScreen({
    super.key,
    required this.readingId,
    required this.reading,
  });

  String _formatDate(dynamic value) {
    if (value is! Timestamp) {
      return '';
    }

    final date = value.toDate();

    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final title =
        reading['title']?.toString() ?? 'Tarot Açılımı';

    final createdAt = reading['createdAt'];

    final cards =
        (reading['cards'] as List<dynamic>?) ?? [];

    final overallReading =
        reading['overallReading']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarot Açılımı'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
            ),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Açılımı Sil'),
                    content: const Text(
                      'Bu tarot açılımını silmek istediğine emin misin?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Vazgeç'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text(
                          'Sil',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );

              if (shouldDelete != true) return;

              final user = FirebaseAuth.instance.currentUser;

              if (user == null) return;

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('tarotReadings')
                  .doc(readingId)
                  .delete();

              if (!context.mounted) return;

              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _formatDate(createdAt),
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 24),

            ...List.generate(cards.length, (index) {
              final card =
                  cards[index] as Map<String, dynamic>;

              final name =
                  card['name']?.toString() ?? 'Kart';

              final suit =
                  card['suit']?.toString() ?? '';

              final meaning =
                  card['meaning']?.toString() ?? '';

              final energy =
                  card['energy']?.toString() ?? '';

              final position =
                  card['position']?.toString() ??
                  'Kart ${index + 1}';

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF17102D),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      position,
                      style: const TextStyle(
                        color: Color(0xFFB794F6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (suit.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        suit,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),

                    Text(
                      meaning,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    if (energy.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        energy,
                        style: const TextStyle(
                          color: Color(0xFFB794F6),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),

            if (overallReading.isNotEmpty) ...[
              const SizedBox(height: 10),

              const Text(
                'Genel Yorum',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF17102D),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  overallReading,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            const Text(
              'Tarot yorumları sembolik ve eğlence amaçlıdır. '
              'Kesin gelecek tahmini olarak değerlendirilmemelidir.',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}