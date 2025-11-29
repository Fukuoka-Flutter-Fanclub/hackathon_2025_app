import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_2025_app/core/constants/database_constants.dart';
import 'package:hackathon_2025_app/features/map/data/models/koemyaku/koemyaku_data.dart';
import 'package:hackathon_2025_app/features/map/data/models/marker/marker_data.dart';
import 'package:uuid/uuid.dart';

/// KoemyakuServiceのProvider
final koemyakuServiceProvider = Provider<KoemyakuService>((ref) {
  return KoemyakuService();
});

class KoemyakuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// コレクション参照
  CollectionReference<Map<String, dynamic>> get _koemyakuCollection =>
      _firestore.collection(Collections.koemyaku);

  /// 音声ファイルをFirebase Storageにアップロード
  Future<String?> _uploadVoiceFile(String localPath, String markerId) async {
    try {
      final file = File(localPath);
      if (!await file.exists()) {
        debugPrint('Voice file does not exist: $localPath');
        return null;
      }

      final ref = _storage.ref().child(StoragePaths.voiceFile(markerId));
      final uploadTask = ref.putFile(file);

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      debugPrint('Voice uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('Failed to upload voice: $e');
      return null;
    }
  }

  /// マーカーの音声ファイルをアップロードし、URLを更新したマーカーリストを返す
  Future<List<MarkerData>> _uploadMarkerVoices(List<MarkerData> markers) async {
    final updatedMarkers = <MarkerData>[];

    for (final marker in markers) {
      if (marker.voicePath != null && marker.voicePath!.isNotEmpty) {
        // ローカルパスの場合のみアップロード
        if (!marker.voicePath!.startsWith('http')) {
          final downloadUrl = await _uploadVoiceFile(marker.voicePath!, marker.id);
          updatedMarkers.add(marker.copyWith(voicePath: downloadUrl));
        } else {
          updatedMarkers.add(marker);
        }
      } else {
        updatedMarkers.add(marker);
      }
    }

    return updatedMarkers;
  }

  /// Koemyakuを保存
  Future<KoemyakuData> saveKoemyaku({
    required String userId,
    required String title,
    required String message,
    required List<MarkerData> markers,
  }) async {
    final id = const Uuid().v4();

    // 音声ファイルをアップロード
    final uploadedMarkers = await _uploadMarkerVoices(markers);

    final koemyaku = KoemyakuData.create(
      id: id,
      userId: userId,
      title: title,
      message: message,
      markers: uploadedMarkers,
    );

    // Firestoreに保存
    await _koemyakuCollection.doc(id).set(koemyaku.toFirestore());

    debugPrint('Koemyaku saved: $id');
    return koemyaku;
  }

  /// ユーザーのKoemyaku一覧を取得
  Future<List<KoemyakuData>> getKoemyakuList(String userId) async {
    final snapshot = await _koemyakuCollection
        .where(Fields.userId, isEqualTo: userId)
        .orderBy(Fields.createdAt, descending: true)
        .get();

    return snapshot.docs
        .map((doc) => KoemyakuData.fromFirestore(doc))
        .toList();
  }

  /// Koemyakuを更新
  Future<KoemyakuData> updateKoemyaku({
    required String id,
    required String userId,
    required String title,
    required String message,
    required List<MarkerData> markers,
    required DateTime createdAt,
  }) async {
    // 音声ファイルをアップロード
    final uploadedMarkers = await _uploadMarkerVoices(markers);

    final koemyaku = KoemyakuData(
      id: id,
      userId: userId,
      title: title,
      message: message,
      markers: uploadedMarkers,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );

    // Firestoreに更新
    await _koemyakuCollection.doc(id).update(koemyaku.toFirestore());

    debugPrint('Koemyaku updated: $id');
    return koemyaku;
  }

  /// Koemyakuを削除
  Future<void> deleteKoemyaku(String id) async {
    await _koemyakuCollection.doc(id).delete();
    debugPrint('Koemyaku deleted: $id');
  }
}
