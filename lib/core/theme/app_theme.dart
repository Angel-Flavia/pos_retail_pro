import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'app_colors.dart'; 
 
class AppTheme { 
  AppTheme._(); 
 
  static ThemeData get light { 
    final base = GoogleFonts.interTextTheme(); 
    return ThemeData( 
      useMaterial3: true, 
      primaryColor: AppColors.primary, 
      scaffoldBackgroundColor: AppColors.background, 
      colorScheme: const ColorScheme.light( 
        primary: AppColors.primary, 
        secondary: AppColors.secondary, 
        surface: AppColors.surface, 
        error: AppColors.error, 
      ), 
      textTheme: base.copyWith( 
        headlineMedium: base.headlineMedium?.copyWith( 
          fontWeight: FontWeight.w700, 
          color: AppColors.textPrimary, 
        ), 
        bodyMedium: base.bodyMedium?.copyWith(color: AppColors.textSecondary), 
      ), 
      appBarTheme: AppBarTheme( 
        backgroundColor: AppColors.surface, 
        elevation: 0, 
        centerTitle: true, 
        iconTheme: const IconThemeData(color: AppColors.textPrimary), 
        titleTextStyle: GoogleFonts.inter( 
          color: AppColors.textPrimary, 
          fontSize: 18, 
          fontWeight: FontWeight.w600, 
        ), 
      ), 
      elevatedButtonTheme: ElevatedButtonThemeData( 
        style: ElevatedButton.styleFrom( 
          backgroundColor: AppColors.primary, 
          foregroundColor: Colors.white, 
          minimumSize: const Size(double.infinity, 54), 
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(12), 
          ), 
          textStyle: GoogleFonts.inter( 
            fontSize: 16, 
            fontWeight: FontWeight.w600, 
          ), 
          elevation: 0, 
        ), 
      ), 
      inputDecorationTheme: InputDecorationTheme( 
        filled: true, 
        fillColor: AppColors.surface, 
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), 
        border: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(12), 
          borderSide: const BorderSide(color: AppColors.border), 
        ), 
        enabledBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(12), 
          borderSide: const BorderSide(color: AppColors.border), 
        ), 
        focusedBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(12), 
          borderSide: const BorderSide(color: AppColors.primary, width: 2), 
        ), 
      ), 
    ); 
  } 
}