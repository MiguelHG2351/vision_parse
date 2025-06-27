import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SliverAppbar extends SliverPersistentHeaderDelegate {
  SliverAppbar({
    required TabController tabController,
    this.interstitialAd
  }) : _tabController = tabController;

  InterstitialAd? interstitialAd;
  final TabController _tabController;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vision Parse',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(icon: Icon(Icons.camera_enhance_outlined, size: 30), child: Text('Escanear texto')),
                        Tab(
                          icon: Icon(Icons.history_outlined, size: 30),
                          child: Text('Historial de escaneos'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 220;

  @override
  double get minExtent => 140;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
