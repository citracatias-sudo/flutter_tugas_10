import 'package:flutter_tugas_10/day_16/database/models/user_model.dart';
import 'package:flutter_tugas_10/day_16/database/sqflite.dart';

class UserController {
  static Future<void> registerUser(UserModel user) async {
    final dbs = await DBHelper.db();
    await dbs.insert('User', user.toMap());
    print(user.toMap());
  }

  static Future<List<UserModel>> getAllUser() async {
    final dbs = await DBHelper.db();
    final List<Map<String, dynamic>> results = await dbs.query('user');

    print(results.map((e) => UserModel.fromMap(e)).toList());
    return results.map((e) => UserModel.fromMap(e)).toList();
  }
}
