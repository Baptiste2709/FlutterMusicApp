class AppConstants {
  // Noms des routes pour GoRouter
  static const String homeRoute = '/';
  static const String artistDetailsRoute = '/artist/:id';
  static const String albumDetailsRoute = '/album/:id';
  
  // Clés pour le stockage local
  static const String favoriteArtistsKey = 'favorite_artists';
  
  // Valeurs par défaut
  static const int defaultSearchLimit = 20;
  static const int defaultLoadingDelayMillis = 300;
  
  // Indices des onglets pour la page d'accueil
  static const int chartsTabIndex = 0;
  static const int searchTabIndex = 1;
  static const int favoritesTabIndex = 2;
}