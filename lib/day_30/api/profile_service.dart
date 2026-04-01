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
      throw Exception("Gagal memuat profil");
    }
  }

  // UPDATE DATA (Update) - Mengirim perubahan ke API
  static Future<bool> updateProfile(String name, String email) async {
    var token = await PreferenceHandler.getToken();
    final response = await http.post(
      Uri.parse(
        Endpoint.profile,
      ), // Biasanya endpoint update sama dengan profile tapi method POST/PUT
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {"name": name, "email": email},
    );
    return response.statusCode == 200;
  }

  // DELETE (Delete)
  static Future<bool> deleteAccount() async {
    var token = await PreferenceHandler.getToken();
    final response = await http.delete(
      Uri.parse(Endpoint.profile), // Sesuaikan endpoint delete
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    return response.statusCode == 200;
  }
}
