import 'package:flutter/material.dart';

class SliverAppbar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: const [
          Positioned(
            child: TabBar(
              // labelColor: Colors.white,
              // unselectedLabelColor: Colors.white70,
              // indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'Camera'),
                Tab(text: 'Gallery'),
              ],
            )
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 140;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
