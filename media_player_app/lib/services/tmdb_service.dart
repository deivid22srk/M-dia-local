import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/media_item.dart';

class TmdbService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  // IMPORTANTE: Substitua pela sua chave API do TMDB
  // Obtenha gratuitamente em: https://www.themoviedb.org/settings/api
  static const String _apiKey = 'YOUR_TMDB_API_KEY';
  
  // Buscar filme/série por nome
  Future<List<MediaItem>> searchMulti(String query) async {
    if (query.isEmpty) return [];
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search/multi?api_key=$_apiKey&query=$query&language=pt-BR&page=1'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        
        return results
            .where((item) => item['media_type'] == 'movie' || item['media_type'] == 'tv')
            .map((item) => MediaItem.fromJson(item))
            .toList();
      } else {
        throw Exception('Falha ao buscar: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na busca: $e');
      return [];
    }
  }
  
  // Buscar detalhes do filme
  Future<MediaItem?> getMovieDetails(String movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey&language=pt-BR'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MediaItem.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar detalhes: $e');
      return null;
    }
  }
  
  // Buscar detalhes da série
  Future<MediaItem?> getTvDetails(String tvId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/tv/$tvId?api_key=$_apiKey&language=pt-BR'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MediaItem.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar detalhes: $e');
      return null;
    }
  }
  
  // Buscar populares
  Future<List<MediaItem>> getPopular({String type = 'movie', int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$type/popular?api_key=$_apiKey&language=pt-BR&page=$page'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((item) => MediaItem.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Erro ao buscar populares: $e');
      return [];
    }
  }
  
  // URL da imagem
  String getImageUrl(String? path, {String size = 'w500'}) {
    if (path == null || path.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/$size$path';
  }
}
