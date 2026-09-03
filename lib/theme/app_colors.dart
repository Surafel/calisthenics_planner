import 'package:flutter/material.dart';

import '../models/exercise.dart';

class AppColors {
  AppColors._();

  static const charcoal = Color(0xFF1C1C1E);
  static const steel = Color(0xFF3A3A3C);
  static const accent = Color(0xFFFF6B35);
  static const surface = Color(0xFFF5F5F7);
  static const bodyText = Color(0xFF1C1C1E);
  static const muted = Color(0xFF8E8E93);

  static const _categoryColors = {
    ExerciseCategory.push: Color(0xFFFF6B35),
    ExerciseCategory.pull: Color(0xFF2E86AB),
    ExerciseCategory.legs: Color(0xFF4CAF50),
    ExerciseCategory.core: Color(0xFFB185DB),
    ExerciseCategory.skills: Color(0xFFE0B02E),
  };

  static Color colorFor(ExerciseCategory category) =>
      _categoryColors[category] ?? charcoal;
}
