import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _darkMode = false;
  double _fontSize = 16;
  Color _accentColor = const Color(0xFF6B5CF6);
  bool _loaded = false;

  bool get darkMode => _darkMode;
  double get fontSize => _fontSize;
  Color get accentColor => _accentColor;

  SettingsProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();

    _darkMode = prefs.getBool('dark_mode') ?? false;
    _fontSize = prefs.getDouble('font_size') ?? 16;
    final color = prefs.getInt('accent_color');

    if (color != null) {
      _accentColor = Color(color);
    }

    _loaded = true;
    notifyListeners();
  }

  Future<void> toggleDark() async {
    _darkMode = !_darkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _darkMode);
    notifyListeners();
  }

  Future<void> setFont(double size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_size', size);
    notifyListeners();
  }

  Future<void> setAccent(Color color) async {
    _accentColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accent_color', color.value);
    notifyListeners();
  }
}
