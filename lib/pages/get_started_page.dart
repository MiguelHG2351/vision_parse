import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vision_parse/core/get_it.dart';
import 'package:vision_parse/pages/home_page.dart';
import 'package:vision_parse/pages/register_page.dart';
import 'package:vision_parse/pages/signin_page.dart';
import 'package:vision_parse/utils/shared_preferences_manager.dart';

class GetStartedPage extends StatefulWidget {
  static const String pathName = 'GetStartedPage';
  static const String path = '/get-started';

  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get Started')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'How would you like to continue?',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  serviceLocator<SharedPreferencesManager>().setIsGuest(true);
                  context.goNamed(HomePage.pathName);
                },
                child: const Text('Continue as Guest'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  //hacer register
                  context.goNamed(RegisterPage.pathName);
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.goNamed(SigninPage.pathName);
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
