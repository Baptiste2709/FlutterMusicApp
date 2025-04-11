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
      if (key.toString().startsWith('artist_')) {
        final jsonString = _favoritesBox!.get(key);
        if (jsonString != null) {
          try {
            final Map<String, dynamic> artist = json.decode(jsonString);
            favorites.add(artist);
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
  
  // Ajouter un artiste aux favoris
  static Future<void> addArtistToFavorites(Map<String, dynamic> artist) async {
    if (_favoritesBox == null) return;
    
    final String artistId = artist['id'];
    await _favoritesBox!.put('artist_$artistId', json.encode(artist));
    
    // Mettre à jour la liste des favoris
    final currentFavorites = List<Map<String, dynamic>>.from(favoritesNotifier.value);
    currentFavorites.add(artist);
    favoritesNotifier.value = currentFavorites;
  }
  
  // Supprimer un artiste des favoris
  static Future<void> removeArtistFromFavorites(String artistId) async {
    if (_favoritesBox == null) return;
    
    await _favoritesBox!.delete('artist_$artistId');
    
    // Mettre à jour la liste des favoris
    final currentFavorites = List<Map<String, dynamic>>.from(favoritesNotifier.value);
    currentFavorites.removeWhere((artist) => artist['id'] == artistId);
    favoritesNotifier.value = currentFavorites;
  }
  
  // Obtenir tous les artistes favoris
  static List<Map<String, dynamic>> getAllFavoriteArtists() {
    return favoritesNotifier.value;
  }
  
  // Fermer la box de favoris
  static void dispose() {
    _favoritesBox?.close();
  }
}