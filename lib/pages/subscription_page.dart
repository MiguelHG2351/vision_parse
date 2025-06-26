import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vision_parse/pages/settings_page.dart';

class SubscriptionPage extends StatelessWidget {
  static const String pathName = 'subscription';
  static const String path = '/subscription';
  
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi plan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.goNamed(SettingsPage.pathName);
          },
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Tu cuenta actual es: Premium',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Tienes acceso a el historial y puedes usar el app sin ads.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget for plan display
class _PlanTile extends StatelessWidget {
  final String planName;
  final String price;
  final List<String> features;
  final bool highlight;

  const _PlanTile({
    required this.planName,
    required this.price,
    required this.features,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: highlight ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
        border: highlight ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(planName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(width: 8),
              Text(price, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 8),
          ...features.map((f) => Row(
                children: [
                  const Icon(Icons.check, size: 16, color: Colors.green),
                  const SizedBox(width: 6),
                  Expanded(child: Text(f)),
                ],
              )),
        ],
      ),
    );
  }
}