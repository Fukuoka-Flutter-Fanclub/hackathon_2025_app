/// Firestoreコレクション名
class Collections {
  /// Koemyaku（声の地図）コレクション
  static const String koemyaku = 'koemyaku';

  /// ユーザーコレクション（将来の拡張用）
  static const String users = 'users';
}

/// Firestoreフィールド名
class Fields {
  // 共通フィールド
  static const String id = 'id';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';

  // Koemyakuフィールド
  static const String userId = 'userId';
  static const String title = 'title';
  static const String message = 'message';
  static const String markers = 'markers';

  // Markerフィールド
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String radius = 'radius';
  static const String voicePath = 'voicePath';
  static const String amplitudes = 'amplitudes';
}

/// Firebase Storageパス
class StoragePaths {
  /// 音声ファイル保存ディレクトリ
  static const String voices = 'voices';

  /// 音声ファイルの拡張子
  static const String voiceExtension = 'm4a';

  /// 音声ファイルのパスを生成
  static String voiceFile(String markerId) => '$voices/$markerId.$voiceExtension';
}

/// クエリ関連の定数
class QueryLimits {
  /// Koemyaku一覧取得時のデフォルトリミット
  static const int koemyakuList = 20;

  /// デフォルトのページサイズ
  static const int defaultPageSize = 20;
}
