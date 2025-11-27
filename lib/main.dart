import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/pages/login_page.dart';
import 'package:record/pages/home_page.dart';
import 'package:record/pages/entry_page.dart';
import 'package:record/pages/search_page.dart';
import 'package:record/pages/profile_page.dart';
import 'package:record/pages/settings_page.dart';
import 'package:record/services/theme_provider.dart';
import 'package:record/services/theme_service.dart';
import 'constants/app_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeService = ThemeService();

    final routes = <String, WidgetBuilder>{
      AppConstants.loginRoute: (context) => const LoginPage(),
      AppConstants.homeRoute: (context) => const HomePage(),
      AppConstants.entryRoute: (context) => const EntryPage(),
      AppConstants.searchRoute: (context) => const SearchPage(),
      AppConstants.profileRoute: (context) => const ProfilePage(),
      AppConstants.settingsRoute: (context) => const SettingsPage(),
    };

    return MaterialApp(
      title: AppConstants.appName,
      theme: themeService.getCurrentTheme(),
      darkTheme:
          ThemeService.getThemeById(AppConstants.darkBlueThemeId).themeData,
      themeMode: themeProvider.themeMode,
      initialRoute: AppConstants.loginRoute,
      routes: routes,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
