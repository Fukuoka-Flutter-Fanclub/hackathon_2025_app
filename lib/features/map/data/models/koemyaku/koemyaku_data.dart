import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../marker/marker_data.dart';

part 'koemyaku_data.freezed.dart';
part 'koemyaku_data.g.dart';

/// Firestore の Timestamp を DateTime に変換するコンバーター
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

/// Firestore の Timestamp を DateTime? に変換するコンバーター (nullable)
class NullableTimestampConverter
    implements JsonConverter<DateTime?, Timestamp?> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;
}

@freezed
abstract class KoemyakuData with _$KoemyakuData {
  const factory KoemyakuData({
    required String id,
    required String userId,
    required String title,
    @Default('') String message,
    @TimestampConverter() required DateTime createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
    @Default([]) List<MarkerData> markers,
  }) = _KoemyakuData;

  const KoemyakuData._();

  factory KoemyakuData.fromJson(Map<String, dynamic> json) =>
      _$KoemyakuDataFromJson(json);

  /// Firestore ドキュメントから作成
  factory KoemyakuData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return KoemyakuData.fromJson({
      ...data,
      'id': doc.id,
    });
  }

  /// Firestore に保存する Map に変換
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'markers': markers.map((m) => m.toFirestoreMap()).toList(),
    };
  }

  /// 新規作成用ファクトリ
  factory KoemyakuData.create({
    required String id,
    required String userId,
    required String title,
    String message = '',
    List<MarkerData> markers = const [],
  }) {
    return KoemyakuData(
      id: id,
      userId: userId,
      title: title,
      message: message,
      createdAt: DateTime.now(),
      markers: markers,
    );
  }
}
