import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cosmica/widgets/top_notification.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _birthPlaceController = TextEditingController();

  DateTime? _birthDate;
  TimeOfDay? _birthTime;

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() {
          _loading = false;
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
        final data = doc.data()!;

        _nameController.text =
            data['name']?.toString() ?? user.displayName ?? '';

        _birthPlaceController.text =
            data['birthPlace']?.toString() ?? '';

        if (data['birthDate'] is Timestamp) {
          _birthDate =
              (data['birthDate'] as Timestamp).toDate();
        }

        final hour = data['birthTimeHour'];
        final minute = data['birthTimeMinute'];

        if (hour != null && minute != null) {
          _birthTime = TimeOfDay(
            hour: int.tryParse(hour.toString()) ?? 12,
            minute: int.tryParse(minute.toString()) ?? 0,
          );
        }
      } else {
        _nameController.text = user.displayName ?? '';
      }
    } catch (e) {
      if (mounted) {
        showTopNotification(
  context,
  'Profil güncellenemedi: $e',
  isError: true,
);
      }
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selected != null && mounted) {
      setState(() {
        _birthDate = selected;
      });
    }
  }

  Future<void> _selectTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime:
          _birthTime ?? const TimeOfDay(hour: 12, minute: 0),
    );

    if (selected != null && mounted) {
      setState(() {
        _birthTime = selected;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'name': _nameController.text.trim(),
          'birthPlace': _birthPlaceController.text.trim(),
          if (_birthDate != null)
            'birthDate': Timestamp.fromDate(_birthDate!),
          if (_birthTime != null) ...{
            'birthTimeHour': _birthTime!.hour,
            'birthTimeMinute': _birthTime!.minute,
          },
        },
        SetOptions(merge: true),
      );

      await user.updateDisplayName(
        _nameController.text.trim(),
      );

      if (!mounted) return;

      showTopNotification(
  context,
  'Profil bilgilerin güncellendi ✨',
);
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profil güncellenemedi: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Doğum tarihini seç';
    }

    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'Doğum saatini seç';
    }

    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthPlaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profili Düzenle'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kişisel Bilgiler',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Ad Soyad',
                        prefixIcon: const Icon(
                          Icons.person_outline,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF17102D),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Adını girmen gerekiyor';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Doğum Bilgileri',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _SelectionTile(
                      icon: Icons.calendar_month_outlined,
                      title: 'Doğum Tarihi',
                      value: _formatDate(_birthDate),
                      onTap: _selectDate,
                    ),

                    _SelectionTile(
                      icon: Icons.access_time,
                      title: 'Doğum Saati',
                      value: _formatTime(_birthTime),
                      onTap: _selectTime,
                    ),

                    const SizedBox(height: 4),

                    TextFormField(
                      controller: _birthPlaceController,
                      decoration: InputDecoration(
                        labelText: 'Doğum Yeri',
                        hintText: 'Örn. Ankara',
                        prefixIcon: const Icon(
                          Icons.location_on_outlined,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF17102D),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Doğum yerini girmen gerekiyor';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed:
                            _saving ? null : _saveProfile,
                        child: _saving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Değişiklikleri Kaydet',
                                style: TextStyle(
                                  fontSize: 16,
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

class _SelectionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _SelectionTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF17102D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.white60,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
        ),
      ),
    );
  }
}