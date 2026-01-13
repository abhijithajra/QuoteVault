import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/forgot_password_provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ForgotPasswordProvider>();
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
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
                    blurRadius: 30,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Reset your password",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter your email to receive a reset link",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 32),

                  TextField(
                    controller: p.email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email address",
                      prefixIcon: const Icon(Icons.email_outlined),
                      errorText: p.emailError,
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (p.message != null)
                    Text(
                      p.message!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: p.message!.toLowerCase().contains("sent")
                            ? Colors.green
                            : Colors.redAccent,
                      ),
                    ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: p.loading ? null : p.submit,
                    child: p.loading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text("Send reset link"),
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
}
