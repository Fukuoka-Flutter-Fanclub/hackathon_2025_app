import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConstants {
  static const String _defaultWebBaseUrl = 'https://hackathon2025app.web.app/#';

  String webClientId = '';
  String iosClientId = '';
  String androidClientId = '';
  String webBaseUrl = _defaultWebBaseUrl;

  // シングルトンインスタンス
  static final EnvConstants _instance = EnvConstants._internal();

  // プライベートなコンストラクタ
  EnvConstants._internal();

  // インスタンスを取得するメソッド
  factory EnvConstants() {
    return _instance;
  }

  // 初期化
  Future<void> init() async {
    await dotenv.load(fileName: '.env');
    final env = dotenv.env;
    webClientId = env['WEB_CLIENT_ID'] ?? '';
    iosClientId = env['IOS_CLIENT_ID'] ?? '';
    androidClientId = env['ANDROID_CLIENT_ID'] ?? '';
    webBaseUrl = env['WEB_BASE_URL'] ?? _defaultWebBaseUrl;
  }
}
