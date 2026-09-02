import 'package:flutter/material.dart';

import '../../core/widgets/custom_app_bar.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "Start Session"),
        body: Center(child: Text('session')));
  }
}
