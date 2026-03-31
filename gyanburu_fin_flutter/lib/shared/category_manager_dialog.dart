import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';

import '../main.dart';
import '../mock/mock_data.dart';
import '../theme/app_theme.dart';

/// Opens the Manage Categories dialog. Returns the updated list of categories
/// if the user made changes, or null if dismissed.
Future<List<Category>?> showCategoryManagerDialog(
  BuildContext context,
  List<Category> categories,
) {
  return showDialog<List<Category>>(
    context: context,
    builder: (_) => CategoryManagerDialog(categories: categories),
  );
}

class CategoryManagerDialog extends StatefulWidget {
  const CategoryManagerDialog({super.key, required this.categories});
  final List<Category> categories;

  @override
  State<CategoryManagerDialog> createState() => _CategoryManagerDialogState();
}

class _CategoryManagerDialogState extends State<CategoryManagerDialog> {
  late List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _categories = List.from(widget.categories);
  }

  void _addCategory() async {
    final result = await showDialog<Category>(
      context: context,
      builder: (_) => const CategoryEditDialog(),
    );
    if (result != null) {
      final saved = await client.category.create(result);
      setState(() => _categories.add(saved));
    }
  }

  void _editCategory(int index) async {
    final result = await showDialog<Category>(
      context: context,
      builder: (_) => CategoryEditDialog(existing: _categories[index]),
    );
    if (result != null) {
      final saved = await client.category.update(result);
      setState(() => _categories[index] = saved);
    }
  }

  void _deleteCategory(int index) async {
    final cat = _categories[index];
    if (cat.id != null) {
      await client.category.delete(cat.id!);
    }
    setState(() => _categories.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.category, size: 22),
                  const SizedBox(width: 8),
                  Text('Manage Categories',
                      style: theme.textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _categories.length,
                  itemBuilder: (ctx, i) {
                    final cat = _categories[i];
                    final icon =
                        MockData.categoryIconMap[cat.icon] ?? Icons.category;
                    final color =
                        Color(int.parse('FF${cat.color}', radix: 16));

                    return ListTile(
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: color, size: 18),
                      ),
                      title: Text(cat.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => _editCategory(i),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,
                                size: 18, color: AppColors.negative),
                            onPressed: () => _deleteCategory(i),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _addCategory,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New Category'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, _categories),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category Edit Dialog
// ---------------------------------------------------------------------------

class CategoryEditDialog extends StatefulWidget {
  const CategoryEditDialog({super.key, this.existing});
  final Category? existing;

  @override
  State<CategoryEditDialog> createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends State<CategoryEditDialog> {
  late final TextEditingController _nameController;
  late String _selectedIcon;
  late String _selectedColor;

  static const _availableIcons = [
    'work', 'computer', 'trending_up', 'home', 'bolt', 'directions_car',
    'local_hospital', 'movie', 'school', 'restaurant', 'shopping_bag',
    'attach_money', 'credit_card', 'pets', 'fitness_center', 'flight',
    'phone_android', 'child_care', 'build',
  ];

  static const _availableColors = [
    '4CAF50', '66BB6A', '26A69A', '42A5F5', '5C6BC0', 'AB47BC',
    'EF5350', 'FF7043', 'FFA726', 'FFCA28', '29B6F6', '78909C',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _selectedIcon = widget.existing?.icon ?? _availableIcons.first;
    _selectedColor = widget.existing?.color ?? _availableColors.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final cat = Category(
      id: widget.existing?.id,
      userId: Uuid().v4obj(),
      name: name,
      icon: _selectedIcon,
      color: _selectedColor,
    );
    Navigator.pop(context, cat);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.existing != null;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isEditing ? 'Edit Category' : 'New Category',
                  style: theme.textTheme.titleLarge),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 20),
              Text('Icon', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _availableIcons.map((iconKey) {
                  final iconData =
                      MockData.categoryIconMap[iconKey] ?? Icons.category;
                  final isSelected = _selectedIcon == iconKey;
                  return InkWell(
                    onTap: () => setState(() => _selectedIcon = iconKey),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.deepPurple.withValues(alpha: 0.2)
                            : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(iconData,
                          size: 20,
                          color: isSelected
                              ? AppColors.deepPurple
                              : AppColors.textSecondary),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text('Color', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _availableColors.map((hex) {
                  final color = Color(int.parse('FF$hex', radix: 16));
                  final isSelected = _selectedColor == hex;
                  return InkWell(
                    onTap: () => setState(() => _selectedColor = hex),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _save,
                    child: Text(isEditing ? 'Save' : 'Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
