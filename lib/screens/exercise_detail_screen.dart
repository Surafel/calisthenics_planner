import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/exercise.dart';
import '../theme/app_colors.dart';
import '../widgets/youtube_embed.dart';

String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppColors.colorFor(exercise.category);
    final videoId = exercise.videoId;

    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (videoId != null) ...[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubeEmbed(videoId: videoId),
            ),
            if (exercise.videoChannel != null) ...[
              const SizedBox(height: 4),
              Text(
                'Video by ${exercise.videoChannel}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.muted),
              ),
            ],
            const SizedBox(height: 20),
          ],
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: Text(_capitalize(exercise.category.name)),
                backgroundColor: categoryColor.withValues(alpha: 0.15),
              ),
              Chip(label: Text(_capitalize(exercise.difficulty.name))),
              Chip(
                label: Text(
                  exercise.measurementType == MeasurementType.hold
                      ? 'Timed hold'
                      : 'Reps',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Muscle groups', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final muscle in exercise.muscleGroups)
                Chip(label: Text(_capitalize(muscle))),
            ],
          ),
          const SizedBox(height: 20),
          Text('Equipment', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in exercise.equipment)
                Chip(label: Text(_capitalize(item))),
            ],
          ),
          const SizedBox(height: 20),
          Text('How to', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(exercise.description, style: Theme.of(context).textTheme.bodyLarge),
          if (videoId == null) ...[
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => _openVideoSearch(context, exercise),
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('Watch video'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openVideoSearch(BuildContext context, Exercise exercise) async {
    final messenger = ScaffoldMessenger.of(context);
    final opened = await launchUrl(
      exercise.videoSearchUrl,
      mode: LaunchMode.externalApplication,
    );
    if (!opened) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open the video link.')),
      );
    }
  }
}
