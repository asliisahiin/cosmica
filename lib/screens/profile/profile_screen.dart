import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/top_notification.dart';

import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';
import 'pro_screen.dart';
import 'saved_tarot_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentThemeMode;

  const ProfileScreen({
    super.key,
    required this.onThemeChanged,
    required this.currentThemeMode,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _loadingSettings = true;

  // Profil ekranında gösterilen güncel tema
  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    super.initState();

    _selectedThemeMode = widget.currentThemeMode;

    _loadSettings();
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Ana uygulamadaki tema değiştiğinde
    // profil ekranındaki tema bilgisini de güncelle.
    if (oldWidget.currentThemeMode != widget.currentThemeMode) {
      setState(() {
        _selectedThemeMode = widget.currentThemeMode;
      });
    }
  }

  Future<void> _loadSettings() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() {
          _loadingSettings = false;
        });
      }
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();

        if (data != null && data['notificationsEnabled'] != null) {
          _notificationsEnabled =
              data['notificationsEnabled'] == true;
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _loadingSettings = false;
      });
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    final user = FirebaseAuth.instance.currentUser;

    setState(() {
      _notificationsEnabled = value;
    });

    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'notificationsEnabled': value,
        },
        SetOptions(merge: true),
      );

      if (!mounted) return;

      showTopNotification(
        context,
        value
            ? 'Bildirimler açıldı ✨'
            : 'Bildirimler kapatıldı',
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _notificationsEnabled = !value;
      });

      showTopNotification(
        context,
        'Bildirim ayarı kaydedilemedi',
      );
    }
  }

  Future<void> _openEditProfile() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );

    if (updated == true && mounted) {
      setState(() {});
    }
  }

  String _themeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Açık tema';

      case ThemeMode.system:
        return 'Sistem teması';

      case ThemeMode.dark:
        return 'Koyu tema';
    }
  }

  IconData _themeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode_outlined;

      case ThemeMode.system:
        return Icons.brightness_auto_outlined;

      case ThemeMode.dark:
        return Icons.dark_mode_outlined;
    }
  }

  void _selectTheme(ThemeMode mode) {
    // Profil ekranındaki seçimi hemen değiştir.
    setState(() {
      _selectedThemeMode = mode;
    });

    // Uygulamanın gerçek temasını değiştir.
    widget.onThemeChanged(mode);

    // Tema penceresini kapat.
    Navigator.of(context).pop();

    Future.delayed(
      const Duration(milliseconds: 150),
      () {
        if (!mounted) return;

        String message;

        switch (mode) {
          case ThemeMode.dark:
            message = 'Koyu tema aktif 🌙';
            break;

          case ThemeMode.light:
            message = 'Açık tema aktif ☀️';
            break;

          case ThemeMode.system:
            message = 'Sistem teması aktif 📱';
            break;
        }

        showTopNotification(
          context,
          message,
        );
      },
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ThemeOption(
                icon: Icons.dark_mode_outlined,
                title: 'Koyu Tema',
                selected:
                    _selectedThemeMode == ThemeMode.dark,
                onTap: () {
                  _selectTheme(ThemeMode.dark);
                },
              ),

              _ThemeOption(
                icon: Icons.light_mode_outlined,
                title: 'Açık Tema',
                selected:
                    _selectedThemeMode == ThemeMode.light,
                onTap: () {
                  _selectTheme(ThemeMode.light);
                },
              ),

              _ThemeOption(
                icon: Icons.brightness_auto_outlined,
                title: 'Sistem Teması',
                selected:
                    _selectedThemeMode == ThemeMode.system,
                onTap: () {
                  _selectTheme(ThemeMode.system);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          onThemeChanged: widget.onThemeChanged,
          currentThemeMode: _selectedThemeMode,
        ),
      ),
      (route) => false,
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Belirtilmemiş';
    }

    final date = timestamp.toDate();

    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  String _formatTime(dynamic hour, dynamic minute) {
    if (hour == null || minute == null) {
      return 'Belirtilmemiş';
    }

    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    if (user == null) {
      return const Center(
        child: Text('Kullanıcı bulunamadı'),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? {};

        final name =
            data['name']?.toString() ??
            user.displayName ??
            'Cosmica Kullanıcısı';

        final email = user.email ?? '';

        final birthDate =
            data['birthDate'] as Timestamp?;

        final birthPlace =
            data['birthPlace']?.toString() ??
            'Belirtilmemiş';

        final birthTime = _formatTime(
          data['birthTimeHour'],
          data['birthTimeMinute'],
        );

        final cardColor = theme.colorScheme.surface;

        final secondaryText =
            theme.colorScheme.onSurface.withValues(alpha: 0.55);

        final primaryText =
            theme.colorScheme.onSurface;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF8B5CF6),
                            Color(0xFF5B21B6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6)
                                .withValues(alpha: 0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 46,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      email,
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Text(
                'Doğum Bilgilerin',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.calendar_month_outlined,
                      title: 'Doğum Tarihi',
                      value: _formatDate(birthDate),
                    ),

                    const SizedBox(height: 16),

                    _InfoRow(
                      icon: Icons.access_time,
                      title: 'Doğum Saati',
                      value: birthTime,
                    ),

                    const SizedBox(height: 16),

                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      title: 'Doğum Yeri',
                      value: birthPlace,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              _ProfileTile(
                icon: Icons.edit_outlined,
                title: 'Profili Düzenle',
                value: 'Bilgilerini güncelle',
                onTap: _openEditProfile,
              ),

              const SizedBox(height: 26),

              Text(
                'Tarot',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              const SizedBox(height: 12),

              _ProfileTile(
                icon: Icons.auto_awesome,
                title: 'Kaydedilen Kartlar',
                value:
                    'Kaydettiğin tarot açılımlarını görüntüle',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const SavedTarotScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 26),

              Text(
                'Ayarlar',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              const SizedBox(height: 12),

              _ProfileTile(
                icon: Icons.notifications_none,
                title: 'Bildirimler',
                value: _loadingSettings
                    ? 'Yükleniyor...'
                    : _notificationsEnabled
                        ? 'Günlük kozmik mesajlar açık'
                        : 'Bildirimler kapalı',
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: _loadingSettings
                      ? null
                      : _toggleNotifications,
                ),
                onTap: () {
                  if (!_loadingSettings) {
                    _toggleNotifications(
                      !_notificationsEnabled,
                    );
                  }
                },
              ),

              // ==================================================
              // TEMA
              // ==================================================

              _ProfileTile(
                icon: _themeIcon(
                  _selectedThemeMode,
                ),
                title: 'Tema',
                value: _themeName(
                  _selectedThemeMode,
                ),
                onTap: _showThemeDialog,
              ),

              _ProfileTile(
                icon: Icons.workspace_premium_outlined,
                title: 'Cosmica Pro',
                value: 'Premium özellikleri keşfet',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ProScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.redAccent,
                  ),
                  label: const Text(
                    'Çıkış Yap',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.redAccent
                          .withValues(alpha: 0.35),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  'Cosmica ✨',
                  style: TextStyle(
                    color:
                        primaryText.withValues(alpha: 0.25),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ======================================================
// TEMA SEÇENEĞİ
// ======================================================

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected
            ? const Color(0xFF8B5CF6)
            : null,
      ),
      title: Text(title),
      trailing: selected
          ? const Icon(
              Icons.check,
              color: Color(0xFFB794F6),
            )
          : null,
      onTap: onTap,
    );
  }
}

// ======================================================
// BİLGİ SATIRI
// ======================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6)
                .withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFB794F6),
            size: 21,
          ),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.55),
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ======================================================
// PROFİL AYAR KARTI
// ======================================================

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  final Widget? trailing;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6)
                .withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFB794F6),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            color: theme.colorScheme.onSurface
                .withValues(alpha: 0.55),
            fontSize: 12,
          ),
        ),
        trailing: trailing ??
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface
                  .withValues(alpha: 0.35),
            ),
      ),
    );
  }
}