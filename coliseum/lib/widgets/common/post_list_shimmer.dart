import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostListShimmer extends StatelessWidget {
  const PostListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: ListView.builder(
        itemCount: 5, // Show 5 shimmer items
        itemBuilder: (_, __) => const _ShimmerPlaceholder(),
      ),
    );
  }
}

class _ShimmerPlaceholder extends StatelessWidget {
  const _ShimmerPlaceholder();

  Widget _buildPlaceholder(double height, double width, {double radius = 8.0}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildPlaceholder(40, 40, radius: 20),
                const SizedBox(width: 8),
                _buildPlaceholder(16, 100),
              ],
            ),
          ),
          // Post Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _buildPlaceholder(screenWidth, screenWidth, radius: 16),
          ),
          // Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildPlaceholder(24, 24),
                const SizedBox(width: 16),
                _buildPlaceholder(24, 24),
                const SizedBox(width: 16),
                _buildPlaceholder(24, 24),
              ],
            ),
          ),
          // Text lines
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPlaceholder(14, 80),
                const SizedBox(height: 8),
                _buildPlaceholder(14, screenWidth * 0.9),
                const SizedBox(height: 8),
                _buildPlaceholder(14, screenWidth * 0.6),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 