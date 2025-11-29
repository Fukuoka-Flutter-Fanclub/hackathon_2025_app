import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AuthServiceのProvider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// 現在の認証状態を監視するProvider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// 現在のユーザーを取得するProvider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).whenData((user) => user).value;
});

/// ログイン済みかどうかを取得するProvider
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 現在のユーザーを取得
  User? get currentUser => _auth.currentUser;

  /// 認証状態の変更を監視
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// ログイン済みかどうか
  bool get isLoggedIn => currentUser != null;

  /// 匿名認証でサインイン
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      debugPrint('Anonymous sign in successful: ${userCredential.user?.uid}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Anonymous sign in failed: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Anonymous sign in failed: $e');
      rethrow;
    }
  }

  /// サインアウト
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      debugPrint('Sign out successful');
    } catch (e) {
      debugPrint('Sign out failed: $e');
      rethrow;
    }
  }

  /// ユーザーIDを取得（ログイン済みの場合のみ）
  String? get userId => currentUser?.uid;
}
