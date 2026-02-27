import 'package:flutter/material.dart';
import 'package:flutter_tugas_10/coming_soon.dart';

class EmptyPage15 extends StatelessWidget {
  final String name;
  final String city;

  const EmptyPage15({super.key, required this.name, required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Welcome to Herspace",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFF8428F),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome $name",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Dari kota $city", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ComingSoonDay15()),
                );
              },
              child: Text(
                "Connect with the community",
                style: TextStyle(color: Color(0xFFF8428F)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
