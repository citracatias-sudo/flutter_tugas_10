import 'package:flutter/material.dart';
import 'package:flutter_tugas_10/login_page.dart';
import 'package:flutter_tugas_10/day_16/database/preference.dart';

class SplashScreenDay16 extends StatefulWidget {
  const SplashScreenDay16({super.key});

  @override
  State<SplashScreenDay16> createState() => _SplashScreenDay16State();
}

class _SplashScreenDay16State extends State<SplashScreenDay16> {
  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  Future<void> _autoLogin() async {
    await Future.delayed(Duration(seconds: 2));

    bool? isLoggedIn = await PreferenceHandler.getIsLogin();

    if (!mounted) return;

    if (isLoggedIn == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPageDay15()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPageDay15()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8428F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.woman),
            // Logo/Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                // color: Colors.white,
                // shape: BoxShape.circle,
              ),
              // child: Icon(Icons.favorite, size: 60, color: Colors.white),
            ),
            SizedBox(height: 40),

            // App Name
            Text(
              "HerSpace",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),

            // Subtitle
            Text(
              "Join the Community",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 60),

            // Loading Indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
