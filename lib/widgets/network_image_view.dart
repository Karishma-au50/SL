import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../shared/app_colors.dart';
import '../shared/constant/app_constants.dart';

class NetworkImageView extends StatelessWidget {
  final String imgUrl;
  final double radius;
  final String? errorImage;
  final Color backgroundColor;
  final BoxFit fit;
  final bool isBorder;
  final bool isShimmer;
  final bool isFullPath;

  const NetworkImageView({
    super.key,
    required this.imgUrl,
    this.radius = 10,
    this.errorImage,
    this.backgroundColor = Colors.transparent,
    this.fit = BoxFit.contain,
    this.isBorder = false,
    this.isShimmer = true,
    this.isFullPath = false,
  });
  @override
  Widget build(BuildContext context) {
    print('Image URL: ${isFullPath ? imgUrl : AppConstants.assetUrl + imgUrl}');
    if (imgUrl.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: isBorder ? Border.all(color: AppColors.kcPrimaryColor) : null,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: Text(
            'Image not available',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: isBorder ? Border.all(color: AppColors.kcPrimaryColor) : null,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: CachedNetworkImage(
            imageUrl: isFullPath ? imgUrl : AppConstants.assetUrl + imgUrl,
            fadeInCurve: Curves.easeIn,
            maxHeightDiskCache: 800,
            maxWidthDiskCache: 800,
            fadeInDuration: const Duration(milliseconds: 500),
            placeholder: (context, url) => isShimmer
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[100]!,
                    highlightColor: Colors.grey[300]!,
                    child: Container(color: Colors.white),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                    // CustomLoader(),
                  ),
            errorWidget: (context, url, error) {
              if (errorImage == null) {
                return const Icon(Icons.error);
              }
              return Image.asset(errorImage!);
            },
            fit: fit,
          ),
        ),
      ),
    );
  }
}
