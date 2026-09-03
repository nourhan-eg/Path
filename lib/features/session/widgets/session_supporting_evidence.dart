import 'package:flutter/material.dart';

/// Section widget containing Upload Photo and Upload PDF evidence card buttons.
class SessionSupportingEvidence extends StatelessWidget {
  final Color primaryColor;
  final Color cardBgColor;
  final Color textPrimary;
  final bool isDark;
  final VoidCallback onUploadPhoto;
  final VoidCallback onUploadPdf;

  const SessionSupportingEvidence({
    super.key,
    required this.primaryColor,
    required this.cardBgColor,
    required this.textPrimary,
    required this.isDark,
    required this.onUploadPhoto,
    required this.onUploadPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supporting Evidence',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Upload Photo Card
            Expanded(
              child: GestureDetector(
                onTap: onUploadPhoto,
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF3A3C35)
                          : const Color(0xFFE8E6DF),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: primaryColor,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upload Photo',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Upload PDF Card
            Expanded(
              child: GestureDetector(
                onTap: onUploadPdf,
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF3A3C35)
                          : const Color(0xFFE8E6DF),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.picture_as_pdf_outlined,
                        color: primaryColor,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upload PDF',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
