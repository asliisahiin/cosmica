import 'package:flutter/material.dart';

class ProScreen extends StatelessWidget {
  const ProScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.auto_awesome,
        'title': 'Detaylı Doğum Haritası Analizi',
        'description':
            'Gezegenlerinin ve evlerinin hayatındaki etkilerini daha detaylı keşfet.',
      },
      {
        'icon': Icons.favorite_outline,
        'title': 'İlişki ve Aşk Analizi',
        'description':
            'Aşk hayatındaki astrolojik temaları ve ilişki dinamiklerini keşfet.',
      },
      {
        'icon': Icons.psychology_outlined,
        'title': 'Derin Kişilik Analizi',
        'description':
            'Haritandaki önemli göstergeler üzerinden daha kapsamlı bir profil.',
      },
      {
        'icon': Icons.timeline,
        'title': 'Yıllık Astroloji Raporu',
        'description':
            'Önümüzdeki dönemin önemli astrolojik temalarını incele.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosmica Pro'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8B5CF6),
                    Color(0xFF5B21B6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Column(
                children: [
                  Text(
                    '✨',
                    style: TextStyle(fontSize: 48),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'COSMICA PRO',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Gökyüzünü daha derin keşfet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Premium özellikler',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 14),

            ...features.map(
              (feature) => Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: const Color(0xFF17102D),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        feature['icon'] as IconData,
                        color: const Color(0xFFB794F6),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            feature['description'] as String,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.lock_outline,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Cosmica Pro çok yakında aktif olacak ✨',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text(
                  'Cosmica Pro\'yu Keşfet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Premium özellikler uygulamanın sonraki sürümünde aktif edilecektir.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}