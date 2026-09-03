import 'package:flutter/material.dart';

/// Card widget representing the AI Check-in placeholder section.
class SessionAiCheckInCard extends StatelessWidget {
  final TextEditingController controller;
  final Color primaryColor;
  final Color cardBgColor;
  final Color inputBgColor;
  final Color textPrimary;
  final Color textSecondary;
  final bool isDark;

  const SessionAiCheckInCard({
    super.key,
    required this.controller,
    required this.primaryColor,
    required this.cardBgColor,
    required this.inputBgColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF3A3C35) : const Color(0xFFE8E6DF),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryColor.withAlpha(40),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: 16,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'AI Check-in',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'How did your work feel today?\nBriefly describe your focus.',
            style: TextStyle(
              fontSize: 13,
              color: textSecondary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: inputBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              maxLines: 3,
              style: TextStyle(fontSize: 13, color: textPrimary),
              decoration: InputDecoration(
                hintText: 'My mind was wandering a bit at first, but...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFF7A7E75)
                      : const Color(0xFFA5A9A0),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
