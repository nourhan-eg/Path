import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_app_bar.dart';

class BuildWithAiScreen extends StatelessWidget {
  static const String routeName = '/goals ai';
  const BuildWithAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ""),
    );
  }
}
