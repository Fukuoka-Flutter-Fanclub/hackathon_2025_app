import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web/web.dart' as web;

/// Web用コンパスサービスのProvider
final webCompassServiceProvider = Provider<WebCompassService>((ref) {
  return WebCompassService();
});

/// コンパスの権限状態
enum WebCompassPermissionStatus {
  /// 未確認
  unknown,

  /// 許可済み
  granted,

  /// 拒否
  denied,

  /// サポートされていない
  notSupported,
}

/// DeviceOrientationEventのJS型定義
@JS('DeviceOrientationEvent')
external JSObject? get _deviceOrientationEventClass;

/// DeviceOrientationEventの拡張
extension DeviceOrientationEventExtension on web.DeviceOrientationEvent {
  @JS('webkitCompassHeading')
  external double? get webkitCompassHeading;
}

/// Web用コンパスサービス
/// Android Chrome: deviceorientationabsolute イベント使用
/// iOS Safari: DeviceOrientationEvent.requestPermission() + webkitCompassHeading 使用
class WebCompassService {
  StreamController<double>? _headingController;
  bool _isListening = false;
  WebCompassPermissionStatus _permissionStatus =
      WebCompassPermissionStatus.unknown;

  /// 権限状態を取得
  WebCompassPermissionStatus get permissionStatus => _permissionStatus;

  /// iOSかどうかを判定
  bool get _isIOS {
    final userAgent = web.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('iphone') ||
        userAgent.contains('ipad') ||
        userAgent.contains('ipod');
  }

  /// コンパスがサポートされているかチェック
  bool get isSupported {
    if (!kIsWeb) return false;

    // DeviceOrientationEventが存在するかチェック
    return _deviceOrientationEventClass != null;
  }

  /// iOS用: requestPermissionが必要かチェック
  bool get _needsPermissionRequest {
    if (!_isIOS) return false;

    // iOS 13以降はrequestPermissionが必要
    final deviceOrientationEvent = _deviceOrientationEventClass;
    if (deviceOrientationEvent == null) return false;

    // requestPermissionプロパティが存在するか確認
    return _hasRequestPermission(deviceOrientationEvent);
  }

  bool _hasRequestPermission(JSObject obj) {
    try {
      final result = _getRequestPermission(obj);
      return result != null;
    } catch (e) {
      return false;
    }
  }

  /// 権限をリクエスト（iOS Safari用）
  /// ユーザージェスチャー（ボタンタップ等）から呼び出す必要がある
  Future<WebCompassPermissionStatus> requestPermission() async {
    if (!isSupported) {
      _permissionStatus = WebCompassPermissionStatus.notSupported;
      return _permissionStatus;
    }

    // Androidの場合は権限不要
    if (!_needsPermissionRequest) {
      _permissionStatus = WebCompassPermissionStatus.granted;
      return _permissionStatus;
    }

    // iOS Safari: DeviceOrientationEvent.requestPermission()を呼び出し
    try {
      final result = await _requestIOSPermission();
      if (result == 'granted') {
        _permissionStatus = WebCompassPermissionStatus.granted;
      } else {
        _permissionStatus = WebCompassPermissionStatus.denied;
      }
    } catch (e) {
      debugPrint('Permission request failed: $e');
      _permissionStatus = WebCompassPermissionStatus.denied;
    }

    return _permissionStatus;
  }

  Future<String> _requestIOSPermission() async {
    final deviceOrientationEvent = _deviceOrientationEventClass;
    if (deviceOrientationEvent == null) {
      return 'denied';
    }

    try {
      final promise = _callRequestPermission(deviceOrientationEvent);
      if (promise == null) {
        return 'denied';
      }
      final result = await promise.toDart;
      return result.toDart;
    } catch (e) {
      debugPrint('requestPermission error: $e');
      return 'denied';
    }
  }

  /// コンパス方位のストリームを取得
  Stream<double> getHeadingStream() {
    if (_headingController != null && _isListening) {
      return _headingController!.stream;
    }

    _headingController = StreamController<double>.broadcast(
      onListen: _startListening,
      onCancel: _stopListening,
    );

    return _headingController!.stream;
  }

  void _startListening() {
    if (_isListening) return;
    _isListening = true;

    if (_isIOS) {
      _startIOSCompass();
    } else {
      _startAndroidCompass();
    }
  }

  void _startAndroidCompass() {
    // Android: deviceorientationabsolute イベントを使用
    web.window.addEventListener(
      'deviceorientationabsolute',
      _onDeviceOrientationAbsolute.toJS,
    );

    // フォールバック: deviceorientationabsoluteがサポートされていない場合
    web.window.addEventListener(
      'deviceorientation',
      _onDeviceOrientation.toJS,
    );
  }

  void _startIOSCompass() {
    // iOS: deviceorientation イベント + webkitCompassHeading を使用
    web.window.addEventListener(
      'deviceorientation',
      _onDeviceOrientationIOS.toJS,
    );
  }

  void _onDeviceOrientationAbsolute(web.Event event) {
    final orientationEvent = event as web.DeviceOrientationEvent;

    // absoluteがtrueの場合のみ使用
    if (orientationEvent.absolute) {
      final alpha = orientationEvent.alpha;
      if (alpha != null) {
        // alphaは0-360で、0が北
        // コンパス方位に変換（0が北、時計回り）
        final heading = (360 - alpha) % 360;
        _headingController?.add(heading);
      }
    }
  }

  void _onDeviceOrientation(web.Event event) {
    final orientationEvent = event as web.DeviceOrientationEvent;

    // absoluteがfalseの場合はフォールバック
    if (!orientationEvent.absolute) {
      final alpha = orientationEvent.alpha;
      if (alpha != null) {
        // 相対方位（初期方向からの相対値）
        // 注意: これは真北ではない可能性がある
        final heading = (360 - alpha) % 360;
        _headingController?.add(heading);
      }
    }
  }

  void _onDeviceOrientationIOS(web.Event event) {
    // webkitCompassHeadingを取得（Safari専用プロパティ）
    final orientationEvent = event as web.DeviceOrientationEvent;
    final heading = _getWebkitCompassHeading(orientationEvent);

    if (heading != null && !heading.isNaN) {
      _headingController?.add(heading);
    }
  }

  void _stopListening() {
    if (!_isListening) return;
    _isListening = false;

    web.window.removeEventListener(
      'deviceorientationabsolute',
      _onDeviceOrientationAbsolute.toJS,
    );
    web.window.removeEventListener(
      'deviceorientation',
      _onDeviceOrientation.toJS,
    );
    web.window.removeEventListener(
      'deviceorientation',
      _onDeviceOrientationIOS.toJS,
    );
  }

  /// リソースを解放
  void dispose() {
    _stopListening();
    _headingController?.close();
    _headingController = null;
  }
}

/// requestPermissionを取得
JSFunction? _getRequestPermission(JSObject deviceOrientationEvent) {
  return _getProperty(deviceOrientationEvent, 'requestPermission');
}

/// requestPermissionを呼び出し
JSPromise<JSString>? _callRequestPermission(JSObject deviceOrientationEvent) {
  final fn = _getRequestPermission(deviceOrientationEvent);
  if (fn == null) return null;
  return fn.callAsFunction() as JSPromise<JSString>?;
}

/// webkitCompassHeadingを取得
double? _getWebkitCompassHeading(web.DeviceOrientationEvent event) {
  final jsEvent = event as JSObject;
  final value = _getProperty(jsEvent, 'webkitCompassHeading');
  if (value == null) return null;
  return (value as JSNumber).toDartDouble;
}

/// プロパティを安全に取得
@JS('Reflect.get')
external T? _getProperty<T extends JSAny?>(JSObject obj, String prop);
