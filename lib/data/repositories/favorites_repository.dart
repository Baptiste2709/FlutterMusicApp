import 'package:hive_flutter/hive_flutter.dart';
import '../../api/models/artist.dart';
import '../../core/constants/app_constants.dart';

class FavoritesRepository {
  late Box<Map> _favoritesBox;
  
  // Singleton
  static final FavoritesRepository _instance = FavoritesRepository._internal();
  
  factory FavoritesRepository() => _instance;
  
  FavoritesRepository._internal();
  
  /// Initialise le stockage des favoris
  Future<void> init() async {
    _favoritesBox = await Hive.openBox<Map>('favorites');
  }
  
  /// Ajoute ou supprime un artiste des favoris
  Future<bool> toggleFavoriteArtist(Artist artist) async {
    if (artist.id == null) return false;
    
    final favoriteArtists = getFavoriteArtists();
    final isCurrentlyFavorite = isArtistFavorite(artist.id);
    
    if (isCurrentlyFavorite) {
      // Supprimer l'artiste des favoris
      favoriteArtists.removeWhere((a) => a.id == artist.id);
    } else {
      // Ajouter l'artiste aux favoris
      favoriteArtists.add(artist);
    }
    
    // Sauvegarder la liste mise à jour
    await _saveFavoriteArtists(favoriteArtists);
    
    // Retourner le nouvel état (true si maintenant favori, false sinon)
    return !isCurrentlyFavorite;
  }
  
  /// Récupère tous les artistes favoris
  List<Artist> getFavoriteArtists() {
    final List<Map> favorites = _favoritesBox.get(
      AppConstants.favoriteArtistsKey,
      defaultValue: <Map>[],
    ) as List<Map>;
    
    return favorites.map((map) {
      return Artist.fromJson(Map<String, dynamic>.from(map));
    }).toList();
  }
  
  /// Vérifie si un artiste est dans les favoris
  bool isArtistFavorite(String? artistId) {
    if (artistId == null) return false;
    
    final favoriteArtists = getFavoriteArtists();
    return favoriteArtists.any((artist) => artist.id == artistId);
  }
  
  /// Sauvegarde la liste des artistes favoris
  Future<void> _saveFavoriteArtists(List<Artist> artists) async {
    final List<Map<String, dynamic>> artistMaps = artists
        .map((artist) => artist.toJson())
        .toList();
    
    await _favoritesBox.put(AppConstants.favoriteArtistsKey, artistMaps);
  }
}