import 'package:flutter/material.dart';
import 'package:flutter_tugas_10/login_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool obscurePassword = true;

  void login() {
    if (_formKey.currentState!.validate()) {
      if (emailController.text == "admin@email.com" &&
          passwordController.text == "123456") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login berhasil 🎉"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email or password doesn't match ❌"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3E5F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.pink,
                      child: Icon(Icons.favorite_border,
                          color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text("Sign in to continue"),
                    SizedBox(height: 25),

                    /// EMAIL
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Email Address"),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "your@email.com",
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email tidak boleh kosong";
                        }
                        if (!value.contains("@")) {
                          return "Format email tidak valid";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    /// PASSWORD
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Password"),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              obscurePassword =
                                  !obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password tidak boleh kosong";
                        }
                        if (value.length < 6) {
                          return "Minimal 6 karakter";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 10),

                    /// REMEMBER + FORGOT
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),
                        Text("Remember me"),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                                color: Colors.pink),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 15),

                    /// SIGN IN BUTTON
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Colors.pink,
                            Colors.purple
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text("Sign In"),
                      ),
                    ),

                    SizedBox(height: 20),

                    /// SIGN UP
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoginPageDay15(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.pink),
                          ),
                        ),
                      ],
                    )
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