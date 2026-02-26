import 'package:flutter/material.dart';
import 'package:flutter_tugas_10/empty_page.dart';

class LoginPageDay15 extends StatefulWidget {
  const LoginPageDay15({super.key});

  @override
  State<LoginPageDay15> createState() => _LoginPageDay15State();
}

class _LoginPageDay15State extends State<LoginPageDay15> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE7F6),
      body: Padding(
        padding: EdgeInsets.fromLTRB(32, 100, 32, 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Join the Community",
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 39, 35, 35),
                ),
              ),
              Text(
                "Create your account",
                style: TextStyle(
                  fontSize: 13,
                  color: Color.fromARGB(115, 47, 44, 44),
                ),
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: "City",
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: "Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  final digitsOnly = RegExp(r'^\d+$');
                  if (!digitsOnly.hasMatch(value)) {
                    return 'Only digits allowed';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "E-mail",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  final emailRegex = RegExp(
                    r"^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$",
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF8428F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Registration Succesful 🎉"),
                            content: Text(
                              "Hallo ${nameController.text} from ${cityController.text}, we welcome you to HerSpace!",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // tutup dialog
                                },
                                child: Text("Close"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // tutup dialog dulu
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EmptyPage15(
                                        name: nameController.text,
                                        city: cityController.text,
                                      ),
                                    ),
                                  );
                                },
                                child: Text("Agree"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
