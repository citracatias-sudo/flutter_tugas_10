import 'package:flutter_tugas_10/day_16/database/models/user_model.dart';
import 'package:flutter_tugas_10/day_16/database/sqflite.dart';

class UserController {
  static Future<void> registerUser(UserModel user) async {
    final dbs = await DBHelper.db();
    await dbs.insert('users', user.toMap());
  }

  static Future<List<UserModel>> getAllUser() async {
    final dbs = await DBHelper.db();
    final results = await dbs.query('users');

    return results.map((e) => UserModel.fromMap(e)).toList();
  }

  static Future<int> updateUser(UserModel user) async {
    final dbs = await DBHelper.db();
    return dbs.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  static Future<int> deleteUser(int id) async {
    final dbs = await DBHelper.db();
    return dbs.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
