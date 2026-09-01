import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../models/goal_model.dart';

class BuildWithAiScreen extends StatelessWidget {
  static const String routeName = '/goals ai';

  const BuildWithAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goal = ModalRoute.of(context)?.settings.arguments as GoalModel?;
    return Scaffold(
      appBar: CustomAppBar(title: ""),
    );
  }
}
