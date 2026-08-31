import 'package:flutter/material.dart';

class GoalsScreen extends StatelessWidget {
  static const String routeName = 'goals';
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("no goals yet")),
    );
  }
}
