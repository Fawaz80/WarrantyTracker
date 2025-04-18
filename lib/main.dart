import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/storage_service.dart';
void main() {
  runApp(const WarrantyTrackerApp());
}

class WarrantyTrackerApp extends StatelessWidget {
  const WarrantyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warranty Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // This will follow system theme
      home:  LoginScreen(),
    );
  }
}