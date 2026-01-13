import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/signup_provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SignupProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? null
              : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF6F7FB), Color(0xFFEDEBFF)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Create account",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Secure your account with a strong password",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 32),

                  _input(
                      p.email,
                      "Email address",
                      Icons.email_outlined,
                      p.emailError,
                      theme),
                  const SizedBox(height: 16),

                  _passwordInput(
                      p.password,
                      "Password",
                      p.showPassword,
                      p.togglePassword,
                      p.passwordError,
                      theme),
                  const SizedBox(height: 10),

                  _rules(p),

                  const SizedBox(height: 16),

                  _passwordInput(
                      p.confirmPassword,
                      "Confirm password",
                      p.showConfirm,
                      p.toggleConfirm,
                      p.confirmError,
                      theme),
                  const SizedBox(height: 24),

                  if (p.message != null)
                    Text(
                      p.message!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: p.message!.toLowerCase().contains("account")
                            ? Colors.green
                            : Colors.redAccent,
                      ),
                    ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: p.loading
                        ? null
                        : () async {
                      final ok = await p.signup();
                      if (ok && context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: p.loading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text("Create account"),
                  ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Back to login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String hint, IconData icon,
      String? error, ThemeData theme) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        errorText: error,
      ),
    );
  }

  Widget _passwordInput(TextEditingController c, String hint, bool show,
      VoidCallback toggle, String? error, ThemeData theme) {
    return TextField(
      controller: c,
      obscureText: !show,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline),
        errorText: error,
        suffixIcon: IconButton(
          icon: Icon(show ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
      ),
    );
  }

  Widget _rules(SignupProvider p) {
    Widget rule(bool ok, String text) {
      return Row(
        children: [
          Icon(ok ? Icons.check_circle : Icons.circle_outlined,
              size: 14, color: ok ? Colors.green : Colors.grey),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(
                fontSize: 13,
                color: ok ? Colors.green : Colors.grey,
              )),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rule(p.hasLength, "At least 8 characters"),
        rule(p.hasUpper, "One uppercase letter"),
        rule(p.hasLower, "One lowercase letter"),
        rule(p.hasNumber, "One number"),
        rule(p.hasSymbol, "One symbol"),
      ],
    );
  }
}