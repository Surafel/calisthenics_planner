import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../theme/app_colors.dart';

String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

class CategoryFilterBar extends StatelessWidget {
  final ExerciseCategory? selected;
  final ValueChanged<ExerciseCategory?> onSelected;

  const CategoryFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: const Text('All'),
              selected: selected == null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          for (final category in ExerciseCategory.values)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(_capitalize(category.name)),
                selected: selected == category,
                selectedColor: AppColors.colorFor(category).withValues(alpha: 0.25),
                onSelected: (_) => onSelected(category),
              ),
            ),
        ],
      ),
    );
  }
}
