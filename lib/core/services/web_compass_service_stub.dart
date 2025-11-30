import 'dart:async';

import 'web_compass_service.dart';

/// スタブ実装（モバイルプラットフォーム用）
/// Web以外のプラットフォームではコンパスサービスは利用不可
WebCompassService createWebCompassService() => WebCompassServiceStub();

class WebCompassServiceStub implements WebCompassService {
  @override
  WebCompassPermissionStatus get permissionStatus =>
      WebCompassPermissionStatus.notSupported;

  @override
  bool get isSupported => false;

  @override
  Future<WebCompassPermissionStatus> requestPermission() async {
    return WebCompassPermissionStatus.notSupported;
  }

  @override
  Stream<double> getHeadingStream() {
    return const Stream.empty();
  }

  @override
  void dispose() {}
}
