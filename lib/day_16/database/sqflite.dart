import 'package:flutter_tugas_10/day_16/database/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();

    return openDatabase(
      join(dbPath, 'her_space.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,
            username TEXT, email TEXT, password TEXT)''');
      },
    );
  }

  // REGISTER
  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();
    await dbs.insert('users', user.toMap());
  }

  // READ ALL USERS (untuk ListView)
  static Future<List<UserModel>> getUsers() async {
    final dbs = await db();
    final List<Map<String, dynamic>> maps = await dbs.query('users');

    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }
}
