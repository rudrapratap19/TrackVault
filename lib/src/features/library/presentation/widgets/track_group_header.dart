import 'package:flutter/material.dart';

class TrackGroupHeaderDelegate extends SliverPersistentHeaderDelegate {
  TrackGroupHeaderDelegate({required this.title});

  final String title;

  @override
  double get minExtent => 36;

  @override
  double get maxExtent => 36;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant TrackGroupHeaderDelegate oldDelegate) {
    return oldDelegate.title != title;
  }
}
