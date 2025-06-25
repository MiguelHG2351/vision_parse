
/// Validates the strength of a password based on various criteria.
///
/// Checks if the password contains at least one uppercase letter, one lowercase letter,
/// one digit, and one special character from the set [!@#$%^&*(),.?":{}|<>].
///
/// Returns `true` if the password meets all the criteria, otherwise `false`.
bool passwordValidator(String password) {
  final hasMinLength = password.length >= 8;
  final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
  final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
  final hasDigits = RegExp(r'[0-9]').hasMatch(password);
  final hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}+|<>-]').hasMatch(password);
  // Return true if all criteria are met
  return hasMinLength && hasUpperCase && hasLowerCase && hasDigits && hasSpecialCharacters;
}

/// Validates the format of an email address.
///
/// Uses a regular expression to validate whether the given string matches
/// the typical format of an email address.
///
/// Returns `true` if the email address format is valid, otherwise `false`.
bool emailValidator(String email) {
  // Use a regular expression to validate the email format
  final emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  return emailRegExp.hasMatch(email);
}
