import 'package:flutter/material.dart';

import '../services/exercise_repository.dart';
import '../services/schedule_repository.dart';
import '../services/workout_repository.dart';
import 'library_screen.dart';
import 'schedule_screen.dart';
import 'today_screen.dart';
import 'workouts_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final _exerciseRepository = ExerciseRepository();
  final _workoutRepository = WorkoutRepository();
  final _scheduleRepository = ScheduleRepository();

  int _tabIndex = 0;
  bool _loading = true;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadFailed = false;
    });
    try {
      await Future.wait([
        _exerciseRepository.load(),
        _workoutRepository.load(),
        _scheduleRepository.load(),
      ]);
      setState(() => _loading = false);
    } catch (_) {
      setState(() {
        _loading = false;
        _loadFailed = true;
      });
    }
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_loadFailed) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not load app data.'),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final tabs = [
      TodayScreen(
        exerciseRepository: _exerciseRepository,
        workoutRepository: _workoutRepository,
        scheduleRepository: _scheduleRepository,
        onGoToSchedule: () => setState(() => _tabIndex = 3),
      ),
      LibraryScreen(exerciseRepository: _exerciseRepository),
      WorkoutsScreen(
        exerciseRepository: _exerciseRepository,
        workoutRepository: _workoutRepository,
        scheduleRepository: _scheduleRepository,
        onChanged: _refresh,
      ),
      ScheduleScreen(
        workoutRepository: _workoutRepository,
        scheduleRepository: _scheduleRepository,
        onChanged: _refresh,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _tabIndex, children: tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (index) => setState(() => _tabIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
        ],
      ),
    );
  }
}
