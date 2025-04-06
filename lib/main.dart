import 'package:flutter/material.dart';
import 'package:fluttermusicapp/themes/app_theme.dart';

void main() {
  AppTheme.configureSystemUI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: AppTheme.lightTheme,
      // Rest of your app configuration
      home: const MyHomePage(title: 'Music App'),
    );
  }
}