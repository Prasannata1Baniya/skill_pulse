import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page.dart';

void main() {
  runApp(const SkillPulseApp());
}

class SkillPulseApp extends StatelessWidget {
  const SkillPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skill Pulse',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}