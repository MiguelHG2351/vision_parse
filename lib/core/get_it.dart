import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vision_parse/blocs/bloc/auth_bloc.dart';
import 'package:vision_parse/utils/shared_preferences_manager.dart';

final serviceLocator = GetIt.instance;

void setupServiceLocator() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Initialize Supabase
  serviceLocator.registerLazySingleton(() => Supabase.instance.client);
  // shared preferences
  serviceLocator.registerSingleton<SharedPreferencesManager>(SharedPreferencesManager(prefs: prefs));

  serviceLocator.registerSingleton<AuthBloc>(AuthBloc());
}
