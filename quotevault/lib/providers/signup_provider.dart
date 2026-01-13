import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupProvider extends ChangeNotifier {
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  SignupProvider() {
    email.addListener(notifyListeners);
    password.addListener(notifyListeners);
    confirmPassword.addListener(notifyListeners);
  }

  bool loading = false;
  String? message;
  bool showErrors = false;
  bool showPassword = false;
  bool showConfirm = false;

  bool get hasUpper => RegExp(r'[A-Z]').hasMatch(password.text);
  bool get hasLower => RegExp(r'[a-z]').hasMatch(password.text);
  bool get hasNumber => RegExp(r'\d').hasMatch(password.text);
  bool get hasSymbol => RegExp(r'[!@#\$&*~_\-]').hasMatch(password.text);
  bool get hasLength => password.text.length >= 8;

  bool get passwordValid =>
      hasUpper && hasLower && hasNumber && hasSymbol && hasLength;

  bool get emailValid => RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  ).hasMatch(email.text.trim());

  String? get emailError {
    if (!showErrors) return null;
    if (email.text.trim().isEmpty) return "Email is required";
    if (!emailValid) return "Enter a valid email";
    return null;
  }

  String? get passwordError {
    if (!showErrors) return null;
    if (password.text.isEmpty) return "Password is required";
    if (!passwordValid) return "Password does not meet requirements";
    return null;
  }

  String? get confirmError {
    if (!showErrors) return null;
    if (confirmPassword.text.isEmpty) return "Confirm your password";
    if (confirmPassword.text != password.text) return "Passwords do not match";
    return null;
  }

  bool get isValid => emailValid && passwordValid && confirmError == null;

  void togglePassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  void toggleConfirm() {
    showConfirm = !showConfirm;
    notifyListeners();
  }

  Future<bool> signup() async {
    showErrors = true;
    notifyListeners();

    if (!isValid) return false;

    loading = true;
    message = null;
    notifyListeners();

    try {
      await Supabase.instance.client.auth.signUp(
        email: email.text.trim(),
        password: password.text,
      );
      message = "Account created successfully";
      loading = false;
      notifyListeners();
      return true;
    } catch (_) {
      message = "Signup failed. Try again.";
      loading = false;
      notifyListeners();
      return false;
    }
  }
}