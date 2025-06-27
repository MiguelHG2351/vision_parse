import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vision_parse/blocs/bloc/auth_bloc.dart';
import 'package:vision_parse/pages/home_page.dart';
import 'package:vision_parse/utils/debouncer.dart';
import 'package:vision_parse/utils/validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:vision_parse/pages/complete_profile_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  static const String pathName = 'signIn';
  static const String path = '/sign-in';

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool isButtonEnabled = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // focus node
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  void _validateForm() {
    // validate fields
    final isValid =
        _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    setState(() {
      isButtonEnabled = isValid;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(milliseconds: 500);
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
                Image.asset('assets/images/pingu-login.png', width: 100),
                SizedBox(height: 20),
                Text(
                  'Bienvenido!',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  focusNode: _emailFocusNode,
                  controller: _emailController,
                  style: textTheme.titleMedium,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Inicio de sesión',
                    hintStyle: textTheme.titleMedium,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (_) {
                    debouncer.run(() {
                      _validateForm();
                    });
                  },
                  validator: (email) {
                    final validateEmail = emailValidator(email ?? '');
                    if (email == null ||
                        email.isEmpty ||
                        validateEmail == false) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  focusNode: _passwordFocusNode,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    hintStyle: textTheme.titleMedium,
                    border: const OutlineInputBorder(),
                  ),
                  style: textTheme.titleMedium,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  onChanged: (_) {
                    debouncer.run(() {
                      _validateForm();
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) async {
                    if (state.emailLoginProgressStatus.isError) {
                      final snackBar = SnackBar(
                        content: Text(
                          state.emailErrorMessage,
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      isButtonEnabled = true;
                    }
                    if (state.emailLoginProgressStatus.isSuccess) {
                      context.goNamed(HomePage.pathName);
                    }
                  },
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              disabledBackgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                            ),
                            onPressed:
                                isButtonEnabled
                                    ? () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        _emailFocusNode.unfocus();
                                        _passwordFocusNode.unfocus();
                                        context.read<AuthBloc>().add(
                                          AuthEmailLoginEvent(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          ),
                                        );
                                      }
                                      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                        final snackBar = SnackBar(
                                          content: Text(
                                            'Por favor, completa todos los campos',
                                            style: textTheme.titleMedium?.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.red,
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        return;
                                      }
                                    }
                                    
                                    : null,
                            child: AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: AnimatedSwitcher(
                                transitionBuilder: (child, animation) {
                                  // Combina fade + scale para un efecto más vistoso
                                  return FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                  );
                                },
                                duration: const Duration(milliseconds: 300),
                                child:
                                    state.emailLoginProgressStatus.isLoading
                                        ? SizedBox(
                                          key: const ValueKey('loader'),
                                          width: 20,
                                          height: 20,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                        )
                                        : const Text('Iniciar sesión'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 16),
                Text('¿No tienes cuenta?'),
                TextButton(
                  onPressed: () {
                    // Navigate to registration page
                    context.goNamed('register');
                  },
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
