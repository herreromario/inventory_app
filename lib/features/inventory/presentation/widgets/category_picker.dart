import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';

class CategoryPicker extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onSelected;

  const CategoryPicker({
    super.key,
    this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final hasCategory = selectedCategory?.isNotEmpty == true;

    return InkWell(
      onTap: () async {
        final result = await context.push<String>(AppRoutes.categories);
        onSelected(result);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Category',
          border: const OutlineInputBorder(),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasCategory)
                IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () => onSelected(null),
                ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
        child: Text(
          hasCategory ? selectedCategory! : 'Sin categoría',
          style: TextStyle(
            color: hasCategory ? null : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}
