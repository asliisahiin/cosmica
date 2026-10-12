
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'services/notification_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Bildirim izinlerini iste ve kullanıcının FCM token'ını kaydet.
  // Kullanıcı giriş yapmamışsa token, giriş sonrasında da kaydedilir.
  try {
    await NotificationService.initialize();
  } catch (error) {
    debugPrint('Bildirim servisi başlatılamadı: $error');
  }

  // Firebase'in kullanıcı oturumunu hazırlamasını bekle.
  final user = await FirebaseAuth.instance.authStateChanges().first;

  // Önce cihazdaki kayıtlı temayı al.
  final prefs = await SharedPreferences.getInstance();
  final savedLocalTheme = prefs.getString('themeMode');

  ThemeMode initialTheme = ThemeMode.dark;

  switch (savedLocalTheme) {
    case 'light':
      initialTheme = ThemeMode.light;
      break;
    case 'system':
      initialTheme = ThemeMode.system;
      break;
    case 'dark':
      initialTheme = ThemeMode.dark;
      break;
  }

  // Kullanıcı giriş yaptıysa Firestore'daki tema tercihini kontrol et.
  if (user != null) {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final savedFirestoreTheme =
          doc.data()?['themeMode']?.toString();

      switch (savedFirestoreTheme) {
        case 'light':
          initialTheme = ThemeMode.light;
          break;
        case 'system':
          initialTheme = ThemeMode.system;
          break;
        case 'dark':
          initialTheme = ThemeMode.dark;
          break;
      }
    } catch (error) {
      debugPrint('Tema tercihi okunamadı: $error');
    }
  }

  runApp(
    CosmicApp(
      initialThemeMode: initialTheme,
    ),
  );
}

class CosmicApp extends StatefulWidget {
  final ThemeMode initialThemeMode;

  const CosmicApp({
    super.key,
    required this.initialThemeMode,
  });

  @override
  State<CosmicApp> createState() => _CosmicAppState();
}

class _CosmicAppState extends State<CosmicApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  Future<void> _changeTheme(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });

    final String themeValue;

    switch (mode) {
      case ThemeMode.light:
        themeValue = 'light';
        break;
      case ThemeMode.dark:
        themeValue = 'dark';
        break;
      case ThemeMode.system:
        themeValue = 'system';
        break;
    }

    // Cihazda sakla.
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('themeMode', themeValue);
    } catch (error) {
      debugPrint('Tema cihazda kaydedilemedi: $error');
    }

    // Giriş yapılmışsa Firestore'a da kaydet.
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(
          {'themeMode': themeValue},
          SetOptions(merge: true),
        );
      }
    } catch (error) {
      debugPrint('Tema Firestore kaydı başarısız: $error');
    }
  }

  ThemeData _lightTheme() {
    const primaryPurple = Color(0xFF7C3AED);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8F7FC),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF8F7FC),
        foregroundColor: Color(0xFF211A2E),
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        indicatorColor: primaryPurple.withValues(alpha: 0.14),
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: primaryPurple,
            width: 1.5,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.black.withValues(alpha: 0.07),
      ),
    );
  }

  ThemeData _darkTheme() {
    const primaryPurple = Color(0xFF8B5CF6);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0D0820),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D0820),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF17102D),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF130D27),
        elevation: 0,
        indicatorColor: primaryPurple.withValues(alpha: 0.25),
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF17102D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: primaryPurple,
            width: 1.5,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF17102D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.08),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cosmica',
      themeMode: _themeMode,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      home: AuthGate(
        onThemeChanged: _changeTheme,
        currentThemeMode: _themeMode,
      ),
    );
  }
}

// ======================================================
// AUTH GATE
// ======================================================

class AuthGate extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentThemeMode;

  const AuthGate({
    super.key,
    required this.onThemeChanged,
    required this.currentThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          return HomeScreen(
            onThemeChanged: onThemeChanged,
            currentThemeMode: currentThemeMode,
          );
        }

        return WelcomePage(
          onThemeChanged: onThemeChanged,
          currentThemeMode: currentThemeMode,
        );
      },
    );
  }
}

// ======================================================
// WELCOME
// ======================================================

class WelcomePage extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentThemeMode;

  const WelcomePage({
    super.key,
    required this.onThemeChanged,
    required this.currentThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '✨',
                style: TextStyle(fontSize: 70),
              ),
              const SizedBox(height: 24),
              Text(
                'COSMICA',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Gökyüzünde sana ait\nbir hikâye var.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  height: 1.5,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(
                          onThemeChanged: onThemeChanged,
                          currentThemeMode: currentThemeMode,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Başla',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
