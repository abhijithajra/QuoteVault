import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);
    final accent = settings.accentColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card(
            context,
            child: SwitchListTile(
              title: const Text("Dark Mode"),
              subtitle: const Text("Switch between light and dark theme"),
              value: settings.darkMode,
              activeColor: accent,
              onChanged: (_) => settings.toggleDark(),
            ),
          ),

          const SizedBox(height: 16),

          _card(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Font Size",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Slider(
                  min: 14,
                  max: 28,
                  divisions: 7,
                  value: settings.fontSize,
                  activeColor: accent,
                  onChanged: (v) => settings.setFont(v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _card(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Accent Color",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 14,
                  children: [
                    _colorDot(context, const Color(0xFF4BC6B9)),
                    _colorDot(context, const Color(0xFF6B5CF6)),
                    _colorDot(context, Colors.orange),
                    _colorDot(context, Colors.pink),
                    _colorDot(context, Colors.teal),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _colorDot(BuildContext context, Color color) {
    final settings = context.watch<SettingsProvider>();
    final selected = settings.accentColor == color;

    return GestureDetector(
      onTap: () => settings.setAccent(color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? settings.accentColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: color,
          child: selected ? const Icon(Icons.check, color: Colors.white) : null,
        ),
      ),
    );
  }
}
