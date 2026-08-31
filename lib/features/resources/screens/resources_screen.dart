import 'package:flutter/material.dart';
import '../../../core/widgets/custom_app_bar.dart';

class ResourcesScreen extends StatelessWidget {
  static const String routeName = '/resources';

  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "Resources"),
      body: Center(
        child: Text("Resources Tab"),
      ),
    );
  }
}
