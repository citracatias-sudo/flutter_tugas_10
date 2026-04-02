import 'package:flutter/material.dart';
import 'package:flutter_tugas_10/day_30/screen/login_day_30.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryPink = Color(0xFFEA4C89);
    const softPink = Color(0xFFFF7AA2);
    const warmCream = Color(0xFFFFF7FB);
    const deepText = Color(0xFF2D1635);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Tugas 10',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPink,
          primary: primaryPink,
          secondary: softPink,
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: warmCream,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: deepText,
          elevation: 0,
          centerTitle: true,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: deepText,
          contentTextStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const LoginPageDay30(),
    );
  }
}
