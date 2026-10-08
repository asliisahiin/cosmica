import 'package:flutter/material.dart';

class BiorhythmCard extends StatelessWidget {
  final DateTime birthDate;

  const BiorhythmCard({
    super.key,
    required this.birthDate,
  });

  double _cycle(int days) {
    final today = DateTime.now();
    final difference = today.difference(birthDate).inDays;

    final value =
        (difference % days) / days;

    return (value * 2 * 3.1415926535).abs();
  }

  double _energy(int days) {
    final angle = _cycle(days);

    return (1 + _sin(angle)) / 2;
  }

  double _sin(double value) {
    // Basit sinüs yaklaşımı
    double x = value;
    double result = 0;

    while (x > 3.1415926535) {
      x -= 2 * 3.1415926535;
    }

    while (x < -3.1415926535) {
      x += 2 * 3.1415926535;
    }

    result = x -
        (x * x * x) / 6 +
        (x * x * x * x * x) / 120;

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final physical = (_energy(23) * 100).round();
    final emotional = (_energy(28) * 100).round();
    final mental = (_energy(33) * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF17102D),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📈 Günlük Bioritim',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Bugünkü enerji seviyelerin',
            style: TextStyle(
              color: Colors.white60,
            ),
          ),

          const SizedBox(height: 20),

          _energyRow(
            '⚡ Fiziksel',
            physical,
          ),

          const SizedBox(height: 14),

          _energyRow(
            '🧠 Zihinsel',
            mental,
          ),

          const SizedBox(height: 14),

          _energyRow(
            '💗 Duygusal',
            emotional,
          ),
        ],
      ),
    );
  }

  Widget _energyRow(
    String title,
    int value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '%$value',
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),

        const SizedBox(height: 7),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: value / 100,
            minHeight: 8,
            backgroundColor:
                Colors.white12,
          ),
        ),
      ],
    );
  }
}