import 'package:flutter/material.dart';

class NumerologyCard extends StatelessWidget {
  final DateTime birthDate;

  const NumerologyCard({
    super.key,
    required this.birthDate,
  });

  int _reduceNumber(int number) {
    while (number > 9 && number != 11 && number != 22 && number != 33) {
      number = number
          .toString()
          .split('')
          .map(int.parse)
          .reduce((a, b) => a + b);
    }

    return number;
  }

  int _lifePathNumber() {
    final digits = '${birthDate.day}${birthDate.month}${birthDate.year}'
        .split('')
        .map(int.parse)
        .fold(0, (sum, digit) => sum + digit);

    return _reduceNumber(digits);
  }

  String _meaning(int number) {
    switch (number) {
      case 1:
        return 'Liderlik, bağımsızlık ve yeni başlangıçlar';
      case 2:
        return 'Uyum, sezgi ve güçlü ilişkiler';
      case 3:
        return 'Yaratıcılık, iletişim ve neşe';
      case 4:
        return 'Düzen, disiplin ve sağlam temeller';
      case 5:
        return 'Özgürlük, değişim ve macera';
      case 6:
        return 'Sorumluluk, sevgi ve koruyuculuk';
      case 7:
        return 'İçgörü, araştırma ve derin düşünce';
      case 8:
        return 'Güç, hedefler ve başarı';
      case 9:
        return 'Şefkat, idealizm ve tamamlanma';
      case 11:
        return 'Güçlü sezgi, ilham ve farkındalık';
      case 22:
        return 'Büyük hedefler ve güçlü yapı kurma';
      case 33:
        return 'Şefkat, öğreticilik ve ilham';
      default:
        return 'Kendini keşfetme ve gelişim';
    }
  }

  @override
  Widget build(BuildContext context) {
    final number = _lifePathNumber();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF17102D),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔢 Numeroloji',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Doğum tarihinden hesaplanan Yaşam Yolu Sayın',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _meaning(number),
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}