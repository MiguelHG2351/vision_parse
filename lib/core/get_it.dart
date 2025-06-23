import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton(() => Supabase.instance);
}
