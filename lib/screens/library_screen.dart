import 'package:flutter/material.dart';

import '../services/exercise_repository.dart';
import '../widgets/exercise_browser.dart';
import 'exercise_detail_screen.dart';

class LibraryScreen extends StatelessWidget {
  final ExerciseRepository exerciseRepository;

  const LibraryScreen({super.key, required this.exerciseRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise Library')),
      body: ExerciseBrowser(
        exercises: exerciseRepository.exercises,
        onTap: (exercise) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ExerciseDetailScreen(exercise: exercise),
          ),
        ),
      ),
    );
  }
}
