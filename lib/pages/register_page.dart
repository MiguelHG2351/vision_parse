import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vision_parse/pages/get_started_page.dart';
import 'package:vision_parse/pages/home_page.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static const String pathName = 'register';
  static const String path = '/register';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: 400),
          child: Form(
            key:
                _formKey, // with the key you can use _formKey.currentState?.validate() to check if all fields are valid
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
                  'Bienvenido a vision parse!',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Introduce tu correo',
                  ),
                  // Autovalidate mode to validate fields when the user interacts with them, f.g. when they focus on the field or change its value
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu correo';
                    } else if (!RegExp(
                      r'^[^@]+@[^@]+\.[^@]+',
                    ).hasMatch(value)) {
                      return 'Introduce un correo válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Introduce tu nueva contraseña',
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Confirma tu contraseña',
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
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          context.goNamed(HomePage.pathName);
                        },
                        child: const Text('Registrar usuario'),
                      ),
                    ),
                  ],
                  
                ),
                 Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).secondaryHeaderColor,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          context.goNamed(GetStartedPage.pathName);
                        },
                        child: const Text('Regresar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
