import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

enum LocationPermissionStatus { granted, denied, permanentlyDenied, restricted }

/// LocationServiceのProvider
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

class LocationService {
  /// 位置情報の権限をチェック
  Future<LocationPermissionStatus> checkLocationPermission() async {
    try {
      final geoPermission = await Geolocator.checkPermission();

      switch (geoPermission) {
        case LocationPermission.always:
        case LocationPermission.whileInUse:
          return LocationPermissionStatus.granted;
        case LocationPermission.denied:
          return LocationPermissionStatus.denied;
        case LocationPermission.deniedForever:
          return LocationPermissionStatus.permanentlyDenied;
        case LocationPermission.unableToDetermine:
          return LocationPermissionStatus.restricted;
      }
    } catch (e) {
      debugPrint('Location permission check failed: $e');
      return LocationPermissionStatus.restricted;
    }
  }

  /// 位置情報の権限をリクエスト
  Future<LocationPermissionStatus> requestLocationPermission() async {
    try {
      final permission = await Geolocator.requestPermission();

      switch (permission) {
        case LocationPermission.always:
        case LocationPermission.whileInUse:
          return LocationPermissionStatus.granted;
        case LocationPermission.denied:
          return LocationPermissionStatus.denied;
        case LocationPermission.deniedForever:
          return LocationPermissionStatus.permanentlyDenied;
        case LocationPermission.unableToDetermine:
          return LocationPermissionStatus.restricted;
      }
    } catch (e) {
      return LocationPermissionStatus.restricted;
    }
  }

  /// 設定画面を開く
  Future<void> openLocationSettings() async {
    await openAppSettings();
  }

  /// 現在地を取得
  Future<Position?> getCurrentLocation() async {
    final permission = await checkLocationPermission();

    if (permission != LocationPermissionStatus.granted) {
      return null;
    }

    try {
      // 位置情報サービスが有効かチェック
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // 現在地を取得
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      debugPrint('Failed to get current location: $e');
      return null;
    }
  }

  /// 位置情報サービスが有効かチェック
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// 位置情報のストリームを取得（リアルタイム更新用）
  Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 5,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    );
  }

  /// 位置情報の権限を確認し、必要であればリクエストする
  /// 権限が付与されたらtrueを返す
  Future<bool> ensureLocationPermission() async {
    // サービスが有効か確認
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // 権限を確認
    var permission = await checkLocationPermission();
    if (permission == LocationPermissionStatus.granted) {
      return true;
    }

    // 権限をリクエスト
    if (permission == LocationPermissionStatus.denied) {
      permission = await requestLocationPermission();
    }

    return permission == LocationPermissionStatus.granted;
  }

  /// コンパスが利用可能かチェック
  /// Webプラットフォームでは常にfalseを返す
  Future<bool> isCompassAvailable() async {
    // Webではコンパスは利用不可
    if (kIsWeb) {
      return false;
    }

    try {
      // センサーが利用可能かチェック
      final event = await FlutterCompass.events?.first;
      return event?.heading != null;
    } catch (e) {
      debugPrint('Compass availability check failed: $e');
      return false;
    }
  }

  /// コンパスの方位ストリームを取得
  /// Webプラットフォームでは空のストリームを返す
  Stream<double> getCompassStream() {
    // Webではコンパスは利用不可なので空のストリームを返す
    if (kIsWeb) {
      return const Stream.empty();
    }

    final events = FlutterCompass.events;
    if (events == null) {
      return const Stream.empty();
    }

    return events
        .where((event) => event.heading != null)
        .map((event) => event.heading!);
  }
}
