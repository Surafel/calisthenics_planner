import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../models/weekly_schedule.dart';
import '../models/workout_exercise.dart';
import '../services/exercise_repository.dart';
import '../services/schedule_repository.dart';
import '../services/workout_repository.dart';
import '../widgets/workout_card.dart';

DayOfWeek _todayAsDayOfWeek() {
  // DateTime.weekday is 1 (Monday) through 7 (Sunday), matching enum order.
  return DayOfWeek.values[DateTime.now().weekday - 1];
}

class TodayScreen extends StatelessWidget {
  final ExerciseRepository exerciseRepository;
  final WorkoutRepository workoutRepository;
  final ScheduleRepository scheduleRepository;
  final VoidCallback onGoToSchedule;

  const TodayScreen({
    super.key,
    required this.exerciseRepository,
    required this.workoutRepository,
    required this.scheduleRepository,
    required this.onGoToSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final today = _todayAsDayOfWeek();
    final workoutId = scheduleRepository.schedule.workoutIdFor(today);
    final workout = workoutId == null ? null : workoutRepository.byId(workoutId);

    return Scaffold(
      appBar: AppBar(title: const Text('Today')),
      body: workout == null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Rest day.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: onGoToSchedule,
                    child: const Text('Edit schedule'),
                  ),
                ],
              ),
            )
          : ListView(
              children: [
                WorkoutCard(workout: workout),
                for (final entry in workout.exercises)
                  if (exerciseRepository.byId(entry.exerciseId) != null)
                    _TodaySetTile(
                      exercise: exerciseRepository.byId(entry.exerciseId)!,
                      entry: entry,
                    ),
              ],
            ),
    );
  }
}

class _TodaySetTile extends StatelessWidget {
  final Exercise exercise;
  final WorkoutExercise entry;

  const _TodaySetTile({required this.exercise, required this.entry});

  @override
  Widget build(BuildContext context) {
    final measure = exercise.measurementType == MeasurementType.hold
        ? '${entry.holdSeconds}s hold'
        : '${entry.reps} reps';
    return ListTile(
      title: Text(exercise.name),
      subtitle: Text('${entry.sets} sets · $measure · ${entry.restSeconds}s rest'),
    );
  }
}
