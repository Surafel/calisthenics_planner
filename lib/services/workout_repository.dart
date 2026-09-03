import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/workout.dart';

const _workoutsKey = 'workouts_v1';

class WorkoutRepository {
  List<Workout> _workouts = [];
  SharedPreferences? _prefs;

  List<Workout> get workouts => List.unmodifiable(_workouts);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    final raw = prefs.getString(_workoutsKey);
    if (raw == null) return;
    final data = jsonDecode(raw) as List<dynamic>;
    _workouts =
        data.map((e) => Workout.fromJson(e as Map<String, dynamic>)).toList();
  }

  Workout? byId(String id) {
    for (final w in _workouts) {
      if (w.id == id) return w;
    }
    return null;
  }

  Future<void> saveWorkout(Workout workout) async {
    final index = _workouts.indexWhere((w) => w.id == workout.id);
    if (index >= 0) {
      _workouts[index] = workout;
    } else {
      _workouts.add(workout);
    }
    await _persist();
  }

  Future<void> deleteWorkout(String id) async {
    _workouts.removeWhere((w) => w.id == id);
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setString(
      _workoutsKey,
      jsonEncode(_workouts.map((w) => w.toJson()).toList()),
    );
  }
}
