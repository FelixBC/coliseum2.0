import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            _ProfileHeaderShimmer(),
            SizedBox(height: 24),
            _PostGridShimmer(),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeaderShimmer extends StatelessWidget {
  const _ProfileHeaderShimmer();

  Widget _buildPlaceholder(double height, double width, {double radius = 8.0}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildPlaceholder(80, 80, radius: 40),
              const SizedBox(width: 24),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [_buildPlaceholder(20, 30), const SizedBox(height: 4), _buildPlaceholder(14, 50)]),
                    Column(children: [_buildPlaceholder(20, 30), const SizedBox(height: 4), _buildPlaceholder(14, 70)]),
                    Column(children: [_buildPlaceholder(20, 30), const SizedBox(height: 4), _buildPlaceholder(14, 70)]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPlaceholder(16, 120), // Username
          const SizedBox(height: 8),
          _buildPlaceholder(14, 250), // Bio line 1
          const SizedBox(height: 4),
          _buildPlaceholder(14, 200), // Bio line 2
          const SizedBox(height: 16),
          _buildPlaceholder(35, double.infinity), // Button
        ],
      ),
    );
  }
}

class _PostGridShimmer extends StatelessWidget {
  const _PostGridShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.white,
        );
      },
    );
  }
} 