import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tugas_10/day_16/database/preference.dart';
import 'endpoint.dart';
import '../models/get_model.dart';

class ProfileService {
  // GET DATA (Read) - Mengambil data user yang sedang login
  static Future<GetUserModel> getProfile() async {
    var token = await PreferenceHandler.getToken();
    final response = await http.get(
      Uri.parse(
        Endpoint.profile,
      ), // Sesuaikan endpoint profile di endpoint.dart
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return GetUserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(_extractMessage(response, "Gagal memuat profil"));
    }
  }

  // UPDATE DATA (Update) - Mengirim perubahan ke API
  static Future<bool> updateProfile(String name, String email) async {
    var token = await PreferenceHandler.getToken();
    final headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    final body = {"name": name, "email": email};

    http.Response response = await http.put(
      Uri.parse(Endpoint.profile),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 404 ||
        response.statusCode == 405 ||
        response.statusCode == 422) {
      response = await http.post(
        Uri.parse(Endpoint.profile),
        headers: headers,
        body: body,
      );
    }

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception(_extractMessage(response, "Gagal menyimpan perubahan profil"));
  }

  static String _extractMessage(http.Response response, String fallback) {
    try {
      final jsonBody = json.decode(response.body);
      if (jsonBody is Map<String, dynamic>) {
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
          return firstError.toString();
        }
      }
    } catch (_) {}

    return fallback;
  }
}
