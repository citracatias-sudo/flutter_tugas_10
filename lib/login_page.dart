import 'package:flutter/material.dart';
import 'package:flutter_tugas_10/day_16/database/models/user_model.dart';
import 'package:flutter_tugas_10/day_16/database/sqflite.dart';
import 'package:flutter_tugas_10/day_17/listview_17.dart';
import 'package:flutter_tugas_10/empty_page.dart';

class LoginPageDay15 extends StatefulWidget {
  const LoginPageDay15({super.key});

  @override
  State<LoginPageDay15> createState() => _LoginPageDay15State();
}

class _LoginPageDay15State extends State<LoginPageDay15> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE7F6),
      body: Padding(
        padding: EdgeInsets.fromLTRB(32, 100, 32, 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Join the Community", style: TextStyle(fontSize: 25)),
                Text("Create your account", style: TextStyle(fontSize: 13)),
                SizedBox(height: 20),

                // NAME
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter your name" : null,
                ),
                SizedBox(height: 15),

                // USERNAME
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.alternate_email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter username" : null,
                ),
                SizedBox(height: 15),

                // CITY
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Phone Number" : null,
                ),
                SizedBox(height: 15),

                // EMAIL
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter email";
                    }
                    if (!value.contains("@")) {
                      return "Invalid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),

                // PASSWORD
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter password";
                    }
                    if (value.length < 6) {
                      return "Min 6 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color((0XFFF8428F)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await DBHelper.registerUser(
                          UserModel(
                            name: nameController.text,
                            username: usernameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Registration Successful")),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => UserListPage()),
                        );
                      }
                    },
                    child: Text("Sign Up"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
