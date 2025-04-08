import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../presentation/blocs/favorites/favorites_bloc.dart';
import '../../../../presentation/blocs/favorites/favorites_event.dart';
import '../../../../presentation/blocs/favorites/favorites_state.dart';
import '../../../../presentation/widgets/artist_card.dart';
import '../../../../presentation/widgets/loading_indicator.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({Key? key}) : super(key: key);

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  @override
  void initState() {
    super.initState();
    // Load favorites when the tab is initialized
    context.read<FavoritesBloc>().add(LoadFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoadingState) {
          return const LoadingIndicator();
        } else if (state is FavoritesLoadedState) {
          if (state.favorites.isEmpty) {
            return _buildEmptyFavorites();
          }
          return _buildFavoritesList(state);
        } else if (state is FavoritesErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error.withOpacity(0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${state.message}',
                  style: AppTextStyles.withColor(
                    AppTextStyles.body1,
                    AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<FavoritesBloc>().add(LoadFavoritesEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildEmptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 72,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No favorite artists yet',
            style: AppTextStyles.withColor(
              AppTextStyles.h3,
              AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Start adding your favorite artists by tapping the heart icon on artist details',
              style: AppTextStyles.withColor(
                AppTextStyles.body2,
                AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to the search tab
              context.go('/search');
            },
            icon: const Icon(Icons.search),
            label: const Text('Find Artists'),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(FavoritesLoadedState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: state.favorites.length,
        itemBuilder: (context, index) {
          final artist = state.favorites[index];
          return ArtistCard(
            artist: artist,
            onTap: () => context.push('/artist/${artist.id}'),
          );
        },
      ),
    );
  }
}