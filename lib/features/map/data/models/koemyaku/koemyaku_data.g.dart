// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'koemyaku_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KoemyakuData _$KoemyakuDataFromJson(Map<String, dynamic> json) =>
    _KoemyakuData(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      message: json['message'] as String? ?? '',
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      updatedAt: const NullableTimestampConverter().fromJson(
        json['updatedAt'] as Timestamp?,
      ),
      markers:
          (json['markers'] as List<dynamic>?)
              ?.map((e) => MarkerData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$KoemyakuDataToJson(
  _KoemyakuData instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'message': instance.message,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const NullableTimestampConverter().toJson(instance.updatedAt),
  'markers': instance.markers,
};
