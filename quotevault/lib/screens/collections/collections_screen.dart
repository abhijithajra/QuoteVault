import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/collections_provider.dart';
import 'collection_detail_screen.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollectionsProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CollectionsProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Collections")),
      body: Column(
        children: [
          _createInput(theme),

          Expanded(
            child: cp.collections.isEmpty
                ? Center(
              child: Text(
                "No collections yet",
                style: theme.textTheme.bodySmall,
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: cp.collections.length,
              itemBuilder: (_, i) =>
                  _collectionCard(theme, cp.collections[i]),
            ),
          )
        ],
      ),
    );
  }

  Widget _createInput(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                  theme.brightness == Brightness.dark ? 0.25 : 0.04),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Create a new collection",
            prefixIcon: Icon(Icons.add),
            border: InputBorder.none,
          ),
          onSubmitted: (v) {
            if (v.trim().isNotEmpty) {
              context.read<CollectionsProvider>().create(v.trim());
              controller.clear();
            }
          },
        ),
      ),
    );
  }

  Widget _collectionCard(ThemeData theme, dynamic c) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CollectionDetailScreen(c)),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                  theme.brightness == Brightness.dark ? 0.25 : 0.04),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  c.name,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.iconTheme.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
