import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../api/models/artist.dart';
import '../../../api/models/album.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/string_utils.dart';
import '../../../presentation/blocs/artist/artist_bloc.dart';
import '../../../presentation/blocs/artist/artist_event.dart';
import '../../../presentation/blocs/artist/artist_state.dart';
import '../../../presentation/widgets/album_card.dart';
import '../../../presentation/widgets/error_view.dart';
import '../../../presentation/widgets/favorite_button.dart';
import '../../../presentation/widgets/loading_indicator.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_text_styles.dart';

class ArtistDetailsScreen extends StatefulWidget {
  final String artistId;
  
  const ArtistDetailsScreen({
    Key? key,
    required this.artistId,
  }) : super(key: key);

  @override
  State<ArtistDetailsScreen> createState() => _ArtistDetailsScreenState();
}

class _ArtistDetailsScreenState extends State<ArtistDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les détails de l'artiste au chargement de l'écran
    context.read<ArtistBloc>().add(LoadArtistEvent(widget.artistId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ArtistBloc, ArtistState>(
        builder: (context, state) {
          if (state is ArtistLoadingState) {
            return const LoadingIndicator();
          } else if (state is ArtistErrorState) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<ArtistBloc>().add(LoadArtistEvent(widget.artistId));
              },
            );
          } else if (state is ArtistLoadedState) {
            return _buildArtistDetails(context, state.artist, state.albums);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildArtistDetails(BuildContext context, Artist artist, List<Album> albums) {
    final locale = Localizations.localeOf(context).languageCode;
    final biography = artist.getBiography(locale);
    
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // App bar avec bannière de l'artiste
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          backgroundColor: AppColors.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          actions: [
            if (artist.id != null) 
              FavoriteButton(
                artist: artist,
                activeColor: Colors.white,
                inactiveColor: Colors.white.withOpacity(0.7),
              ),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Bannière de l'artiste ou image par défaut
                if (artist.artistBanner != null)
                  CachedNetworkImage(
                    imageUrl: artist.artistBanner!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.8),
                            AppColors.primaryDark,
                          ],
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.8),
                            AppColors.primaryDark,
                          ],
                        ),
                      ),
                    ),
                  )
                else if (artist.artistThumb != null)
                  CachedNetworkImage(
                    imageUrl: artist.artistThumb!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.8),
                            AppColors.primaryDark,
                          ],
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.8),
                            AppColors.primaryDark,
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withOpacity(0.8),
                          AppColors.primaryDark,
                        ],
                      ),
                    ),
                  ),
                
                // Superposition de gradient pour améliorer la lisibilité du texte
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
                
                // Miniature et nom de l'artiste
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Photo de profil de l'artiste
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: artist.artistThumb != null
                              ? CachedNetworkImage(
                                  imageUrl: artist.artistThumb!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 50,
                                    ),
                                  ),
                                )
                              : Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Nom de l'artiste
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          artist.name ?? 'Unknown Artist',
                          style: AppTextStyles.withColor(
                            AppTextStyles.h2,
                            Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Informations de base sur l'artiste
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Genre et style
                if (artist.genre != null || artist.style != null) ...[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (artist.genre != null && artist.genre!.isNotEmpty) ...[
                          Chip(
                            label: Text(artist.genre!),
                            backgroundColor: AppColors.genreColors[0].withOpacity(0.2),
                            labelStyle: AppTextStyles.withColor(
                              AppTextStyles.caption,
                              AppColors.genreColors[0],
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (artist.style != null && artist.style!.isNotEmpty) ...[
                          Chip(
                            label: Text(artist.style!),
                            backgroundColor: AppColors.genreColors[1].withOpacity(0.2),
                            labelStyle: AppTextStyles.withColor(
                              AppTextStyles.caption,
                              AppColors.genreColors[1],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Année de formation et pays
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (artist.formedYear != null && artist.formedYear!.isNotEmpty) ...[
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Formed in ${artist.formedYear}',
                          style: AppTextStyles.withColor(
                            AppTextStyles.body2,
                            AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 24),
                      ],
                      if (artist.country != null && artist.country!.isNotEmpty) ...[
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          artist.country!,
                          style: AppTextStyles.withColor(
                            AppTextStyles.body2,
                            AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Liens sociaux
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (artist.website != null && artist.website!.isNotEmpty) 
                        _buildSocialButton(
                          icon: Icons.language,
                          url: _formatUrl(artist.website!),
                          tooltip: 'Website',
                        ),
                      if (artist.facebook != null && artist.facebook!.isNotEmpty) 
                        _buildSocialButton(
                          icon: Icons.facebook,
                          url: _formatUrl(artist.facebook!, prefix: 'https://facebook.com/'),
                          tooltip: 'Facebook',
                        ),
                      if (artist.twitter != null && artist.twitter!.isNotEmpty) 
                        _buildSocialButton(
                          icon: Icons.account_circle,
                          url: _formatUrl(artist.twitter!, prefix: 'https://twitter.com/'),
                          tooltip: 'Twitter',
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                
                // Biographie
                if (biography.isNotEmpty) ...[
                  const Text(
                    'Biography',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    StringUtils.cleanString(biography),
                    style: AppTextStyles.body1,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
        
        // Section Albums
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Albums',
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        
        // Grille d'albums
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: albums.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.album,
                          size: 48,
                          color: AppColors.textLight.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No albums found',
                          style: AppTextStyles.withColor(
                            AppTextStyles.body1,
                            AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final album = albums[index];
                      return AlbumCard(
                        album: album,
                        width: double.infinity,
                        onTap: () {
                          if (album.id != null) {
                            context.push('/album/${album.id}');
                          }
                        },
                      );
                    },
                    childCount: albums.length,
                  ),
                ),
        ),
        
        // Espacement en bas
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String url,
    String tooltip = '',
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: () async {
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  String _formatUrl(String url, {String prefix = ''}) {
    if (url.isEmpty) {
      return '';
    }
    
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    } else {
      return '$prefix$url';
    }
  }
}