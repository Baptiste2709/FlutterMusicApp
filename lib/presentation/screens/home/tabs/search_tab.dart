import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../api/models/search_result.dart';
import '../../../../presentation/blocs/search/search_bloc.dart';
import '../../../../presentation/blocs/search/search_event.dart';
import '../../../../presentation/blocs/search/search_state.dart';
import '../../../../presentation/widgets/album_card.dart';
import '../../../../presentation/widgets/artist_card.dart';
import '../../../../presentation/widgets/error_view.dart';
import '../../../../presentation/widgets/loading_indicator.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    
    // Add listener to search controller to trigger search on text change
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty && _searchController.text.length >= 3) {
        context.read<SearchBloc>().add(SearchQueryEvent(_searchController.text));
      }
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus the search field when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            
            // Search input field
            _buildSearchField(),
            
            const SizedBox(height: 16),
            
            // Search results
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitialState) {
                    return _buildEmptyState();
                  } else if (state is SearchLoadingState) {
                    return const LoadingIndicator();
                  } else if (state is SearchErrorState) {
                    return ErrorView(
                      message: state.message,
                      onRetry: () {
                        if (_searchController.text.isNotEmpty) {
                          context.read<SearchBloc>().add(SearchQueryEvent(_searchController.text));
                        }
                      },
                    );
                  } else if (state is SearchLoadedState) {
                    if (state.results.isEmpty) {
                      return _buildNoResultsState();
                    }
                    return _buildSearchResults(state.results);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      style: AppTextStyles.searchInput,
      decoration: InputDecoration(
        hintText: 'Search for artists or albums...',
        hintStyle: AppTextStyles.withColor(
          AppTextStyles.searchInput,
          AppColors.textLight,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textLight,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: AppColors.textLight,
                ),
                onPressed: () {
                  _searchController.clear();
                  context.read<SearchBloc>().add(const ClearSearchEvent());
                },
              )
            : null,
        filled: true,
        fillColor: AppColors.cardBackground,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          context.read<SearchBloc>().add(SearchQueryEvent(value));
        }
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 72,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Search for your favorite artists and albums',
            style: AppTextStyles.withColor(
              AppTextStyles.body1,
              AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_dissatisfied,
            size: 72,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found for "${_searchController.text}"',
            style: AppTextStyles.withColor(
              AppTextStyles.body1,
              AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(CombinedSearchResults results) {
    return ListView.builder(
      itemCount: results.artists.length,
      itemBuilder: (context, index) {
        final artist = results.artists[index];
        final artistAlbums = results.albumsByArtist[artist.id] ?? [];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artist card
            ArtistCard(
              artist: artist,
              onTap: () => context.push('/artist/${artist.id}'),
            ),
            
            // Albums for this artist
            if (artistAlbums.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, bottom: 16),
                child: SizedBox(
                  height: 190,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: artistAlbums.length,
                    itemBuilder: (context, albumIndex) {
                      final album = artistAlbums[albumIndex];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: AlbumCard(
                          album: album,
                          width: 150,
                          onTap: () => context.push('/album/${album.id}'),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
            const Divider(height: 32),
          ],
        );
      },
    );
  }
}