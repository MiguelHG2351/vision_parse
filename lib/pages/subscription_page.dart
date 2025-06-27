import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vision_parse/blocs/bloc/auth_bloc.dart';
import 'package:vision_parse/pages/settings_page.dart';
import 'package:vision_parse/widgets/stripe_webview.dart';

class SubscriptionPage extends StatefulWidget {
  static const String pathName = 'subscription';
  static const String path = '/subscription';

  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> with WidgetsBindingObserver {
  bool _openedStripe = false;
  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _handleLoaderAndRefresh() async {
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      setState(() {
        _showLoader = false;
      });
      context.read<AuthBloc>().add(AuthRefreshSession());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      print('SubscriptionPage listener called');
                      print('Profile: ${state.profile}');
                    },
                    buildWhen: (previous, current) {
                      // Only rebuild when the profile changes
                      return previous.profile != current.profile;
                    },
                    builder: (context, state) {
                      final isPremium = state.profile.paymentMethod.isNotEmpty;
                      final planName = isPremium ? 'Premium' : 'Free';
                      
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Tu cuenta actual es: $planName',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          // Sección llamativa de features premium
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Theme.of(context).colorScheme.primary, size: 28),
                                      SizedBox(width: 10),
                                      Text(
                                        'Ventajas de Premium',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Icon(Icons.block, color: Colors.green, size: 22),
                                      SizedBox(width: 8),
                                      Text('Sin anuncios', style: Theme.of(context).textTheme.bodyLarge),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.history, color: Colors.green, size: 22),
                                      SizedBox(width: 8),
                                      Text('Acceso al historial', style: Theme.of(context).textTheme.bodyLarge),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isPremium)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Tienes acceso a el historial y puedes usar el app sin ads.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Actualmente estás usando la versión gratuita. Considera actualizar a Premium para disfrutar de todas las funciones.',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      _openedStripe = true;
                                      await showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => Dialog(
                                          insetPadding: EdgeInsets.all(12),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: MediaQuery.of(context).size.height * 0.85,
                                            child: StripeWebView(
                                              url: 'https://buy.stripe.com/test_4gM00jcC31rp2el0U5g3609',
                                              onClose: () {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  _showLoader = true;
                                                });
                                                _handleLoaderAndRefresh();
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Actualizar a Premium'),
                                  )
                                ],
                              ),
                            ),
                          const SizedBox(height: 20),
                          
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_showLoader)
          Container(
            color: Colors.black.withOpacity(0.4),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
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
        color:
            highlight
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : null,
        borderRadius: BorderRadius.circular(8),
        border:
            highlight
                ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
                : null,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                planName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(width: 8),
              Text(
                price,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...features.map(
            (f) => Row(
              children: [
                const Icon(Icons.check, size: 16, color: Colors.green),
                const SizedBox(width: 6),
                Expanded(child: Text(f)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
