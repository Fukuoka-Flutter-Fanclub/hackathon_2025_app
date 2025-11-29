// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marker_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MarkerData _$MarkerDataFromJson(Map<String, dynamic> json) => _MarkerData(
  id: json['id'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  radius: (json['radius'] as num?)?.toDouble() ?? 10.0,
  voicePath: json['voicePath'] as String?,
  amplitudes:
      (json['amplitudes'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      const [],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$MarkerDataToJson(_MarkerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radius': instance.radius,
      'voicePath': instance.voicePath,
      'amplitudes': instance.amplitudes,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
