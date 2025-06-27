import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vision_parse/blocs/bloc/auth_bloc.dart';
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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<bool> _isDisabled = [false, true];

  onTap() async {
    if (_isDisabled[_tabController.index]) {
      int index = _tabController.previousIndex;
      setState(() {
        _tabController.index = index;
      });
      // Mostrar modal para actualizar a premium
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Función Premium'),
          content: Text('Actualiza a Premium para acceder al historial.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/subscription');
              },
              child: Text('Actualizar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(onTap);
    final isPremium = context.read<AuthBloc>().state.profile.paymentMethod.isNotEmpty;
    _isDisabled = [false, !isPremium];
  }

  @override
  void dispose() {
    _tabController.removeListener(onTap);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.profile.paymentMethod.isNotEmpty) {
          _isDisabled = [false, false];
        } else {
          _isDisabled = [false, true];
        }
      },
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxIsScrolled,
            ) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                  sliver: SliverPersistentHeader(
                    delegate: SliverAppbar(tabController: _tabController),
                    floating: false,
                    pinned: true,
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [AnalyzeTab(), HistoryTab()],
            ),
          ),
        ),
      ),
    );
  }
}
