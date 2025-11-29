import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_2025_app/core/constants/database_constants.dart';
import 'package:hackathon_2025_app/features/map/data/models/koemyaku/koemyaku_data.dart';

/// KoemyakuRepositoryのProvider
final koemyakuRepositoryProvider = Provider<KoemyakuRepository>((ref) {
  return KoemyakuRepository();
});

/// Koemyakuデータのリポジトリ
class KoemyakuRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// コレクション参照
  CollectionReference<Map<String, dynamic>> get _koemyakuCollection =>
      _firestore.collection(Collections.koemyaku);

  /// ユーザーのKoemyaku一覧を取得
  Future<List<KoemyakuData>> getKoemyakuList(String userId) async {
    try {
      final snapshot = await _koemyakuCollection
          .where(Fields.userId, isEqualTo: userId)
          .orderBy(Fields.createdAt, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => KoemyakuData.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('Failed to get koemyaku list: $e');
      rethrow;
    }
  }

  /// Koemyaku一覧をストリームで取得（リアルタイム更新）
  Stream<List<KoemyakuData>> watchKoemyakuList(String userId) {
    return _koemyakuCollection
        .where(Fields.userId, isEqualTo: userId)
        .orderBy(Fields.createdAt, descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => KoemyakuData.fromFirestore(doc))
            .toList());
  }

  /// Koemyakuを削除
  Future<void> deleteKoemyaku(String id) async {
    try {
      await _koemyakuCollection.doc(id).delete();
      debugPrint('Koemyaku deleted: $id');
    } catch (e) {
      debugPrint('Failed to delete koemyaku: $e');
      rethrow;
    }
  }

  /// 単一のKoemyakuを取得
  Future<KoemyakuData?> getKoemyaku(String id) async {
    try {
      final doc = await _koemyakuCollection.doc(id).get();
      if (!doc.exists) return null;
      return KoemyakuData.fromFirestore(doc);
    } catch (e) {
      debugPrint('Failed to get koemyaku: $e');
      rethrow;
    }
  }
}
