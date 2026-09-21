import 'package:flutter/material.dart';
import 'package:story_teller/widget/shimmer_widget.dart';

/// Shimmer skeleton that mirrors the home screen layout.
class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(3, (index) => _buildShimmerCategory(size)),
      ),
    );
  }

  Widget _buildShimmerCategory(Size size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: ShimmerWidget(
              width: size.width * 0.4,
              height: 18,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          // Category description
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 12),
            child: ShimmerWidget(
              width: size.width * 0.6,
              height: 13,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          // Story cards row
          SizedBox(
            height: size.height * 0.16,
            child: Row(
              children: List.generate(4, (i) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ShimmerWidget(
                    width: size.width * 0.25,
                    height: size.height * 0.13,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
          ),
          // "See More" button
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ShimmerWidget(
                width: size.width * 0.31,
                height: size.height * 0.045,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
