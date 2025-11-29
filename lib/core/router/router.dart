import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon_2025_app/core/services/auth_service.dart';

import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/map/presentation/pages/map_edit_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: WelcomePage.routeName,
    redirect: (context, state) {
      final user = authState.whenData((user) => user).value;
      final isLoggedIn = user != null;
      final isGoingToWelcome = state.matchedLocation == WelcomePage.routeName;

      // ログイン済みでWelcome画面に行こうとしている場合はMapEditへ
      if (isLoggedIn && isGoingToWelcome) {
        return MapEditPage.routeName;
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
          return MaterialPage(key: state.pageKey, child: const MapEditPage());
        },
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(body: Center(child: Text(state.error.toString()))),
    ),
  );
});
