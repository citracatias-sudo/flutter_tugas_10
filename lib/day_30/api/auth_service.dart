import 'dart:convert';
import 'package:http/http.dart' as http;
import 'endpoint.dart';
import '../models/register_model.dart';

class AuthService {
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
      return RegisterModel.fromJson(_decodeBody(response.body));
    }

    throw Exception(_extractMessage(response, "Gagal daftar"));
  }

  static Future<RegisterModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      return RegisterModel.fromJson(_decodeBody(response.body));
    }

    throw Exception(_extractMessage(response, "Email atau password salah"));
  }

  static Map<String, dynamic> _decodeBody(String body) {
    final decoded = json.decode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    throw const FormatException('Format respons API tidak valid');
  }

  static String _extractMessage(http.Response response, String fallback) {
    try {
      final jsonBody = _decodeBody(response.body);
      final message = jsonBody['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }

      final errors = jsonBody['errors'];
      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
        if (firstError != null) {
          return firstError.toString();
        }
      }
    } catch (_) {}

    return fallback;
  }
}
