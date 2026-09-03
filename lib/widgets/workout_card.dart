import 'package:flutter/material.dart';

import '../models/workout.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback? onTap;
  final Widget? trailing;

  const WorkoutCard({
    super.key,
    required this.workout,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(child: Icon(Icons.list_alt)),
        title: Text(workout.name),
        subtitle: Text('${workout.exercises.length} exercises'),
        trailing: trailing,
      ),
    );
  }
}
