import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;
  bool showPassword = false;
  String? authError;
  AutovalidateMode autoValidate = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
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
                    color: Colors.black.withOpacity(isDark ? 0.25 : 0.06),
                    blurRadius: 30,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                autovalidateMode: autoValidate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Welcome back",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign in to continue",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 32),

                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: "Email address",
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Email is required";
                        }
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (!emailRegex.hasMatch(v.trim())) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: password,
                      obscureText: !showPassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() => showPassword = !showPassword);
                          },
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Password is required";
                        }
                        if (v.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    if (authError != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          authError!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),

                    ElevatedButton(
                      onPressed: loading
                          ? null
                          : () async {
                        FocusScope.of(context).unfocus();

                        if (!_formKey.currentState!.validate()) {
                          setState(() {
                            autoValidate =
                                AutovalidateMode.onUserInteraction;
                          });
                          return;
                        }

                        setState(() {
                          loading = true;
                          authError = null;
                        });

                        try {
                          await auth.login(
                            email.text.trim(),
                            password.text,
                          );
                        } catch (_) {
                          setState(() {
                            authError = "Invalid email or password";
                          });
                        }

                        setState(() => loading = false);
                      },
                      child: loading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text("Sign in"),
                    ),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      ),
                      child: const Text("Forgot password?"),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: theme.textTheme.bodySmall,
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          ),
                          child: const Text("Sign up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
