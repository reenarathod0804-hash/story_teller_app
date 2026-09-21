import 'package:flutter/material.dart';
import 'package:story_teller/configue/constant/colors.dart';
import 'package:story_teller/widget/shimmer_widget.dart';

class AppStoryImage extends StatelessWidget {
  final String? imageUrl;
  final String? seed;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  static const List<String> bookImages = [
    'assets/images/png/book1.png',
    'assets/images/png/book2.png',
    'assets/images/png/book3.png',
    'assets/images/png/book4.png',
    'assets/images/png/book5.png',
    'assets/images/png/book6.png',
    'assets/images/png/book8.png',
    'assets/images/png/book9.png',
    'assets/images/png/book10.png',
    'assets/images/png/book11.png',
    'assets/images/png/book12.png',
    'assets/images/png/book13.png',
    'assets/images/png/6.png',
    'assets/images/png/7.png',
  ];

  static String getImageForStory(String? idOrTitle) {
    if (idOrTitle == null || idOrTitle.isEmpty) return bookImages[0];
    final int hash = idOrTitle.hashCode.abs();
    return bookImages[hash % bookImages.length];
  }

  const AppStoryImage({
    super.key,
    required this.imageUrl,
    this.seed,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  String _getFallbackAsset() {
    final key = (seed != null && seed!.isNotEmpty) ? seed! : (imageUrl ?? '');
    if (key.isNotEmpty) {
      return getImageForStory(key);
    }
    return bookImages[0];
  }

  Widget _buildPlaceholder() {
    final assetPath = _getFallbackAsset();
    return Container(
      width: width,
      height: height,
      color: AppColors.grey,
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.grey,
            child: const Center(
              child: Icon(
                Icons.menu_book_rounded,
                color: AppColors.mainBlue,
                size: 32,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawUrl = imageUrl?.trim() ?? '';

    Widget imageWidget;

    if (rawUrl.isEmpty) {
      imageWidget = _buildPlaceholder();
    } else if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      imageWidget = Image.network(
        rawUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return ShimmerWidget(
            width: width ?? 100,
            height: height ?? 100,
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    } else if (rawUrl.startsWith('assets/')) {
      imageWidget = Image.asset(
        rawUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    } else {
      String resolvedPath = rawUrl.endsWith('.png') || rawUrl.endsWith('.jpg')
          ? 'assets/images/png/$rawUrl'
          : 'assets/images/png/$rawUrl.png';

      imageWidget = Image.asset(
        resolvedPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
