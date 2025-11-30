import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

// 追加：多言語対応のためのインポート
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hackathon_2025_app/core/constants/env_constants.dart';
import 'package:hackathon_2025_app/core/router/router.dart';
import 'package:hackathon_2025_app/core/theme/app_theme.dart';
import 'package:hackathon_2025_app/firebase_options.dart';
import 'package:hackathon_2025_app/i18n/strings.g.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await EnvConstants().init();

      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Crashlytics is not supported on Web
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

      // Firebase Analytics
      final analytics = FirebaseAnalytics.instance;
      await analytics.setAnalyticsCollectionEnabled(true);

      // デバイスのロケールを使用して言語を設定
      await LocaleSettings.useDeviceLocale();

      // アプリの起動
      runApp(ProviderScope(child: TranslationProvider(child: const MyApp())));
    },
    (error, stack) {
      // Firebaseが初期化されている場合のみCrashlyticsに報告（Web以外）
      if (!kIsWeb && Firebase.apps.isNotEmpty) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      } else {
        // Firebase初期化前またはWebのエラーはコンソールに出力
        debugPrint('Error: $error');
        debugPrint('$stack');
      }
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) {
        final router = ref.watch(routerProvider);
        final themeMode = ref.watch(themeModeProvider);
        final lightTheme = ref.watch(themeProvider);
        final darkTheme = ref.watch(darkThemeProvider);
        return MaterialApp.router(
          title: 'KoeMyaku',
          themeMode: themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          locale: TranslationProvider.of(context).flutterLocale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocale.values.map((e) => e.flutterLocale),
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
