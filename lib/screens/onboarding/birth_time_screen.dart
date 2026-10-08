import 'package:flutter/material.dart';
import 'birth_place_screen.dart';

class BirthTimeScreen extends StatefulWidget {
  final String name;
  final DateTime birthDate;

  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentThemeMode;

  const BirthTimeScreen({
    super.key,
    required this.name,
    required this.birthDate,
    required this.onThemeChanged,
    required this.currentThemeMode,
  });

  @override
  State<BirthTimeScreen> createState() => _BirthTimeScreenState();
}

class _BirthTimeScreenState extends State<BirthTimeScreen> {
  TimeOfDay? selectedTime;

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void _continue() {
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen doğum saatini seç ✨'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BirthPlaceScreen(
          name: widget.name,
          birthDate: widget.birthDate,
          birthTime: selectedTime!,
          onThemeChanged: widget.onThemeChanged,
          currentThemeMode: widget.currentThemeMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              Text(
                '3 / 4',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'Doğum saatin kaç?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Yükselen burcunu doğru hesaplayabilmek için doğum saatine ihtiyacımız var.',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: OutlinedButton(
                  onPressed: _selectTime,
                  child: Text(
                    selectedTime == null
                        ? 'Saat seç'
                        : selectedTime!.format(context),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _continue,
                  child: const Text(
                    'Devam Et',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}