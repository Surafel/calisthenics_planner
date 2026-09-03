import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../models/workout_exercise.dart';

/// Editable row for one WorkoutExercise inside the workout builder.
/// The parent screen owns the state; this widget just reports changes.
class SetEntryRow extends StatelessWidget {
  final Exercise exercise;
  final WorkoutExercise entry;
  final ValueChanged<WorkoutExercise> onChanged;
  final VoidCallback onRemove;

  const SetEntryRow({
    super.key,
    required this.exercise,
    required this.entry,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isHold = exercise.measurementType == MeasurementType.hold;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    exercise.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onRemove,
                ),
              ],
            ),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _Stepper(
                  label: 'Sets',
                  value: entry.sets,
                  min: 1,
                  onChanged: (v) => onChanged(entry.copyWith(sets: v)),
                ),
                if (isHold)
                  _Stepper(
                    label: 'Hold (s)',
                    value: entry.holdSeconds ?? 20,
                    min: 1,
                    step: 5,
                    onChanged: (v) => onChanged(entry.copyWith(holdSeconds: v)),
                  )
                else
                  _Stepper(
                    label: 'Reps',
                    value: entry.reps ?? 10,
                    min: 1,
                    onChanged: (v) => onChanged(entry.copyWith(reps: v)),
                  ),
                _Stepper(
                  label: 'Rest (s)',
                  value: entry.restSeconds,
                  min: 0,
                  step: 5,
                  onChanged: (v) => onChanged(entry.copyWith(restSeconds: v)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int step;
  final ValueChanged<int> onChanged;

  const _Stepper({
    required this.label,
    required this.value,
    required this.min,
    this.step = 1,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              visualDensity: VisualDensity.compact,
              onPressed:
                  value > min ? () => onChanged((value - step).clamp(min, 1 << 30)) : null,
            ),
            SizedBox(
              width: 28,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              visualDensity: VisualDensity.compact,
              onPressed: () => onChanged(value + step),
            ),
          ],
        ),
      ],
    );
  }
}
