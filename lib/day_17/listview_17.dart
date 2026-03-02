import 'package:flutter/material.dart';
import 'package:flutter_tugas_10/day_16/database/models/user_model.dart';
import 'package:flutter_tugas_10/day_16/database/sqflite.dart';

class UserListPage extends StatefulWidget {
  UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<UserModel>> users;

  @override
  void initState() {
    super.initState();
    users = DBHelper.getUsers(); //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registered Users")),
      body: FutureBuilder<List<UserModel>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No users yet"));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final user = data[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: Text(user.username),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
