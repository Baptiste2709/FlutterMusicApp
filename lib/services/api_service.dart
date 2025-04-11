import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/single_model.dart';
import '../models/album_model.dart';

class ApiService {
  static const String baseUrl = 'https://theaudiodb.com/api/v1/json/523532';
  
  // Recherche d'artistes
  static Future<List<dynamic>> searchArtists(String query) async {
    if (query.isEmpty) return [];
    
    // Version simplifiée pour utiliser l'API de recherche d'artiste par nom
    final url = Uri.parse('$baseUrl/search.php?s=${Uri.encodeComponent(query)}');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['artists'] == null) return [];
      
      // Transformation des données en modèles
      return data['artists'].map((artist) {
        return {
          'id': artist['idArtist'],
          'name': artist['strArtist'],
          'imageUrl': artist['strArtistThumb'] ?? '',
          'type': 'artist',
          'country': artist['strCountry'] ?? '',
          'genre': artist['strGenre'] ?? '',
          'description': artist['strBiographyFR'] ?? artist['strBiographyEN'] ?? '',
        };
      }).toList();
    } else {
      throw Exception('Échec de la recherche d\'artistes');
    }
  }
  
  // Recherche d'albums par nom d'artiste
  static Future<List<dynamic>> searchAlbums(String query) async {
    if (query.isEmpty) return [];
    
    final url = Uri.parse('$baseUrl/searchalbum.php?s=${Uri.encodeComponent(query)}');
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
          'artistId': album['idArtist'],
          'imageUrl': album['strAlbumThumb'] ?? '',
          'type': 'album',
          'year': album['intYearReleased'] ?? '',
          'genre': album['strGenre'] ?? '',
          'description': album['strDescriptionFR'] ?? album['strDescriptionEN'] ?? '',
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
      
      // Récupérer l'ID de l'artiste
      String artistId = '';
      if (item['strArtist'] != null) {
        try {
          // Rechercher l'artiste pour obtenir son ID
          final artistData = await searchArtists(item['strArtist']);
          if (artistData.isNotEmpty) {
            artistId = artistData[0]['id'] ?? '';
          }
        } catch (e) {
          print('Erreur lors de la récupération de l\'ID artiste: $e');
        }
      }
      
      singles.add(
        SingleModel(
          position: i + 1,
          title: item['strTrack'] ?? 'Inconnu',
          artist: item['strArtist'] ?? 'Artiste inconnu',
          imageUrl: item['strTrackThumb'] ?? '',
          artistId: artistId, // Ajouter l'ID de l'artiste
          trackId: item['idTrack'] ?? '', // Récupérer l'ID du titre
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
      
      // Variables pour stocker les IDs
      String albumId = '';
      String artistId = '';
      
      // Récupérer l'ID de l'album et de l'artiste si disponible
      if (item['strAlbum'] != null && item['strArtist'] != null) {
        try {
          // Rechercher l'album pour obtenir son ID
          final albumData = await searchAlbums(item['strArtist']);
          if (albumData.isNotEmpty) {
            // Chercher l'album correspondant
            for (final album in albumData) {
              if (album['title'] == item['strAlbum']) {
                albumId = album['id'] ?? '';
                artistId = album['artistId'] ?? '';
                break;
              }
            }
          }
          
          // Si artistId n'est pas trouvé dans la recherche d'album
          if (artistId.isEmpty) {
            final artistData = await searchArtists(item['strArtist']);
            if (artistData.isNotEmpty) {
              artistId = artistData[0]['id'] ?? '';
            }
          }
        } catch (e) {
          print('Erreur lors de la récupération des IDs: $e');
        }
      }
      
      albums.add(
        AlbumModel(
          position: i + 1,
          title: item['strAlbum'] ?? 'Inconnu',
          artist: item['strArtist'] ?? 'Artiste inconnu',
          imageUrl: item['strAlbumThumb'] ?? '',
          albumId: albumId, // Ajouter l'ID de l'album
          artistId: artistId, // Ajouter l'ID de l'artiste
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
          albumId: item['idAlbum'] ?? '', // Ajouter l'ID de l'album
          artistId: item['idArtist'] ?? artistId, // Ajouter l'ID de l'artiste
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
  
  // Obtenir les genres musicaux (prédéfinis)
  static Future<List<String>> getMusicGenres() async {
    // Liste de genres musicaux prédéfinis
    return [
      'Pop', 'Rock', 'Hip Hop', 'R&B', 'Jazz', 'Électronique',
      'Classique', 'Reggae', 'Country', 'Blues', 'Folk', 'Metal'
    ];
  }

  // Obtenir des artistes populaires
  static Future<List<dynamic>> getPopularArtists() async {
    // Une liste d'artistes populaires à rechercher
    final popularNames = ['Coldplay', 'Drake', 'Taylor Swift', 'Beyonce', 'Adele', 'Ed Sheeran'];
    List<dynamic> results = [];
    
    // Rechercher Coldplay qui est pris en charge par l'API gratuite
    try {
      final response = await searchArtists('coldplay');
      if (response.isNotEmpty) {
        results.add(response[0]);
      }
      
      // Pour simuler plus d'artistes populaires (en production, vous utiliseriez l'API complète)
      for (int i = 1; i < popularNames.length; i++) {
        results.add({
          'id': '1000$i',
          'name': popularNames[i],
          'imageUrl': '',  // pas d'image réelle disponible sans API premium
          'type': 'artist',
          'genre': i % 2 == 0 ? 'Pop' : 'Rock',
          'country': 'US',
        });
      }
    } catch (e) {
      // En cas d'erreur, retourner une liste vide
      print('Erreur lors de la récupération des artistes populaires: $e');
    }
    
    return results;
  }
}