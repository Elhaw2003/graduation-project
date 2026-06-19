import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';

class TourGuideProfileImage extends StatelessWidget {
  const TourGuideProfileImage({super.key, required this.imageUrl});
  final String imageUrl;

  void _openFullscreen(BuildContext context) {
    if (imageUrl.isEmpty) return;
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        barrierDismissible: true,
        pageBuilder: (_, __, ___) =>
            _FullscreenImageViewer(imageUrl: imageUrl.toHttps()),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFullscreen(context),
      child: Container(
        height: 100.r,
        width: 100.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryColor, width: 3.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(3.r),
          child: ClipOval(
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl.toHttps(),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: AppColors.grey100Color,
                      highlightColor: AppColors.whiteColor,
                      child: Container(
                        height: 100.r,
                        width: 100.r,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.grey100Color,
                      child: Icon(
                        Icons.person,
                        size: 50.r,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                : Container(
                    color: AppColors.grey100Color,
                    child: Icon(
                      Icons.person,
                      size: 50.r,
                      color: AppColors.primaryColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _FullscreenImageViewer extends StatelessWidget {
  final String imageUrl;
  const _FullscreenImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // close button
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 22),
                ),
              ),
            ),
            // image centered
            Center(
              child: Hero(
                tag: imageUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.85,
                    placeholder: (_, __) =>
                        const CircularProgressIndicator(color: Colors.white),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.broken_image_rounded,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
