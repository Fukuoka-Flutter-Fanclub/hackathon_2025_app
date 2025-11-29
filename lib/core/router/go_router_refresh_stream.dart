// import 'dart:async';
// import 'package:flutter/foundation.dart';

// class GoRouterRefreshStream extends ChangeNotifier {
//   GoRouterRefreshStream(Stream<User?> stream) {
//     notifyListeners();
//     _subscription = stream.listen((user) => notifyListeners());
//   }

//   late final StreamSubscription<User?> _subscription;

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }
