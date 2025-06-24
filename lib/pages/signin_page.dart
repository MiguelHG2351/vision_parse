import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vision_parse/pages/home_page.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  static const String pathName = 'signIn';
  static const String path = '/sign-in';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 400
          ),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/pingu-login.png',
                  width: 100,
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome back!',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Inicio de sesión',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white
                      ),
                      onPressed: () {
                        context.goNamed(HomePage.pathName);
                      },
                      child: const Text('Iniciar sesión'),
                    ))
                  ],
                )
              ]
            )
          ),
        ),
      ),
    );
  }
}