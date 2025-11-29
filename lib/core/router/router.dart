import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/map/presentation/pages/map_edit_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: MapEditPage.routeName,
    routes: [
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
