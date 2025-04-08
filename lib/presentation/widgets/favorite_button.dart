import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/models/artist.dart';
import '../../presentation/blocs/favorites/favorites_bloc.dart';
import '../../presentation/blocs/favorites/favorites_event.dart';
import '../../presentation/blocs/favorites/favorites_state.dart';
import '../../themes/app_colors.dart';

class FavoriteButton extends StatelessWidget {
  final Artist artist;
  final Color? activeColor;
  final Color? inactiveColor;
  final double size;
  
  const FavoriteButton({
    Key? key,
    required this.artist,
    this.activeColor,
    this.inactiveColor,
    this.size = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state is FavoritesLoadedState && state.isFavorite(artist.id ?? '');
        
        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite 
                ? activeColor ?? AppColors.favorite 
                : inactiveColor ?? AppColors.iconInactive,
            size: size,
          ),
          onPressed: () {
            if (artist.id == null) return;
            
            if (isFavorite) {
              context.read<FavoritesBloc>().add(RemoveFavoriteEvent(artist.id!));
            } else {
              context.read<FavoritesBloc>().add(AddFavoriteEvent(artist));
            }
          },
        );
      },
    );
  }
}