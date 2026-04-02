import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tugas_10/day_16/database/preference.dart';
import 'package:image_picker/image_picker.dart';
import '../api/profile_local_storage.dart';
import '../api/profile_service.dart';
import '../models/get_model.dart';
import 'login_day_30.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  bool isEditing = false;
  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;
  UserData? user;

  File? profileImageFile;

  final Color kPrimaryPink = Color(0xFFEA4C89);
  final Color kSoftPink = Color(0xFFFF7AA2);
  final Color kAccentYellow = Color(0xFFF5B232);
  final Color kBackgroundLight = Color(0xFFFFF7FB);

  String get displayName {
    final value = isEditing ? nameController.text.trim() : user?.name?.trim();
    return (value != null && value.isNotEmpty) ? value : '-';
  }

  String get displayEmail {
    final value = isEditing ? emailController.text.trim() : user?.email?.trim();
    return (value != null && value.isNotEmpty) ? value : '-';
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
    loadSavedProfilePhoto();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
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

  Future<void> loadSavedProfilePhoto() async {
    final savedPath = await ProfileLocalStorage.getProfileImagePath();
    if (savedPath == null || savedPath.isEmpty) {
      return;
    }

    final savedFile = File(savedPath);
    if (!await savedFile.exists()) {
      await ProfileLocalStorage.clearProfileImagePath();
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      profileImageFile = savedFile;
    });
  }

  Future<void> saveProfile() async {
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

    if (!newEmail.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Format email belum valid'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (newName == (user?.name ?? '') && newEmail == (user?.email ?? '')) {
      setState(() {
        isEditing = false;
      });
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

      user = UserData(id: user?.id, name: newName, email: newEmail);

      if (!mounted) {
        return;
      }

      setState(() {
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil berhasil diperbarui'),
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
  }

  Future<void> pickProfilePhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    final file = File(picked.path);
    await ProfileLocalStorage.saveProfileImagePath(file.path);

    setState(() {
      profileImageFile = file;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Foto profil berhasil dipilih'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void startEditing({bool focusEmail = false}) {
    if (isEditing) {
      if (focusEmail) {
        emailFocusNode.requestFocus();
      } else {
        nameFocusNode.requestFocus();
      }
      return;
    }

    setState(() {
      isEditing = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (focusEmail) {
        emailFocusNode.requestFocus();
      } else {
        nameFocusNode.requestFocus();
      }
    });
  }

  void toggleEditing() {
    if (isEditing) {
      resetChanges();
      return;
    }

    startEditing();
  }

  Future<void> deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus Akun'),
        content: Text('Apakah anda yakin menghapus akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      final success = await ProfileService.deleteProfile();
      if (success) {
        if (!mounted) return;

        await PreferenceHandler().init();
        await PreferenceHandler().deleteToken();
        await PreferenceHandler().deleteIsLogin();
        await ProfileLocalStorage.clearProfileImagePath();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Akun berhasil dihapus, silakan login ulang'),
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPageDay30()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  InputDecoration buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: kPrimaryPink),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isEditing ? Colors.white : Color(0xFFFFEFF5),
      contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFFF4C6D8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: kPrimaryPink, width: 1.3),
      ),
    );
  }

  Widget buildIconAction({
    required IconData icon,
    required VoidCallback onTap,
    required Alignment alignment,
    Color? backgroundColor,
  }) {
    return Align(
      alignment: alignment,
      child: Material(
        color: backgroundColor ?? kPrimaryPink,
        shape: CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: CircleBorder(),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildProfileAvatar() {
    final initial = displayName != '-'
        ? displayName[0].toUpperCase()
        : 'U';

    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFFF9D7E4),
            backgroundImage: profileImageFile != null
                ? FileImage(profileImageFile!) as ImageProvider
                : null,
            child: profileImageFile == null
                ? Text(
                    initial,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryPink,
                    ),
                  )
                : null,
          ),
          buildIconAction(
            icon: Icons.add_a_photo_rounded,
            onTap: pickProfilePhoto,
            alignment: Alignment.bottomRight,
            backgroundColor: Color(0xFF2D1635),
          ),
        ],
      ),
    );
  }

  Widget buildActionButtons() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 54,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(colors: [kPrimaryPink, kSoftPink]),
                ),
                child: ElevatedButton(
                  onPressed: isSaving ? null : saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isSaving
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'Simpan Update',
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
                onPressed: isSaving ? null : resetChanges,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFFF3A8C3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Batal',
                  style: TextStyle(
                    color: kPrimaryPink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundLight,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF7FB), Color(0xFFFFEEF5), Color(0xFFFFFBF2)],
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
                                      kPrimaryPink,
                                      kSoftPink,
                                      kAccentYellow,
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
                              color: Color(0xFFFFF2F7),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Color(0xFFF4C6D8)),
                            ),
                            child: Row(
                              children: [
                                buildProfileAvatar(),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2D1635),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        displayEmail,
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
                            focusNode: nameFocusNode,
                            readOnly: !isEditing,
                            showCursor: isEditing,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) => setState(() {}),
                            onSubmitted: (_) => emailFocusNode.requestFocus(),
                            decoration: buildInputDecoration(
                              hintText: 'Masukkan nama lengkap',
                              prefixIcon: Icons.person_outline_rounded,
                              suffixIcon: !isEditing
                                  ? IconButton(
                                      onPressed: () => startEditing(),
                                      icon: Icon(
                                        Icons.edit_rounded,
                                        color: kPrimaryPink,
                                      ),
                                      tooltip: 'Edit nama',
                                    )
                                  : null,
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
                            focusNode: emailFocusNode,
                            readOnly: !isEditing,
                            showCursor: isEditing,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            onChanged: (_) => setState(() {}),
                            onSubmitted: (_) {
                              if (!isSaving) {
                                saveProfile();
                              }
                            },
                            decoration: buildInputDecoration(
                              hintText: 'Masukkan email',
                              prefixIcon: Icons.email_outlined,
                              suffixIcon: !isEditing
                                  ? IconButton(
                                      onPressed: () => startEditing(
                                        focusEmail: true,
                                      ),
                                      icon: Icon(
                                        Icons.edit_rounded,
                                        color: kPrimaryPink,
                                      ),
                                      tooltip: 'Edit email',
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(height: 24),
                          if (isEditing) buildActionButtons(),
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: deleteAccount,
                              icon: Icon(
                                Icons.delete_forever,
                                color: kPrimaryPink,
                              ),
                              label: Text(
                                'Hapus Akun',
                                style: TextStyle(
                                  color: kPrimaryPink,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Color(0xFFF3A8C3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
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
