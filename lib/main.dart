import 'package:flutter/material.dart';
import 'package:record/pages/login_page.dart';
import 'package:record/pages/home_page.dart';
import 'package:record/pages/entry_page.dart';
import 'package:record/pages/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Record System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/entry': (context) => const EntryPage(),
        '/search': (context) => const SearchPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
