import 'package:flutter/material.dart';
import 'package:flutter_tugas_10/day_16/database/models/siswa_model.dart';
import 'package:flutter_tugas_10/day_16/database/siswa_controller.dart';
import 'package:flutter_tugas_10/day_16/database/user_controller.dart';

class CRSiswaScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController kelasController = TextEditingController();

  CRSiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.woman_2_rounded),
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Required a name")));
                  return;
                }
                SiswaController.registerSiswa(
                  SiswaModel(
                    nama: nameController.text,
                    kelas: kelasController.text,
                  ), //siswamodel
                );
                nameController.clear();
                kelasController.clear();
              },
              child: Text("Tambah Siswa"),
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.people),
                labelText: "Masukkan Nama Siswa",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Nama belum diisi")));
                  return;
                }
                SiswaController.registerSiswa(
                  SiswaModel(
                    nama: nameController.text,
                    kelas: kelasController.text,
                  ), //siswamodel
                );
                nameController.clear();
                kelasController.clear();
              },
              child: Text("Tambah Siswa"),
            ),
            TextFormField(
              controller: kelasController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.room),
                labelText: "Masukkan kelas",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Kelas belum diisi")));
                  return;
                }
                SiswaController.registerSiswa(
                  SiswaModel(
                    nama: nameController.text,
                    kelas: kelasController.text,
                  ), //siswamodel
                );
                nameController.clear();
                kelasController.clear();
              },
              child: Text("Tambah Siswa"),
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.people),
                labelText: "Masukkan Nama Siswa",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     if (kelasController.text.isEmpty) {
            //       ScaffoldMessenger.of(
            //         context,
            //       ).showSnackBar(SnackBar(content: Text("Kelas belum diisi")));
            //       return;
            //     }
            //   //   kelasController.(
            //   //     kelasModel(
            //   //       nama: nameController.text,
            //   //       kelas: kelasController.text,
            //   //     ), //siswamodel
            //   //   );
            //   //   nameController.clear();
            //   //   kelasController.clear();
            //   // },
            //   // child: Text("Tambah Siswa"),
            // ),
          ],
        ),
      ),
    );
  }
}
