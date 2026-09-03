import 'package:flutter/material.dart';

import '../models/weekly_schedule.dart';
import '../services/schedule_repository.dart';
import '../services/workout_repository.dart';
import '../widgets/day_schedule_tile.dart';

class ScheduleScreen extends StatefulWidget {
  final WorkoutRepository workoutRepository;
  final ScheduleRepository scheduleRepository;
  final VoidCallback onChanged;

  const ScheduleScreen({
    super.key,
    required this.workoutRepository,
    required this.scheduleRepository,
    required this.onChanged,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Future<void> _pickWorkout(DayOfWeek day) async {
    final workouts = widget.workoutRepository.workouts;
    final selected = await showModalBottomSheet<String?>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Rest day'),
              onTap: () => Navigator.of(context).pop(),
            ),
            const Divider(height: 1),
            for (final workout in workouts)
              ListTile(
                title: Text(workout.name),
                onTap: () => Navigator.of(context).pop(workout.id),
              ),
            if (workouts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No saved workouts yet. Build one in the Workouts tab.'),
              ),
          ],
        ),
      ),
    );
    await widget.scheduleRepository.assignWorkout(day, selected);
    setState(() {});
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final schedule = widget.scheduleRepository.schedule;
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Schedule')),
      body: ListView(
        children: [
          for (final day in DayOfWeek.values)
            DayScheduleTile(
              day: day,
              assignedWorkout: schedule.workoutIdFor(day) == null
                  ? null
                  : widget.workoutRepository.byId(schedule.workoutIdFor(day)!),
              onTap: () => _pickWorkout(day),
            ),
        ],
      ),
    );
  }
}
