import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {

  static String supabaseUrl = kReleaseMode
      ? const String.fromEnvironment('SUPABASE_URL')
      : dotenv.get('SUPABASE_URL');

  static String supabaseApiKey = kReleaseMode
      ? const String.fromEnvironment('SUPABASE_API_KEY')
      : dotenv.get('SUPABASE_API_KEY');
}
