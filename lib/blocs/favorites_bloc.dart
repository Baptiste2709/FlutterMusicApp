import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesBloc {
  static const String _favoritesBoxName = 'favorites';
  static Box<String>? _favoritesBox;
  
  // Notifier pour informer les widgets des changements
  static final ValueNotifier<List<Map<String, dynamic>>> favoritesNotifier = 
      ValueNotifier<List<Map<String, dynamic>>>([]);
  
  // Initialisation du bloc
  static Future<void> init() async {
    await Hive.initFlutter();
    _favoritesBox = await Hive.openBox<String>(_favoritesBoxName);
    _loadFavorites();
  }
  
  // Charger les favoris depuis Hive
  static Future<void> _loadFavorites() async {
    if (_favoritesBox == null) return;
    
    final List<Map<String, dynamic>> favorites = [];
    
    for (var key in _favoritesBox!.keys) {
      if (key.toString().startsWith('artist_') || key.toString().startsWith('album_')) {
        final jsonString = _favoritesBox!.get(key);
        if (jsonString != null) {
          try {
            final Map<String, dynamic> favorite = json.decode(jsonString);
            favorites.add(favorite);
          } catch (e) {
            print('Erreur lors de la lecture des favoris: $e');
          }
        }
      }
    }
    
    favoritesNotifier.value = favorites;
  }
  
  // Vérifier si un artiste est dans les favoris
  static Future<bool> isArtistFavorite(String artistId) async {
    if (_favoritesBox == null) return false;
    return _favoritesBox!.containsKey('artist_$artistId');
  }
  
  // Vérifier si un album est dans les favoris
  static Future<bool> isAlbumFavorite(String albumId) async {
    if (_favoritesBox == null) return false;
    return _favoritesBox!.containsKey('album_$albumId');
  }
  
  // Ajouter un artiste aux favoris
  static Future<void> addArtistToFavorites(Map<String, dynamic> artist) async {
    if (_favoritesBox == null) return;
    
    // S'assurer que le type est défini
    artist['type'] = 'artist';
    
    final String artistId = artist['id'];
    await _favoritesBox!.put('artist_$artistId', json.encode(artist));
    
    // Mettre à jour la liste des favoris
    final currentFavorites = List<Map<String, dynamic>>.from(favoritesNotifier.value);
    currentFavorites.add(artist);
    favoritesNotifier.value = currentFavorites;
  }
  
  // Ajouter un album aux favoris
  static Future<void> addAlbumToFavorites(Map<String, dynamic> album) async {
    if (_favoritesBox == null) return;
    
    // S'assurer que le type est défini
    album['type'] = 'album';
    
    final String albumId = album['id'];
    await _favoritesBox!.put('album_$albumId', json.encode(album));
    
    // Mettre à jour la liste des favoris
    final currentFavorites = List<Map<String, dynamic>>.from(favoritesNotifier.value);
    currentFavorites.add(album);
    favoritesNotifier.value = currentFavorites;
  }
  
  // Supprimer un artiste des favoris
  static Future<void> removeArtistFromFavorites(String artistId) async {
    if (_favoritesBox == null) return;
    
    await _favoritesBox!.delete('artist_$artistId');
    
    // Mettre à jour la liste des favoris
    final currentFavorites = List<Map<String, dynamic>>.from(favoritesNotifier.value);
    currentFavorites.removeWhere((item) => item['type'] == 'artist' && item['id'] == artistId);
    favoritesNotifier.value = currentFavorites;
  }
  
  // Supprimer un album des favoris
  static Future<void> removeAlbumFromFavorites(String albumId) async {
    if (_favoritesBox == null) return;
    
    await _favoritesBox!.delete('album_$albumId');
    
    // Mettre à jour la liste des favoris
    final currentFavorites = List<Map<String, dynamic>>.from(favoritesNotifier.value);
    currentFavorites.removeWhere((item) => item['type'] == 'album' && item['id'] == albumId);
    favoritesNotifier.value = currentFavorites;
  }
  
  // Obtenir tous les favoris
  static List<Map<String, dynamic>> getAllFavorites() {
    return favoritesNotifier.value;
  }
  
  // Fermer la box de favoris
  static void dispose() {
    _favoritesBox?.close();
  }
}