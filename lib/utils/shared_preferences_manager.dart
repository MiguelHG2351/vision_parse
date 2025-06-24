import 'package:shared_preferences/shared_preferences.dart';

// https://github.com/piratotasktracker/front-end-flutter/blob/3a0f2594ba5e55337e59e7409174c011ac88b88b/lib/sl.dart#L25
class SharedPreferencesManager{
  final SharedPreferences prefs;

  const SharedPreferencesManager({required this.prefs});

  void setIsGuest(bool isGuest) {
    prefs.setBool('isGuest', isGuest);
  }

  bool? getIsGuest() {
    return prefs.getBool('isGuest');
  }
}

