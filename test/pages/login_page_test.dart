import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:record/pages/login_page.dart';
import 'package:record/services/theme_provider.dart';
import 'package:record/services/user_provider.dart';
import 'package:record/services/user_service.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([UserProvider])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('LoginPage login test', (WidgetTester tester) async {
    final mockUserProvider = MockUserProvider();

    when(mockUserProvider.user).thenReturn(User(
      id: 1,
      name: 'John Doe',
      email: 'john.doe@example.com',
      employeeId: 'EMP001',
      role: 'Administrator',
    ));
    when(mockUserProvider.loadUser()).thenAnswer((_) async => {});

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        ],
        child: const MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Verify that the LoginPage is displayed.
    expect(find.byType(LoginPage), findsOneWidget);

    // Enter username and password.
    await tester.enterText(find.byType(TextFormField).at(0), 'testuser');
    await tester.enterText(find.byType(TextFormField).at(1), 'password');

    // Tap the login button.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    // Verify that the loadUser method is called.
    verify(mockUserProvider.loadUser()).called(1);
  });
}