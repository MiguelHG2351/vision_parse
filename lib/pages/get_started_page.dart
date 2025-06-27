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
      appBar: AppBar( 
      title: const Text('Bienvenido a Vision Parse'),
      leading: Icon(Icons.text_fields, color: Colors.white), 
        backgroundColor: const Color.fromARGB(255, 215, 119, 40), // Cambia el color aquí
        titleTextStyle: TextStyle(
          fontSize: 20, // Cambia el tamaño aquí
          fontWeight: FontWeight.bold,
          color: Colors.white, // Cambia el color del texto del AppBar
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Elige como quieres continuar',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 24, // Cambia el tamaño aquí
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 160, 43, 0), // Cambia el color aquí
                ),
                textAlign: TextAlign.center,
              
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  serviceLocator<SharedPreferencesManager>().setIsGuest(true);
                  context.goNamed(HomePage.pathName);
                },
                icon: const Icon(Icons.person_2_outlined, size:30, color: Color.fromARGB(255, 160, 43, 0)), // Puedes cambiar el ícono
                label: const Text('Continuar como invitado',
                  style: TextStyle(
                    fontSize: 18,         // Cambia el tamaño aquí
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 160, 43, 0) // Opcional
                  ),),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  //hacer register
                  context.goNamed(RegisterPage.pathName);
                },
                 icon: const Icon(Icons.person_add_alt, size:30, color: Color.fromARGB(255, 160, 43, 0)), // Puedes cambiar el ícono
                label: const Text('Registrarme',
                  style: TextStyle(
                    fontSize: 18,         // Cambia el tamaño aquí
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 160, 43, 0) // Opcional
                  ),),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  context.goNamed(SigninPage.pathName);
                },
                 icon: const Icon(Icons.login, size:30, color: Color.fromARGB(255, 160, 43, 0)), // Puedes cambiar el ícono
                label: const Text('Iniciar sesión',
                  style: TextStyle(
                    fontSize: 18,         // Cambia el tamaño aquí
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 160, 43, 0) // Opcional
                  ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
