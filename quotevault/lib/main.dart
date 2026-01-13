import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotevault/providers/forgot_password_provider.dart';
import 'package:quotevault/providers/signup_provider.dart';
import 'config/supabase.dart';
import 'providers/auth_provider.dart';
import 'providers/quote_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/collections_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  runApp(const QuotesApp());
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
        ChangeNotifierProvider(create: (_) => QuoteProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => CollectionsProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (_, settings, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,

            // LIGHT THEME
            theme: ThemeData(
              brightness: Brightness.light,
              useMaterial3: false,
              primaryColor: settings.accentColor,
              scaffoldBackgroundColor: const Color(0xFFF6F7FB),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFFF6F7FB),
                foregroundColor: Color(0xFF1F2937),
                elevation: 0,
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: settings.accentColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            // DARK THEME (soft slate)
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: false,
              primaryColor: settings.accentColor,

              scaffoldBackgroundColor: const Color(0xFF0B1220), // slate dark
              cardColor: const Color(0xFF121A2F),               // soft card
              dialogBackgroundColor: const Color(0xFF121A2F),

              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF0B1220),
                foregroundColor: Colors.white,
                elevation: 0,
              ),

              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFF121A2F),
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),

              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Color(0xFFE5E7EB)),
                bodyMedium: TextStyle(color: Color(0xFFD1D5DB)),
                bodySmall: TextStyle(color: Color(0xFF9CA3AF)),
                titleLarge: TextStyle(color: Colors.white),
                titleMedium: TextStyle(color: Color(0xFFE5E7EB)),
              ),

              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: settings.accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            home: const _RootRouter(),
          );
        },
      ),
    );
  }
}

class _RootRouter extends StatelessWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return auth.isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}

