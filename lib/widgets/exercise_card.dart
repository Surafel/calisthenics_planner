import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../theme/app_colors.dart';

String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseCard({super.key, required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppColors.colorFor(exercise.category);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: categoryColor.withValues(alpha: 0.15),
          child: Icon(Icons.fitness_center, color: categoryColor),
        ),
        title: Text(exercise.name),
        subtitle: Text(
          '${_capitalize(exercise.category.name)} · ${_capitalize(exercise.difficulty.name)}',
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
