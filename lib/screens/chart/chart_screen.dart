import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/birth_chart_service.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  Map<String, dynamic>? _birthChart;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBirthChart();
  }

  Future<void> _loadBirthChart() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Kullanıcı bulunamadı');
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();

      if (data == null) {
        throw Exception('Doğum bilgileri bulunamadı');
      }

      final birthDate = data['birthDate'];
      final hour = data['birthTimeHour'] ?? 12;
      final minute = data['birthTimeMinute'] ?? 0;
      final city = data['birthPlace'];

      if (birthDate == null || city == null) {
        throw Exception('Doğum bilgileri eksik');
      }

      final date = (birthDate as Timestamp).toDate();

      final formattedDate =
          '${date.day.toString().padLeft(2, '0')}.'
          '${date.month.toString().padLeft(2, '0')}.'
          '${date.year}';

      final formattedTime =
          '${hour.toString().padLeft(2, '0')}:'
          '${minute.toString().padLeft(2, '0')}';

      final result = await BirthChartService.getBirthChart(
        birthDate: formattedDate,
        birthTime: formattedTime,
        city: city.toString(),
      );

      if (!mounted) return;

      setState(() {
        _birthChart = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getPlanets() {
    final planets = _birthChart?['all_planets'];

    if (planets is List) {
      return planets
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    return [];
  }

  String _planetSymbol(String planet) {
    switch (planet) {
      case 'Güneş':
        return '☉';
      case 'Ay':
        return '☽';
      case 'Merkür':
        return '☿';
      case 'Venüs':
        return '♀';
      case 'Mars':
        return '♂';
      case 'Jüpiter':
        return '♃';
      case 'Satürn':
        return '♄';
      case 'Uranüs':
        return '♅';
      case 'Neptün':
        return '♆';
      case 'Plüton':
        return '♇';
      default:
        return '•';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Yıldız Haritam',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Harita yüklenemedi',
                        style: TextStyle(
                          fontSize: 20,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _loading = true;
                            _error = null;
                          });

                          _loadBirthChart();
                        },
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                )
              : _buildChart(),
    );
  }

  Widget _buildChart() {
    final planets = _getPlanets();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        30,
      ),
      child: Column(
        children: [
          Text(
            'DOĞUM HARİTAN',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 3,
              color: theme.textTheme.bodyMedium?.color?.withValues(
                alpha: 0.65,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withValues(
                  alpha: 0.25,
                ),
              ),
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: BirthChartPainter(
                  planets: planets,
                  risingDegree:
                      (_birthChart?['raw_ascending_degree'] as num?)
                              ?.toDouble() ??
                          0,
                  isDark: isDark,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          _buildCoreCards(),

          const SizedBox(height: 24),

          _buildPlanetList(planets),
        ],
      ),
    );
  }

  Widget _buildCoreCards() {
    final core = _birthChart?['core_placements'];
    final theme = Theme.of(context);

    debugPrint('CORE VERİSİ: $core');

    String getSunSign() {
      if (core is Map) {
        final sun = core['Güneş'];

        if (sun is Map) {
          return sun['sign']?.toString() ?? '-';
        }

        return core['sign']?.toString() ?? '-';
      }

      return '-';
    }

    String getSunDegree() {
      if (core is Map) {
        final sun = core['Güneş'];

        if (sun is Map) {
          final degree = sun['degree'];

          if (degree is num) {
            return '${degree.toStringAsFixed(2)}°';
          }
        }

        final degree = core['degree'];

        if (degree is num) {
          return '${degree.toStringAsFixed(2)}°';
        }
      }

      return '';
    }

    String getRisingSign() {
      final rising = _birthChart?['rising'];

      if (rising is Map) {
        return rising['sign']?.toString() ?? '-';
      }

      return '-';
    }

    String getRisingDegree() {
      final rising = _birthChart?['rising'];

      if (rising is Map) {
        final degree = rising['degree'];

        if (degree is num) {
          return '${degree.toStringAsFixed(2)}°';
        }
      }

      return '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'KOZMİK ÜÇLÜN',
            style: TextStyle(
              fontSize: 13,
              letterSpacing: 2,
              color: theme.textTheme.bodyMedium?.color?.withValues(
                alpha: 0.65,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _coreCard(
                symbol: '☉',
                title: 'Güneş',
                sign: '${getSunSign()} ${getSunDegree()}',
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _coreCard(
                symbol: '☽',
                title: 'Ay',
                sign: _birthChart?['moon'] is Map
                    ? '${(_birthChart!['moon'] as Map)['sign'] ?? '-'} '
                        '${((_birthChart!['moon'] as Map)['degree'] as num?)?.toStringAsFixed(2) ?? ''}°'
                    : '-',
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _coreCard(
                symbol: 'ASC',
                title: 'Yükselen',
                sign: '${getRisingSign()} ${getRisingDegree()}',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _coreCard({
    required String symbol,
    required String title,
    required String sign,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(
            alpha: 0.25,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            symbol,
            style: const TextStyle(
              fontSize: 24,
              color: Color(0xFF8B5CF6),
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: theme.textTheme.bodyMedium?.color?.withValues(
                alpha: 0.65,
              ),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            sign,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetList(
    List<Map<String, dynamic>> planets,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(
            alpha: 0.15,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gezegenlerin',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),

          const SizedBox(height: 14),

          ...planets.map(
            (planet) {
              final name =
                  planet['planet']?.toString() ?? '';

              final sign =
                  planet['sign']?.toString() ?? '';

              final degree =
                  (planet['degree'] as num?)
                          ?.toDouble() ??
                      0;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 35,
                      child: Text(
                        _planetSymbol(name),
                        style: TextStyle(
                          fontSize: 23,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),

                    Text(
                      '$sign ${degree.toStringAsFixed(2)}°',
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color
                            ?.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BirthChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> planets;
  final double risingDegree;
  final bool isDark;

  BirthChartPainter({
    required this.planets,
    required this.risingDegree,
    required this.isDark,
  });

  final List<String> signs = const [
    'Koç',
    'Boğa',
    'İkizler',
    'Yengeç',
    'Aslan',
    'Başak',
    'Terazi',
    'Akrep',
    'Yay',
    'Oğlak',
    'Kova',
    'Balık',
  ];

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final textColor = isDark
        ? Colors.white70
        : const Color(0xFF4A405A);

    final lineColor = isDark
        ? Colors.white.withValues(alpha: 0.18)
        : const Color(0xFF6B5B7A).withValues(alpha: 0.25);

    final planetBackground = isDark
        ? const Color(0xFF241642)
        : const Color(0xFFF1EAFB);

    final planetBorder = isDark
        ? const Color(0xFF9F7AEA)
        : const Color(0xFF8B5CF6);

    final planetText = isDark
        ? Colors.white
        : const Color(0xFF352544);

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        math.min(size.width, size.height) / 2 - 15;

    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color =
          const Color(0xFF8B5CF6).withValues(alpha: 0.65);

    final thinPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = lineColor;

    canvas.drawCircle(
      center,
      radius,
      outerPaint,
    );

    canvas.drawCircle(
      center,
      radius * 0.72,
      thinPaint,
    );

    canvas.drawCircle(
      center,
      radius * 0.42,
      thinPaint,
    );

    for (int i = 0; i < 12; i++) {
      final degree = i * 30.0;
      final angle = _angle(degree);

      final start = Offset(
        center.dx +
            math.cos(angle) * radius,
        center.dy +
            math.sin(angle) * radius,
      );

      final inner = Offset(
        center.dx +
            math.cos(angle) * radius * 0.72,
        center.dy +
            math.sin(angle) * radius * 0.72,
      );

      canvas.drawLine(
        start,
        inner,
        thinPaint,
      );

      final textAngle = _angle(degree + 15);

      final textPosition = Offset(
        center.dx +
            math.cos(textAngle) *
                radius *
                0.86,
        center.dy +
            math.sin(textAngle) *
                radius *
                0.86,
      );

      _drawText(
        canvas,
        signs[i],
        textPosition,
        11,
        textColor,
        center: true,
      );
    }

    final ascAngle = _angle(risingDegree);

    final ascEnd = Offset(
      center.dx +
          math.cos(ascAngle) * radius,
      center.dy +
          math.sin(ascAngle) * radius,
    );

    final ascPaint = Paint()
      ..color = const Color(0xFF8B5CF6)
      ..strokeWidth = 2.5;

    canvas.drawLine(
      center,
      ascEnd,
      ascPaint,
    );

    _drawText(
      canvas,
      'ASC',
      ascEnd,
      10,
      const Color(0xFF8B5CF6),
      center: true,
    );

    void drawAspects(
      Canvas canvas,
      Offset center,
      double radius,
      List<Map<String, dynamic>> planets,
    ) {
      final aspectPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = lineColor;

      for (int i = 0; i < planets.length; i++) {
        final degree1 =
            (planets[i]['total_ecliptic_longitude']
                    as num?)
                ?.toDouble() ??
            0;

        for (int j = i + 1; j < planets.length; j++) {
          final degree2 =
              (planets[j]['total_ecliptic_longitude']
                      as num?)
                  ?.toDouble() ??
              0;

          double difference =
              (degree1 - degree2).abs();

          if (difference > 180) {
            difference = 360 - difference;
          }

          final isMajorAspect =
              (difference - 0).abs() <= 6 ||
              (difference - 60).abs() <= 6 ||
              (difference - 90).abs() <= 6 ||
              (difference - 120).abs() <= 6 ||
              (difference - 180).abs() <= 6;

          if (!isMajorAspect) continue;

          final angle1 = _angle(degree1);
          final angle2 = _angle(degree2);

          final point1 = Offset(
            center.dx +
                math.cos(angle1) *
                    radius *
                    0.42,
            center.dy +
                math.sin(angle1) *
                    radius *
                    0.42,
          );

          final point2 = Offset(
            center.dx +
                math.cos(angle2) *
                    radius *
                    0.42,
            center.dy +
                math.sin(angle2) *
                    radius *
                    0.42,
          );

          canvas.drawLine(
            point1,
            point2,
            aspectPaint,
          );
        }
      }
    }

    drawAspects(
      canvas,
      center,
      radius,
      planets,
    );

    for (final planet in planets) {
      final degree =
          (planet['total_ecliptic_longitude']
                  as num?)
              ?.toDouble() ??
          0;

      final angle = _angle(degree);

      final position = Offset(
        center.dx +
            math.cos(angle) *
                radius *
                0.58,
        center.dy +
            math.sin(angle) *
                radius *
                0.58,
      );

      final name =
          planet['planet']?.toString() ?? '';

      _drawPlanet(
        canvas,
        name,
        position,
        planetBackground,
        planetBorder,
        planetText,
      );
    }

    final centerPaint = Paint()
      ..color =
          const Color(0xFF8B5CF6)
              .withValues(alpha: 0.2);

    canvas.drawCircle(
      center,
      radius * 0.08,
      centerPaint,
    );
  }

  double _angle(double degree) {
    return -math.pi / 2 +
        (degree * math.pi / 180);
  }

  void _drawPlanet(
    Canvas canvas,
    String name,
    Offset position,
    Color planetBackground,
    Color planetBorder,
    Color planetText,
  ) {
    final circlePaint = Paint()
      ..color = planetBackground
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = planetBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(
      position,
      17,
      circlePaint,
    );

    canvas.drawCircle(
      position,
      17,
      borderPaint,
    );

    _drawText(
      canvas,
      _symbol(name),
      position,
      18,
      planetText,
      center: true,
    );
  }

  String _symbol(String name) {
    switch (name) {
      case 'Güneş':
        return '☉';
      case 'Ay':
        return '☽';
      case 'Merkür':
        return '☿';
      case 'Venüs':
        return '♀';
      case 'Mars':
        return '♂';
      case 'Jüpiter':
        return '♃';
      case 'Satürn':
        return '♄';
      case 'Uranüs':
        return '♅';
      case 'Neptün':
        return '♆';
      case 'Plüton':
        return '♇';
      default:
        return '•';
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset position,
    double fontSize,
    Color color, {
    bool center = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    final offset = center
        ? Offset(
            position.dx -
                painter.width / 2,
            position.dy -
                painter.height / 2,
          )
        : position;

    painter.paint(
      canvas,
      offset,
    );
  }

  @override
  bool shouldRepaint(
    covariant BirthChartPainter oldDelegate,
  ) {
    return oldDelegate.planets != planets ||
        oldDelegate.risingDegree != risingDegree ||
        oldDelegate.isDark != isDark;
  }
}