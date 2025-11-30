import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'web_compass_service_stub.dart'
    if (dart.library.js_interop) 'web_compass_service_web.dart';

/// Web用コンパスサービスのProvider
final webCompassServiceProvider = Provider<WebCompassService>((ref) {
  return createWebCompassService();
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

/// Web用コンパスサービスのインターフェース
abstract class WebCompassService {
  /// 権限状態を取得
  WebCompassPermissionStatus get permissionStatus;

  /// コンパスがサポートされているかチェック
  bool get isSupported;

  /// 権限をリクエスト（iOS Safari用）
  /// ユーザージェスチャー（ボタンタップ等）から呼び出す必要がある
  Future<WebCompassPermissionStatus> requestPermission();

  /// コンパス方位のストリームを取得
  Stream<double> getHeadingStream();

  /// リソースを解放
  void dispose();
}
