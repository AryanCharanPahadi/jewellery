import 'package:flutter/material.dart';

class Header2Delegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  Header2Delegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Ensuring consistent height and proper layout
    return SizedBox.expand(
      child: Material(
        elevation: overlapsContent ? 4 : 0, // Add shadow if content overlaps
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => 60.0; // Fixed maximum height
  @override
  double get minExtent => 60.0; // Fixed minimum height
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false; // Rebuild only if necessary
  }
}
