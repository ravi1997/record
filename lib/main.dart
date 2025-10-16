import 'package:flutter/material.dart';
import 'package:record/pages/login_page.dart';
import 'package:record/pages/home_page.dart';
import 'package:record/pages/entry_page.dart';
import 'package:record/pages/search_page.dart';
import 'package:record/pages/profile_page.dart';
import 'package:record/pages/settings_page.dart';
import 'package:record/pages/dashboard_page.dart';
import 'package:record/services/theme_service.dart';
import 'constants/app_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService();
    final theme = themeService.getCurrentTheme();
    final themeMode = themeService.getCurrentThemeMode();

    // Define routes as a separate variable to ensure they're not null
    final routes = <String, WidgetBuilder>{
      AppConstants.loginRoute: (context) => const LoginPage(),
      AppConstants.homeRoute: (context) => const HomePage(),
      AppConstants.entryRoute: (context) => const EntryPage(),
      AppConstants.searchRoute: (context) => const SearchPage(),
      AppConstants.profileRoute: (context) => const ProfilePage(),
      AppConstants.settingsRoute: (context) => const SettingsPage(),
      AppConstants.dashboardRoute: (context) => const DashboardPage(),
    };

    return MaterialApp(
      title: AppConstants.appName,
      theme: theme,
      darkTheme: ThemeService.getThemeById(AppConstants.darkBlueThemeId)
          .themeData, // Use proper dark theme
      themeMode: themeMode,
      initialRoute: AppConstants.loginRoute,
      routes: routes,
      onGenerateRoute: (RouteSettings settings) {
        // Handle any route that isn't defined in the routes map
        return MaterialPageRoute(
          builder: (context) => const LoginPage(), // Default to login page
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
