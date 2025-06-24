import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vision_parse/core/get_it.dart';
import 'package:vision_parse/pages/signin_page.dart';
import 'package:vision_parse/utils/shared_preferences_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vision_parse/core/entities/profile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

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
    isGuest = serviceLocator<SharedPreferencesManager>().getIsGuest() ?? false;
    if (!isGuest) {
      fetchProfile();
    }
  }

  Future<void> fetchProfile() async {
    setState(() => isLoading = true);
    final res = await serviceLocator<SupabaseClient>().rpc('get_user_profile').single();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: isGuest
            ? []
            : [
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: _logout,
                ),
              ],
      ),
      body: isGuest
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
                              'You are currently using the app as a guest.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to login or registration page
                                context.goNamed(SigninPage.pathName);
                              },
                              child: const Text('Login / Register'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ])
                ),
              ],
            )
          : isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Option 1'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.info),
                          title: const Text('Option 2'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.help),
                          title: const Text('Option 3'),
                        ),
                      ]),
                    ),
                  ],
                ),
    );
  }
}