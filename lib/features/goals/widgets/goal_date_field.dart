import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

/// Renders the target date selector text field.
class GoalDateField extends StatelessWidget {
  final TextEditingController controller;
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const GoalDateField({
    super.key,
    required this.controller,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorScheme>()!;

    return Semantics(
      button: true,
      label: 'Target date selector',
      hint: selectedDate == null
          ? 'Double tap to pick a deadline date'
          : 'Selected date ${controller.text}',
      child: TextFormField(
        readOnly: true,
        controller: controller,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          fillColor: colors.card,
          filled: true,
          hintText: 'mm/dd/yyyy',
          prefixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
          hintStyle: const TextStyle(
            color: Color(0xff444841),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
