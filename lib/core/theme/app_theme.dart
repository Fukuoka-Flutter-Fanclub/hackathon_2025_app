import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hackathon_2025_app/core/theme/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_colors.dart';

// SharedPreferencesのキー
const String _themePreferenceKey = 'theme_mode';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themePreferenceKey);
    if (themeString != null) {
      state = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeString,
        orElse: () => ThemeMode.light,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, mode.toString());
    state = mode;
  }

  Future<void> toggleThemeMode() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, newMode.toString());
    state = newMode;
  }
}

// StateProviderをStateNotifierProviderに変更
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});

final themeProvider = Provider<ThemeData>((ref) {
  final textTheme = AppTextStyles.createTextTheme();
  return _createThemeData(textTheme, isLight: true);
});

final darkThemeProvider = Provider<ThemeData>((ref) {
  final textTheme = AppTextStyles.createTextTheme(isDark: true);
  return _createThemeData(textTheme, isLight: false);
});

ThemeData _createThemeData(TextTheme textTheme, {required bool isLight}) {
  final colorScheme = isLight ? _lightColorScheme : _darkColorScheme;

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'NotoSansJP',
    brightness: isLight ? Brightness.light : Brightness.dark,
    scaffoldBackgroundColor: isLight
        ? const Color(0xFFF0FFFE)
        : const Color(0xFF0D1B1A), // ターコイズ寄りの背景色
    textTheme: textTheme,
    colorScheme: colorScheme,
    elevatedButtonTheme: _createElevatedButtonTheme(textTheme, colorScheme),
    inputDecorationTheme: _createInputDecorationTheme(textTheme, colorScheme),
  );
}

ColorScheme get _lightColorScheme => ColorScheme.light(
  primary: MyColors.primaryMain.color, // ライトシーグリーン
  onPrimary: MyColors.white.color,
  secondary: MyColors.secondaryMain.color, // 明るいターコイズ
  surface: MyColors.white.color,
  surfaceVariant: MyColors.gray100.color, // surfaceVariantを追加
  error: MyColors.red.color,
  onSurface: MyColors.black.color,
  // RefreshIndicator用の追加設定
  surfaceContainerHighest: MyColors.gray300.color,
);

ColorScheme get _darkColorScheme => ColorScheme.dark(
  primary: MyColors.turquoiseBright.color, // ダークモードでは明るいターコイズ
  onPrimary: MyColors.black900.color,
  secondary: MyColors.turquoiseMedium.color, // ダークターコイズ
  surface: MyColors.black900.color,
  surfaceVariant: MyColors.black700.color, // surfaceVariantを追加
  error: MyColors.red.color,
  onSurface: MyColors.white.color,
  // RefreshIndicator用の追加設定
  surfaceContainerHighest: MyColors.black600.color,
);

ElevatedButtonThemeData _createElevatedButtonTheme(
  TextTheme textTheme,
  ColorScheme colorScheme,
) {
  return ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(colorScheme.primary),
      foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
      minimumSize: WidgetStateProperty.all(Size(double.infinity, 48.h)),
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      textStyle: WidgetStateProperty.all(
        textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
  );
}

InputDecorationTheme _createInputDecorationTheme(
  TextTheme textTheme,
  ColorScheme colorScheme,
) {
  return InputDecorationTheme(
    labelStyle: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
    hintStyle: textTheme.bodyLarge?.copyWith(
      color: colorScheme.onSurface.withValues(alpha: 0.6),
    ),
    filled: true,
    fillColor: colorScheme.surface,
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.primary, width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.error),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorScheme.error, width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: colorScheme.onSurface.withValues(alpha: 0.2),
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
    floatingLabelStyle: textTheme.bodyLarge?.copyWith(
      color: colorScheme.primary,
    ),
  );
}
