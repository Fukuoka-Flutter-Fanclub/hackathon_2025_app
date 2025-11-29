import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'marker_data.freezed.dart';
part 'marker_data.g.dart';

@freezed
abstract class MarkerData with _$MarkerData {
  const factory MarkerData({
    required String id,
    required double latitude,
    required double longitude,
    @Default(10.0) double radius,
    String? voicePath,
    @Default([]) List<double> amplitudes,
    DateTime? createdAt,
  }) = _MarkerData;

  const MarkerData._();

  factory MarkerData.fromJson(Map<String, dynamic> json) =>
      _$MarkerDataFromJson(json);

  /// LatLngを取得するヘルパーメソッド
  LatLng get latLng => LatLng(latitude, longitude);

  /// LatLngからMarkerDataを作成するファクトリ
  factory MarkerData.fromLatLng({
    required String id,
    required LatLng latLng,
    double radius = 10.0,
    String? voicePath,
    List<double> amplitudes = const [],
  }) {
    return MarkerData(
      id: id,
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      radius: radius,
      voicePath: voicePath,
      amplitudes: amplitudes,
      createdAt: DateTime.now(),
    );
  }
}
