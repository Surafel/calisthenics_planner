import '../models/weekly_schedule.dart';
import '../models/workout.dart';
import '../models/workout_exercise.dart';

const pushDayId = 'starter-push-day';
const pullDayId = 'starter-pull-day';
const legsDayId = 'starter-legs-day';
const coreDayId = 'starter-core-day';

/// A balanced 4-day push/pull/legs/core split with 3 rest days, using
/// beginner-to-intermediate movements. Fixed ids make loading it again
/// idempotent (it updates the same 4 workouts rather than duplicating them).
List<Workout> buildStarterWorkouts() => const [
      Workout(
        id: pushDayId,
        name: 'Push Day',
        exercises: [
          WorkoutExercise(exerciseId: 'incline_pushup', sets: 2, reps: 12, restSeconds: 45),
          WorkoutExercise(exerciseId: 'pushup', sets: 3, reps: 10, restSeconds: 60),
          WorkoutExercise(exerciseId: 'diamond_pushup', sets: 3, reps: 8, restSeconds: 60),
          WorkoutExercise(exerciseId: 'pike_pushup', sets: 3, reps: 8, restSeconds: 60),
          WorkoutExercise(exerciseId: 'decline_pushup', sets: 3, reps: 10, restSeconds: 60),
        ],
      ),
      Workout(
        id: pullDayId,
        name: 'Pull Day',
        exercises: [
          WorkoutExercise(exerciseId: 'dead_hang', sets: 3, holdSeconds: 20, restSeconds: 45),
          WorkoutExercise(exerciseId: 'australian_row', sets: 3, reps: 10, restSeconds: 60),
          WorkoutExercise(exerciseId: 'negative_pullup', sets: 3, reps: 5, restSeconds: 60),
          WorkoutExercise(exerciseId: 'chinup', sets: 3, reps: 6, restSeconds: 60),
        ],
      ),
      Workout(
        id: legsDayId,
        name: 'Legs Day',
        exercises: [
          WorkoutExercise(exerciseId: 'bodyweight_squat', sets: 3, reps: 15, restSeconds: 45),
          WorkoutExercise(exerciseId: 'split_squat', sets: 3, reps: 10, restSeconds: 60),
          WorkoutExercise(exerciseId: 'bulgarian_split_squat', sets: 3, reps: 8, restSeconds: 60),
          WorkoutExercise(exerciseId: 'glute_bridge', sets: 3, reps: 15, restSeconds: 45),
          WorkoutExercise(exerciseId: 'single_leg_glute_bridge', sets: 3, reps: 8, restSeconds: 45),
        ],
      ),
      Workout(
        id: coreDayId,
        name: 'Core & Conditioning',
        exercises: [
          WorkoutExercise(exerciseId: 'plank', sets: 3, holdSeconds: 40, restSeconds: 45),
          WorkoutExercise(exerciseId: 'side_plank', sets: 3, holdSeconds: 25, restSeconds: 30),
          WorkoutExercise(exerciseId: 'hollow_body_hold', sets: 3, holdSeconds: 20, restSeconds: 45),
          WorkoutExercise(exerciseId: 'russian_twist', sets: 3, reps: 20, restSeconds: 45),
          WorkoutExercise(exerciseId: 'hanging_knee_raise', sets: 3, reps: 10, restSeconds: 60),
        ],
      ),
    ];

/// Monday/Wednesday/Friday/Saturday training, Tuesday/Thursday/Sunday rest.
const Map<DayOfWeek, String?> starterScheduleAssignments = {
  DayOfWeek.monday: pushDayId,
  DayOfWeek.tuesday: null,
  DayOfWeek.wednesday: pullDayId,
  DayOfWeek.thursday: null,
  DayOfWeek.friday: legsDayId,
  DayOfWeek.saturday: coreDayId,
  DayOfWeek.sunday: null,
};
