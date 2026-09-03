import 'package:flutter/material.dart';

import '../services/exercise_repository.dart';
import '../widgets/exercise_browser.dart';

class ExercisePickerScreen extends StatelessWidget {
  final ExerciseRepository exerciseRepository;

  const ExercisePickerScreen({super.key, required this.exerciseRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Exercise')),
      body: ExerciseBrowser(
        exercises: exerciseRepository.exercises,
        onTap: (exercise) => Navigator.of(context).pop(exercise),
      ),
    );
  }
}
