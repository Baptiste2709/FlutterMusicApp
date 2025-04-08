import 'package:flutter/material.dart';
import '../../api/models/artist.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;
  final VoidCallback? onTap;
  
  const ArtistCard({
    Key? key,
    required this.artist,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Artist thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: artist.artistThumb != null
                      ? Image.network(
                          artist.artistThumb!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 40,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Artist info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artist.name ?? 'Unknown Artist',
                      style: AppTextStyles.artistName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (artist.genre != null) ...[
                      Text(
                        artist.genre!,
                        style: AppTextStyles.withColor(
                          AppTextStyles.body2,
                          AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    ],
                    Row(
                      children: [
                        if (artist.formedYear != null) ...[
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            artist.formedYear!,
                            style: AppTextStyles.withColor(
                              AppTextStyles.caption,
                              AppColors.textLight,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (artist.country != null) ...[
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            artist.country!,
                            style: AppTextStyles.withColor(
                              AppTextStyles.caption,
                              AppColors.textLight,
                            ),
                          ),
                        ],
                      ],
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