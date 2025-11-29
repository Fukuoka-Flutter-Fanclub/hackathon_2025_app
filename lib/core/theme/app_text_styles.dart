import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  // Static getters for commonly used text styles
  static TextStyle get h1Bold => _createTextStyle(
        fontSize: 31,
        height: 56 / 31,
        letterSpacing: 0.33,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      );

  static TextStyle get h2Bold => _createTextStyle(
        fontSize: 27,
        height: 48 / 27,
        letterSpacing: 0.27,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      );

  static TextStyle get h3Bold => _createTextStyle(
        fontSize: 23,
        height: 40 / 23,
        letterSpacing: 0.21,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      );

  static TextStyle get titleLarge => _createTextStyle(
        fontSize: 21,
        height: 36 / 21,
        letterSpacing: 0.18,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      );

  static TextStyle get titleMedium => _createTextStyle(
        fontSize: 17,
        height: 24 / 17,
        letterSpacing: 0.12,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      );

  static TextStyle get bodyLarge => _createTextStyle(
        fontSize: 15,
        height: 24 / 15,
        letterSpacing: 0.09,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      );

  static TextStyle get bodyMedium => _createTextStyle(
        fontSize: 13,
        height: 20 / 13,
        letterSpacing: 0.06,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      );

  static TextStyle get bodySmall => _createTextStyle(
        fontSize: 11,
        height: 16 / 11,
        letterSpacing: 0.06,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      );

  static TextStyle get buttonLarge => _createTextStyle(
        fontSize: 17,
        height: 24 / 17,
        letterSpacing: 0.12,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      );

  static TextStyle get buttonMedium => _createTextStyle(
        fontSize: 15,
        height: 20 / 15,
        letterSpacing: 0.09,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      );

  static TextStyle get caption => _createTextStyle(
        fontSize: 11,
        height: 16 / 11,
        letterSpacing: 0.06,
        fontWeight: FontWeight.w400,
        color: Colors.black54,
      );
  static TextTheme createTextTheme({bool isDark = false}) {
    final baseColor = isDark ? Colors.white : Colors.black;

    return TextTheme(
      // headline styles
      headlineLarge: _createTextStyle(
        fontSize: 31,
        height: 56 / 31,
        letterSpacing: 0.33,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      headlineMedium: _createTextStyle(
        fontSize: 27,
        height: 48 / 27,
        letterSpacing: 0.27,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      headlineSmall: _createTextStyle(
        fontSize: 23,
        height: 40 / 23,
        letterSpacing: 0.21,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),

      // title styles
      titleLarge: _createTextStyle(
        fontSize: 21,
        height: 36 / 21,
        letterSpacing: 0.18,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      titleMedium: _createTextStyle(
        fontSize: 17,
        height: 24 / 17,
        letterSpacing: 0.12,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      titleSmall: _createTextStyle(
        fontSize: 15,
        height: 20 / 15,
        letterSpacing: 0.09,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),

      // label styles
      labelLarge: _createTextStyle(
        fontSize: 17,
        height: 28 / 17,
        letterSpacing: 0.12,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      labelMedium: _createTextStyle(
        fontSize: 15,
        height: 24 / 15,
        letterSpacing: 0.09,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      labelSmall: _createTextStyle(
        fontSize: 13,
        height: 20 / 13,
        letterSpacing: 0.06,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),

      // body styles
      bodyLarge: _createTextStyle(
        fontSize: 15,
        height: 24 / 15,
        letterSpacing: 0.09,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),
      bodyMedium: _createTextStyle(
        fontSize: 13,
        height: 20 / 13,
        letterSpacing: 0.06,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      bodySmall: _createTextStyle(
        fontSize: 11,
        height: 16 / 11,
        letterSpacing: 0.06,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),
    );
  }

  static TextStyle _createTextStyle({
    required double fontSize,
    required double height,
    required double letterSpacing,
    required FontWeight fontWeight,
    required Color color,
  }) {
    return TextStyle(
      fontSize: fontSize.sp,
      height: height,
      letterSpacing: letterSpacing.sp,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
