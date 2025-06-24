import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vision_parse/pages/home_page.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 400
          ),
          child: Form(
            key: _formKey, // with the key you can use _formKey.currentState?.validate() to check if all fields are valid
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // .asset is used to load an image from the assets folder
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
                  // Autovalidate mode to validate fields when the user interacts with them, f.g. when they focus on the field or change its value
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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