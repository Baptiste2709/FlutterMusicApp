import 'package:flutter/material.dart';
import '../../api/models/album.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  final double width;
  final double? height;
  final VoidCallback? onTap;
  
  const AlbumCard({
    Key? key,
    required this.album,
    this.width = 140,
    this.height,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Album cover
              SizedBox(
                width: width,
                height: width,
                child: album.albumThumb != null
                    ? Image.network(
                        album.albumThumb!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.album,
                              color: Colors.grey,
                              size: 40,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.album,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
              ),
              
              // Album info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      album.name ?? 'Unknown Album',
                      style: AppTextStyles.withColor(
                        AppTextStyles.body2,
                        AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (album.artist != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        album.artist!,
                        style: AppTextStyles.withColor(
                          AppTextStyles.caption,
                          AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (album.yearReleased != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        album.yearReleased!,
                        style: AppTextStyles.withColor(
                          AppTextStyles.caption,
                          AppColors.textLight,
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
    );
  }
}