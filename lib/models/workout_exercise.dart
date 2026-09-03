/// One exercise entry inside a saved Workout, with the sets/reps/hold/rest
/// the user configured for it.
class WorkoutExercise {
  final String exerciseId;
  final int sets;
  final int? reps;
  final int? holdSeconds;
  final int restSeconds;

  const WorkoutExercise({
    required this.exerciseId,
    required this.sets,
    this.reps,
    this.holdSeconds,
    required this.restSeconds,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      WorkoutExercise(
        exerciseId: json['exerciseId'] as String,
        sets: json['sets'] as int,
        reps: json['reps'] as int?,
        holdSeconds: json['holdSeconds'] as int?,
        restSeconds: json['restSeconds'] as int,
      );

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'sets': sets,
        if (reps != null) 'reps': reps,
        if (holdSeconds != null) 'holdSeconds': holdSeconds,
        'restSeconds': restSeconds,
      };

  WorkoutExercise copyWith({
    int? sets,
    int? reps,
    int? holdSeconds,
    int? restSeconds,
  }) =>
      WorkoutExercise(
        exerciseId: exerciseId,
        sets: sets ?? this.sets,
        reps: reps ?? this.reps,
        holdSeconds: holdSeconds ?? this.holdSeconds,
        restSeconds: restSeconds ?? this.restSeconds,
      );
}
