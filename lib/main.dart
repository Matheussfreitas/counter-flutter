import 'package:contador_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador Moderno',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, // Cor nova
          brightness: Brightness.dark, // Modo escuro
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}