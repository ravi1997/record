import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:record/pages/home_page.dart';
import 'package:record/services/local_db_service.dart';
import 'package:record/services/theme_provider.dart';
import 'package:record/services/user_provider.dart';
import 'package:record/services/user_service.dart';

import 'home_page_test.mocks.dart';

@GenerateMocks([LocalDBService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('HomePage displays dashboard metrics', (WidgetTester tester) async {
    final mockLocalDBService = MockLocalDBService();

    when(mockLocalDBService.getPatientCount()).thenAnswer((_) async => 10);
    when(mockLocalDBService.getSyncedPatientCount()).thenAnswer((_) async => 5);
    when(mockLocalDBService.getFileCount()).thenAnswer((_) async => 20);
    when(mockLocalDBService.getSyncedFileCount()).thenAnswer((_) async => 10);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          Provider<LocalDBService>(create: (_) => mockLocalDBService),
        ],
        child: MaterialApp(
          home: HomePage(localDBService: mockLocalDBService),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Today\'s Entries'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);

    expect(find.text('Total Records'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);

    expect(find.text('Synced'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);

    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
  });
}
