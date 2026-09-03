import 'package:flutter/material.dart';

import '../models/exercise.dart';
import 'category_filter_bar.dart';
import 'exercise_card.dart';

/// Shared search + category-filter + list UI, embedded by both the
/// Library screen and the exercise picker used from the workout builder.
class ExerciseBrowser extends StatefulWidget {
  final List<Exercise> exercises;
  final ValueChanged<Exercise> onTap;

  const ExerciseBrowser({
    super.key,
    required this.exercises,
    required this.onTap,
  });

  @override
  State<ExerciseBrowser> createState() => _ExerciseBrowserState();
}

class _ExerciseBrowserState extends State<ExerciseBrowser> {
  ExerciseCategory? _category;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.exercises.where((e) {
      final matchesCategory = _category == null || e.category == _category;
      final matchesQuery =
          _query.isEmpty || e.name.toLowerCase().contains(_query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search exercises',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              isDense: true,
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        const SizedBox(height: 8),
        CategoryFilterBar(
          selected: _category,
          onSelected: (category) => setState(() => _category = category),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('No exercises match.'))
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final exercise = filtered[index];
                    return ExerciseCard(
                      exercise: exercise,
                      onTap: () => widget.onTap(exercise),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
