import 'package:flutter_test/flutter_test.dart';
import 'package:record/main.dart';
import 'package:record/pages/login_page.dart';

void main() {
  testWidgets('App starts at LoginPage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the LoginPage is displayed.
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
