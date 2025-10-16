import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracking_app/core/theme/app_colors.dart';


 class AppTheme {
  static ThemeData getTheme(ColorScheme colors) {
    return ThemeData(
      colorScheme: colors,

       scaffoldBackgroundColor: AppColors.white,
        appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.white,
        titleSpacing: 0,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.black,size: 30),
        titleTextStyle: GoogleFonts.roboto(
          color: AppColors.black,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(


          backgroundColor: AppColors.pink[50],
          foregroundColor: AppColors.white,
          textStyle: GoogleFonts.roboto(
           // fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: AppColors.black[55]?? Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: AppColors.black[55]?? Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: AppColors.black[60]?? Colors.grey, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: AppColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.red, width: 2.0),
        ),
        labelStyle: GoogleFonts.roboto(color: AppColors.black, fontSize: 16),
        hintStyle: GoogleFonts.roboto(color: AppColors.black[55], fontSize: 14),
        contentPadding:const  EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      textTheme: TextTheme(bodyLarge: GoogleFonts.roboto(fontSize:18,fontWeight:FontWeight.w500,color: AppColors.black)

      , bodyMedium: GoogleFonts.roboto(fontSize:16,fontWeight:FontWeight.w400,color: AppColors.black[55]),
      bodySmall: GoogleFonts.roboto(fontSize:14,fontWeight:FontWeight.w400,color: AppColors.pink),
    ));
  }

  static ThemeData lightTheme = getTheme(
    const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.pink,
      onPrimary: AppColors.white,
      secondary: AppColors.black,
      onSecondary: AppColors.white, 
      error: AppColors.red, 
      onError: AppColors.white, 
      surface: AppColors.white,
      onSurface: AppColors.black)

  );
}
