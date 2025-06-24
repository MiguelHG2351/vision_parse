import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vision_parse/widgets/custom_bottom_navigation.dart';

class ShellUi extends StatefulWidget {

  const ShellUi({
    key,
    required this.navigationShell,
  }): super(key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));

  final StatefulNavigationShell navigationShell;

  @override
  State<ShellUi> createState() => _ShellUiState();
}

class _ShellUiState extends State<ShellUi> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigation(
        navigationShell: widget.navigationShell,
      ),
      // backgroundColor: colorScheme.primary.withValues(alpha: 0.14),
      // This will render the current branch's page
      body: widget.navigationShell,
    );
  }
}
