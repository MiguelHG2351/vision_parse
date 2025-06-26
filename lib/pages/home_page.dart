import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vision_parse/utils/app_ads.dart';
import 'package:vision_parse/widgets/history_tab.dart';
import 'package:vision_parse/widgets/sliver_appbar.dart';
import 'package:vision_parse/widgets/analyze_tab.dart';

class HomePage extends StatefulWidget {
  static const String pathName = 'HomePage';
  static const String path = '/home';
  
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: SliverPersistentHeader(
                  delegate: SliverAppbar(),
                  floating: false,
                  pinned: true,
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [AnalyzeTab(), HistoryTab()],
          ),
        ),
      ),
    );
  }
}
