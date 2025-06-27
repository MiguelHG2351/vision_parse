import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vision_parse/core/get_it.dart';
import 'package:vision_parse/pages/get_started_page.dart';
import 'package:vision_parse/pages/subscription_page.dart';
import 'package:vision_parse/utils/shared_preferences_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vision_parse/core/entities/profile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  static const String pathName = 'settings';
  static const String path = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isGuest;
  Profile? profile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isGuest = serviceLocator<SupabaseClient>().auth.currentSession == null;
    if (!isGuest) {
      fetchProfile();
    }
  }

  Future<void> fetchProfile() async {
    setState(() => isLoading = true);
    final res =
        await serviceLocator<SupabaseClient>().rpc('get_user_profile').single();
    setState(() {
      profile = Profile.fromJson(res);
      isLoading = false;
    });
  }

  void _logout() async {
    await serviceLocator<SupabaseClient>().auth.signOut();
    serviceLocator<SharedPreferencesManager>().setIsGuest(false);
    if (mounted) {
      setState(() {
        isGuest = true;
        profile = null;
      });
    }
    // ignore: use_build_context_synchronously
    context.goNamed(GetStartedPage.pathName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        actions:
            isGuest
                ? []
                : [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout',
                    onPressed: _logout,
                  ),
                ],
      ),
      body:
          isGuest
              ? CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Card(
                        margin: const EdgeInsets.all(24),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estás usando la app como invitado.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  serviceLocator<SharedPreferencesManager>().setIsGuest(false);
                                  setState(() {
                                    isGuest = false;
                                    profile = null;
                                  });
                                  // Navigate to login or registration page
                                  context.goNamed(GetStartedPage.pathName);
                                },
                                child: const Text('Iniciar sesión o registrarse'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              )
              : isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: InkWell(
                      onTap: () {
                        context.goNamed('completeProfile'); // Asegúrate que 'completeProfile' coincida con el nombre de ruta que definiste
                      },
                      borderRadius: BorderRadius.circular(12), // efecto de toque redondeado
                      child: Card(
                        margin: const EdgeInsets.all(24),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundImage: profile?.avatarUrl.isNotEmpty == true
                                    ? NetworkImage(profile!.avatarUrl)
                                    : null,
                                child: profile?.avatarUrl.isEmpty == true
                                    ? const Icon(Icons.person, size: 32)
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${profile?.firstName ?? ''} ${profile?.lastName ?? ''}',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      profile?.email ?? '',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                children: const [
                                  Icon(Icons.edit, size: 20, color: Colors.black87),
                                  SizedBox(height: 4),
                                  Text(
                                    'Editar',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      ListTile(
                        onTap: () {
                          context.goNamed(SubscriptionPage.pathName);
                        },
                        leading: const Icon(Icons.settings),
                        title: Text((profile?.paymentMethod != null && profile!.paymentMethod.isNotEmpty) ? 'Ya eres premium' : 'Mejorar a premium'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.help),
                        title: const Text('Ayuda'),
                      ),
                    ]),
                  ),
                ],
              ),
    );
  }
}
