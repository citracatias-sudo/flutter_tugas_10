import 'package:flutter/material.dart';
import '../api/profile_service.dart';
import '../models/get_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  bool isEditing = false;
  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;
  UserData? user;
  Map<String, Map<String, String>> lastChanges = {};

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await ProfileService.getProfile();
      user = result.data;
      nameController.text = user?.name ?? '';
      emailController.text = user?.email ?? '';
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> saveProfile() async {
    final oldName = user?.name ?? '';
    final oldEmail = user?.email ?? '';
    final newName = nameController.text.trim();
    final newEmail = emailController.text.trim();

    if (newName.isEmpty || newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nama dan email tidak boleh kosong'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final success = await ProfileService.updateProfile(newName, newEmail);

      if (!success) {
        throw Exception('Gagal menyimpan perubahan profil');
      }

      await loadProfile();

      final updatedChanges = <String, Map<String, String>>{};
      if (oldName != newName) {
        updatedChanges['Nama'] = {'before': oldName, 'after': newName};
      }
      if (oldEmail != newEmail) {
        updatedChanges['Email'] = {'before': oldEmail, 'after': newEmail};
      }

      if (!mounted) {
        return;
      }

      setState(() {
        lastChanges = updatedChanges;
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            updatedChanges.isEmpty
                ? 'Tidak ada perubahan data'
                : 'Profil berhasil diperbarui',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void resetChanges() {
    nameController.text = user?.name ?? '';
    emailController.text = user?.email ?? '';

    setState(() {
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Perubahan input berhasil dihapus'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon),
      filled: true,
      fillColor: Color(0xFFFFF7FB),
      contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFFF1D8E7)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFFEA4C89), width: 1.3),
      ),
    );
  }

  Widget buildChangeCard(String label, Map<String, String> value) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF5FA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color(0xFFF6CADC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF7D3153),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Sebelum',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9E6D84),
            ),
          ),
          SizedBox(height: 4),
          Text(value['before']!.isEmpty ? '-' : value['before']!),
          SizedBox(height: 10),
          Text(
            'Sesudah',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9E6D84),
            ),
          ),
          SizedBox(height: 4),
          Text(
            value['after']!.isEmpty ? '-' : value['after']!,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF7FB),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFE3F1), Color(0xFFFFF7FB), Color(0xFFFDEBFF)],
            ),
          ),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: Color(0xFFEA4C89),
                        ),
                        SizedBox(height: 12),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF6C596F)),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: loadProfile,
                          child: Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 460),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFEA4C89).withValues(alpha: 0.18),
                            blurRadius: 30,
                            offset: Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFEA4C89),
                                      Color(0xFFFF8FB1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 34,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Profil Saya',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2D1635),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Kelola data profilmu dengan tampilan yang rapi dan nyaman.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 1.5,
                                        color: Color(0xFF7A647D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 28),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFF5FA),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Color(0xFFFFD1E3),
                                  child: Text(
                                    (user?.name?.isNotEmpty ?? false)
                                        ? user!.name![0].toUpperCase()
                                        : 'U',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF9C2F60),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.name ?? '-',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2D1635),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        user?.email ?? '-',
                                        style: TextStyle(
                                          color: Color(0xFF7A647D),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            'Nama Lengkap',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF49304F),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: nameController,
                            enabled: isEditing,
                            decoration: buildInputDecoration(
                              hintText: 'Masukkan nama lengkap',
                              prefixIcon: Icons.person_outline_rounded,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Email Address',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF49304F),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: emailController,
                            enabled: isEditing,
                            decoration: buildInputDecoration(
                              hintText: 'Masukkan email',
                              prefixIcon: Icons.email_outlined,
                            ),
                          ),
                          SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 54,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFEA4C89),
                                          Color(0xFFFF7AA2),
                                        ],
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: isSaving
                                          ? null
                                          : () {
                                              if (isEditing) {
                                                saveProfile();
                                              } else {
                                                setState(() {
                                                  isEditing = true;
                                                });
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        disabledBackgroundColor:
                                            Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: isSaving
                                          ? SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.4,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              isEditing
                                                  ? 'Simpan Perubahan'
                                                  : 'Edit Profil',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 54,
                                  child: OutlinedButton(
                                    onPressed: isEditing ? resetChanges : null,
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Color(0xFFF2BDD3),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      'Hapus Perubahan',
                                      style: TextStyle(
                                        color: Color(0xFFB13C6C),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (lastChanges.isNotEmpty) ...[
                            SizedBox(height: 28),
                            Text(
                              'Perubahan Terakhir',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D1635),
                              ),
                            ),
                            SizedBox(height: 14),
                            ...lastChanges.entries.map(
                              (entry) => buildChangeCard(entry.key, entry.value),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
