import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_project/theme/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      textTheme: GoogleFonts.comfortaaTextTheme(),
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    );
  }
}
