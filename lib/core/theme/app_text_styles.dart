import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle heading1(Color color) => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: color,
  );
  static TextStyle heading2(Color color) => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: color,
  );
  static TextStyle body(Color color) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
  );
}
