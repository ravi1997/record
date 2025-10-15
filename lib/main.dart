import 'package:flutter/material.dart';
import 'package:record/pages/login_page.dart';
import 'package:record/pages/home_page.dart';
import 'package:record/pages/entry_page.dart';
import 'package:record/pages/search_page.dart';
import 'package:record/pages/profile_page.dart';
import 'package:record/pages/settings_page.dart';
import 'package:record/pages/dashboard_page.dart';
import 'package:record/services/theme_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThemeData>(
      future: ThemeService().getCurrentTheme(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError ||
            snapshot.data == null) {
          return MaterialApp(
            title: 'Medical Record System',
            home: const Scaffold(
                body: Center(child: CircularProgressIndicator())),
            debugShowCheckedModeBanner: false,
          );
        }

        final theme = snapshot.data ?? ThemeData.light();

        // Define routes as a separate variable to ensure they're not null
        final routes = <String, WidgetBuilder>{
          '/': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/entry': (context) => const EntryPage(),
          '/search': (context) => const SearchPage(),
          '/profile': (context) => const ProfilePage(),
          '/settings': (context) => const SettingsPage(),
          '/dashboard': (context) => const DashboardPage(),
        };

        return MaterialApp(
          title: 'Medical Record System',
          theme: theme,
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system, // Follow system theme
          initialRoute: '/',
          routes: routes,
          onGenerateRoute: (RouteSettings settings) {
            // Handle any route that isn't defined in the routes map
            return MaterialPageRoute(
              builder: (context) => const LoginPage(), // Default to login page
            );
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
