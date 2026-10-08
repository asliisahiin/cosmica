import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'calculating_screen.dart';

class BirthPlaceScreen extends StatefulWidget {
  final String name;
  final DateTime birthDate;
  final TimeOfDay birthTime;

  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentThemeMode;

  const BirthPlaceScreen({
    super.key,
    required this.name,
    required this.birthDate,
    required this.birthTime,
    required this.onThemeChanged,
    required this.currentThemeMode,
  });

  @override
  State<BirthPlaceScreen> createState() => _BirthPlaceScreenState();
}

class _BirthPlaceScreenState extends State<BirthPlaceScreen> {
  final TextEditingController _placeController = TextEditingController();

  bool _loading = false;

  Future<void> _saveProfile() async {
    final birthPlace = _placeController.text.trim();

    if (birthPlace.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen doğum yerini gir ✨'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kullanıcı bulunamadı. Lütfen tekrar giriş yap.'),
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': widget.name,
        'email': user.email,
        'birthDate': Timestamp.fromDate(widget.birthDate),
        'birthTimeHour': widget.birthTime.hour,
        'birthTimeMinute': widget.birthTime.minute,
        'birthPlace': birthPlace,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CalculatingScreen(
            onThemeChanged: widget.onThemeChanged,
            currentThemeMode: widget.currentThemeMode,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bilgiler kaydedilemedi: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
                '✨ 4 / 4',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'Nerede doğdun?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Doğum yerin, yıldız haritanı doğru konumla hesaplamamıza yardımcı olacak.',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: _placeController,
                decoration: InputDecoration(
                  labelText: 'Doğum yeri',
                  hintText: 'Örn. Ankara, Türkiye',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _loading ? null : _saveProfile,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Haritamı Oluştur ✨',
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