import 'package:flutter/material.dart';

import '../data/starter_plan.dart';
import '../models/workout.dart';
import '../services/exercise_repository.dart';
import '../services/schedule_repository.dart';
import '../services/workout_repository.dart';
import '../widgets/workout_card.dart';
import 'workout_builder_screen.dart';

class WorkoutsScreen extends StatefulWidget {
  final ExerciseRepository exerciseRepository;
  final WorkoutRepository workoutRepository;
  final ScheduleRepository scheduleRepository;
  final VoidCallback onChanged;

  const WorkoutsScreen({
    super.key,
    required this.exerciseRepository,
    required this.workoutRepository,
    required this.scheduleRepository,
    required this.onChanged,
  });

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  Future<void> _openBuilder({Workout? existing}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutBuilderScreen(
          exerciseRepository: widget.exerciseRepository,
          workoutRepository: widget.workoutRepository,
          existingWorkout: existing,
        ),
      ),
    );
    setState(() {});
    widget.onChanged();
  }

  Future<void> _delete(Workout workout) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete workout?'),
        content: Text('This will remove "${workout.name}" and unschedule it.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.workoutRepository.deleteWorkout(workout.id);
    await widget.scheduleRepository.clearWorkout(workout.id);
    setState(() {});
    widget.onChanged();
  }

  Future<void> _loadStarterPlan() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Load starter plan?'),
        content: const Text(
          'Adds 4 preset workouts (Push, Pull, Legs, Core & Conditioning) and '
          'schedules them Monday/Wednesday/Friday/Saturday, with the other '
          'days set to rest. This overwrites whatever is currently scheduled '
          'on those days.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Load plan'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    for (final workout in buildStarterWorkouts()) {
      await widget.workoutRepository.saveWorkout(workout);
    }
    for (final entry in starterScheduleAssignments.entries) {
      await widget.scheduleRepository.assignWorkout(entry.key, entry.value);
    }
    setState(() {});
    widget.onChanged();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Starter plan loaded and scheduled.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final workouts = widget.workoutRepository.workouts;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'Load starter plan',
            onPressed: _loadStarterPlan,
          ),
        ],
      ),
      body: workouts.isEmpty
          ? const Center(
              child: Text(
                'No workouts yet. Tap + to build one, or load the starter plan.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return WorkoutCard(
                  workout: workout,
                  onTap: () => _openBuilder(existing: workout),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _delete(workout),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openBuilder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
