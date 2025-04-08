import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../api/models/artist.dart';

class FavoritesStorage {
  static const String _boxName = 'favorites';
  
  /// Initialise la base de données Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_boxName);
  }
  
  /// Récupère la box des favoris
  Box<String> get _box => Hive.box<String>(_boxName);
  
  /// Récupère tous les artistes favoris
  Future<List<Artist>> getFavorites() async {
    final List<Artist> favorites = [];
    
    for (var key in _box.keys) {
      final jsonString = _box.get(key);
      if (jsonString != null) {
        try {
          final Map<String, dynamic> json = jsonDecode(jsonString);
          favorites.add(Artist.fromJson(json));
        } catch (e) {
          // Ignorer les entrées invalides
          await _box.delete(key);
        }
      }
    }
    
    return favorites;
  }
  
  /// Ajoute un artiste aux favoris
  Future<void> addFavorite(Artist artist) async {
    if (artist.id == null) return;
    
    final jsonString = jsonEncode(artist.toJson());
    await _box.put(artist.id!, jsonString);
  }
  
  /// Supprime un artiste des favoris
  Future<void> removeFavorite(String artistId) async {
    await _box.delete(artistId);
  }
  
  /// Vérifie si un artiste est dans les favoris
  Future<bool> isFavorite(String artistId) async {
    return _box.containsKey(artistId);
  }
  
  /// Efface tous les favoris
  Future<void> clearFavorites() async {
    await _box.clear();
  }
}