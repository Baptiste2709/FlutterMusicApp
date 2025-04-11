import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/single_model.dart';
import '../models/album_model.dart';

class ApiService {
  static const String baseUrl = 'https://theaudiodb.com/api/v1/json/523532';
  
  // Recherche d'artistes
  static Future<List<dynamic>> searchArtists(String query) async {
    if (query.isEmpty) return [];
    
    final url = Uri.parse('$baseUrl/search.php?s=$query');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['artists'] == null) return [];
      
      // Transformation des données en modèles
      return data['artists'].map((artist) {
        return {
          'id': artist['idArtist'],
          'name': artist['strArtist'],
          'imageUrl': artist['strArtistThumb'],
          'type': 'artist',
        };
      }).toList();
    } else {
      throw Exception('Échec de la recherche d\'artistes');
    }
  }
  
  // Recherche d'albums
  static Future<List<dynamic>> searchAlbums(String query) async {
    if (query.isEmpty) return [];
    
    final url = Uri.parse('$baseUrl/searchalbum.php?s=$query');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['album'] == null) return [];
      
      // Transformation des données en modèles
      return data['album'].map((album) {
        return {
          'id': album['idAlbum'],
          'title': album['strAlbum'],
          'artist': album['strArtist'],
          'imageUrl': album['strAlbumThumb'],
          'type': 'album',
        };
      }).toList();
    } else {
      throw Exception('Échec de la recherche d\'albums');
    }
  }
  
  // Obtenir les classements
  static Future<List<SingleModel>> getTrendingSingles() async {
    final url = Uri.parse('$baseUrl/trending.php?country=us&type=itunes&format=singles');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['trending'] == null) return [];
      
      // Transformation des données en modèles SingleModel
      List<SingleModel> singles = [];
      for (int i = 0; i < data['trending'].length; i++) {
        final item = data['trending'][i];
        singles.add(
          SingleModel(
            position: i + 1,
            title: item['strTrack'] ?? 'Inconnu',
            artist: item['strArtist'] ?? 'Artiste inconnu',
            imageUrl: item['strTrackThumb'] ?? '',
          )
        );
      }
      return singles;
    } else {
      throw Exception('Échec de la récupération des tendances singles');
    }
  }
  
  // Obtenir les albums en tendance
  static Future<List<AlbumModel>> getTrendingAlbums() async {
    final url = Uri.parse('$baseUrl/trending.php?country=us&type=itunes&format=albums');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['trending'] == null) return [];
      
      // Transformation des données en modèles AlbumModel
      List<AlbumModel> albums = [];
      for (int i = 0; i < data['trending'].length; i++) {
        final item = data['trending'][i];
        albums.add(
          AlbumModel(
            position: i + 1,
            title: item['strAlbum'] ?? 'Inconnu',
            artist: item['strArtist'] ?? 'Artiste inconnu',
            imageUrl: item['strAlbumThumb'] ?? '',
          )
        );
      }
      return albums;
    } else {
      throw Exception('Échec de la récupération des tendances albums');
    }
  }
  
  // Obtenir les détails d'un artiste
  static Future<Map<String, dynamic>> getArtistDetails(String artistId) async {
    final url = Uri.parse('$baseUrl/artist.php?i=$artistId');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['artists'] == null || data['artists'].isEmpty) {
        throw Exception('Artiste non trouvé');
      }
      return data['artists'][0];
    } else {
      throw Exception('Échec de la récupération des détails de l\'artiste');
    }
  }
  
  // Obtenir les albums d'un artiste
  static Future<List<AlbumModel>> getArtistAlbums(String artistId) async {
    final url = Uri.parse('$baseUrl/album.php?i=$artistId');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['album'] == null) return [];
      
      List<AlbumModel> albums = [];
      for (int i = 0; i < data['album'].length; i++) {
        final item = data['album'][i];
        albums.add(
          AlbumModel(
            position: i + 1,
            title: item['strAlbum'] ?? 'Inconnu',
            artist: item['strArtist'] ?? 'Artiste inconnu',
            imageUrl: item['strAlbumThumb'] ?? '',
          )
        );
      }
      return albums;
    } else {
      throw Exception('Échec de la récupération des albums de l\'artiste');
    }
  }
  
  // Obtenir les détails d'un album
  static Future<Map<String, dynamic>> getAlbumDetails(String albumId) async {
    final url = Uri.parse('$baseUrl/album.php?m=$albumId');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['album'] == null || data['album'].isEmpty) {
        throw Exception('Album non trouvé');
      }
      return data['album'][0];
    } else {
      throw Exception('Échec de la récupération des détails de l\'album');
    }
  }
}