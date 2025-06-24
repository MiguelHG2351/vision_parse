import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vision_parse/core/enums/navigator_page.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({
    required this.navigationShell,
    super.key
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  
  int _selectedIndex = 0;
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // NavigatorPage is an enum that represents the pages in the app
    // 0 is Home, 1 is Settings
    final page = NavigatorPage.values[index];
    print('Selected page: $page, index: $index');
    _navigate(page, context);
  }

  Future<void> _navigate(NavigatorPage page, BuildContext context) async {
    // goBranch navigates using the indices of the branches array from the StatefulShellRoute.indexedStack field in the router
    switch (page) {
      case NavigatorPage.home:
        widget.navigationShell.goBranch(NavigatorPage.home.index); // 0 is Home
        break;
      case NavigatorPage.settings:
        widget.navigationShell.goBranch(NavigatorPage.settings.index); // 1 is Settings
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Items that will be displayed in the bottom navigation bar
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configuraciones',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.5),
      onTap: _onItemTapped, // This function is called when an item is tapped
    );
  }
}