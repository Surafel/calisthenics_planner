import 'workout_exercise.dart';

class Workout {
  final String id;
  final String name;
  final List<WorkoutExercise> exercises;

  const Workout({
    required this.id,
    required this.name,
    required this.exercises,
  });

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        id: json['id'] as String,
        name: json['name'] as String,
        exercises: (json['exercises'] as List)
            .map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  Workout copyWith({String? name, List<WorkoutExercise>? exercises}) =>
      Workout(
        id: id,
        name: name ?? this.name,
        exercises: exercises ?? this.exercises,
      );
}
