import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/workout_exercise.dart';
import '../services/exercise_repository.dart';
import '../services/workout_repository.dart';
import '../widgets/set_entry_row.dart';
import 'exercise_picker_screen.dart';

class WorkoutBuilderScreen extends StatefulWidget {
  final ExerciseRepository exerciseRepository;
  final WorkoutRepository workoutRepository;
  final Workout? existingWorkout;

  const WorkoutBuilderScreen({
    super.key,
    required this.exerciseRepository,
    required this.workoutRepository,
    this.existingWorkout,
  });

  @override
  State<WorkoutBuilderScreen> createState() => _WorkoutBuilderScreenState();
}

class _WorkoutBuilderScreenState extends State<WorkoutBuilderScreen> {
  late final TextEditingController _nameController;
  late List<WorkoutExercise> _exercises;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingWorkout?.name);
    _exercises = List.of(widget.existingWorkout?.exercises ?? const []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addExercise() async {
    final picked = await Navigator.of(context).push<Exercise>(
      MaterialPageRoute(
        builder: (_) => ExercisePickerScreen(
          exerciseRepository: widget.exerciseRepository,
        ),
      ),
    );
    if (picked == null) return;
    setState(() {
      _exercises.add(
        WorkoutExercise(
          exerciseId: picked.id,
          sets: 3,
          reps: picked.measurementType == MeasurementType.reps ? 10 : null,
          holdSeconds: picked.measurementType == MeasurementType.hold ? 20 : null,
          restSeconds: 60,
        ),
      );
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Give the workout a name and at least one exercise.'),
        ),
      );
      return;
    }
    final workout = Workout(
      id: widget.existingWorkout?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      exercises: _exercises,
    );
    await widget.workoutRepository.saveWorkout(workout);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingWorkout == null ? 'New Workout' : 'Edit Workout'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _save),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Workout name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _exercises.isEmpty
                ? const Center(child: Text('Add exercises to build this workout.'))
                : ListView.builder(
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) {
                      final entry = _exercises[index];
                      final exercise = widget.exerciseRepository.byId(entry.exerciseId);
                      if (exercise == null) return const SizedBox.shrink();
                      return SetEntryRow(
                        exercise: exercise,
                        entry: entry,
                        onChanged: (updated) =>
                            setState(() => _exercises[index] = updated),
                        onRemove: () => setState(() => _exercises.removeAt(index)),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addExercise,
        icon: const Icon(Icons.add),
        label: const Text('Add exercise'),
      ),
    );
  }
}
