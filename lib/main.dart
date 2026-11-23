import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://exmgtlgxmvfalukmgjjv.supabase.co',
    anonKey: 'sb_publishable_yzZcv21UnmsSOrHvhD1cMg_NF8gIu-6',
  );

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
