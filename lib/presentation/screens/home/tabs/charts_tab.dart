import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../api/models/chart.dart';
import '../../../../presentation/blocs/charts/charts_bloc.dart';
import '../../../../presentation/blocs/charts/charts_event.dart';
import '../../../../presentation/blocs/charts/charts_state.dart';
import '../../../../presentation/widgets/error_view.dart';
import '../../../../presentation/widgets/loading_indicator.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';

class ChartsTab extends StatefulWidget {
  const ChartsTab({Key? key}) : super(key: key);

  @override
  State<ChartsTab> createState() => _ChartsTabState();
}

class _ChartsTabState extends State<ChartsTab> {
  @override
  void initState() {
    super.initState();
    // Load charts data when the tab is initialized
    context.read<ChartsBloc>().add(LoadChartsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartsBloc, ChartsState>(
      builder: (context, state) {
        if (state is ChartsLoadingState) {
          return const LoadingIndicator();
        } else if (state is ChartsErrorState) {
          return ErrorView(
            message: state.message,
            onRetry: () {
              context.read<ChartsBloc>().add(LoadChartsEvent());
            },
          );
        } else if (state is ChartsLoadedState) {
          return _buildChartsList(state);
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  Widget _buildChartsList(ChartsLoadedState state) {
    return CustomScrollView(
      slivers: [
        // Singles section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.singleChart,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Singles',
                  style: AppTextStyles.h3,
                ),
              ],
            ),
          ),
        ),
        
        // Singles list
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final track = state.tracks?[index];
              if (track == null) return const SizedBox.shrink();
              
              return _buildChartItem(
                track, 
                index + 1, 
                AppColors.singleChart,
                onTap: () {
                  if (track.artistId != null) {
                    context.push('/artist/${track.artistId}');
                  }
                },
              );
            },
            childCount: state.tracks?.length ?? 0,
          ),
        ),
        
        // Albums section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.albumChart,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Albums',
                  style: AppTextStyles.h3,
                ),
              ],
            ),
          ),
        ),
        
        // Albums list
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final album = state.albums?[index];
              if (album == null) return const SizedBox.shrink();
              
              return _buildChartItem(
                album, 
                index + 1, 
                AppColors.albumChart,
                onTap: () {
                  if (album.artistId != null) {
                    context.push('/artist/${album.artistId}');
                  }
                },
              );
            },
            childCount: state.albums?.length ?? 0,
          ),
        ),
        
        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
      ],
    );
  }

  Widget _buildChartItem(ChartItem item, int position, Color accentColor, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Position number
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  position.toString(),
                  style: AppTextStyles.withColor(
                    AppTextStyles.chartPosition,
                    accentColor,
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: item.albumThumb != null || item.trackThumb != null
                      ? Image.network(
                          item.albumThumb ?? item.trackThumb ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.album,
                                color: Colors.grey,
                                size: 30,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.album,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Text details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.trackName ?? item.albumName ?? 'Unknown',
                      style: AppTextStyles.albumName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.artistName ?? 'Unknown Artist',
                      style: AppTextStyles.withColor(
                        AppTextStyles.body2, 
                        AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}