import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon_2025_app/core/services/auth_service.dart';
import 'package:hackathon_2025_app/features/finder/presentation/pages/finder_page.dart';
import 'package:hackathon_2025_app/features/map/data/models/koemyaku/koemyaku_data.dart';

import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/finder/presentation/pages/finder_web_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/map/presentation/pages/map_edit_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    // Webではブラウザの URL を使う（initialLocationを設定しない）
    // モバイルでは WelcomePage から開始
    initialLocation: kIsWeb ? null : WelcomePage.routeName,
    redirect: (context, state) {
      final user = authState.whenData((user) => user).value;
      final isLoggedIn = user != null;
      final path = state.uri.path;
      final isGoingToWelcome = path == WelcomePage.routeName;
      final isGoingToFinderWeb = path.startsWith(FinderWebPage.routeName);

      debugPrint('Router redirect - path: $path, isLoggedIn: $isLoggedIn, isGoingToFinderWeb: $isGoingToFinderWeb');

      // Web版のFinderページは認証不要
      if (isGoingToFinderWeb) {
        return null;
      }

      // ログイン済みでWelcome画面に行こうとしている場合はMapEditへ
      if (isLoggedIn && isGoingToWelcome) {
        return HomePage.routeName;
      }

      // 未ログインでWelcome以外に行こうとしている場合はWelcomeへ
      if (!isLoggedIn && !isGoingToWelcome) {
        return WelcomePage.routeName;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: WelcomePage.routeName,
        name: WelcomePage.name,
        pageBuilder: (context, state) {
          return MaterialPage(key: state.pageKey, child: const WelcomePage());
        },
      ),
      GoRoute(
        path: HomePage.routeName,
        name: HomePage.name,
        pageBuilder: (context, state) {
          return MaterialPage(key: state.pageKey, child: const HomePage());
        },
      ),
      GoRoute(
        path: MapPage.routeName,
        name: MapPage.name,
        pageBuilder: (context, state) {
          return MaterialPage(key: state.pageKey, child: const MapPage());
        },
      ),
      GoRoute(
        path: MapEditPage.routeName,
        name: MapEditPage.name,
        pageBuilder: (context, state) {
          final koemyaku = state.extra as KoemyakuData?;
          return MaterialPage(
            key: state.pageKey,
            child: MapEditPage(editingKoemyaku: koemyaku),
          );
        },
      ),
      GoRoute(
        path: FinderPage.routeName,
        name: FinderPage.name,
        pageBuilder: (context, state) {
          final koemyaku = state.extra as KoemyakuData;
          return MaterialPage(
            key: state.pageKey,
            child: FinderPage(koemyaku: koemyaku),
          );
        },
      ),
      // Web用 Finder ページ（URLパラメータでkoemyakuIdを受け取る）
      GoRoute(
        path: '${FinderWebPage.routeName}/:koemyakuId',
        name: FinderWebPage.name,
        pageBuilder: (context, state) {
          final koemyakuId = state.pathParameters['koemyakuId'] ?? '';
          return MaterialPage(
            key: state.pageKey,
            child: FinderWebPage(koemyakuId: koemyakuId),
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(body: Center(child: Text(state.error.toString()))),
    ),
  );
});
