import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final email = TextEditingController();

  bool loading = false;
  String? message;
  bool showErrors = false;

  bool get isValid {
    final v = email.text.trim();
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(v);
  }

  String? get emailError {
    if (!showErrors) return null;
    if (email.text.trim().isEmpty) return "Email is required";
    if (!isValid) return "Enter a valid email";
    return null;
  }

  Future<void> submit() async {
    showErrors = true;
    notifyListeners();

    if (!isValid) return;

    loading = true;
    message = null;
    notifyListeners();

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email.text.trim(),
      );
      message = "Reset link sent to your email";
    } catch (_) {
      message = "Failed to send reset email. Try again.";
    }

    loading = false;
    notifyListeners();
  }
}
