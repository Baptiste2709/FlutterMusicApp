import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../api/models/album.dart';
import '../../../presentation/blocs/album/album_bloc.dart';
import '../../../presentation/blocs/album/album_event.dart';
import '../../../presentation/blocs/album/album_state.dart';
import '../../../presentation/widgets/error_view.dart';
import '../../../presentation/widgets/loading_indicator.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class AlbumDetailsScreen extends StatefulWidget {
  final String albumId;
  
  const AlbumDetailsScreen({
    Key? key,
    required this.albumId,
  }) : super(key: key);

  @override
  State<AlbumDetailsScreen> createState() => _AlbumDetailsScreenState();
}

class _AlbumDetailsScreenState extends State<AlbumDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Load album details when the screen is initialized
    context.read<AlbumBloc>().add(LoadAlbumEvent(widget.albumId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoadingState) {
            return const LoadingIndicator();
          } else if (state is AlbumErrorState) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<AlbumBloc>().add(LoadAlbumEvent(widget.albumId));
              },
            );
          } else if (state is AlbumLoadedState) {
            return _buildAlbumDetails(context, state.album);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildAlbumDetails(BuildContext context, Album album) {
    final locale = Localizations.localeOf(context).languageCode;
    final description = album.getDescription(locale);
    
    return CustomScrollView(
      slivers: [
        // App bar with album cover
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Album cover background
                if (album.albumThumbHQ != null || album.albumThumb != null)
                  Image.network(
                    album.albumThumbHQ ?? album.albumThumb ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.albumChart.withOpacity(0.8),
                              AppColors.primary,
                            ],
                          ),
                        ),
                      );
                    },
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.albumChart.withOpacity(0.8),
                          AppColors.primary,
                        ],
                      ),
                    ),
                  ),
                
                // Gradient overlay for better text readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
                
                // Album info at bottom
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        album.name ?? 'Unknown Album',
                        style: AppTextStyles.withColor(
                          AppTextStyles.h2,
                          Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        album.artist ?? 'Unknown Artist',
                        style: AppTextStyles.withColor(
                          AppTextStyles.h4,
                          Colors.white.withOpacity(0.9),
                        ),
                      ),
                      if (album.yearReleased != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          album.yearReleased!,
                          style: AppTextStyles.withColor(
                            AppTextStyles.body2,
                            Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Album details
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Genre and style
                if (album.genre != null || album.style != null) ...[
                  Row(
                    children: [
                      if (album.genre != null) ...[
                        Chip(
                          label: Text(album.genre!),
                          backgroundColor: AppColors.genreColors[0].withOpacity(0.2),
                          labelStyle: AppTextStyles.withColor(
                            AppTextStyles.caption,
                            AppColors.genreColors[0],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (album.style != null) ...[
                        Chip(
                          label: Text(album.style!),
                          backgroundColor: AppColors.genreColors[1].withOpacity(0.2),
                          labelStyle: AppTextStyles.withColor(
                            AppTextStyles.caption,
                            AppColors.genreColors[1],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Label and sales
                Row(
                  children: [
                    if (album.label != null) ...[
                      Icon(
                        Icons.business,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        album.label!,
                        style: AppTextStyles.withColor(
                          AppTextStyles.body2,
                          AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                    if (album.sales != null) ...[
                      Icon(
                        Icons.album,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${album.sales} sales',
                        style: AppTextStyles.withColor(
                          AppTextStyles.body2,
                          AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                
                if (album.artistId != null) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.push('/artist/${album.artistId}');
                    },
                    icon: const Icon(Icons.person),
                    label: const Text('View Artist'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                const Divider(),
                
                // Description
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'About the Album',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: AppTextStyles.body1,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}