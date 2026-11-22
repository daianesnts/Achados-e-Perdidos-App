import 'package:flutter/material.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(const AchadosPerdidosApp());
}

class AchadosPerdidosApp extends StatelessWidget {
  const AchadosPerdidosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achados e Perdidos UFS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), 
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}
