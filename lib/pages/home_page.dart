import 'package:flutter/material.dart';
import 'package:vision_parse/widgets/sliver_appbar.dart';

class HomePage extends StatelessWidget {
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
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  delegate: SliverAppbar(),
                  pinned: true,
                ),
              )
            ];
          },
          body: const TabBarView(
            children: [
              Center(child: Text('Camera View')),
              Center(child: Text('Gallery View')),
            ],
          ),
        )
      ),
    );
  }
}