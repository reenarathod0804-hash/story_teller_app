import 'package:flutter/material.dart';

/// A shimmer effect widget using AnimationController (no external package).
/// Sweeps a bright highlight from left to right over a grey base.
class ShimmerWidget extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // translate the highlight band from -1.0 (left, off-screen) to +2.0 (right, off-screen)
        final double slide = -1.0 + (_controller.value * 3.0);
        return ClipRRect(
          borderRadius: widget.borderRadius,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: const [
                  Color(0xFFE0E0E0),
                  Color(0xFFEAEAEA),
                  Color(0xFFF0F0F0),
                  Color(0xFFF8F8F8),
                  Color(0xFFF0F0F0),
                  Color(0xFFEAEAEA),
                  Color(0xFFE0E0E0),
                ],
                stops: [
                  (slide - 0.3).clamp(0.0, 1.0),
                  (slide - 0.15).clamp(0.0, 1.0),
                  (slide - 0.05).clamp(0.0, 1.0),
                  slide.clamp(0.0, 1.0),
                  (slide + 0.05).clamp(0.0, 1.0),
                  (slide + 0.15).clamp(0.0, 1.0),
                  (slide + 0.3).clamp(0.0, 1.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
