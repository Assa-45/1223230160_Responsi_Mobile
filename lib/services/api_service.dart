import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime_model.dart';

class ApiService {
  static const String _baseUrl = 'https://kitsu.io/api/edge/';

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<List<Anime>> fetchAnimes({int limit = 100}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/anime?limit=$limit'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['anime'] as List)
          .map((p) => Anime.fromJson(p))
          .toList();
    } else {
      throw Exception('Gagal memuat anime. Status: ${response.statusCode}');
    }
  }

  Future<Anime> fetchAnimeById(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/anime/$id'),
    );

    if (response.statusCode == 200) {
      return Anime.fromJson(json.decode(response.body));
    } else {
      throw Exception('Anime tidak ditemukan. Status: ${response.statusCode}');
    }
  }
}