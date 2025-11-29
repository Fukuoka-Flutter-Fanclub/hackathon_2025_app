import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_2025_app/core/services/auth_service.dart';
import 'package:hackathon_2025_app/features/home/data/repositories/koemyaku_repository.dart';
import 'package:hackathon_2025_app/features/map/data/models/koemyaku/koemyaku_data.dart';

/// Koemyaku一覧をストリームで監視するProvider
final koemyakuListStreamProvider =
    StreamProvider<List<KoemyakuData>>((ref) {
  // authServiceから直接userIdを取得（Streamをwatchしない）
  final authService = ref.read(authServiceProvider);
  final userId = authService.userId;

  if (userId == null) {
    return Stream.value([]);
  }

  final repository = ref.read(koemyakuRepositoryProvider);
  return repository.watchKoemyakuList(userId);
});

/// Koemyaku削除用のProvider
final deleteKoemyakuProvider =
    FutureProvider.family.autoDispose<void, String>((ref, id) async {
  final repository = ref.read(koemyakuRepositoryProvider);
  await repository.deleteKoemyaku(id);
});
