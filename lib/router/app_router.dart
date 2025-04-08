import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/artist_details/artist_details_screen.dart';
import '../presentation/screens/album_details/album_details_screen.dart';

/// Router central de l'application utilisant GoRouter.
class AppRouter {
  final GoRouter router;
  
  AppRouter() : router = _createRouter();
  
  static GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/charts',
      routes: [
        // Route principale: redirection vers l'onglet Charts
        GoRoute(
          path: '/',
          redirect: (context, state) => '/charts',
        ),
        
        // Routes des onglets de la page d'accueil
        GoRoute(
          path: '/charts',
          builder: (context, state) => const HomeScreen(initialTabIndex: 0),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const HomeScreen(initialTabIndex: 1),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const HomeScreen(initialTabIndex: 2),
        ),
        
        // Détails d'un artiste
        GoRoute(
          path: '/artist/:id',
          builder: (context, state) {
            final artistId = state.pathParameters['id'] ?? '';
            return ArtistDetailsScreen(artistId: artistId);
          },
        ),
        
        // Détails d'un album
        GoRoute(
          path: '/album/:id',
          builder: (context, state) {
            final albumId = state.pathParameters['id'] ?? '';
            return AlbumDetailsScreen(albumId: albumId);
          },
        ),
      ],
      
      // Configuration des erreurs
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Page Not Found'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'The page "${state.uri.toString()}" was not found.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => GoRouter.of(context).go('/charts'),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}