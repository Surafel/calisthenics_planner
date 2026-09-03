import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:calisthenics_planner/main.dart';

void main() {
  testWidgets('App loads and shows the bottom navigation tabs',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const CalisthenicsPlannerApp());
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsWidgets);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Workouts'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
  });
}
