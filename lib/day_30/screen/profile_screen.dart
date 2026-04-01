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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil CRUD")),
      body: FutureBuilder<GetUserModel>(
        future: ProfileService.getProfile(), // Memanggil data dari API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final user = snapshot.data?.data;

          // Mengisi controller hanya saat pertama kali data muncul
          if (!isEditing) {
            nameController.text = user?.name ?? "";
            emailController.text = user?.email ?? "";
          }

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  enabled: isEditing,
                  decoration: InputDecoration(labelText: "Nama"),
                ),
                TextField(
                  controller: emailController,
                  enabled: isEditing,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                SizedBox(height: 20),

                // TOMBOL UPDATE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (isEditing) {
                          // Logika Simpan (Update)
                          bool success = await ProfileService.updateProfile(
                            nameController.text,
                            emailController.text,
                          );
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Berhasil Update!")),
                            );
                            setState(() {
                              isEditing = false;
                            }); // Refresh UI
                          }
                        } else {
                          setState(() {
                            isEditing = true;
                          });
                        }
                      },
                      child: Text(isEditing ? "Simpan" : "Edit Profil"),
                    ),

                    // TOMBOL DELETE
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => _showDeleteDialog(),
                      child: Text(
                        "Hapus Akun",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Dialog konfirmasi hapus
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Hapus Akun?"),
        content: Text("Tindakan ini tidak bisa dibatalkan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              bool success = await ProfileService.deleteAccount();
              if (success) {
                Navigator.pop(context); // Tutup dialog
                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                ); // Tendang ke login
              }
            },
            child: Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
