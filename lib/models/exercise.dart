enum ExerciseCategory { push, pull, legs, core, skills }

enum Difficulty { beginner, intermediate, advanced }

/// Whether a workout entry for this exercise is tracked by rep count
/// or by hold duration (e.g. planche, L-sit, plank).
enum MeasurementType { reps, hold }

class Exercise {
  final String id;
  final String name;
  final ExerciseCategory category;
  final List<String> muscleGroups;
  final Difficulty difficulty;
  final MeasurementType measurementType;
  final List<String> equipment;
  final String description;
  final String? videoId;
  final String? videoChannel;

  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.muscleGroups,
    required this.difficulty,
    required this.measurementType,
    required this.equipment,
    required this.description,
    this.videoId,
    this.videoChannel,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json['id'] as String,
        name: json['name'] as String,
        category: ExerciseCategory.values.byName(json['category'] as String),
        muscleGroups: (json['muscleGroups'] as List).cast<String>(),
        difficulty: Difficulty.values.byName(json['difficulty'] as String),
        measurementType:
            MeasurementType.values.byName(json['measurementType'] as String),
        equipment: (json['equipment'] as List).cast<String>(),
        description: json['description'] as String,
        videoId: json['videoId'] as String?,
        videoChannel: json['videoChannel'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category.name,
        'muscleGroups': muscleGroups,
        'difficulty': difficulty.name,
        'measurementType': measurementType.name,
        'equipment': equipment,
        'description': description,
        if (videoId != null) 'videoId': videoId,
        if (videoChannel != null) 'videoChannel': videoChannel,
      };

  /// A YouTube search for this exercise, used as a fallback when no curated
  /// video is available for it.
  Uri get videoSearchUrl => Uri.https(
        'www.youtube.com',
        '/results',
        {'search_query': '$name calisthenics tutorial'},
      );
}
