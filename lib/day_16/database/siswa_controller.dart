import 'package:flutter_tugas_10/day_16/database/models/siswa_model.dart';
import 'package:flutter_tugas_10/day_16/database/sqflite.dart';

class SiswaController {
  static Future<void> registerSiswa(SiswaModel siswa) async {
    final dbs = await DBHelper.db();
    await dbs.insert('siswa', siswa.toMap());
    print(siswa.toMap());
  }

  static Future<List<SiswaModel>> getAllSiswa() async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query('siswa');

    print(results.map((e) => SiswaModel.fromMap(e)).toList());
    return results.map((e) => SiswaModel.fromMap(e)).toList();
  }
}
