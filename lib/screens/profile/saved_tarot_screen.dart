import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'saved_tarot_detail_screen.dart';

class SavedTarotScreen extends StatelessWidget {
  const SavedTarotScreen({super.key});

  static const List<Map<String, dynamic>> _spreadTypes = [
    {
      'title': 'Aşk Açılımı',
      'icon': Icons.favorite_outline,
    },
    {
      'title': 'Günün Kartı',
      'icon': Icons.auto_awesome,
    },
    {
      'title': 'Üç Kart',
      'icon': Icons.style_outlined,
    },
    {
      'title': 'Karar Açılımı',
      'icon': Icons.alt_route,
    },
    {
      'title': 'Kelt Haçı',
      'icon': Icons.blur_circular,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaydedilen Kartlar'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          40,
        ),
        itemCount: _spreadTypes.length,
        itemBuilder: (context, index) {
          final spread = _spreadTypes[index];

          return _SpreadTile(
            title: spread['title'] as String,
            icon: spread['icon'] as IconData,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SavedTarotCategoryScreen(
                    spreadTitle: spread['title'] as String,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SpreadTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SpreadTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF17102D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF312E81),
                Color(0xFF6D28D9),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 25,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            'Kayıtlı açılımlarını görüntüle',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white38,
        ),
      ),
    );
  }
}

class SavedTarotCategoryScreen extends StatelessWidget {
  final String spreadTitle;

  const SavedTarotCategoryScreen({
    super.key,
    required this.spreadTitle,
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
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Kullanıcı bulunamadı'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(spreadTitle),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
       stream: FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .collection('tarotReadings')
    .where(
      'spreadTitle',
      isEqualTo: spreadTitle,
    )
    .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  'Kayıtlı açılımlar yüklenemedi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ),
            );
          }

         final readings = [...(snapshot.data?.docs ?? [])];

readings.sort((a, b) {
  final aDate = a.data()['createdAt'];
  final bDate = b.data()['createdAt'];

  if (aDate is Timestamp && bDate is Timestamp) {
    return bDate.compareTo(aDate);
  }

  return 0;
});

          if (readings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '🃏',
                      style: TextStyle(fontSize: 50),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Henüz kayıtlı $spreadTitle yok',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Bu açılımı kaydettiğinde burada görebilirsin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              40,
            ),
            itemCount: readings.length,
            itemBuilder: (context, index) {
              final doc = readings[index];
              final reading = doc.data();

              final cards =
                  reading['cards'] is List
                      ? reading['cards'] as List
                      : [];

              final date =
                  _formatDate(reading['createdAt']);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF17102D),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6)
                        .withValues(alpha: 0.12),
                  ),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  leading: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF312E81),
                          Color(0xFF6D28D9),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        '✦',
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    '$spreadTitle #${readings.length - index}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding:
                        const EdgeInsets.only(top: 6),
                    child: Text(
                      '${cards.length} kart'
                      '${date.isNotEmpty ? ' • $date' : ''}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white38,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SavedTarotDetailScreen(
                          readingId: doc.id,
                          reading: reading,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}