import 'package:flutter/material.dart';

import 'screens/root_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const CalisthenicsPlannerApp());
}

class CalisthenicsPlannerApp extends StatelessWidget {
  const CalisthenicsPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calisthenics Planner',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          primary: AppColors.charcoal,
          secondary: AppColors.accent,
        ),
        scaffoldBackgroundColor: AppColors.surface,
      ),
      home: const RootScreen(),
    );
  }
}
