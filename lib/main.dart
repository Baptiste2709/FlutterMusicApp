import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'api/client.dart';
import 'api/services/artist_service.dart';
import 'api/services/album_service.dart';
import 'api/services/chart_service.dart';
import 'data/local/favorites_storage.dart';
import 'data/repositories/artist_repository.dart';
import 'data/repositories/album_repository.dart';
import 'data/repositories/chart_repository.dart';
import 'data/repositories/favorites_repository.dart';
import 'presentation/blocs/artist/artist_bloc.dart';
import 'presentation/blocs/album/album_bloc.dart';
import 'presentation/blocs/charts/charts_bloc.dart';
import 'presentation/blocs/favorites/favorites_bloc.dart';
import 'presentation/blocs/search/search_bloc.dart';
import 'router/app_router.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configuration du thème et UI systèmes
  AppTheme.configureSystemUI();
  
  // Initialisation de Hive pour le stockage local
  await FavoritesStorage.init();
  
  // Lancement de l'application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialisation des services et dépendances
    final apiClient = ApiClient();
    
    // Création des repositories
    final artistRepository = ArtistRepository(); // Sans paramètre si le repository crée son propre client
    final albumRepository = AlbumRepository(); // Sans paramètre si le repository crée son propre client
    final chartRepository = ChartRepository(chartService: apiClient.chartService);
    final favoritesRepository = FavoritesRepository(); 
    
    // Configuration du router
    final appRouter = AppRouter();
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<ArtistBloc>(
          create: (context) => ArtistBloc(
            artistRepository: artistRepository,
            albumRepository: albumRepository,
          ),
        ),
        BlocProvider<AlbumBloc>(
          create: (context) => AlbumBloc(
            albumRepository: albumRepository,
          ),
        ),
        BlocProvider<ChartsBloc>(
          create: (context) => ChartsBloc(
            chartRepository: chartRepository,
          ),
        ),
        BlocProvider<FavoritesBloc>(
          create: (context) => FavoritesBloc(
            favoritesRepository: favoritesRepository,
          ),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(
            artistRepository: artistRepository,
            albumRepository: albumRepository,
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Music App',
        theme: AppTheme.lightTheme,
        routerConfig: appRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}