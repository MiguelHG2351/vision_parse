import 'package:flutter/material.dart';
import 'package:vision_parse/widgets/history_tab.dart';
import 'package:vision_parse/widgets/sliver_appbar.dart';
import 'package:vision_parse/widgets/analyze_tab.dart';

class HomePage extends StatelessWidget {
  static const String pathName = 'HomePage';
  static const String path = '/home';
  
  const HomePage({super.key});

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
