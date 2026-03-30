import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/character_model.dart'; 

Future<List<Result>> getCharacters() async {
  final response = await http.get(
    Uri.parse("https://rickandmortyapi.com/api/character"),
  );

  if (response.statusCode == 200) {
    // 1. Decode body response
    final Map<String, dynamic> jsonData = json.decode(response.body);

    // 2. Ambil List dari key "results"
    final List<dynamic> results = jsonData["results"];

    // 3. Ubah menjadi List of CharacterData menggunakan model
    return results.map((e) => Result.fromJson(e)).toList();
  } else {
    throw Exception("Gagal mengambil data karakter");
  }
}
