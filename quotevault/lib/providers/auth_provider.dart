import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _bootstrapped = false;

  AuthProvider() {
    _bootstrap();
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get ready => _bootstrapped;

  String get email => _user?.email ?? "";
  String get userId => _user?.id ?? "";

  void _bootstrap() {
    final auth = Supabase.instance.client.auth;

    // 1️⃣ Load cached session synchronously
    _user = auth.currentUser;

    // 2️⃣ Listen for auth changes
    auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      _bootstrapped = true;
      notifyListeners();
    });

    // 3️⃣ Mark initial load complete
    _bootstrapped = true;
    notifyListeners();
  }

  // ---------- AUTH ACTIONS ----------

  Future<void> login(String email, String password) async {
    final res = await Supabase.instance.client.auth
        .signInWithPassword(email: email, password: password);

    if (res.user == null) {
      throw Exception("Login failed");
    }
  }

  Future<void> signup(String email, String password) async {
    final res = await Supabase.instance.client.auth
        .signUp(email: email, password: password);

    if (res.user == null) {
      throw Exception("Signup failed");
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    _user = null;
    notifyListeners();
  }
}