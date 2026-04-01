import 'dart:convert';
import 'package:http/http.dart' as http;
import 'endpoint.dart';
import '../models/register_model.dart';

class AuthService {
  // CREATE (Register)
  static Future<RegisterModel> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse(Endpoint.register),
      headers: {"Accept": "application/json"},
      body: {"name": name, "email": email, "password": password},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RegisterModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(json.decode(response.body)['message'] ?? "Gagal Daftar");
    }
  }

  // CREATE (Login)
  static Future<RegisterModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      return RegisterModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        json.decode(response.body)['message'] ?? "Email/Password Salah",
      );
    }
  }
}
