import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/exercise.dart';

const _exerciseAssetPath = 'assets/exercises/exercises.json';

/// Loads the bundled exercise library. This is a single small local asset,
/// so it is simply re-parsed on every app start rather than cached.
class ExerciseRepository {
  List<Exercise> _exercises = const [];

  List<Exercise> get exercises => _exercises;

  Future<void> load() async {
    final raw = await rootBundle.loadString(_exerciseAssetPath);
    final data = jsonDecode(raw) as List<dynamic>;
    _exercises =
        data.map((e) => Exercise.fromJson(e as Map<String, dynamic>)).toList();
  }

  Exercise? byId(String id) {
    for (final e in _exercises) {
      if (e.id == id) return e;
    }
    return null;
  }

  List<Exercise> byCategory(ExerciseCategory? category) {
    if (category == null) return _exercises;
    return _exercises.where((e) => e.category == category).toList();
  }

  List<Exercise> search(String query) {
    if (query.isEmpty) return _exercises;
    final q = query.toLowerCase();
    return _exercises.where((e) => e.name.toLowerCase().contains(q)).toList();
  }
}
