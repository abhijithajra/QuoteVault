import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/supabase.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();

  final ValueNotifier<bool> changed = ValueNotifier(false);
  final ValueNotifier<bool> loading = ValueNotifier(true);

  String? originalName;
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    nameController.addListener(_onNameChange);
  }

  void _onNameChange() {
    final text = nameController.text.trim();
    changed.value = text.isNotEmpty && text != originalName;
  }

  Future<void> _loadProfile() async {
    final user = supabase.auth.currentUser!;
    final prefs = await SharedPreferences.getInstance();
    avatarUrl = prefs.getString('avatar_url');

    final res = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    originalName = res['name'] ?? '';
    avatarUrl = res['avatar_url'];

    if (avatarUrl != null) {
      await prefs.setString('avatar_url', avatarUrl!);
    }

    nameController.text = originalName!;
    loading.value = false;
  }

  Future<void> _saveProfile() async {
    final name = nameController.text.trim();
    if (name.isEmpty || name == originalName) return;

    final user = supabase.auth.currentUser!;
    await supabase.from('profiles').update({
      'name': name,
      'avatar_url': avatarUrl,
    }).eq('id', user.id);

    originalName = name;
    changed.value = false;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated")),
    );
  }

  Future<void> _changePassword() async {
    final email = supabase.auth.currentUser!.email!;
    await supabase.auth.resetPasswordForEmail(email);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password reset link sent")),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    changed.dispose();
    loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = supabase.auth.currentUser?.email ?? '';
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Profile")),
      body: ValueListenableBuilder<bool>(
        valueListenable: loading,
        builder: (_, isLoading, __) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _avatarCard(theme, email),
              const SizedBox(height: 20),
              _nameCard(theme),
              const SizedBox(height: 20),
              _securityCard(theme),
              const SizedBox(height: 30),
              _logoutButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _avatarCard(ThemeData theme, String email) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _card(theme),
      child: Column(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundColor: theme.primaryColor,
            child: CircleAvatar(
              radius: 48,
              backgroundImage:
              avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? const Icon(Icons.person, size: 48)
                  : null,
            ),
          ),
          const SizedBox(height: 14),
          Text(email, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _nameCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _card(theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Display Name",
              style:
              theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: "Your display name",
            ),
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder<bool>(
            valueListenable: changed,
            builder: (_, show, __) {
              if (!show) return const SizedBox.shrink();

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text("Save Changes"),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _securityCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _card(theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Security",
              style:
              theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Change Password"),
            subtitle: const Text("Send password reset email"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _changePassword,
          )
        ],
      ),
    );
  }

  Widget _logoutButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
      onPressed: () async {
        await supabase.auth.signOut();
        if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
      },
      icon: const Icon(Icons.logout),
      label: const Text("Logout"),
    );
  }

  BoxDecoration _card(ThemeData theme) => BoxDecoration(
    color: theme.cardColor,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 18,
        offset: const Offset(0, 10),
      ),
    ],
  );
}
